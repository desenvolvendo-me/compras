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

  describe '.without_licitation_ratification' do
    it 'returns creditors without ratification for the passed licitation process' do
      bidder_wenderson  = Bidder.make!(:licitante)
      bidder_sobrinho   = Bidder.make!(:licitante_sobrinho)
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador,
        bidders: [bidder_wenderson, bidder_sobrinho])

      result = Creditor.without_licitation_ratification(licitation_process.id)
      expect(result).to include(bidder_wenderson.creditor, bidder_sobrinho.creditor)

      LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation_process, creditor: bidder_wenderson.creditor)

      result = Creditor.without_licitation_ratification(licitation_process.id)
      expect(result).to eq [bidder_sobrinho.creditor]
    end
  end

  describe '.won_calculation_for_trading' do
    it 'returns creditors whom won trading for a passed licitation process' do
      creditor_sobrinho = Creditor.make!(:sobrinho_sa)
      creditor_nohup    = Creditor.make!(:nohup)

      item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado)
      item_arame         = PurchaseProcessItem.make!(:item_arame)

      licitation = LicitationProcess.make!(:pregao_presencial,
        bidders: [],
        items: [item_arame_farpado, item_arame])

      accreditation_sobrinho = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor,
        creditor: creditor_sobrinho)

      accreditation_nohup = PurchaseProcessAccreditationCreditor.make(:wenderson_creditor,
        creditor: creditor_nohup)

      accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
        licitation_process: licitation,
        purchase_process_accreditation_creditors: [accreditation_sobrinho, accreditation_nohup])

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation, creditor: creditor_sobrinho,
          item: item_arame_farpado, unit_price: 3.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_sobrinho,
          item: item_arame, unit_price: 15.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame_farpado, unit_price: 9.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame, unit_price: 5.00)

      trading = PurchaseProcessTrading.create!(purchase_process_id: licitation.id)

      trading_item_arame_farpado = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame_farpado.id)

      trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame.id)

      accreditation_sobrinho = accreditation.purchase_process_accreditation_creditors.first
      accreditation_nohup    = accreditation.purchase_process_accreditation_creditors.last

      PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame_farpado.id,
        purchase_process_accreditation_creditor_id: accreditation_nohup.id,
        amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

      PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
        purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
        amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

      result = Creditor.won_calculation_for_trading(licitation.id)

      expect(result).to eq [creditor_sobrinho, creditor_nohup]
    end
  end
end