# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_lot_item'
require 'app/models/price_collection_proposal_item'

describe PriceCollectionLotItem do
  it { should belong_to :price_collection_lot }
  it { should belong_to :material }
  it { should have_many(:price_collection_proposal_items).dependent(:destroy) }

  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_numericality_of :quantity }

  it 'should not have quantity less than 1' do
    subject.should_not allow_value(0).for(:quantity).
                                      with_message("deve ser maior ou igual a 1")
  end

  it 'should return the winner proposal' do
    classificator = double(:winner_proposal => 'proposal 1')
    classificator_class = double(:new => classificator)

    subject.winner_proposal(classificator_class).should eq 'proposal 1'
  end
end
