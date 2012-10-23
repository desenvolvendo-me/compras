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
    it "fulfills all the items with the same material as the group's" do
      process = double(:process)
      item1 = double(:item1)
      item2 = double(:item2)

      item1.should_receive(:fulfill).with(process)
      item2.should_receive(:fulfill).with(process)

      subject.stub(:purchase_solicitation_items).and_return([item1, item2])

      subject.fulfill_items(process)
    end

    it "clear fulfiller of all items" do
      process = nil
      item1 = double(:item1)
      item2 = double(:item2)

      item1.should_receive(:fulfill).with(process)
      item2.should_receive(:fulfill).with(process)

      subject.stub(:purchase_solicitation_items).and_return([item1, item2])

      subject.fulfill_items(process)
    end
  end

  context "validations" do
    it "validates if purchase solicitations are pending" do
      purchase_solicitation = double(:purchase_solicitation,
                                     :can_be_grouped? => false)
      subject.stub(:purchase_solicitations => [purchase_solicitation])

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to include "deve estar com situação Liberada para ser agrupada"
    end
  end
end
