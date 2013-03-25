require 'unit_helper'
require 'app/business/direct_purchase_budget_allocation_cleaner'

describe DirectPurchaseBudgetAllocationCleaner do
  let(:direct_purchase) do
    double(:direct_purchase,
      :purchase_solicitation => nil,
      :direct_purchase_budget_allocations => [allocation1, allocation2]
    )
  end

  let(:allocation1) { double(:allocation1) }
  let(:allocation2) { double(:allocation2) }

  it 'should mark for destruction budget allocations when purchase solicitation change' do
    new_purchase_solicitation = double(:solicitation)

    allocation1.should_receive(:mark_for_destruction)
    allocation2.should_receive(:mark_for_destruction)

    described_class.clear_old_records(direct_purchase, new_purchase_solicitation)
  end

  it 'should not mark for destruction budget allocations when purchase_solicitatio' do
    new_purchase_solicitation = double(:solicitation)

    allocation1.should_not_receive(:mark_for_destruction)
    allocation2.should_not_receive(:mark_for_destruction)

    described_class.clear_old_records(direct_purchase, nil)
  end
end
