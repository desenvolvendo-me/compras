# encoding: utf-8
require 'model_helper'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'

describe BudgetAllocation do
  it 'should return description as to_s id/year' do
    subject.id = '1'
    subject.year = 2012

    subject.to_s.should eq '1/2012'
  end

  it { should validate_presence_of :description }

  it { should belong_to(:organogram) }
  it { should belong_to(:function) }
  it { should belong_to(:subfunction) }
  it { should belong_to(:government_program) }
  it { should belong_to(:government_action) }
  it { should belong_to(:expense_economic_classification) }
  it { should belong_to(:capability) }
  it { should have_many(:purchase_solicitations).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:restrict) }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }
end
