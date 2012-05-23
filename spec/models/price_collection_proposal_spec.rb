# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_proposal'

describe PriceCollectionProposal do
  it { should belong_to :price_collection }
  it { should belong_to :provider }

  it { should validate_presence_of :price_collection }
  it { should validate_presence_of :provider }

  it 'should return price_colletion and provider as to_s method' do
    subject.stub(:price_collection).and_return('Price Collection 1')
    subject.stub(:provider).and_return('Provider 1')

    subject.to_s.should eq 'Price Collection 1 - Provider 1'
  end

  context 'items by lot' do
    let(:item_1) do
      double('item 1', :price_collection_lot => 'lot 1', :total_price => 10)
    end

    let(:item_2) do
      double('item 2', :price_collection_lot => 'lot 2', :total_price => 20)
    end

    let(:item_3) do
      double('item 3', :price_collection_lot => 'lot 1', :total_price => 40)
    end

    it 'should return the items by lot' do
      subject.stub(:items).and_return([item_1, item_2, item_3])

      subject.items_by_lot('lot 1').should eq [item_1, item_3]
    end

    it 'should return the item total value by lot' do
      subject.stub(:items).and_return([item_1, item_2, item_3])

      subject.item_total_value_by_lot('lot 1').should eq 50
    end
  end
end
