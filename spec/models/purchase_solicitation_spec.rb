# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation_item'

describe PurchaseSolicitation do
  it 'should return the id in to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end

  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:destroy).order(:id) }
  it { should belong_to :responsible }
  it { should belong_to :delivery_location }
  it { should belong_to :liberator }
  it { should belong_to :budget_structure }

  it "must delegate the amount to budget_allocation" do
    subject.stub(:budget_allocation).and_return double("Allocation", :amount  => '400,00')

    subject.budget_allocation_amount.should eq("400,00")
  end

  context "validations" do
    it { should validate_presence_of :accounting_year }
    it { should validate_numericality_of :accounting_year }
    it { should validate_presence_of :request_date }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :responsible }
    it { should validate_presence_of :kind }

    it { should_not allow_value('a2012').for(:accounting_year) }
    it { should allow_value('2012').for(:accounting_year) }

    it "the duplicated budget_allocations should be invalid except the first" do
      item_one = subject.purchase_solicitation_budget_allocations.build(:budget_allocation_id => 1)
      item_two = subject.purchase_solicitation_budget_allocations.build(:budget_allocation_id => 1)

      subject.valid?

      item_one.errors.messages[:budget_allocation_id].should be_nil
      item_two.errors.messages[:budget_allocation_id].should include "já está em uso"
    end

    it "the diferent budget_allocations should be valid" do
      item_one = subject.purchase_solicitation_budget_allocations.build(:budget_allocation_id => 1)
      item_two = subject.purchase_solicitation_budget_allocations.build(:budget_allocation_id => 2)

      subject.valid?

      item_one.errors.messages[:budget_allocation_id].should be_nil
      item_two.errors.messages[:budget_allocation_id].should be_nil
    end
  end

  describe '#annul!' do
    it 'should updates the service status to annulled' do
      subject.should_receive(:update_attribute).with(:service_status, PurchaseSolicitationServiceStatus::ANNULLED)

      subject.annul!
    end
  end
end
