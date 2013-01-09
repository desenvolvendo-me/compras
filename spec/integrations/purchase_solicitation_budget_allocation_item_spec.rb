require 'spec_helper'

describe PurchaseSolicitationBudgetAllocationItem do
  describe 'validate uniqueness' do
    before { PurchaseSolicitationBudgetAllocationItem.make!(:item) }

    it { should validate_uniqueness_of(:material_id).scoped_to(:purchase_solicitation_budget_allocation_id) }
  end

  describe '.with_status' do
    let(:item_pending) do
      PurchaseSolicitationBudgetAllocationItem.make!(:item,
        :status => PurchaseSolicitationBudgetAllocationItemStatus::PENDING)
    end

    let(:item_grouped) do
      PurchaseSolicitationBudgetAllocationItem.make!(:arame_farpado,
        :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
    end

    let(:item_attended) do
      PurchaseSolicitationBudgetAllocationItem.make!(:office,
        :status => PurchaseSolicitationBudgetAllocationItemStatus::ATTENDED)
    end

    it 'should filter only records with specified status' do
      expect(described_class.with_status(
        PurchaseSolicitationBudgetAllocationItemStatus::PENDING)).to eq [item_pending]

      expect(described_class.with_status(
        PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)).to eq [item_grouped]

      expect(described_class.with_status(
        PurchaseSolicitationBudgetAllocationItemStatus::ATTENDED)).to eq [item_attended]
    end
  end
end
