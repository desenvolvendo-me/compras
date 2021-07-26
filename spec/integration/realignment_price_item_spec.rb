require 'spec_helper'

describe RealignmentPriceItem do
  describe '.purchase_process_id' do
    it 'should filter by purchase_process_id' do
      item = PurchaseProcessItem.make!(:item)
      item_arame = PurchaseProcessItem.make!(:item_arame)

      processo_licitatorio_canetas = LicitationProcess.make!(:processo_licitatorio_canetas)

      apuracao_por_lote = LicitationProcess.make!(:apuracao_por_lote, items: [item, item_arame])

      realinhamento1 = RealignmentPrice.make!(:realinhamento,
       purchase_process: apuracao_por_lote)

      realinhamento1_item = RealignmentPriceItem.create!(
        realignment_price_id: realinhamento1.id,
        purchase_process_item_id: item.id,
        price: 100.00)

      realinhamento1_item_arame = RealignmentPriceItem.create!(
        realignment_price_id: realinhamento1.id,
        purchase_process_item_id: item_arame.id,
        price: 50.00)

      realinhamento2 = RealignmentPrice.make!(:realinhamento,
       purchase_process: processo_licitatorio_canetas)

      expect(described_class.purchase_process_id(apuracao_por_lote.id)).to eq [realinhamento1_item, realinhamento1_item_arame]
    end
  end

  describe '.creditor_id' do
    it 'should filter by creditor_id' do
      sobrinho = Creditor.make!(:sobrinho)
      wenderson = Creditor.make!(:wenderson_sa)

      item = PurchaseProcessItem.make!(:item)
      item_arame = PurchaseProcessItem.make!(:item_arame)

      processo_licitatorio_canetas = LicitationProcess.make!(:processo_licitatorio_canetas, items: [item])
      apuracao_por_lote = LicitationProcess.make!(:apuracao_por_lote, items: [item_arame])

      realinhamento1 = RealignmentPrice.make!(:realinhamento,
       purchase_process: apuracao_por_lote,
       creditor: sobrinho)

      realinhamento1_item = RealignmentPriceItem.create!(
        realignment_price_id: realinhamento1.id,
        purchase_process_item_id: item.id,
        price: 100.00)

      realinhamento2 = RealignmentPrice.make!(:realinhamento,
       purchase_process: processo_licitatorio_canetas,
       creditor: wenderson)

      realinhamento2_item_arame = RealignmentPriceItem.create!(
        realignment_price_id: realinhamento2.id,
        purchase_process_item_id: item.id,
        price: 50.00)

      expect(described_class.creditor_id(wenderson.id)).to eq [realinhamento2_item_arame]
    end
  end

  describe '.lot' do
    it 'should filter by lot' do
      item = PurchaseProcessItem.make!(:item)
      item_arame = PurchaseProcessItem.make!(:item_arame)

      processo_licitatorio_canetas = LicitationProcess.make!(:processo_licitatorio_canetas, items: [item])
      apuracao_por_lote = LicitationProcess.make!(:apuracao_por_lote, items: [item_arame])

      realinhamento1 = RealignmentPrice.make!(:realinhamento,
       purchase_process: apuracao_por_lote,
       lot: 10)

      realinhamento1_item = RealignmentPriceItem.create!(
        realignment_price_id: realinhamento1.id,
        purchase_process_item_id: item.id,
        price: 100.00)

      realinhamento2 = RealignmentPrice.make!(:realinhamento,
       purchase_process: processo_licitatorio_canetas,
       lot: 15)

      ealinhamento2_item_arame = RealignmentPriceItem.create!(
        realignment_price_id: realinhamento2.id,
        purchase_process_item_id: item.id,
        price: 50.00)

      expect(described_class.lot(10)).to eq [realinhamento1_item]
    end
  end
end
