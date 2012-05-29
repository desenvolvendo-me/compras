require 'unit_helper'
require 'app/business/price_collection_proposal_generator'

describe PriceCollectionProposalGenerator do
  subject do
    described_class.new(price_collection, proposal_storage, proposal_item_storage)
  end

  let(:price_collection) do
    double(:id => 1,
           :providers => [provider],
           :price_collection_proposals => [],
           :items => [item])
  end

  let(:provider) do
    double('provider', :id => 2)
  end

  let(:item) do
    double('item', :id => 3)
  end

  let(:proposal) do
    double('proposal', :id => 4, :price_collection_id => 1, :provider_id => 2, :provider => provider)
  end

  let(:proposal_storage) do
    double('proposal_storage')
  end

  let(:proposal_item_storage) do
    double('proposal_item_storage')
  end

  it 'should create a new proposal for the provider when there is no proposal' do
    proposal_storage.should_receive(:by_price_collection_and_provider).and_return([])

    proposal_storage.should_receive(:create!).with({:price_collection_id=>1, :provider_id=>2}).once

    subject.generate!
  end

  it 'should not create a new proposal for the provider when there is a proposal' do
    proposal_storage.should_receive(:by_price_collection_and_provider).and_return([1])

    proposal_storage.should_receive(:create!).never

    subject.generate!
  end

  it 'should create a new proposal item when there is no item' do
    subject.stub(:proposals).and_return([proposal])
    proposal_storage.should_receive(:by_price_collection_and_provider).and_return([proposal])

    proposal_item_storage.should_receive(:by_proposal_and_item).and_return([])

    proposal_item_storage.should_receive(:create!).with({:price_collection_proposal_id=>4, :price_collection_lot_item_id=>3}).once

    subject.generate!
  end

  it 'should not create a new proposal item when there is an item' do
    subject.stub(:proposals).and_return([proposal])
    proposal_storage.should_receive(:by_price_collection_and_provider).and_return([proposal])

    proposal_item_storage.should_receive(:by_proposal_and_item).and_return([1])

    proposal_item_storage.should_receive(:create!).never

    subject.generate!
  end
end
