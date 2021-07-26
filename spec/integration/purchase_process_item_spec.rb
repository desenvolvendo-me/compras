require 'spec_helper'

describe PurchaseProcessItem do
  context '#unit_price_by_bidder' do
    subject do
      PurchaseProcessItem.make!(:item)
    end

    it 'should return 0 as unit_price_by_bidder that does not have proposal' do
      bidder = Bidder.make!(:licitante_sobrinho)
      bidder.stub(:purchase_process_item => subject)

      expect(subject.unit_price_by_bidder(bidder)).to eq 0
    end

    it 'should return proposal unit_price as unit_price_by_bidder have proposal' do
      bidder = Bidder.make!(:licitante_com_proposta_1)
      bidder.stub(:purchase_process_item => subject)

      expect(subject.unit_price_by_bidder(bidder)).to eq 10
    end
  end

  context '.lots' do
    it 'should return the unique lots' do
      item = PurchaseProcessItem.make(:item_arame_farpado, lot: 50)
      item2 = PurchaseProcessItem.make(:item_arame, lot: 50)
      item3 = PurchaseProcessItem.make(:item, lot: 51)

      licitation_process = LicitationProcess.make!(:pregao_presencial,
        items: [item, item2, item3],
        judgment_form: JudgmentForm.make!(:por_lote_com_menor_preco))

      expect(licitation_process.items.lots).to eq [50, 51]
    end
  end
end
