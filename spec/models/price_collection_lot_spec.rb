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
  it { should validate_duplication_of(:material_id).on(:items) }

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
end
