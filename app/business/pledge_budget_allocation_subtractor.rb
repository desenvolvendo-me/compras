class PledgeBudgetAllocationSubtractor
  attr_accessor :pledge, :budget_allocation

  def initialize(pledge)
    self.pledge = pledge
    self.budget_allocation = pledge.budget_allocation
  end

  def subtract_budget_allocation_amount!
    return unless self.budget_allocation

    if pledge.valid?
      new_amount = budget_allocation.amount - pledge.value
      budget_allocation.update_attributes!(:amount => new_amount)
    end
  end
end
