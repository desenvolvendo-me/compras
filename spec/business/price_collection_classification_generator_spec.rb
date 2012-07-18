require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/price_collection_classification_generator'

describe PriceCollectionClassificationGenerator do

  let :price_collection do
    double('PriceCollection',
      :id => 1,
      :price_collection_proposals => price_collection_proposals,
      :price_collection_lots => price_collection_lots,
      :items => items,
      :proposals_with_total_value => proposals_with_total_value
    )
  end

  let :price_collection_classification_repository do
    double('PriceCollectionClassification')
  end

  let :price_collection_proposals do
    [double('PriceCollectionProposal', :id => 10, :creditor => double('Creditor'))]
  end

  let :item do
    double('PriceCollectionLotItem', :id => 1, :quantity => 5, :proposal_items => proposal_items)
  end

  let :items do
    [item]
  end

  let :lot do
    double('PriceCollectionLot', :id => 20, :creditor => double('Creditor'), :lots_with_total_value => lots_with_total_value)
  end

  let :price_collection_lots do
    [lot]
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

  context "generete a list of price collection classifications" do
    it "when type of calculation equals lowest total price by item" do
      price_collection.stub(:type_of_calculation => 'lowest_total_price_by_item')

      price_collection_classification_repository.should_receive(:create!)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_classification_repository).generate!
    end

    it "when type of calculation equals lowest global price" do
      price_collection.stub(:type_of_calculation => 'lowest_global_price')

      price_collection_classification_repository.should_receive(:create!)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_classification_repository).generate!
    end

    it "when type of calculation equals lowest total price by item" do
      price_collection.stub(:type_of_calculation => 'lowest_price_by_lot')

      price_collection_classification_repository.should_receive(:create!)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_classification_repository).generate!
    end
  end
end
