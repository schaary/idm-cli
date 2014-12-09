# encoding: utf-8

require 'erb'
require 'mail'

class AccountMailHandler

  def initialize
    options = { \
      :address              => ENV['MAIL_SMTP_HOST'],
      :port                 => ENV['MAIL_SMTP_PORT'].to_i,
      :domain               => 'uni-halle.de',
      #:user_name            => '<username>',
      #:password             => '<password>',
      #:authentication       => 'plain',
      :enable_starttls_auto => false
    }

    Mail.defaults do
      delivery_method ENV['MAIL_DELIVERY_METHOD'].to_sym, options
    end

    @mail = Mail.new
    @mail.charset = 'UTF-8'
    @mail.content_transfer_encoding = '8bit'
    @mail.from = ENV['MAIL_SENDER']
  end

  def subject text
    @mail.subject = text
  end


  def to address
    puts address
    @mail.to = address
  end

  def body account: nil, date_container: nil, template: nil
    @account = account
    @date_container = date_container

    body_template = File.read template
    renderer = ERB.new body_template
    @mail.body = renderer.result(binding)

    @mail.deliver

    @mail
  end
end
