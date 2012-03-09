# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase'
require 'app/models/budget_allocation'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/supply_authorization'

describe DirectPurchase do
  it 'should return id as to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end

  it { should belong_to :legal_reference }
  it { should belong_to :provider }
  it { should belong_to :organogram }
  it { should belong_to :licitation_object }
  it { should belong_to :delivery_location }
  it { should belong_to :employee }
  it { should belong_to :payment_method }
  it { should belong_to :period }
  it { should have_many(:direct_purchase_budget_allocations).dependent(:destroy).order(:id) }
  it { should have_one(:supply_authorization).dependent(:restrict) }

  context "validations" do
    it "the duplicated budget_allocations should be invalid except the first" do
      allocation_one = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)
      allocation_two = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)

      subject.valid?

      allocation_one.errors.messages[:budget_allocation_id].should be_nil
      allocation_two.errors.messages[:budget_allocation_id].should include "já está em uso"
    end

    it "the diferent budget_allocations should be valid" do
      allocation_one = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 1)
      allocation_two = subject.direct_purchase_budget_allocations.build(:budget_allocation_id => 2)

      subject.valid?

      allocation_one.errors.messages[:budget_allocation_id].should be_nil
      allocation_two.errors.messages[:budget_allocation_id].should be_nil
    end

    it { should validate_presence_of :status }
    it { should validate_presence_of :year }
    it { should validate_presence_of :date }
    it { should validate_presence_of :legal_reference }
    it { should validate_presence_of :modality }
    it { should validate_presence_of :organogram }
    it { should validate_presence_of :licitation_object }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :employee }
    it { should validate_presence_of :payment_method }
    it { should validate_presence_of :period }
  end
end
