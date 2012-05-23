# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_proposal_item'

describe PriceCollectionProposalItem do
  it { should belong_to :price_collection_proposal }
  it { should belong_to :price_collection_lot_item }
  it { should have_one(:price_collection_lot).through(:price_collection_lot_item) }

  it 'should return 0 as the total price default value' do
    subject.total_price.should eq 0
  end

  it 'should return the total price with quantity and unit_price' do
    subject.stub(:quantity).and_return(5)
    subject.stub(:unit_price).and_return(10)

    subject.total_price.should eq 50
  end
end
