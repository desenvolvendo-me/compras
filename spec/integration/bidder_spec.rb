require 'spec_helper'

describe Bidder do
  context 'uniqueness validations' do
    before { LicitationProcess.make!(:processo_licitatorio_computador) }

    it { should validate_uniqueness_of(:creditor_id).scoped_to(:licitation_process_id) }
  end

  describe '.benefited' do
    it 'should return only bidders benefited' do
      licitante = Bidder.make!(:licitante)
      licitante_sobrinho = Bidder.make!(:licitante_sobrinho)
      licitante_com_proposta_3 = Bidder.make!(:licitante_com_proposta_3)
      me_pregao = Bidder.make(:me_pregao)

      expect(Bidder.benefited).to eq [licitante_com_proposta_3]
    end
  end

  describe '.type_of_purchase_licitation' do
    it 'should return only bidders in licitation' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      direct_purchase = LicitationProcess.make!(:compra_direta)

      licitante = Bidder.make!(:licitante, licitation_process: licitation_process)
      licitante_sobrinho = Bidder.make!(:licitante_sobrinho, licitation_process: direct_purchase)
      licitante_com_proposta_3 = Bidder.make!(:licitante_com_proposta_3, licitation_process: direct_purchase)
      me_pregao = Bidder.make!(:me_pregao, licitation_process: licitation_process)

      expect(Bidder.type_of_purchase_licitation).to include(licitante, me_pregao)
      expect(Bidder.type_of_purchase_licitation).to_not include(licitante_sobrinho, licitante_com_proposta_3)
    end
  end

  context 'callbacks' do
    describe '#update_proposal_ranking' do
      let(:bidder) do
        Bidder.make!(:licitante_sobrinho, enabled: true,  habilitation_date: Date.current)
      end

      let(:licitation_process) do
        LicitationProcess.make!(:processo_licitatorio_computador,
          purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
          judgment_form: JudgmentForm.make!(:por_item_com_melhor_tecnica),
          creditor_proposals: [PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado)],
          bidders: [bidder])
      end

      it 'updates the bidder creditor proposals when they are enabled or not' do
        expect(licitation_process.creditor_proposals.first.ranking).to eql 1

        bidder.enabled = false
        bidder.habilitation_date = nil
        bidder.save

        expect(licitation_process.creditor_proposals.first.ranking).to eql -1
      end
    end
  end
end
