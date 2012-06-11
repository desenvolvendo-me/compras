# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_proposal'
require 'app/models/price_collection_proposal_item'
require 'lib/annullable'
require 'app/models/resource_annul'

describe PriceCollectionProposal do
  it { should belong_to :price_collection }
  it { should belong_to :provider }

  it { should have_many :items }
  it { should have_one :annul }

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

  describe '#editable_by?' do
    let :provider do
      double('Provider')
    end

    before do
      subject.stub(:provider).and_return provider
    end

    it 'should be true when the provider is the given user' do
      user = double('User', :authenticable => provider)

      subject.editable_by?(user).should be_true
    end

    it 'should not be true for when the provider is not the given user' do
      user = double('User', :authenticable => double)

      subject.editable_by?(user).should be_false
    end
  end

  describe '#annul!' do
    it 'should change the subject status to annuled' do
      subject.should_receive(:update_attribute).with(:status, PriceCollectionStatus::ANNULLED)

      subject.annul!
    end
  end

  it 'should return 0 as the total price when there are no items' do
    subject.total_price.should eq 0
  end

  it 'should return the total price' do
    item_1 = double('item 1', :total_price => 300)
    item_2 = double('item 2', :total_price => 200)

    subject.stub(:items).and_return([item_1, item_2])

    subject.total_price.should eq 500
  end
end
