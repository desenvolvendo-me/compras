# encoding: utf-8
require 'model_helper'
require 'app/models/expense_element'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/material'
require 'app/models/budget_allocation'

describe ExpenseElement do
  it 'should return expense_element as to_s method' do
    subject.expense_element = '3.1.90.11.01.00.00.00'
    subject.to_s.should eq '3.1.90.11.01.00.00.00'
  end

  it { should belong_to :regulatory_act }
  it { should belong_to :entity }
  it { should have_many(:purchase_solicitations).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:restrict) }
  it { should have_many(:materials).dependent(:restrict) }
  it { should have_many(:budget_allocations).dependent(:restrict) }

  it { should validate_presence_of :expense_element }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :description }

  it { should allow_value('3.1.90.11.01.00.00.00').for(:expense_element) }
  it { should_not allow_value('1234').for(:expense_element) }
end
