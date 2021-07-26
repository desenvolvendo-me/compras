require 'spec_helper'

describe LicitationProcessRatificationsHelper do
  describe '#creditor_proposals_helper_path' do
    let(:ratification) { double(:ratification) }

    context 'when licitation_process is not licitation' do
      before do
        ratification.stub(licitation_process_licitation?: false)
      end

      it "should return the purchase_process_items' index path" do
        helper.should_receive(:purchase_process_items_path).and_return('index')

        expect(helper.creditor_proposals_helper_path(ratification)).to eq 'index'
      end
    end

    context 'when licitation_process is licitation' do
      before do
        ratification.stub(licitation_process_licitation?: true)
      end

      context 'when judgment_form is by item' do
        before do
          ratification.stub(judgment_form_item?: true)
        end

        it "should return the trading or proposals' index path" do
          helper.should_receive(:trading_or_proposals_path).and_return('proposals_index')

          expect(helper.creditor_proposals_helper_path(ratification)).to eq 'proposals_index'
        end
      end

      context 'when judgment_form is not by item' do
        before do
          ratification.stub(judgment_form_item?: false)
        end

        it "should return the realignment_price_items' index path" do
          ratification.stub(licitation_process_id: 10)
          helper.should_receive(:realignment_price_items_path).with(purchase_process_id: 10).and_return('realignment_price_items_index')

          expect(helper.creditor_proposals_helper_path(ratification)).to eq 'realignment_price_items_index'
        end
      end
    end
  end

  describe '#trading_or_proposals_path' do
    let(:ratification) { double(:ratification) }

    context 'licitation_process is trading' do
      before { ratification.stub(licitation_process_trading?: true) }

      it 'returns creditor_winner_items_purchase_process_trading_items_path' do
        helper.should_receive(:creditor_winner_items_purchase_process_trading_items_path).and_return 'trading_path'

        expect(helper.send(:trading_or_proposals_path, ratification)).to eq 'trading_path'
      end
    end

    context 'licitation_process is not trading' do
      before { ratification.stub(licitation_process_trading?: false) }

      it 'returns purchase_process_creditor_proposals_path' do
        helper.should_receive(:purchase_process_creditor_proposals_path).and_return 'proposal_path'

        expect(helper.send(:trading_or_proposals_path, ratification)).to eq 'proposal_path'
      end
    end
  end
end
