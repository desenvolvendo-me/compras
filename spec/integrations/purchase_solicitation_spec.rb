# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitation do
  describe '#budget_structure' do
    it "should return the budget structure of the purchase solicitation" do
      budget_structure = BudgetStructure.make!(:secretaria_de_educacao)
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado,
                                                         :budget_structure => budget_structure)
      expect(purchase_solicitation.budget_structure).to eq budget_structure
    end

    it "delegates to the direct purchase if budget structure is nil" do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado,
                                                         :budget_structure => nil)
      direct_purchase = DirectPurchase.make!(:compra,
                                             :purchase_solicitation => purchase_solicitation)

      expect(purchase_solicitation.budget_structure).to eq direct_purchase.budget_structure
    end
  end

  describe ".with_pending_items" do
    it "should return purchase solicitation with items pending" do
      purchase_solicitation_with_pending_item = PurchaseSolicitation.make!(:reparo)
      purchase_solicitation_with_grouped_item = PurchaseSolicitation.make!(:reparo_2013)

      budget_allocation = purchase_solicitation_with_grouped_item.purchase_solicitation_budget_allocations.first

      item_not_pending = PurchaseSolicitationBudgetAllocationItem.make(:arame_farpado,
                                                                       :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
      budget_allocation.items = [ item_not_pending ]

      expect(PurchaseSolicitation.all).to include(purchase_solicitation_with_pending_item, purchase_solicitation_with_grouped_item)
      expect(PurchaseSolicitation.with_pending_items).to eq [purchase_solicitation_with_pending_item]
      expect(PurchaseSolicitation.with_pending_items).not_to include(purchase_solicitation_with_grouped_item)
    end
  end
end
