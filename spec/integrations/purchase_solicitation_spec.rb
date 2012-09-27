# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitation do
  describe '#budget_structure' do
    it "should return the budget structure of the purchase solicitation" do
      budget_structure = BudgetStructure.make!(:secretaria_de_educacao)
      purchase_solicitation = PurchaseSolicitation.make!(:reparo,
                                                         :budget_structure => budget_structure)
      expect(purchase_solicitation.budget_structure).to eq budget_structure
    end

    it "delegates to the direct purchase if budget structure is nil" do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo,
                                                         :budget_structure => nil)
      direct_purchase = DirectPurchase.make!(:compra,
                                             :purchase_solicitation => purchase_solicitation)

      expect(purchase_solicitation.budget_structure).to eq direct_purchase.budget_structure
    end
  end
end
