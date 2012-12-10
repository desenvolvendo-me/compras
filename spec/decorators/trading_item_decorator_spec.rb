# encoding: utf-8
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
    context "negotiation is the current stage" do
      it "it returns the link to classdification if negociation is not started" do
        stage_calculator = double(:stage_calculator,
                                  :stage_of_negotiation? => true)
        item_bids = double(:negotiation => [])
        component.stub(:trading_item_bids => item_bids,
                       :bidders_selected_for_negociation => [])
        routes.stub(:classification_trading_item_path => '/foo')

        expect(subject.trading_item_bid_or_classification_path(:stage_calculator => stage_calculator)).to eq '/foo'
      end

      it "returns the path to new offer if negotiation is started and there are remaining bidders" do
        stage_calculator = double(:stage_calculator,
                                  :stage_of_negotiation? => true)
        item_bids = double(:negotiation => [double])
        component.stub(:trading_item_bids => item_bids,
                       :bidders_selected_for_negociation => [double],
                       :id => -1)
        routes.stub(:new_trading_item_bid_path => '/foo')

        expect(subject.trading_item_bid_or_classification_path(:stage_calculator => stage_calculator)).to eq '/foo'
      end
    end

    it 'should return new_trading_item_bid_path link when it is not on stage of negotiation' do
      stage_calculator = double(:stage_calculator)

      stage_calculator.should_receive(:stage_of_negotiation?).and_return(false)
      component.stub(:id).and_return(1)

      routes.should_receive(:new_trading_item_bid_path).
             with(:trading_item_id => 1, :anchor => :title).and_return('new_trading_item_bid_path#title')


      expect(subject.trading_item_bid_or_classification_path(:stage_calculator => stage_calculator)).to eq 'new_trading_item_bid_path#title'
    end
  end

  describe '#trading_item_bid_or_classification_or_report_classification_path' do
    it "should return proposal report when 'round of bids' is the current stage and dont have any proposal" do
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

  describe '#situation_for_next_stage' do
    let(:bidder_one) { double(:bidder_one) }
    let(:bidder_two) { double(:bidder_two) }
    let(:bidders) { [bidder_one, bidder_two] }

    it 'when the proposal is greater than the limit' do
      I18n.backend.store_translations 'pt-BR', :trading_item => {
          :messages => {
            :not_selected => 'Não selecionado'
        }
      }

      component.should_receive(:bidders).and_return(bidders)
      component.should_receive(:value_limit_to_participate_in_bids).and_return(10)
      bidders.should_receive(:with_proposal_for_proposal_stage_with_amount_lower_than_limit).with(10).and_return([bidder_one])
      component.stub(:bidder_selected?).with(bidder_two).and_return(false)

      expect(subject.situation_for_next_stage(bidder_two)).to eq 'Não selecionado'
    end

    it 'when the proposal is greater than the limit' do
      I18n.backend.store_translations 'pt-BR', :trading_item => {
          :messages => {
            :selected => 'Selecionado'
        }
      }

      component.should_receive(:bidders).and_return(bidders)
      component.should_receive(:value_limit_to_participate_in_bids).and_return(10)
      bidders.should_receive(:with_proposal_for_proposal_stage_with_amount_lower_than_limit).with(10).and_return([bidder_one])
      component.stub(:bidder_selected?).with(bidder_one).and_return(true)

      expect(subject.situation_for_next_stage(bidder_one)).to eq 'Selecionado'
    end
  end

  describe "#must_have_minimum_reduction" do
    before do
      component.stub(:minimum_reduction_value => 0.0,
                     :minimum_reduction_percent => 0.0)
    end

    it "returns nil if item has a minimum reduction value set" do
      component.stub(:minimum_reduction_value => 1.0)

      expect(subject.must_have_minimum_reduction).to be_nil
    end

    it "returns nil if item has a minimum reduction percent set" do
      component.stub(:minimum_reduction_percent => 1.0)

      expect(subject.must_have_minimum_reduction).to be_nil
    end

    it "returns disabled_message if both minimum reductions are nil" do
      I18n.backend.store_translations 'pt-BR', :trading_item => {
        :messages => {
          :must_have_reduction => 'não pode'
        }
      }

      expect(subject.must_have_minimum_reduction).to eq "não pode"
    end
  end
end
