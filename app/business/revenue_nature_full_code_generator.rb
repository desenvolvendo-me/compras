class RevenueNatureFullCodeGenerator
  attr_accessor :revenue_nature_object

  delegate :revenue_rubric_full_code, :to => :revenue_nature_object, :allow_nil => true
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
      revenue_rubric_full_code,
      classification
    ].reject(&:blank?).join('.')
  end
end
