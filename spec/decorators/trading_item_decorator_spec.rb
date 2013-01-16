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
      bidders.should_receive(:selected_for_trading_item).with(component).and_return([bidder_one])
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
      bidders.should_receive(:selected_for_trading_item).with(component).and_return([bidder_one])
      component.stub(:bidder_selected?).with(bidder_one).and_return(true)

      expect(subject.situation_for_next_stage(bidder_one)).to eq 'Selecionado'
    end
  end

  describe "#allows_offer_placing" do
    let(:trading_item) { double(:trading_item, :started? => true, :closed? => true) }
    let(:trading) { double(:trading, :trading_items => [trading_item, component]) }

    before do
      component.stub(:minimum_reduction_value => 0.0,
                     :minimum_reduction_percent => 0.0,
                     :closed? => false,
                     :started? => true,
                     :trading => trading)
    end

    context 'with another item not started' do
      describe "item is still open" do
        it "returns nil if item has a minimum reduction value set" do
          component.stub(:minimum_reduction_value => 1.0)

          expect(subject.allows_offer_placing).to be_nil
        end

        it "returns nil if item has a minimum reduction percent set" do
          component.stub(:minimum_reduction_percent => 1.0)

          expect(subject.allows_offer_placing).to be_nil
        end

        it "returns disabled_message if both minimum reductions are nil" do
          I18n.backend.store_translations 'pt-BR', :trading_item => {
            :messages => {
              :must_have_reduction => 'não pode'
            }
          }

          expect(subject.allows_offer_placing).to eq "não pode"
        end
      end

      describe "item is closed" do
        it "returns a disabling message" do
          component.stub(:minimum_reduction_percent => 0.1,
                         :closed? => true)
          I18n.backend.store_translations 'pt-BR', :trading_item => {
            :messages => {
              :must_be_open => 'deve estar aberto'
            }
          }

          expect(subject.allows_offer_placing).to eq "deve estar aberto"
        end
      end
    end

    context 'with another item started but not closed' do
      before do
        trading_item.stub(:closed? => false)
      end

      describe "item is still open" do
        it "returns there_is_an_pending_item" do
          I18n.backend.store_translations 'pt-BR', :trading_item => {
            :messages => {
              :there_is_an_pending_item => 'acabe o item aberto'
            }
          }

          component.stub(:minimum_reduction_value => 1.0)

          expect(subject.allows_offer_placing).to eq 'acabe o item aberto'
        end
      end

      describe "item is closed" do
        it "returns a disabling message" do
          component.stub(:minimum_reduction_percent => 0.1,
                         :closed? => true)
          I18n.backend.store_translations 'pt-BR', :trading_item => {
            :messages => {
              :must_be_open => 'deve estar aberto'
            }
          }

          expect(subject.allows_offer_placing).to eq "deve estar aberto"
        end
      end
    end
  end

  describe '#current_stage_path' do
    let(:stage_calculator) { double(:stage_calculator) }

    before do
      component.stub(:id).and_return(1)
    end

    context 'when on stage of proposals' do
      before do
        stage_calculator.stub(:stage_of_proposals?).and_return(true)
      end

      it 'should return the path to proposals when at stage of proposals' do
        routes.should_receive(:new_trading_item_bid_proposal_path).
          with(:trading_item_id=>1).and_return('new_proposal_path')

        expect(subject.current_stage_path(:stage_calculator => stage_calculator)).to eq 'new_proposal_path'
      end
    end

    context 'when on stage of round of bids' do
      before do
        stage_calculator.stub(:stage_of_proposals?).and_return(false)
        stage_calculator.stub(:stage_of_round_of_bids?).and_return(true)
      end

      it 'should return the path to propsal_report when there is no bids yet' do
        trading_item_bids = double(:trading_item_bids, :at_stage_of_round_of_bids => [])

        component.stub(:trading_item_bids).and_return(trading_item_bids)

        routes.should_receive(:proposal_report_trading_item_path).
          with(component).
          and_return('proposal_report_trading_item_path')

        expect(subject.current_stage_path(:stage_calculator => stage_calculator)).to eq 'proposal_report_trading_item_path'
      end

      it 'should return the path to the new bid when there is at least one bid' do
        trading_item_bids = double(:trading_item_bids, :at_stage_of_round_of_bids => ['bid'])

        component.stub(:trading_item_bids).and_return(trading_item_bids)

        routes.should_receive(:new_trading_item_bid_round_of_bid_path).
          with(:trading_item_id => 1).
          and_return('new_trading_item_bid_path')

        expect(subject.current_stage_path(:stage_calculator => stage_calculator)).to eq 'new_trading_item_bid_path'
      end
    end

    context 'when on stage of negotiation' do
      before do
        stage_calculator.stub(:stage_of_proposals?).and_return(false)
        stage_calculator.stub(:stage_of_round_of_bids?).and_return(false)
        stage_calculator.stub(:stage_of_negotiation?).and_return(true)
      end

      it 'should returns the classification if have no one negotiation or have no valid negotiation' do
        trading_item_bids = double(:trading_item_bids, :negotiation => [])

        component.stub(:trading_item_bids).and_return(trading_item_bids)

        routes.should_receive(:classification_trading_item_path).
          with(component).
          and_return('classification_trading_item_path')

        expect(subject.current_stage_path(:stage_calculator => stage_calculator)).to eq 'classification_trading_item_path'
      end

      it 'should returns the new negotiation if have one negotiation but have no valid negotiation' do
        trading_item_bids = double(:trading_item_bids, :negotiation => ['negotiation'])

        component.stub(:trading_item_bids).and_return(trading_item_bids)
        component.stub(:valid_bidder_for_negotiation?).and_return(true)

        routes.should_receive(:new_trading_item_bid_negotiation_path).
          with(:trading_item_id => 1).
          and_return('new_negotiation_path')

        expect(subject.current_stage_path(:stage_calculator => stage_calculator)).to eq 'new_negotiation_path'
      end

      it 'should returns the classification if have no one negotiation but have a valid negotiation' do
        trading_item_bids = double(:trading_item_bids, :negotiation => [])

        component.stub(:trading_item_bids).and_return(trading_item_bids)
        component.stub(:valid_negotiation_proposals).and_return(['negotiation'])

        routes.should_receive(:classification_trading_item_path).
          with(component).
          and_return('classification_trading_item_path')

        expect(subject.current_stage_path(:stage_calculator => stage_calculator)).to eq 'classification_trading_item_path'
      end
    end
  end

  describe '#any_bid_at_negotiation?' do
    let(:trading_item_bids) { double(:bids) }

    context 'when there is any bid at round of negotiation' do
      before do
        trading_item_bids.stub(:at_stage_of_negotiation).and_return(['bid'])
        subject.stub(:trading_item_bids).and_return(trading_item_bids)
      end

      it 'should be true' do
        expect(subject.any_bid_at_negotiation?).to be_true
      end
    end

    context 'when there is no one bid at round of negotiation' do
      before do
        trading_item_bids.stub(:at_stage_of_negotiation).and_return([])
        subject.stub(:trading_item_bids).and_return(trading_item_bids)
      end

      it 'should be false' do
        expect(subject.any_bid_at_negotiation?).to be_false
      end
    end
  end

  describe '#cannot_undo_last_offer_message' do
    context  'when item is closed' do
      before do
        component.stub(:closed?).and_return(true)

        I18n.backend.store_translations 'pt-BR', :trading_item => {
            :messages => {
              :cannot_undo_last_offer_when_trading_items_is_closed => 'não pode desfazer'
            }
          }
      end

      it 'should return message' do
        expect(subject.cannot_undo_last_offer_message).to eq 'não pode desfazer'
      end
    end

    context 'when item is not closed' do
      before do
        component.stub(:closed?).and_return(false)
      end

      it 'should retuns nil' do
        expect(subject.cannot_undo_last_offer_message).to be_nil
      end
    end
  end

  describe '#cannot_undo_last_negotiation_message' do
    context  'when item is closed' do
      before do
        component.stub(:closed?).and_return(true)

        I18n.backend.store_translations 'pt-BR', :trading_item => {
            :messages => {
              :cannot_undo_last_negotiation_when_trading_items_is_closed => 'não pode desfazer'
            }
          }
      end

      it 'should return message' do
        expect(subject.cannot_undo_last_negotiation_message).to eq 'não pode desfazer'
      end
    end

    context 'when item is not closed' do
      before do
        component.stub(:closed?).and_return(false)
      end

      it 'should retuns nil' do
        expect(subject.cannot_undo_last_negotiation_message).to be_nil
      end
    end
  end

  describe '#not_allow_offer_message' do
    context 'when have valid proposals at round of proposals' do
      before do
        component.stub(:with_proposal_for_round_of_proposals? => true)
      end

      it { expect(subject.not_allow_offer_message).to be_nil }
    end

    context 'when have no proposal valid at round of proposals' do
      before do
        component.stub(:with_proposal_for_round_of_proposals? => false)

        I18n.backend.store_translations 'pt-BR', :trading_item => {
            :messages => {
              :not_allow_offer => 'não pode ter oferta'
            }
          }
      end

      it { expect(subject.not_allow_offer_message).to eq 'não pode ter oferta' }
    end
  end

  describe '#cannot_start_negotiation_message' do
    context 'when allow_negotiation' do
      before do
        component.stub(:allow_negotiation? => true)
      end

      it { expect(subject.cannot_start_negotiation_message).to be_nil }
    end

    context 'when not allow_negotiation' do
      before do
        component.stub(:allow_negotiation? => false)

        I18n.backend.store_translations 'pt-BR', :trading_item => {
            :messages => {
              :cannot_start_negotiation => 'não pode negociar'
            }
          }
      end

      it 'should return the message' do
        expect(subject.cannot_start_negotiation_message).to eq 'não pode negociar'
      end
    end
  end
end
