# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_lot_item'
require 'app/models/price_collection_proposal_item'
require 'app/models/price_collection_classification'

describe PriceCollectionLotItem do
  it { should belong_to :price_collection_lot }
  it { should belong_to :material }
  it { should have_many(:price_collection_proposal_items).dependent(:destroy) }
  it { should have_many(:price_collection_classifications).dependent(:destroy) }

  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_numericality_of :quantity }

  it 'should not have quantity less than 1' do
    subject.should_not allow_value(0).for(:quantity).
                                      with_message("deve ser maior ou igual a 1")
  end

  context 'unit price and total value in a price collection' do
    let :proposal do
      double('PriceCollectionProposal', :items => [price_collection_proposal_item], :creditor => creditor)
    end

    let :price_collection_proposal_item do
      double('PriceCollectionProposalItem', :id => 1, :price_collection_lot_item => subject, :unit_price => 10)
    end

    let :price_collection do
      double('PriceCollection', :price_collection_proposals => [proposal])
    end

    let :creditor do
      double('Creditor')
    end

    it 'should return unit price by proposal' do
      subject.unit_price_by_proposal(proposal).should eq 10
    end

    it 'should return total value by proposal' do
      subject.quantity = 4
      subject.total_value_by_proposal(proposal).should eq 40
    end

    it 'should return zero when unit price equals nil' do
      price_collection_proposal_item.stub(:unit_price => nil)
      subject.quantity = 3

      subject.total_value_by_proposal(proposal).should eq 0
    end
  end

  it 'should return 0 as the quantity default value' do
    subject.quantity.should eq 0
  end
end
