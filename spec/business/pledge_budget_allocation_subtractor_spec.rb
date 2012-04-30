require 'unit_helper'
require 'app/business/pledge_budget_allocation_subtractor'

describe PledgeBudgetAllocationSubtractor do
  it 'should call budget_allocation#update_attributes with correct amount' do
    budget_allocation = double(:amount => 500)
    pledge = double(:budget_allocation => budget_allocation, :valid? => true, :value => 200)

    budget_allocation.should_receive(:update_attribute).with(:amount, 300)

    PledgeBudgetAllocationSubtractor.new(pledge).subtract_budget_allocation_amount!
  end
end
