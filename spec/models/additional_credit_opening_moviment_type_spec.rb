require 'model_helper'
require 'app/models/additional_credit_opening_moviment_type'

describe AdditionalCreditOpeningMovimentType do
  it { should belong_to :moviment_type }
  it { should belong_to :budget_allocation }
  it { should belong_to :capability }

  it { should validate_presence_of :moviment_type }
  it { should validate_presence_of :value }

  it 'should validate presence of budget_allocation if moviment_type is as budget_allocation' do
    subject.stub(:moviment_type_as_budget_allocation? => true)
    subject.should validate_presence_of :budget_allocation
  end

  it 'should validate presence of budget_allocation if moviment_type is as budget_allocation' do
    subject.stub(:moviment_type_as_capability? => true)
    subject.should validate_presence_of :capability
  end
end
