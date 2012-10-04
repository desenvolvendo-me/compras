# encoding: utf-8
require 'spec_helper'

describe PriceRegistrationBudgetStructure do
  describe "validations" do
    let (:price_registration) { PriceRegistration.make!(:registro_de_precos) } 
    let (:item) { price_registration.items.first } 
    let (:budget_structure) { item.price_registration_budget_structures.first.budget_structure } 

    it "doesn't allow the same budget structure to be selected twice for the same material" do
      duplicate_budget_structure = PriceRegistrationBudgetStructure.make(:secretaria_de_educacao,
                                                                         :budget_structure => budget_structure,
                                                                         :price_registration_item => item)

      expect(duplicate_budget_structure.valid?).to be false
    end

    it "allows the budget structure to be used twice if items are different" do
      new_item = PriceRegistrationItem.make!(:antivirus,
                                         :price_registration => price_registration)

      new_budget_structure = PriceRegistrationBudgetStructure.make(:secretaria_de_educacao,
                                                                   :budget_structure => budget_structure,
                                                                   :price_registration_item => new_item)
      expect(new_budget_structure.valid?).to be true
    end
  end
end
