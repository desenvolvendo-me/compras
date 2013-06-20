# encoding: utf-8
require 'spec_helper'

describe PurchaseProcessTradingItem do
  describe '.creditor_winner_items' do
    it 'returns winner trading items from creditor and trading' do
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

      result_sobrinho = PurchaseProcessTradingItem.creditor_winner_items(creditor_sobrinho.id, trading.id)
      result_nohup    = PurchaseProcessTradingItem.creditor_winner_items(creditor_nohup.id, trading.id)

      expect(result_sobrinho).to eq [trading_item_arame_farpado]
      expect(result_nohup).to    eq [trading_item_arame]
    end
  end
end
