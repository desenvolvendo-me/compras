# encoding: utf-8
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

        it "should return the proposals' index path" do
          helper.should_receive(:purchase_process_creditor_proposals_path).and_return('proposals_index')

          expect(helper.creditor_proposals_helper_path(ratification)).to eq 'proposals_index'
        end
      end

      context 'when judgment_form is not by item' do
        before do
          ratification.stub(judgment_form_item?: false)
        end

        it "should return the realignment_prices' index path" do
          helper.should_receive(:realigment_prices_path).and_return('realignment_prices_index')

          expect(helper.creditor_proposals_helper_path(ratification)).to eq 'realignment_prices_index'
        end
      end
    end
  end
end

