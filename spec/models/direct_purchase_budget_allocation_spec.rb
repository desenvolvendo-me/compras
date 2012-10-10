# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/direct_purchase_budget_allocation_item'
require 'app/models/direct_purchase'
require 'app/models/budget_allocation'

describe DirectPurchaseBudgetAllocation do
  it { should belong_to :direct_purchase }
  it { should belong_to :budget_allocation }

  it { should have_many(:items).dependent(:destroy).order(:id) }

  it { should validate_presence_of :budget_allocation }

  it 'should have at least one item' do
    expect(subject.items).to be_empty

    subject.valid?

    expect(subject.errors[:items]).to include 'é necessário cadastrar pelo menos um item'
  end

  it 'should return 0 as the total value of items when have no items' do
    expect(subject.items).to be_empty

    expect(subject.total_items_value).to eq 0
  end

  it 'should calculate the total value of items' do
    subject.stub(:items).and_return([
      double(:estimated_total_price => 10, :marked_for_destruction? => false),
      double(:estimated_total_price => 20, :marked_for_destruction? => false),
      double(:estimated_total_price => 15, :marked_for_destruction? => false)
    ])

    expect(subject.total_items_value).to eq 45
  end

  it 'should calculate the total value of items when an item is marked for destruction' do
    subject.stub(:items).and_return([
      double(:estimated_total_price => 10, :marked_for_destruction? => false),
      double(:estimated_total_price => 20, :marked_for_destruction? => true),
      double(:estimated_total_price => 15, :marked_for_destruction? => false)
    ])

    expect(subject.total_items_value).to eq 25
  end
end
