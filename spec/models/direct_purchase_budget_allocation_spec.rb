# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/direct_purchase'
require 'app/models/budget_allocation'

describe DirectPurchaseBudgetAllocation do
  it { should belong_to :direct_purchase }
  it { should belong_to :budget_allocation }

  it { should have_many(:items).dependent(:destroy).order(:id) }

  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :pledge_type }

  it 'should have at least one item' do
    subject.items.should be_empty

    subject.valid?

    subject.errors[:items].should include 'é necessário cadastrar pelo menos um item'
  end

  it 'should calculate the total value of items' do
    subject.stub(:items).and_return([
      double(:estimated_total_price => 10),
      double(:estimated_total_price => 20),
      double(:estimated_total_price => 15)
    ])

    subject.total_items_value.should eq 45
  end
end
