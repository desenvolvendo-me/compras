class RevenueNatureCodeGenerator
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
    revenue_nature_object.revenue_nature = revenue_nature
  end

  protected

  def revenue_nature
    [
     value_or_default(revenue_category_code, '0'),
     value_or_default(revenue_subcategory_code, '0'),
     value_or_default(revenue_source_code, '0'),
     value_or_default(revenue_rubric_code, '0'),
     value_or_default(classification, '00.00')
    ].join('.')
  end

  def value_or_default(value, default_value)
    if value.blank?
      default_value
    else
      value
    end
  end
end
