# encoding: utf-8

require 'date'

class DateContainer

  attr_reader :final_month, :final_date

  def initialize(offset: 0)
      months_array = %w(Januar Februar März April Mai Juni Juli August September Oktober Novemer Dezember)

      date = Date.today << (-offset)

      month = date.strftime("%m").to_i
      year = date.strftime("%Y").to_i
      last_day = Date.civil(year.to_i, month.to_i, -1).strftime("%d")

      @final_month = "#{months_array[month - 1].to_s} #{year.to_s}"
      @final_date = "#{last_day}.#{month}.#{year}"
  end
end
