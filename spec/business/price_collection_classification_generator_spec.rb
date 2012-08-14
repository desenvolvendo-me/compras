require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/price_collection_classification_generator'

describe PriceCollectionClassificationGenerator do

  let :price_collection do
    double('PriceCollection',
      :id => 1,
      :price_collection_proposals => price_collection_proposals,
      :price_collection_lots_with_items => price_collection_lots_with_items,
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
    double('PriceCollectionLot', :id => 20, :creditor => double('Creditor'), :lots_with_total_value => lots_with_total_value, :items => items)
  end

  let :price_collection_lots_with_items do
    [lot]
  end

  let :proposal_item do
    double(:unit_price => 20, :quantity => 2)
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

      proposal_item.stub(:price_collection_proposal => proposal)
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

      proposal.should_receive(:global_classification).and_return(1)

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

  context 'check if winner has item with zero in unit price' do
    let :classification_1 do
      double(:classifiable_type => 'PriceCollection', :classifiable_id => 1, :classification => 2)
    end

    let :classification_2 do
      double(:classifiable_type => 'PriceCollection', :classifiable_id => 1, :classification => 1)
    end

    before do
      price_collection.stub(:all_price_collection_classifications => [classification_1, classification_2])
    end

    it 'should check if has classification -1' do
      PriceCollectionClassificationGenerator.new(price_collection, price_collection_classification_repository).check_if_winner_has_zero!

      expect(classification_1.classification).to eq 2
      expect(classification_2.classification).to eq 1
    end

    it 'should update classification' do
      classification_2.stub(:classification => -1)

      classification_1.should_receive(:update_column).with(:classification, 1).and_return(true)

      PriceCollectionClassificationGenerator.new(price_collection, price_collection_classification_repository).check_if_winner_has_zero!
    end
  end
end
