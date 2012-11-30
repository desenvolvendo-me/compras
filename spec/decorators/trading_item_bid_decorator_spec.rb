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

  describe '#form_partial' do
    it 'should return form when stage is not proposal' do
      trading_item = double(:trading_item)
      trading_item_bid_stage_calculator = double(:trading_item_bid_stage_calculator)
      component.should_receive(:trading_item).and_return(trading_item)
      trading_item_bid_stage_calculator.should_receive(:new).and_return(trading_item)
      trading_item.stub(:stage_of_proposals?).and_return(false)

      expect(subject.form_partial(trading_item_bid_stage_calculator)).to eq 'form'
    end

    it 'should return form_of_proposal when stage is not proposal' do
      trading_item = double(:trading_item)
      trading_item_bid_stage_calculator = double(:trading_item_bid_stage_calculator)
      component.should_receive(:trading_item).and_return(trading_item)
      trading_item_bid_stage_calculator.should_receive(:new).and_return(trading_item)
      trading_item.stub(:stage_of_proposals?).and_return(true)

      expect(subject.form_partial(trading_item_bid_stage_calculator)).to eq 'form_of_proposal'
    end
  end
end
