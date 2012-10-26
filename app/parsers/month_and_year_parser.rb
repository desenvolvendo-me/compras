module MonthAndYearParser
  include I18n::Alchemy::DateParser
  extend self

  def localize(value)
    if value
      I18n.localize value, :format => :month_and_year
    else
      value
    end
  end

  protected

  def i18n_format
    I18n.t(:month_and_year, :scope => [:date, :formats])
  end
end
