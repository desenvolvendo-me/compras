#encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_item_group_material'
require 'app/models/purchase_solicitation_item_group_material_purchase_solicitation'
require 'app/models/purchase_solicitation'
require 'app/models/material'

describe PurchaseSolicitationItemGroupMaterial do
  it { should belong_to :purchase_solicitation_item_group }
  it { should belong_to :material }

  it { should have_many(:purchase_solicitation_item_group_material_purchase_solicitations).dependent(:destroy) }
  it { should have_many(:purchase_solicitations).through(:purchase_solicitation_item_group_material_purchase_solicitations) }
  it { should have_many(:purchase_solicitation_items).through(:purchase_solicitations) }

  it {should validate_presence_of(:purchase_solicitations).with_message("deve ter ao menos uma solicitação de compras") }
  it {should validate_presence_of :material }

  context "#fulfill_items" do
    let :purchase_solicitation_items do
      double(:purchase_solicitation_items,
             :by_material => [item])
    end

    let :item do
      double(:item)
    end
    
    let :process do
      double(:process)
    end

    it "should return the purchase solicitation items with the same material as the group's" do
      subject.stub(:purchase_solicitation_items).and_return(purchase_solicitation_items)

      item.should_receive(:update_fulfiller).with(process)
      subject.fulfill_items(process)
    end
  end
end
