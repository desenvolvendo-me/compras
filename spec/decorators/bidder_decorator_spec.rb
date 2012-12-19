# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/bidder_decorator'

describe BidderDecorator do
  context '#process_date' do
    context 'when do not have licitation_process_process_date' do
      before do
        component.stub(:licitation_process_process_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.process_date).to be_nil
      end
    end

    context 'when have licitation_process_process_date' do
      before do
        component.stub(:licitation_process_process_date).and_return(Date.new(2012, 12, 1))
      end

      it 'should localize' do
        expect(subject.process_date).to eq '01/12/2012'
      end
    end
  end

  context '#show_proposal_tabs' do
    it "should return items partial when can update proposals and haven't lots" do
      component.stub(:can_update_proposals?).and_return(true)
      component.stub_chain(:licitation_process_lots, :empty?).and_return(true)
      expect(subject.show_proposal_tabs).to eq "bidders/proposal_by_items"
    end

    it "should return lots partial when can update proposals and have lots" do
      component.stub(:can_update_proposals?).and_return(true)
      component.stub_chain(:licitation_process_lots, :empty?).and_return(false)
      expect(subject.show_proposal_tabs).to eq "bidders/proposal_by_lots"
    end

    context 'when cannot update proposals' do
      before do
        I18n.backend.store_translations 'pt-BR', :other => {
          'compras' => {
            'messages' => {
              'to_add_proposals_all_items_must_belong_to_any_lot_or_any_lot_must_exist' => 'Para adicionar propostas, todos os itens devem pertencer a algum Lote ou nenhum lote deve existir.'
            }
          }
        }
      end

      it "should return erro message" do
        component.stub(:can_update_proposals?).and_return(false)
        expect(subject.show_proposal_tabs).to eq :text => "Para adicionar propostas, todos os itens devem pertencer a algum Lote ou nenhum lote deve existir."
      end
    end
  end

  describe "#proposal_total_value_by_lot" do
    context 'when do not have proposal_total_value_by_lot' do
      before do
        component.stub(:proposal_total_value_by_lot).and_return(0)
      end

      it 'should applies precision to zero' do
        expect(subject.proposal_total_value_by_lot).to eq '0,00'
      end
    end

    context 'when have proposal_total_value_by_lot' do
      before do
        component.stub(:proposal_total_value_by_lot).with(lot).and_return(5000.0)
      end

      let :lot do
        double :lot
      end

      it 'should applies precision' do
        expect(subject.proposal_total_value_by_lot(lot)).to eq '5.000,00'
      end
    end
  end

  context '#proposal_total_value' do
    context 'when do not have proposal_total_value' do
      before do
        component.stub(:proposal_total_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.proposal_total_value).to be_nil
      end
    end

    context 'when have proposal_total_value' do
      before do
        component.stub(:proposal_total_value).and_return(10.0)
      end

      it 'should applies precision' do
        expect(subject.proposal_total_value).to eq '10,00'
      end
    end
  end

  context "with bidder enabled" do
    before { component.stub(:disabled).and_return(false) }

    describe '#lower_trading_item_bid_amount' do
      it 'should return a number with precision' do
        trading_item = double(:trading_item)

        component.should_receive(:lower_trading_item_bid_amount).
          at_least(1).times.with(trading_item).and_return(123456.78)

        expect(subject.lower_trading_item_bid_amount(trading_item)).to eq '123.456,78'
      end

      it 'should be nil' do
        trading_item = double(:trading_item)

        component.stub(:lower_trading_item_bid_amount).and_return(nil)

        expect(subject.lower_trading_item_bid_amount(trading_item)).to be_nil
      end
    end

    describe '#trading_item_classification_percent' do
      it 'should return a number with precision' do
        trading_item = double(:trading_item)

        component.should_receive(:trading_item_classification_percent).
          at_least(1).times.with(trading_item).and_return(123456.78)

        expect(subject.trading_item_classification_percent(trading_item)).to eq '123.456,78'
      end

      it 'should be nil' do
        trading_item = double(:trading_item)

        component.stub(:trading_item_classification_percent).and_return(nil)

        expect(subject.trading_item_classification_percent(trading_item)).to be_nil
      end
    end
  end

  describe '#benefited_by_law_of_proposals_class' do
    it 'should return "benefited" when benefited_by_law_of_proposals and valid_benefited_percent' do
      trading_item = double(:trading_item)

      component.stub(:benefited_by_law_of_proposals?).and_return(true)
      subject.stub(:valid_benefited_percent?).and_return(true)

      expect(subject.benefited_by_law_of_proposals_class(trading_item)).to eq 'benefited'
    end

    it 'should return "not-benefited" when not benefited_by_law_of_proposals and valid_benefited_percent' do
      trading_item = double(:trading_item)

      component.stub(:benefited_by_law_of_proposals?).and_return(false)
      subject.stub(:valid_benefited_percent?).and_return(true)

      expect(subject.benefited_by_law_of_proposals_class(trading_item)).to eq 'not-benefited'
    end

    it 'should return "not-benefited" when benefited_by_law_of_proposals and not valid_benefited_percent' do
      trading_item = double(:trading_item)

      component.stub(:benefited_by_law_of_proposals?).and_return(true)
      subject.stub(:valid_benefited_percent?).and_return(false)

      expect(subject.benefited_by_law_of_proposals_class(trading_item)).to eq 'not-benefited'
    end
  end

  describe '#cant_save_or_destroy_message' do
    before do
      I18n.backend.store_translations 'pt-BR', :bidder => {
          :messages => {
            :cant_save_or_destroy => 'não pode',
            :cant_be_changed_when_licitation_process_has_a_ratification => 'ratification'
        }
      }
    end

    it 'when bidders are not allowed' do
      component.stub(:allow_bidders? => false)
      component.stub(:licitation_process_ratification?).and_return(false)

      expect(subject.cant_save_or_destroy_message).to eq 'não pode'
    end

    it 'when bidders are allowed' do
      component.stub(:allow_bidders? => true)
      component.stub(:licitation_process_ratification?).and_return(false)

      expect(subject.cant_save_or_destroy_message).to be_nil
    end

    it 'should return the ratification message when licitation process has ratification' do
      component.stub(:licitation_process_ratification?).and_return(true)

      expect(subject.cant_save_or_destroy_message).to eq 'ratification'
    end
  end
end
