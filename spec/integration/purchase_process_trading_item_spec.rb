require 'spec_helper'

describe PurchaseProcessTradingItem do
  describe '.creditor_winner_items' do
    it 'returns winner trading items from creditor and trading' do
      creditor_sobrinho = Creditor.make!(:sobrinho_sa)
      creditor_nohup    = Creditor.make!(:nohup)

      item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado)
      item_arame         = PurchaseProcessItem.make!(:item_arame)
      item               = PurchaseProcessItem.make!(:item)

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

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_sobrinho,
          item: item, unit_price: 3.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame_farpado, unit_price: 9.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame, unit_price: 5.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item, unit_price: 15.00)

      trading = PurchaseProcessTrading.create!(purchase_process_id: licitation.id)

      trading_item_arame_farpado = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame_farpado.id)

      trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame.id)

      trading_item = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item.id)

      accreditation_sobrinho = accreditation.purchase_process_accreditation_creditors.first
      accreditation_nohup    = accreditation.purchase_process_accreditation_creditors.last

      PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame_farpado.id,
        purchase_process_accreditation_creditor_id: accreditation_nohup.id,
        amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

      PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
        purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
        amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

      PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
        purchase_process_accreditation_creditor_id: accreditation_nohup.id,
        amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

      trading_item_arame.close!
      trading_item_arame_farpado.close!
      trading_item.update_column :status, PurchaseProcessTradingItemStatus::FAILED

      result_sobrinho = PurchaseProcessTradingItem.creditor_winner_items(creditor_sobrinho.id)
      result_nohup    = PurchaseProcessTradingItem.creditor_winner_items(creditor_nohup.id)

      expect(result_sobrinho).to eq [trading_item_arame_farpado]
      expect(result_nohup).to    eq [trading_item_arame]
    end
  end

  describe '.trading_id' do
    it 'should filter by trading_id' do
      creditor_sobrinho = Creditor.make!(:sobrinho_sa)
      creditor_nohup    = Creditor.make!(:nohup)

      item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado)
      item_arame         = PurchaseProcessItem.make!(:item_arame)
      item               = PurchaseProcessItem.make!(:item)

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

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_sobrinho,
          item: item, unit_price: 3.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame_farpado, unit_price: 9.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame, unit_price: 5.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item, unit_price: 15.00)

      trading = PurchaseProcessTrading.create!(purchase_process_id: licitation.id)

      trading_item_arame_farpado = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame_farpado.id)

      trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame.id)

      trading_item = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item.id)

      expect(described_class.trading_id(trading.id)).to include(trading_item_arame_farpado, trading_item_arame, trading_item)
      expect(described_class.trading_id(trading.id + 55)).to eq []
    end
  end

  describe '.lot' do
    it 'should filter by lot' do
      purchase_process = LicitationProcess.make!(:pregao_presencial,
      items: [
        PurchaseProcessItem.make!(:item_arame_farpado, lot:10),
        PurchaseProcessItem.make!(:item_arame, lot: 10),
        PurchaseProcessItem.make!(:item, lot: 15)],
      judgment_form: JudgmentForm.make!(:por_lote_com_menor_preco))

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: purchase_process,
      purchase_process_accreditation_creditors: [])

    sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
      company_size: CompanySize.make!(:micro_empresa),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      item: nil,
      lot: 10,
      creditor: wenderson.creditor,
      unit_price: 100.0)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      item: nil,
      lot: 15,
      creditor: wenderson.creditor,
      unit_price: 130.0)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      item: nil,
      lot: 10,
      creditor: sobrinho.creditor,
      unit_price: 120.0)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      item: nil,
      lot: 15,
      creditor: sobrinho.creditor,
      unit_price: 111.0)

      trading = PurchaseProcessTrading.create!(purchase_process_id: purchase_process.id)

      trading_item_lot10 = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        lot: 10)

      trading_item_lot15 = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        lot: 15)

      expect(described_class.lot(10)).to eq [trading_item_lot10]
      expect(described_class.lot(15)).to eq [trading_item_lot15]
    end
  end

  describe '.item_id' do
    it 'should filter by item_id' do
      creditor_sobrinho = Creditor.make!(:sobrinho_sa)
      creditor_nohup    = Creditor.make!(:nohup)

      item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado)
      item_arame         = PurchaseProcessItem.make!(:item_arame)
      item               = PurchaseProcessItem.make!(:item)

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

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_sobrinho,
          item: item, unit_price: 3.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame_farpado, unit_price: 9.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame, unit_price: 5.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item, unit_price: 15.00)

      trading = PurchaseProcessTrading.create!(purchase_process_id: licitation.id)

      trading_item_arame_farpado = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame_farpado.id)

      trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame.id)

      trading_item = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item.id)

      expect(described_class.item_id(item_arame_farpado.id)).to eq [trading_item_arame_farpado]
      expect(described_class.item_id(item_arame.id)).to eq [trading_item_arame]
    end
  end

  describe '.purchase_process_id' do
    it 'should filter by purchase_process_id' do
      creditor_sobrinho = Creditor.make!(:sobrinho_sa)
      creditor_nohup    = Creditor.make!(:nohup)

      item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado)
      item_arame         = PurchaseProcessItem.make!(:item_arame)
      item               = PurchaseProcessItem.make!(:item)

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

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_sobrinho,
          item: item, unit_price: 3.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame_farpado, unit_price: 9.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item_arame, unit_price: 5.00)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation, creditor: creditor_nohup,
          item: item, unit_price: 15.00)

      trading = PurchaseProcessTrading.create!(purchase_process_id: licitation.id)

      trading_item_arame_farpado = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame_farpado.id)

      trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item_arame.id)

      trading_item = PurchaseProcessTradingItem.create!(trading_id: trading.id,
        item_id: item.id)

      LicitationProcess.make!(:processo_licitatorio, process: 2)

      expect(described_class.purchase_process_id(licitation.id)).to include(trading_item_arame_farpado, trading_item_arame, trading_item)
    end
  end
end
