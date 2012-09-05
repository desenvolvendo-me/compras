# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/material'

describe PurchaseSolicitationBudgetAllocationItem do
  it { should belong_to :purchase_solicitation_budget_allocation }
  it { should belong_to :material }
  it { should belong_to :fulfiller }

  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }
  it { should validate_presence_of :status }

  it 'should calculate total price' do
    expect(subject.estimated_total_price).to eq 0

    subject.quantity = 10
    subject.unit_price = 5

    expect(subject.estimated_total_price).to eq 50
  end

  context '#update_fulfiller' do
    let :process do
      double(:process, :id => 1)
    end

    it 'should update fulfiller' do
      subject.should_receive(:update_attributes).with(:fulfiller_id => process.id, :fulfiller_type => process.class.name)

      subject.update_fulfiller(process)
    end
  end
end
