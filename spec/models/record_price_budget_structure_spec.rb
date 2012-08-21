require 'model_helper'
require 'app/models/record_price_budget_structure'

describe RecordPriceBudgetStructure do
  it { should belong_to :record_price_item }
  it { should belong_to :budget_structure }

  it { should validate_presence_of :record_price_item }
  it { should validate_presence_of :budget_structure }
  it { should validate_presence_of :quantity_requested }
end
