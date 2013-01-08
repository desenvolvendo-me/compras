# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitation do
  describe '#budget_structure' do
    it "should return the budget structure of the purchase solicitation" do
      budget_structure = BudgetStructure.make!(:secretaria_de_educacao)
      purchase_solicitation = PurchaseSolicitation.make!(:reparo,
                                                         :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
                                                         :budget_structure => budget_structure)
      expect(purchase_solicitation.budget_structure).to eq budget_structure
    end

    it "delegates to the direct purchase if budget structure is nil" do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo,
                                                         :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
                                                         :budget_structure => nil)
      direct_purchase = DirectPurchase.make!(:compra,
                                             :purchase_solicitation => purchase_solicitation)

      expect(purchase_solicitation.budget_structure).to eq direct_purchase.budget_structure
    end
  end

  describe "updating status when a purchase process is created" do
    it "updates the solicitation status to In Purchase Process when a direct purchase is created" do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo,
                                                         :service_status => PurchaseSolicitationServiceStatus::LIBERATED)
      direct_purchase = DirectPurchase.make(:compra)

      PurchaseSolicitationProcess.update_solicitations_status(purchase_solicitation, direct_purchase.purchase_solicitation)

      expect(purchase_solicitation.service_status).to eq PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS
    end

    it "sets the status back to 'Pending' in case the purchase solicitation is unlinked from direct purchase" do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo,
                                                         :service_status => PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS)
      substitute_purchase_solicitation = PurchaseSolicitation.make!(:reparo,
                                                                    :service_status => PurchaseSolicitationServiceStatus::LIBERATED)
      direct_purchase = DirectPurchase.make(:compra,
                                            :purchase_solicitation => purchase_solicitation)

      PurchaseSolicitationProcess.update_solicitations_status(substitute_purchase_solicitation, direct_purchase.purchase_solicitation)

      expect(purchase_solicitation.service_status).to eq PurchaseSolicitationServiceStatus::PENDING
    end
  end

  describe ".with_pending_items" do
    context "with one item pending and one item grouped " do
    end

    it "should return items pending" do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)
      budget_allocation = purchase_solicitation.purchase_solicitation_budget_allocations.first
      item_not_pending = PurchaseSolicitationBudgetAllocationItem.make(:arame_farpado,
                                                                       :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
      budget_allocation.items << item_not_pending

      item_pending = purchase_solicitation.items.first

      expect(purchase_solicitation.items).to include(item_pending, item_not_pending)
      expect(PurchaseSolicitation.with_pending_items.first.items).to include(item_pending)
    end
  end
end
