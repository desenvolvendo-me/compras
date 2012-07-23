# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_item_group'
require 'app/models/purchase_solicitation_item_group_purchase_solicitation'
require 'app/models/purchase_solicitation'

describe PurchaseSolicitationItemGroup do
  it { should have_many(:purchase_solicitation_item_group_purchase_solicitations).dependent(:destroy) }
  it { should have_many(:purchase_solicitations).through(:purchase_solicitation_item_group_purchase_solicitations) }
  it { should have_many(:purchase_solicitation_budget_allocations).through(:purchase_solicitations) }
  it { should have_many(:items).through(:purchase_solicitation_budget_allocations) }

  it { should belong_to(:material) }

  it {should validate_presence_of :material }
  it {should validate_presence_of(:purchase_solicitations).with_message("deve ter ao menos uma solicitação de compras") }

  it 'should be material - count as #to_s method' do
    subject.stub(:count_groups).and_return(5)
    subject.stub(:material).and_return('1 - Antivírus')

    subject.to_s.should eq '1 - Antivírus - 5'
  end
end
