require 'spec_helper'

describe PurchaseProcessCreditorDisqualification do
  describe '#disqualify_proposal_items' do

    let(:bidder_sobrinho) do
      Bidder.make!(:licitante_sobrinho, enabled: true,  habilitation_date: Date.current)
    end

    let(:bidder_wenderson) do
      Bidder.make!(:licitante, enabled: true,  habilitation_date: Date.current)
    end

    let(:licitation_process) do
      LicitationProcess.make!(:pregao_presencial,
        purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
        judgment_form: JudgmentForm.make!(:por_item_com_melhor_tecnica),
        bidders: [bidder_sobrinho, bidder_wenderson])
    end

    let(:proposta_arame_wenderson) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation_process, creditor: bidder_wenderson.creditor)
    end

    let(:proposta_arame_farpado_wenderson) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation_process, creditor: bidder_wenderson.creditor)
    end

    let(:proposta_arame_sobrinho) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation_process, creditor: bidder_sobrinho.creditor,
        unit_price: 3.99)
    end

    let(:proposta_arame_farpado_sobrinho) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation_process, creditor: bidder_sobrinho.creditor,
        unit_price: 5.99)
    end

    it 'disqualifies proposals and set the ranking again' do
      expect(proposta_arame_wenderson.ranking).to eql 1
      expect(proposta_arame_farpado_wenderson.ranking).to eql 1
      expect(proposta_arame_sobrinho.ranking).to eql 2
      expect(proposta_arame_farpado_sobrinho.ranking).to eql 2

      disqualification = PurchaseProcessCreditorDisqualification.new(
        licitation_process_id: licitation_process.id,
        creditor_id: bidder_wenderson.creditor_id,
        disqualification_date: Date.new(2013, 5, 8),
        reason: 'Desclassificado por opção',
        kind: PurchaseProcessCreditorDisqualificationKind::TOTAL,
        proposal_item_ids: [
          proposta_arame_wenderson.id,
          proposta_arame_farpado_wenderson.id
        ]
      )

      disqualification.save!

      proposta_arame_wenderson.reload
      proposta_arame_farpado_wenderson.reload
      proposta_arame_sobrinho.reload
      proposta_arame_farpado_sobrinho.reload

      expect(proposta_arame_wenderson.ranking).to eql -1
      expect(proposta_arame_farpado_wenderson.ranking).to eql -1
      expect(proposta_arame_sobrinho.ranking).to eql 1
      expect(proposta_arame_farpado_sobrinho.ranking).to eql 1
    end
  end
end
