require 'spec_helper'

describe RealignmentPricesHelper do
  describe '#proposals' do
    it 'should return the winning proposals for a given purchase_process and creditor' do
      purchase_process = double(:purchase_process, id: 10)
      creditor = double(:creditor, id: 13)
      proposal1 = double(:proposal1)
      proposal2 = double(:proposal2)

      PurchaseProcessCreditorProposal.
        should_receive(:licitation_process_id).
        with(10).
        and_return PurchaseProcessCreditorProposal

      PurchaseProcessCreditorProposal.
        should_receive(:creditor_id).
        with(13).
        and_return PurchaseProcessCreditorProposal

      PurchaseProcessCreditorProposal.
        should_receive(:winning_proposals).
        and_return PurchaseProcessCreditorProposal

      PurchaseProcessCreditorProposal.
        should_receive(:reorder).
        with("CREDITOR_ID ASC, LOT ASC").
        and_return [proposal1, proposal2]

      expect(helper.proposals(purchase_process, creditor)).to eq [proposal1, proposal2]
    end
  end

  describe '#trading_items' do
    it 'should return the winning items for a given purchase_process and creditor' do
      purchase_process = double(:purchase_process, id: 10)
      creditor = double(:creditor, id: 13)
      item1 = double(:item1, lot: 10)
      item2 = double(:item2, lot: 5)

      PurchaseProcessTradingItem.
        should_receive(:purchase_process_id).
        with(10).
        and_return PurchaseProcessTradingItem

      PurchaseProcessTradingItem.
        should_receive(:creditor_winner_items).
        with(13).
        and_return [item1, item2]

      expect(helper.trading_items(purchase_process, creditor)).to eq [item2, item1]
    end
  end

  describe '#items_or_build' do
    let(:creditor) { double(:creditor) }
    let(:realignment) { double(:realgnment, creditor: creditor) }
    let(:items) { double(:items) }
    let(:item1) { double(:item1, id: 55) }
    let(:item2) { double(:item2, id: 87) }

    context 'when has items' do
      before do
        realignment.stub(items: [item1, item2])
      end

      it 'should return the existing ones' do
        expect(helper.items_or_build(realignment)).to eq [item1, item2]
      end
    end

    context 'when has no items' do
      before do
        realignment.stub(purchase_process_items: [item1, item2])
      end

      it 'should return the existing ones' do
        builded_item = double(:builded_item)
        item1.stub(creditor_winner: creditor)
        item2.stub(creditor_winner: 'creditor')
        realignment.stub(items: items)

        items.should_receive(:any?).and_return(false)

        items.
          should_receive(:build).
          with(purchase_process_item_id: 55 , price: 0).
          and_return builded_item

        expect(helper.items_or_build(realignment)).to eq [builded_item]
      end
    end
  end

  describe '#realignment_link_title' do
    context 'when has no realignment' do
      it "should return 'Criar realinhamento de preço'" do
        RealignmentPrice.
          should_receive(:purchase_process_id).
          with(10).
          and_return RealignmentPrice

        RealignmentPrice.
          should_receive(:creditor_id).
          with(5).
          and_return RealignmentPrice

        RealignmentPrice.
          should_receive(:lot).
          with(7).
          and_return []

        expect(helper.realignment_link_title(10, 5, 7)).to eq 'Criar realinhamento de preço'
      end
    end

    context 'when has a realignment' do
      it "should return 'Editar realinhamento de preço'" do
        RealignmentPrice.
          should_receive(:purchase_process_id).
          with(10).
          and_return RealignmentPrice

        RealignmentPrice.
          should_receive(:creditor_id).
          with(5).
          and_return RealignmentPrice

        RealignmentPrice.
          should_receive(:lot).
          with(7).
          and_return ['realignment']

        expect(helper.realignment_link_title(10, 5, 7)).to eq 'Editar realinhamento de preço'
      end
    end
  end

  describe '#realignment_path_helper' do
    context 'when has no realignment' do
      it "should return the path for a new realignment" do
        RealignmentPrice.
          should_receive(:purchase_process_id).
          with(10).
          and_return RealignmentPrice

        RealignmentPrice.
          should_receive(:creditor_id).
          with(5).
          and_return RealignmentPrice

        RealignmentPrice.
          should_receive(:lot).
          with(7).
          and_return []

        expect(helper.realignment_path_helper(10, 5, 7)).to eq new_realignment_price_path(purchase_process_id: 10, creditor_id: 5, lot: 7)
      end
    end

    context 'when has a realignment' do
      it "should return 'Editar realinhamento de preço'" do
        realignment = double(:realignment)

        RealignmentPrice.
          should_receive(:purchase_process_id).
          with(10).
          and_return RealignmentPrice

        RealignmentPrice.
          should_receive(:creditor_id).
          with(5).
          and_return RealignmentPrice

        RealignmentPrice.
          should_receive(:lot).
          with(7).
          and_return [realignment]

        expect(helper.realignment_path_helper(10, 5, 7)).to eq edit_realignment_price_path(realignment)
      end
    end
  end
end
