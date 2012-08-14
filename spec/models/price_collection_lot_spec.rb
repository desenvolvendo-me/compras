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
    expect(subject.items).to be_empty

    subject.valid?

    expect(subject.errors[:items]).to include 'é necessário cadastrar pelo menos um item'
  end

  it 'should have at least one item without considering the marked for destruction ones' do
    item_marked_for_destruction = double('item', :material_id => 1, :marked_for_destruction? => true)

    subject.stub(:items).and_return([item_marked_for_destruction])

    subject.valid?

    expect(subject.errors[:items]).to include 'é necessário cadastrar pelo menos um item'
  end

  context 'item with unit price equals zero' do
    let :item_1 do
      double(:price_collection_lot => subject, :unit_price => 0)
    end

    let :item_2 do
      double(:price_collection_lot => subject, :unit_price => 1)
    end

    let :proposal do
      double
    end

    it 'should return true' do
      proposal.stub(:items => [item_1, item_2])

      expect(subject.has_item_with_unit_price_equals_zero(proposal)).to eq true
    end

    it 'should return false' do
      proposal.stub(:items => [item_2])

      expect(subject.has_item_with_unit_price_equals_zero(proposal)).to eq false
    end
  end
end
