# encoding: utf-8

require 'erb'
require 'mail'
require 'pry'

class SummaryMailHandler

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
    @mail.from = ENV['MAIL_SUBJECT']
  end

  def to address
    @mail.to = address
  end

  def subject header
    @mail.subject = header
  end

  def body key_data: nil, template: nil
    @key_data = key_data

    body_template = File.read template
    renderer = ERB.new body_template
    @mail.body = renderer.result(binding)

    @mail.deliver

    puts @mail
  end
end
