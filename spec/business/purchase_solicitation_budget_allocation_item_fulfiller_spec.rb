require 'unit_helper'
require 'app/business/purchase_solicitation_budget_allocation_item_fulfiller'

describe PurchaseSolicitationBudgetAllocationItemFulfiller do

  context 'with purchase_solicitation_budget_allocation_items' do
    subject do
      PurchaseSolicitationBudgetAllocationItemFulfiller.new(purchase_solicitation_item_group, direct_purchase)
    end

    let :purchase_solicitation_item_group do
      double(:purchase_solicitation_item_group)
    end

    let :direct_purchase do
      double(:direct_purchase)
    end

    let :items_by_materials do
      [item]
    end

    let :item do
      double(:item)
    end

    it 'should return nil when purchase_solicitation_item_group is not present' do
      purchase_solicitation_item_group.stub(:present?).and_return(false)
      item.should_not_receive(:update_fulfiller)

      subject.fulfill 
    end

    it 'should fulfill the purchase_solicitation_budget_allocation_items' do
      purchase_solicitation_item_group.stub(:present?).and_return(true)
      purchase_solicitation_item_group.stub(:purchase_solicitation_items_by_materials).
                                       and_return(items_by_materials)

      item.should_receive(:update_fulfiller).with(direct_purchase)

      subject.fulfill
    end
  end
end
