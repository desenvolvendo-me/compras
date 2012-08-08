# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_bidder_decorator'

describe LicitationProcessBidderDecorator do
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
      expect(subject.show_proposal_tabs).to eq "licitation_process_bidders/proposal_by_items"
    end

    it "should return lots partial when can update proposals and have lots" do
      component.stub(:can_update_proposals?).and_return(true)
      component.stub_chain(:licitation_process_lots, :empty?).and_return(false)
      expect(subject.show_proposal_tabs).to eq "licitation_process_bidders/proposal_by_lots"
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
end
