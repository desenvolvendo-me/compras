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
    let(:purchase_solicitation_items) { double(:purchase_solicitation_items) }
    let(:process) { double(:process) }
    let(:material_id) { -1 }

    it "fulfills all the items with the same material as the group's" do
      subject.stub(:purchase_solicitation_items).and_return(purchase_solicitation_items)
      subject.material_id = material_id

      purchase_solicitation_items.should_receive(:fulfill_items).with({
        :material_id => subject.material_id,
        :process => process
      })

      subject.fulfill_items(process)
    end
  end
end
