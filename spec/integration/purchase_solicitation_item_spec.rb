require 'spec_helper'

describe PurchaseSolicitationItem, vcr: { cassette_name: 'integration/purchase_solicitation_item' } do
  before do
    UnicoAPI::Consumer.set_customer customer
  end

  let(:customer) { create(:customer, domain: 'compras.dev', name: 'Compras Dev') }

  context 'associations' do
    describe '#price_collection_proposal_items' do
      let(:material_antivirus) do
        Material.order(:id).first
      end

      let(:material_arame) do
        Material.order(:id).last
      end

      let(:purchase_solicitation_item) do
        PurchaseSolicitationItem.where(material_id: material_antivirus.id).order(:id).first
      end

      let(:antivirus_proposals) do
        PriceCollectionProposalItem.
          joins { price_collection_item }.
          where { |my| my.price_collection_item.material_id.eq(material_antivirus.id) }
      end

      let(:arame_proposals) do
        PriceCollectionProposalItem.
          joins { price_collection_item }.
          where { |my| my.price_collection_item.material_id.eq(material_arame.id) }
      end

      before do
        price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes,
          type_of_calculation: PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)

        PriceCollectionProposalItem.destroy_all

        proposal_1 = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, price_collection: price_collection)

        proposal_2 = PriceCollectionProposal.make!(:sobrinho_sa_proposta,
          price_collection: price_collection,
          creditor: Creditor.make(:sobrinho_sa,
            accounts: [ CreditorBankAccount.make(:conta_2, number: '000103') ] ))

        purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year,
          price_collections: [price_collection])

        wenderson_antivirus = PriceCollectionProposalItem.make!(:wenderson_antivirus,
          price_collection_proposal: proposal_1,
          price_collection_item: price_collection.items.first,
          unit_price: 0)

        wenderson_arame = PriceCollectionProposalItem.make!(:wenderson_antivirus,
          price_collection_proposal: proposal_1,
          price_collection_item: price_collection.items.last,
          unit_price: 12.00)

        sobrinho_antivirus = PriceCollectionProposalItem.make!(:sobrinho_antivirus,
          price_collection_proposal: proposal_2,
          price_collection_item: price_collection.items.first,
          unit_price: 13.50)

        sobrinho_arame = PriceCollectionProposalItem.make!(:sobrinho_antivirus,
          price_collection_proposal: proposal_2,
          price_collection_item: price_collection.items.last,
          unit_price: 15.50)
      end

      it 'returns all the price_collection_proposal_items of the same purchase_solicitation and same material' do
        expect(purchase_solicitation_item.price_collection_proposal_items).
          to eql [antivirus_proposals.order(:id).last]

        expect(purchase_solicitation_item.price_collection_proposal_items).
          to_not include(arame_proposals.order(:id).first, arame_proposals.order(:id).last,
            antivirus_proposals.order(:id).first)
      end
    end
  end
end
