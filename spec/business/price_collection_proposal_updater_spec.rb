require 'unit_helper'
require 'app/business/price_collection_proposal_updater'

describe PriceCollectionProposalUpdater do
  let :price_collection do
    double('Collection', :price_collection_proposals => [proposal], :items => [double(:id => 1), double(:id => 2)])
  end

  let :proposal do
    double('Proposal', :id => 1)
  end

  let :proposal_item_repository do
    double('Item Storage')
  end

  subject { described_class.new(price_collection, proposal_item_repository) }

  describe '#update!' do
    before do
      proposal_item_repository.stub(:by_proposal_and_item).with(:proposal_id => 1, :item_id => 2).and_return []
      proposal_item_repository.stub(:by_proposal_and_item).with(:proposal_id => 1, :item_id => 1).and_return [double]
    end

    it 'check all items on the proposals and create the ones with no exists' do
      proposal_item_repository.should_receive(:create!).with(:price_collection_proposal_id => 1, :price_collection_lot_item_id => 2)

      subject.update!
    end
  end

end