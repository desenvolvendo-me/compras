class RevenueNatureFullCodeGenerator
  attr_accessor :revenue_nature_object

  delegate :revenue_category_code, :to => :revenue_nature_object, :allow_nil => true
  delegate :revenue_subcategory_code, :to => :revenue_nature_object, :allow_nil => true
  delegate :revenue_source_code, :to => :revenue_nature_object, :allow_nil => true
  delegate :revenue_rubric_code, :to => :revenue_nature_object, :allow_nil => true
  delegate :classification, :to => :revenue_nature_object, :allow_nil => true

  def initialize(revenue_nature_object)
    self.revenue_nature_object = revenue_nature_object
  end

  def generate!
    revenue_nature_object.full_code = full_code
  end

  protected

  def full_code
    [
     value_or_default(revenue_category_code, 1),
     value_or_default(revenue_subcategory_code, 1),
     value_or_default(revenue_source_code, 1),
     value_or_default(revenue_rubric_code, 1),
     value_or_default(classification, 4)
    ].join('.')
  end

  def value_or_default(value, count)
    if value.blank?
      '0' * count
    else
      value
    end
  end
end
