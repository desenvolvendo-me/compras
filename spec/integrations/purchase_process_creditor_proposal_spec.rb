# encoding: UTF-8
require 'spec_helper'

describe PurchaseProcessCreditorProposal do
  describe '#cheaper_brothers' do
    let(:current_proposal) {
      PurchaseProcessCreditorProposal.make! :proposta_arame_farpado, unit_price: 5.00,
      item: PurchaseProcessItem.make!(:item_arame_farpado)
    }

    let(:cheaper_proposal) {
      PurchaseProcessCreditorProposal.make! :proposta_arame, unit_price: 4.00,
      item: PurchaseProcessItem.make!(:item_arame_farpado)
    }

    it 'returns the cheaper proposals with the same item or lot' do
      expect(current_proposal.cheaper_brothers).to include cheaper_proposal
    end
  end

  describe '#same_price_brothers' do
    let(:current_proposal) {
      PurchaseProcessCreditorProposal.make! :proposta_arame_farpado, unit_price: 5.00,
      item: PurchaseProcessItem.make!(:item_arame_farpado)
    }

    let(:same_price_proposal) {
      PurchaseProcessCreditorProposal.make! :proposta_arame, unit_price: 5.00,
      item: PurchaseProcessItem.make!(:item_arame_farpado)
    }

    it 'returns all the proposals with the same price and item, or lot, of the passed proposal' do
      expect(current_proposal.same_price_brothers).to include(same_price_proposal, current_proposal)
    end
  end
end
