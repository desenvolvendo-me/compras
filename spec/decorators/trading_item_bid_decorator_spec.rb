# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/trading_item_bid_decorator'

describe TradingItemBidDecorator do
  describe '#trading_item_lowest_proposal_value' do
    it 'should return number with precision' do
      component.stub(:trading_item_lowest_proposal_value).and_return(12345.67)

      expect(subject.trading_item_lowest_proposal_value).to eq '12.345,67'
    end
  end

  describe '#minimum_limit' do
    it 'should return number with precision' do
      component.stub(:minimum_limit).and_return(1234.56)

      expect(subject.minimum_limit).to eq '1.234,56'
    end
  end

  describe '#show_undo_button?' do
    it 'should return true when there is at least one bid at round of proposals' do
      trading_item = double(:trading_item, :proposals_for_round_of_bids? => true)

      component.stub(:trading_item).and_return(trading_item)

      expect(subject.show_undo_button?).to be_true
    end

    it 'should return false when there is no one bid at round of proposals' do
      trading_item = double(:trading_item, :proposals_for_round_of_bids? => false)

      component.stub(:trading_item).and_return(trading_item)

      expect(subject.show_undo_button?).to be_false
    end
  end

  describe '#amount' do
    it 'should return number with precision' do
      component.stub(:amount).and_return(1234.56)

      expect(subject.amount).to eq '1.234,56'
    end
  end

  describe '#last_valid_amount_by_bidder_and_item_and_round' do
    it 'should return amount when has amount' do
      component.stub(:amount).and_return(1234.56)

      expect(subject.last_valid_amount_by_bidder_and_item_and_round).to eq '1.234,56'
    end

    it 'should return last_valid_amount_by_bidder_and_item_and_round when has not amount' do
      component.stub(:amount).and_return(0)

      component.should_receive(:last_valid_amount_by_bidder_and_item_and_round).at_least(1).times

      subject.last_valid_amount_by_bidder_and_item_and_round
    end

    it 'should return 0 when has not amount and last_valid_amount_by_bidder_and_item_and_round' do
      component.stub(:amount).and_return(0)
      component.stub(:last_valid_amount_by_bidder_and_item_and_round).and_return(nil)

      expect(subject.last_valid_amount_by_bidder_and_item_and_round).to eq 0
    end
  end
end
