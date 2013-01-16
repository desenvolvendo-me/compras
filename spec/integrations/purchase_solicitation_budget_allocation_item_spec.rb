require 'spec_helper'

describe PurchaseSolicitationBudgetAllocationItem do
  describe 'validate uniqueness' do
    before { PurchaseSolicitationBudgetAllocationItem.make!(:item) }

    it { should validate_uniqueness_of(:material_id).scoped_to(:purchase_solicitation_budget_allocation_id) }
  end

  describe '.group_by_ids' do
    it 'should group items by ids' do
      PurchaseSolicitationBudgetAllocationItem.make!(:office)

      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

      PurchaseSolicitationBudgetAllocationItem.group_by_ids!(1, item_group.id)

      item = PurchaseSolicitationBudgetAllocationItem.find(1)

      expect(item.status).to eq 'grouped'
      expect(item.purchase_solicitation_item_group_id).to eq item_group.id 
    end
  end

  describe '.pending_by_ids' do
    it 'should pending items by ids' do
      PurchaseSolicitationBudgetAllocationItem.make!(:office, :status => 'grouped')

      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

      PurchaseSolicitationBudgetAllocationItem.pending_by_ids!(1)

      item = PurchaseSolicitationBudgetAllocationItem.find(1)

      expect(item.status).to eq 'pending'
      expect(item.purchase_solicitation_item_group_id).to be_nil
    end
  end
end
