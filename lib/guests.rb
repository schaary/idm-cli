
require 'account'
require 'account_mail_handler'
require 'awesome_print'
require 'date'
require 'date_container'
require 'summary_mail_handler'

require 'pry'

module IdmCLI
  class Guests < Thor
    #option :uid, required: true
    desc "stat", "shows the current numbers"
    def stat
      # DeleteUser::connect
      # puts plsql.guest_account_pkg.after_hour_count
    end

    desc "send","sends the goodbye email to all expired accounts"
    def send
      DeleteUser::connect

      #open_summary_file

      mail_counter = 0
      mail_counter += notify_after_hour

      key_data = {
        alive_count: plsql.guest_account_pkg.alive_count,
        after_hour_count: plsql.guest_account_pkg.after_hour_count,
        suspended_count: plsql.guest_account_pkg.suspended_count,
        number_of_mails: mail_counter,
        final_date: 0
      }

      template = "#{DeleteUser::application_root}/templates/status_mails/guest_accounts.erb"

      mail = SummaryMailHandler.new
      mail.subject "Es wurden #{mail_counter} Abschiedsmails an Gast-Accounts verschickt"
      mail.to "michael.schaarschmidt@itz.uni-halle.de"
      mail.body \
        key_data: key_data,
        template: template
    end

    private

    def notify_after_hour
      date_container = DateContainer.new

      records = nil
      plsql.guest_account_pkg.after_hour { |c| records = c.fetch_all }

      mail_counter = 0

      records.pop(records.length-1)
      records.map do |record|
        account = Account.new
        account.uid = record[3]
        account.email = record[2]
        account.firstname = record[0]
        account.lastname = record[1]
        account.end_date = record[4]
        account.gender = record[5]
        account.account_type = record[6]
        account.state = record[7]
        account.date_of_birth = record[8]


        mail = AccountMailHandler.new
        mail.subject "Mitteilung des ITZ der Martin-Luther-Universität Halle-Wittenberg"
        template = "#{DeleteUser::application_root}/templates/abschiedsbriefe/abschiedsbrief_gaeste.txt"
        send_mail = mail.body \
          account: account,
          date_container: date_container,
          template: template

        mail_counter = mail_counter + 1

        write_log_to_file mail: send_mail, account: account

        write_log_to_database(
          firstname: account.firstname,
          lastname: account.lastname,
          date_of_birth: account.date_of_birth,
          gender: account.gender,
          end_date: account.end_date,
          nkz: account.uid,
          mail: account.email,
          account_type: account.account_type,
          state: account.state,
          send_date: Date.today.strftime("%d.%m.%Y"),
          final_date: date_container.final_date)
      end
      mail_counter
    end

    def open_summary_file
      @summary_file = File.open "#{DeleteUser::application_root}/log/#{Date.today.strftime("%Y%m%d")}_summary.log"
    end

    def close_summary_file
      @summary_file.close
    end

    def write_log_to_file mail: nil, account: nil
      file = File.open "#{DeleteUser::application_root}/log/#{Date.today.strftime("%Y%m%d")}_#{account.uid}.log", "w+"
      file.puts mail
      file.close
    end

    def write_log_to_database(
      firstname: nil,
      lastname: nil,
      date_of_birth: nil,
      gender: nil,
      end_date: nil,
      nkz: nil,
      mail: nil,
      account_type: nil,
      state: nil,
      send_date: nil,
      final_date: nil
    )
      plsql.goodbye_pkg.writeLog(
        firstname,
        lastname,
        date_of_birth,
        gender,
        end_date,
        nkz,
        mail,
        account_type,
        state,
        send_date,
        final_date
      )
    end
  end
end
