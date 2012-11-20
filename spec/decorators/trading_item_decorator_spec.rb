require 'decorator_helper'
require 'enumerate_it'
require 'app/decorators/trading_item_decorator'
require 'app/enumerations/trading_item_bid_stage'

describe TradingItemDecorator do
  describe '#unit_price' do
    context 'when unit price is nil' do
      before do
        component.stub(:unit_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.unit_price).to be_nil
      end
    end

    context 'when unit price is not nil' do
      before do
        component.stub(:unit_price).and_return(9.99)
      end

      it 'should apply precision' do
        expect(subject.unit_price).to eq '9,99'
      end
    end
  end

  describe '#quantity' do
    context 'when quantity is nil' do
      before do
        component.stub(:quantity).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.quantity).to be_nil
      end
    end

    context 'when quantity has value' do
      before do
        component.stub(:quantity).and_return(220.0)
      end

      it 'should applies precision' do
        expect(subject.quantity).to eq '220,00'
      end
    end
  end

  describe '#trading_item_bid_or_classification_path' do
    it 'should return classification link when \'negotiation\' is the current stage' do
      stage_calculator = double(:stage_calculator)

      stage_calculator.should_receive(:new).
                       with(component).and_return(stage_calculator)

      stage_calculator.should_receive(:stage_of_negotiation?).and_return(true)

      component.stub(:id).and_return(1)

      routes.should_receive(:classification_trading_item_path).
             with(component).and_return('classification_path')


      expect(subject.trading_item_bid_or_classification_path(stage_calculator)).to eq 'classification_path'
    end

    it 'should return new_trading_item_bid_path link when it is not on stage of negotiation' do
      stage_calculator = double(:stage_calculator)

      stage_calculator.should_receive(:new).
                       with(component).and_return(stage_calculator)

      stage_calculator.should_receive(:stage_of_negotiation?).and_return(false)
      component.stub(:id).and_return(1)

      routes.should_receive(:new_trading_item_bid_path).
             with(:trading_item_id => 1).and_return('new_trading_item_bid_path')


      expect(subject.trading_item_bid_or_classification_path(stage_calculator)).to eq 'new_trading_item_bid_path'
    end
  end

  describe '#trading_item_bid_or_classification_or_report_classification_path' do
    it 'should return proposal report when \'round of bids\' is the current stage and dont have any proposal' do
      stage_calculator = double(:stage_calculator)

      stage_calculator.should_receive(:new).
                       with(component).and_return(stage_calculator)

      stage_calculator.should_receive(:show_proposal_report?).and_return(true)

      component.stub(:id).and_return(1)

      routes.should_receive(:proposal_report_trading_item_path).
             with(component).and_return('proposal_report_path')

      expect(subject.trading_item_bid_or_classification_or_report_classification_path(stage_calculator)).to eq 'proposal_report_path'
    end
  end
end
