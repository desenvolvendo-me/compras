require 'unit_helper'
require 'app/business/direct_purchase_budget_allocation_cleaner'

describe DirectPurchaseBudgetAllocationCleaner do
  let(:direct_purchase) do
    double(:direct_purchase,
      :purchase_solicitation => nil,
      :purchase_solicitation_item_group => nil,
      :direct_purchase_budget_allocations => [allocation1, allocation2]
    )
  end

  let(:allocation1) { double(:allocation1) }
  let(:allocation2) { double(:allocation2) }

  it 'should mark for destruction budget allocations when item group change' do
    new_item_group = double(:new_item_group)

    allocation1.should_receive(:mark_for_destruction)
    allocation2.should_receive(:mark_for_destruction)

    described_class.clear_old_records(direct_purchase, nil, new_item_group)
  end

  it 'should mark for destruction budget allocations when purchase solicitation change' do
    new_purchase_solicitation = double(:solicitation)

    allocation1.should_receive(:mark_for_destruction)
    allocation2.should_receive(:mark_for_destruction)

    described_class.clear_old_records(direct_purchase, new_purchase_solicitation, nil)
  end

  it 'should not mark for destruction budget allocations when purchase_solicitation neither item group change' do
    new_purchase_solicitation = double(:solicitation)

    allocation1.should_not_receive(:mark_for_destruction)
    allocation2.should_not_receive(:mark_for_destruction)

    described_class.clear_old_records(direct_purchase, nil, nil)
  end
end
