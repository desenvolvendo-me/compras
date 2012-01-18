class Report
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :report, :report_class

  def persisted?
    false
  end

  def to_s
    report
  end
end
