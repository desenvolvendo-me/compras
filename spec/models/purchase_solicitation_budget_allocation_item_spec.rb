# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/material'

describe PurchaseSolicitationBudgetAllocationItem do
  it { should belong_to :purchase_solicitation_budget_allocation }
  it { should belong_to :material }

  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }

  it 'should calculate total price' do
    subject.estimated_total_price.should eq 0

    subject.quantity = 10
    subject.unit_price = 5

    subject.estimated_total_price.should eq 50
  end
end
