require 'unit_helper'
require 'enumerate_it'
require 'active_support/core_ext/module/delegation'
require 'app/business/price_collection_classification_generator'
require 'app/enumerations/price_collection_type_of_calculation'

describe PriceCollectionClassificationGenerator do

  let :price_collection do
    double('PriceCollection',
      :id => 1,
      :price_collection_proposals => price_collection_proposals,
      :price_collection_lots => price_collection_lots,
      :items => items
    )
  end

  let :price_collection_proposal_item_storage do
    double('PriceCollectionProposalItem')
  end

  let :price_collection_proposal_storage do
    double('PriceCollectionProposal')
  end

  let :price_collection_classification_storage do
    double('PriceCollectionClassification')
  end

  let :price_collection_proposals do
    [double('PriceCollectionProposal', :id => 10, :creditor => double('Creditor'))]
  end

  let :items do
    [double('PriceCollectionLotItem', :id => 1, :quantity => 5)]
  end

  let :price_collection_lots do
    [double('PriceCollectionLot', :id => 20, :creditor => double('Creditor'))]
  end

  let :proposal_items do
    [double(:unit_price => 20, :creditor => double('Creditor'))]
  end

  let :proposals_with_total_value do
    [double(:total_value => 1000, :creditor => double('Creditor'))]
  end

  let :lots_with_total_value do
    [double(:total_value => 500, :creditor_id => 1)]
  end

  let :classifications do
    []
  end

  context "generete a list of price collection classifications" do
    it "when type of calculation equals lowest total price by item" do
      price_collection.stub(:type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)
      price_collection_proposal_item_storage.should_receive(:by_item_order_by_unit_price).with(1).and_return(proposal_items)

      price_collection_classification_storage.should_receive(:new)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_proposal_item_storage, price_collection_proposal_storage,
                                                 price_collection_classification_storage, classifications).generate!
    end

    it "when type of calculation equals lowest global price" do
      price_collection.stub(:type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE)
      price_collection_proposal_storage.should_receive(:by_price_collection_id_sum_items).with(1).and_return(proposals_with_total_value)
      price_collection_classification_storage.should_receive(:new)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_proposal_item_storage, price_collection_proposal_storage,
                                                 price_collection_classification_storage, classifications).generate!
    end

    it "when type of calculation equals lowest total price by item" do
      price_collection.stub(:type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_PRICE_BY_LOT)
      price_collection_proposal_item_storage.should_receive(:by_lot_item_order_by_unit_price).with(20).and_return(lots_with_total_value)
      price_collection_classification_storage.should_receive(:new)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_proposal_item_storage, price_collection_proposal_storage,
                                                 price_collection_classification_storage, classifications).generate!
    end
  end

end
