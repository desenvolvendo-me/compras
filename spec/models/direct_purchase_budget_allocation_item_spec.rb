# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase_budget_allocation_item'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/material'

describe DirectPurchaseBudgetAllocationItem do
  it { should belong_to :direct_purchase_budget_allocation }
  it { should belong_to :material }

  it 'should calculate total price' do
    subject.estimated_total_price.should eq 0

    subject.quantity = 10
    subject.unit_price = 5

    subject.estimated_total_price.should eq 50
  end

  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }

  context 'should unit_price be greater than 0' do
    it 'should be valid' do
      subject.unit_price = 4
      subject.valid?
      subject.errors[:unit_price].should be_empty
    end

    it 'should be invalid' do
      subject.unit_price = -4
      subject.valid?
      subject.errors[:unit_price].should eq ["deve ser maior que 0"]
    end
  end
end
