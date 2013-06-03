#encoding: utf-8
require 'spec_helper'

describe Creditor do
  describe '.enabled_by_licitation' do
    it 'should return only creditors enabled in purchase process' do
      creditor = Creditor.make!(:sobrinho)
      purchase_process = LicitationProcess.make!(:processo_licitatorio_computador,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      bidders:[Bidder.make!(:licitante_sobrinho, creditor: creditor, enabled: true)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

      expect(Creditor.enabled_by_licitation(purchase_process.id)).to eq [creditor]
    end
  end

  describe '.winner_without_disqualifications_by_licitation' do
    it 'should return only creditor winner and not have proposal disqualification' do
      creditor_sobrinho = Creditor.make!(:sobrinho)
      creditor_nohup = Creditor.make!(:nohup)
      purchase_process = LicitationProcess.make!(:processo_licitatorio_computador,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      bidders:[Bidder.make!(:licitante_sobrinho, creditor: creditor_sobrinho, enabled: true),
        Bidder.make!(:licitante_sobrinho, creditor: creditor_nohup, enabled: true)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: purchase_process,
        creditor: creditor_sobrinho, disqualified: false)
      PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: purchase_process,
        creditor: creditor_nohup, disqualified: true)

      expect(Creditor.winner_without_disqualifications).to eq [creditor_sobrinho]
    end
  end
end
