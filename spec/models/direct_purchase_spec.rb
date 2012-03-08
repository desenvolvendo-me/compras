# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase'
require 'app/models/budget_allocation'
require 'app/models/direct_purchase_budget_allocation'

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
end
