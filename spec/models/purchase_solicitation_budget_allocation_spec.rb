# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_budget_allocation'

describe PurchaseSolicitationBudgetAllocation do
  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :estimated_value }
  it { should belong_to :purchase_solicitation }
  it { should belong_to :budget_allocation }
  it { should belong_to :expense_economic_classification }
  it { should have_many(:items).dependent(:destroy) }

  it "should have false as the default value of blocked" do
    subject.blocked.should eq false
  end

  it 'should have at least one item' do
    subject.items.should be_empty

    subject.valid?

    subject.errors[:items].should include 'é necessário cadastrar pelo menos um item'
  end

  it 'should return 0 as the total value of items when have no items' do
    subject.items.should be_empty

    subject.total_items_value.should eq 0
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
