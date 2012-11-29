require 'spec_helper'

describe PurchaseSolicitationBudgetAllocationItem do
  describe '.with_status' do
    let(:item_pending) do
      PurchaseSolicitationBudgetAllocationItem.make!(:item,
        :status => PurchaseSolicitationBudgetAllocationItemStatus::PENDING)
    end

    let(:item_grouped) do
      PurchaseSolicitationBudgetAllocationItem.make!(:item,
        :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
    end

    let(:item_attended) do
      PurchaseSolicitationBudgetAllocationItem.make!(:item,
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
