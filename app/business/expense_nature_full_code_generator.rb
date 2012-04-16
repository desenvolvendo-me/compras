class ExpenseNatureFullCodeGenerator
  attr_accessor :expense_nature_object

  delegate :expense_category_code, :to => :expense_nature_object, :allow_nil => true
  delegate :expense_group_code, :to => :expense_nature_object, :allow_nil => true
  delegate :expense_modality_code, :to => :expense_nature_object, :allow_nil => true
  delegate :expense_element_code, :to => :expense_nature_object, :allow_nil => true
  delegate :expense_split, :to => :expense_nature_object, :allow_nil => true

  def initialize(expense_nature_object)
    self.expense_nature_object = expense_nature_object
  end

  def generate!
    expense_nature_object.full_code = full_code
  end

  protected

  def full_code
    [
      value_or_mask(expense_category_code),
      value_or_mask(expense_group_code),
      value_or_mask(expense_modality_code, 2),
      value_or_mask(expense_element_code, 2),
      value_or_mask(expense_split, 2)
    ].join('.')
  end

  def value_or_mask(value, count = 1)
    if(value)
      value.rjust(count, '0')
    else
      '_' * count
    end
  end
end
