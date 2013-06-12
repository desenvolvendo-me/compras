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

  describe '.enabled_or_benefited' do
    it 'should list only creditors benefited or enabled' do
      ibm       = Creditor.make!(:ibm)
      wenderson = Creditor.make!(:wenderson_sa)
      nobe      = Creditor.make!(:nobe)
      nohup     = Creditor.make!(:nohup)
      licitation_process = LicitationProcess.make!(:processo_licitatorio_canetas,
        bidders: [
          Bidder.make!(:licitante, creditor: wenderson, proposals: [], documents: [], enabled: true),
          Bidder.make!(:licitante_sobrinho, creditor: ibm, proposals: [], documents: [], enabled: false),
          Bidder.make!(:me_pregao, creditor: nobe, proposals: [], documents: [], enabled: true),
          Bidder.make!(:me_pregao, creditor: nohup, proposals: [], documents: [], enabled: false)
        ])

      expect(described_class.enabled_or_benefited).to include(wenderson, nobe, nohup)
      expect(described_class.enabled_or_benefited).to_not include(ibm)
    end
  end
end
