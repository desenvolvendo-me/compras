require "spec_helper"

describe LicitationProcessRatificationItem do
  describe '#type_of_purchase_licitation' do
    it 'should return all proposals by licitation' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      direct_purchase = LicitationProcess.make!(:compra_direta)
      creditor_sobrinho = Creditor.make!(:sobrinho_sa)
      proposal_arame_farpado_licitation = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation_process)
      proposal_arame_farpado_direct_purchase = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: direct_purchase)

      ratification_licitation = LicitationProcessRatification.make(:processo_licitatorio_computador,
        creditor: creditor_sobrinho,
        licitation_process: licitation_process,
        licitation_process_ratification_items: [])

      ratification_direct_purchase = LicitationProcessRatification.make(:processo_licitatorio_computador,
        creditor: creditor_sobrinho,
        licitation_process: direct_purchase,
        licitation_process_ratification_items: [])

      ratification_item = LicitationProcessRatificationItem.make!(:item, ratificated: true,
        licitation_process_ratification: ratification_licitation,
        purchase_process_creditor_proposal: proposal_arame_farpado_licitation)

      ratification_item_two = LicitationProcessRatificationItem.make!(:item, ratificated: true,
        licitation_process_ratification: ratification_direct_purchase,
        purchase_process_creditor_proposal: proposal_arame_farpado_direct_purchase)

      expect(LicitationProcessRatificationItem.type_of_purchase_licitation).to include(ratification_item)
      expect(LicitationProcessRatificationItem.type_of_purchase_licitation).to_not include(ratification_item_two)
    end
  end
end
