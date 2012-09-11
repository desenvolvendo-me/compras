require 'model_helper'
require 'app/models/price_registration_budget_structure'

describe PriceRegistrationBudgetStructure do
  it { should belong_to :price_registration_item }
  it { should belong_to :budget_structure }

  it { should validate_presence_of :price_registration_item }
  it { should validate_presence_of :budget_structure }
  it { should validate_presence_of :quantity_requested }
end
