require 'spec_helper'

describe LicitationProcessRatification do
  context 'validations' do
    describe 'licitation without proposal_envelope_opening_date' do
      let(:licitation_process) do
        LicitationProcess.make!(:processo_licitatorio_computador,
                                proposal_envelope_opening_date: nil)
      end

      it 'should return error over licitation process' do
        ratification = LicitationProcessRatification.make(
          :processo_licitatorio_computador,
          licitation_process: licitation_process)

        ratification.valid?

        expect(ratification.errors.to_a).to include "O processo de compra (#{licitation_process.to_s}) não tem data da Abertura da Proposta"
      end
    end

    describe 'licitation with proposal_envelope_opening_date' do
      let(:licitation_process) do
        LicitationProcess.make!(:processo_licitatorio_computador)
      end

      it 'should not return error over licitation process' do
        ratification = LicitationProcessRatification.make(
          :processo_licitatorio_computador,
          licitation_process: licitation_process)

        ratification.valid?

        expect(ratification.errors.to_a).to_not include "O processo de compra (#{licitation_process.to_s}) não tem data da Abertura da Proposta"
      end
    end
  end

  describe '#creditor_proposals_total_value' do
    let(:creditor_wenderson) do
      Creditor.make!(:wenderson_sa)
    end

    let(:creditor_sobrinho) do
      Creditor.make!(:sobrinho_sa)
    end

    let(:item_arame) do
      PurchaseProcessItem.make!(:item_arame)
    end

    let(:licitation_process) do
      LicitationProcess.make!(:processo_licitatorio_computador, items: [item_arame], bidders: [])
    end

    it 'should return total value of proposal by creditor' do
      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
        licitation_process: licitation_process, unit_price: 100.00)
      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
        licitation_process: licitation_process, unit_price: 150.00)

      accreditation_wenderson = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor, creditor: creditor_wenderson)
      accreditation_sobrinho = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor, creditor: creditor_sobrinho)

      PurchaseProcessAccreditation.make!(:general_accreditation, licitation_process: licitation_process,
        purchase_process_accreditation_creditors: [accreditation_sobrinho, accreditation_wenderson])

      Bidder.make!(:licitante, creditor: creditor_sobrinho, licitation_process: licitation_process)
      Bidder.make!(:licitante, creditor: creditor_wenderson, licitation_process: licitation_process)

      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: licitation_process)

      expect(ratification.creditor_proposals_total_value).to eq 100.0
    end
  end
end
