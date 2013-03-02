# encoding: utf-8
require 'spec_helper'

describe PriceCollectionProposalItem do
  describe ".by_lot" do
    let(:price_collection) { PriceCollection.make!(:coleta_de_precos_com_2_lotes) }
    let(:proposal_1) { PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, :price_collection => price_collection) }
    let(:item) do
      PriceCollectionProposalItem.make!(:wenderson_antivirus,
                                        :price_collection_proposal => proposal_1,
                                        :price_collection_lot_item => price_collection.items.first,
                                        :unit_price => 0)
    end

    it 'should return item by lot' do
      expect(PriceCollectionProposalItem.by_lot(proposal_1.id)).to eq [item]
    end
  end
end
