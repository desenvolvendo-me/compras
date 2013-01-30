# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/material'

describe PurchaseSolicitationBudgetAllocationItem do
  it { should belong_to :purchase_solicitation_budget_allocation }
  it { should belong_to :purchase_solicitation_item_group }
  it { should belong_to :material }
  it { should belong_to :fulfiller }

  it { should have_one :purchase_solicitation }

  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :status }

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

  context '#fulfill' do
    it "fulfills item with process when process is present" do
      process = double(:process, :id => 1)
      subject.should_receive(:update_fulfiller).with(1, process.class.name)

      subject.fulfill(process)
    end

    it "clear fulfiller item with when process is not present" do
      process = double(:process, :present? => false)
      subject.should_receive(:update_fulfiller).with(nil, nil)

      subject.fulfill(process)
    end
  end

  context '#update_fulfiller' do
    it 'should update fulfiller' do
      process = double(:process, :id => 1)

      subject.should_receive(:update_attributes).
              with(:fulfiller_id => 1, :fulfiller_type => process.class.name)

      subject.fulfill(process)
    end

    it 'should clear fulfiller' do
      process = double(:process, :present? => false)

      subject.should_receive(:update_attributes).
              with(:fulfiller_id => nil, :fulfiller_type => nil)

      subject.fulfill(process)
    end
  end

  describe '#clear_fulfiller_and_status' do
    it 'should clear fulfiller and change status to pending' do
      status_enum = double(:status)

      status_enum.should_receive(:value_for).with(:PENDING).and_return('pending')

      subject.should_receive(:update_attributes).
              with(:fulfiller_id => nil,:fulfiller_type => nil, :status => 'pending')

      subject.clear_fulfiller_and_status(status_enum)
    end
  end

  describe '#pending!' do
    it "should update status to 'pending'" do
      subject.should_receive(:update_column).with(:status, 'pending')

      subject.pending!
    end
  end

  describe '#partially_fulfilled!' do
    it "should update status to 'partially_fulfilled'" do
      subject.should_receive(:update_column).with(:status, 'partially_fulfilled')

      subject.partially_fulfilled!
    end
  end
end
