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

  describe '#form_partial' do
    it 'should return form when stage is not proposal' do
      trading_item = double(:trading_item)
      trading_item_bid_stage_calculator = double(:trading_item_bid_stage_calculator)
      component.should_receive(:trading_item).and_return(trading_item)
      trading_item_bid_stage_calculator.should_receive(:new).with(trading_item).and_return(trading_item_bid_stage_calculator)
      trading_item_bid_stage_calculator.stub(:stage_of_proposals?).and_return(false)

      expect(subject.form_partial(trading_item_bid_stage_calculator)).to eq 'form'
    end

    it 'should return form_of_proposal when stage is not proposal' do
      trading_item = double(:trading_item)
      trading_item_bid_stage_calculator = double(:trading_item_bid_stage_calculator)
      component.should_receive(:trading_item).and_return(trading_item)
      trading_item_bid_stage_calculator.should_receive(:new).with(trading_item).and_return(trading_item_bid_stage_calculator)
      trading_item_bid_stage_calculator.stub(:stage_of_proposals?).and_return(true)

      expect(subject.form_partial(trading_item_bid_stage_calculator)).to eq 'form_of_proposal'
    end
  end

  describe '#new_title' do
    before do
      component.stub(:trading_item).and_return(double(:trading_item))

       I18n.backend.store_translations 'pt-BR',
         :trading_item_bid_negotiations  => { :new => 'Negociação' },
         :trading_item_bid_round_of_bids => { :new => 'Registrar Lance'}
    end

    context 'when at stage of negotiation' do
      let :stage_calculator_instance do
        double(:stage_calculator,
               :stage_of_proposals? => false,
               :stage_of_negotiation? => true,
               :stage_of_round_of_bids? => false)
      end

      it 'should returns create_proposal' do
        stage_calculator = double(:stage_calculator)

        stage_calculator.should_receive(:new).and_return(stage_calculator_instance)

        expect(subject.new_title(stage_calculator)).to eq 'Negociação'
      end
    end

    context 'when at stage of round of bids' do
      let :stage_calculator_instance do
        double(:stage_calculator,
               :stage_of_proposals? => false,
               :stage_of_negotiation? => false,
               :stage_of_round_of_bids? => true)
      end

      it 'should returns create_proposal' do
        stage_calculator = double(:stage_calculator)

        stage_calculator.should_receive(:new).and_return(stage_calculator_instance)

        expect(subject.new_title(stage_calculator)).to eq 'Registrar Lance'
      end
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
end
