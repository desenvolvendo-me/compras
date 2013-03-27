# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/material'

describe PurchaseSolicitationBudgetAllocationItem do
  it { should belong_to :purchase_solicitation_budget_allocation }
  it { should belong_to :material }

  it { should have_one :purchase_solicitation }

  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }

  it "should validate material_characteristic if purchase of services" do
    material = double(:material, :service? => false)
    subject.stub(:services? => true)
    subject.stub(:material => material)

    subject.valid?

    expect(subject.errors[:material]).to include "deve ter a característica de Serviço"
  end

  it { should delegate(:services?).to(:purchase_solicitation_budget_allocation).allowing_nil(true) }
  it { should delegate(:material_characteristic).to(:material).allowing_nil(true) }

  it 'should calculate total price' do
    expect(subject.estimated_total_price).to eq 0

    subject.quantity = 10
    subject.unit_price = 5

    expect(subject.estimated_total_price).to eq 50
  end
end
