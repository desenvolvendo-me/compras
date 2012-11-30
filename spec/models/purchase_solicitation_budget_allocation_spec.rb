# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation_item'

describe PurchaseSolicitationBudgetAllocation do
  describe 'default values' do
    it 'uses false as default for blocked' do
      expect(subject.blocked).to be false
    end
  end

  it { should delegate(:services?).to(:purchase_solicitation).allowing_nil(true) }

  it { should validate_presence_of :budget_allocation }
  it { should belong_to :purchase_solicitation }
  it { should belong_to :budget_allocation }
  it { should belong_to :expense_nature }
  it { should have_many(:items).dependent(:destroy) }

  it "should have false as the default value of blocked" do
    expect(subject.blocked).to eq false
  end

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
      double(:estimated_total_price => 10),
      double(:estimated_total_price => 20),
      double(:estimated_total_price => 15)
    ])

    expect(subject.total_items_value).to eq 45
  end

  describe "#items_by_material" do
    it "returns all the items which have a material belonging to a given set" do
      material_ids = [-1, -2]
      items = double(:items)
      subject.stub(:items => items)

      items.should_receive(:by_material).with(material_ids)
      subject.items_by_material(material_ids)
    end
  end
end
