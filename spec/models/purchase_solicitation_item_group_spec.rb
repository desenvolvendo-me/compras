# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_item_group'
require 'app/models/purchase_solicitation_item_group_material'
require 'app/models/direct_purchase'

describe PurchaseSolicitationItemGroup do
  it { should have_many(:purchase_solicitation_item_group_materials).dependent(:destroy) }
  it { should have_many(:purchase_solicitations).through(:purchase_solicitation_item_group_materials) }
  it { should have_many(:direct_purchases).dependent(:restrict) }

  it { should validate_presence_of(:purchase_solicitation_item_group_materials).with_message("deve ter ao menos um material") }

  it 'should be id as #to_s method' do
    subject.id = 1

    expect(subject.to_s).to eq '1'
  end

  context 'total_purchase_solicitation_budget_allocations_sum' do
    let :purchase_solicitations do
      [
        double(:item1, :total_allocations_items_value => 20),
        double(:item2, :total_allocations_items_value => 15)
      ]
    end

    it 'should return the sum of total_purchase_solicitation_budget_allocations' do
      subject.stub(:purchase_solicitations).and_return(purchase_solicitations)

      expect(subject.total_purchase_solicitation_budget_allocations_sum).to eq 35
    end
  end
end
