# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process_budget_allocation_item'

describe AdministrativeProcessBudgetAllocationItem do
  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }

  it { should belong_to :administrative_process_budget_allocation }
  it { should belong_to :material }
  it { should belong_to :licitation_process_lot }

  it 'should calculate the estimated total price' do
    subject.estimated_total_price.should eq 0

    subject.quantity = 5
    subject.unit_price = 10.1

    subject.estimated_total_price.should eq 50.5
  end
end
