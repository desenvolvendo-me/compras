# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_lot'
require 'app/models/price_collection_lot_item'
require 'app/models/material'
require 'app/models/price_collection_classification'

describe PriceCollectionLot do
  it { should belong_to :price_collection }
  it { should have_many :items }
  it { should have_many(:price_collection_proposals).through(:price_collection) }
  it { should have_many(:price_collection_classifications).dependent(:destroy) }

  it 'should have at least one item' do
    subject.items.should be_empty

    subject.valid?

    subject.errors[:items].should include 'é necessário cadastrar pelo menos um item'
  end

  it 'should have at least one item without considering the marked for destruction ones' do
    item_marked_for_destruction = double('item', :material_id => 1, :marked_for_destruction? => true)

    subject.stub(:items).and_return([item_marked_for_destruction])

    subject.valid?

    subject.errors[:items].should include 'é necessário cadastrar pelo menos um item'
  end

  it "the duplicated items should be invalid except the first" do
    item_one = subject.items.build(:material_id => 1)
    item_two = subject.items.build(:material_id => 1)

    subject.valid?

    item_one.errors.messages[:material_id].should be_nil
    item_two.errors.messages[:material_id].should include "já está em uso"
  end

  it "the diferent itens should be valid" do
    item_one = subject.items.build(:material_id => 1)
    item_two = subject.items.build(:material_id => 2)

    subject.valid?

    item_one.errors.messages[:material_id].should be_nil
    item_two.errors.messages[:material_id].should be_nil
  end
end
