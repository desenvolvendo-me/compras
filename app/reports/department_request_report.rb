class DepartmentRequestReport < Report
  include StartEndDatesRange
  attr_accessor :department
end