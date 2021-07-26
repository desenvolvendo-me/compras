# encoding: utf-8
class ReportFilterParser
  attr_accessor :report, :param, :value

  def initialize(report, param, value)
    self.report = report
    self.param  = param.to_s
    self.value  = value
  end

  def self.parse(report, param, value)
    self.new(report, param, value).parse
  end

  def parse
    return parse_model       if model?
    return parse_enumeration if enumeration?
    return parse_date_range  if date_range?
    return parse_boolean     if boolean?

    value
  end

  private

  def parse_model
    param.gsub("_id", "").camelize.constantize.find(value).to_s
  end

  def parse_enumeration
    report.send "#{param}_humanize"
  end

  def parse_date_range
    "#{I18n.l date_range.first} até #{I18n.l date_range.last}"
  end

  def parse_boolean
    I18n.t value
  end

  def model?
    param.ends_with? "_id"
  end

  def enumeration?
    enumeration.present?
  end

  def date_range?
    date_range.present?
  end

  def boolean?
    ['true', 'false'].include? value
  end

  def date_range
    range = value.first if value.is_a?(Array)

    return range if range.is_a?(Range) && range.first.is_a?(Date)
  end

  def enumeration
    report.class.enumerations[param.to_sym]
  end
end
