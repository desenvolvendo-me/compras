class DepartmentRequestReport < Report
  include Concerns::StartEndDatesRange

  attr_accessor :department
end