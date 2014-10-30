
module IdmCLI
  class Guests < Thor
    #option :uid, required: true
    desc "stat", "shows the current numbers"
    def stat
      DeleteUser::connect
      puts plsql.guest_account_pkg.after_hour_count
    end

    desc "send","sends the goodbye email to all expired accounts"
    def send
    end
  end
end
