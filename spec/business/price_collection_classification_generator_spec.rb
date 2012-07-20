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

  let :proposal do
    double('PriceCollectionProposal', :id => 10,
           :creditor => double('Creditor'), :items => proposal_items,
           :total_price => 200, :creditor_id => 1)
  end

  let :price_collection_proposals do
    [proposal]
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

  let :proposal_item do
    double(:unit_price => 20, :creditor => double('Creditor'), :quantity => 2)
  end

  let :proposal_items do
    [proposal_item]
  end

  let :proposals_with_total_value do
    [double(:total_value => 1000, :creditor => double('Creditor'))]
  end

  let :lots_with_total_value do
    [double(:total_value => 500, :creditor_id => 1)]
  end

  context "generete a list of price collection classifications" do
    before do
      price_collection.should_receive(:destroy_all_price_collection_classifications).and_return(true)
    end

    it "when type of calculation equals lowest total price by item" do
      price_collection.stub(:type_of_calculation => 'lowest_total_price_by_item')

      proposal.should_receive(:classification_by_item).with(proposal_item).and_return(1)

      proposal_item.should_receive(:price_collection_lot_item).and_return(item)

      price_collection_classification_repository.should_receive(:create!)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_classification_repository).generate!
    end

    it "when type of calculation equals lowest global price" do
      price_collection.stub(:type_of_calculation => 'lowest_global_price')

      proposal.should_receive(:classification).and_return(1)

      price_collection_classification_repository.should_receive(:create!)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_classification_repository).generate!
    end

    it "when type of calculation equals lowest total price by item" do
      price_collection.stub(:type_of_calculation => 'lowest_price_by_lot')

      proposal.should_receive(:classification_by_lot).with(lot).and_return(1)
      proposal.should_receive(:item_total_value_by_lot).with(lot).and_return(100)

      price_collection_classification_repository.should_receive(:create!)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_classification_repository).generate!
    end
  end
end
