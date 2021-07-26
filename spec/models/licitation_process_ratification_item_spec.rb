require 'model_helper'
require 'lib/signable'
require 'app/models/licitation_process_ratification_item'
require 'app/models/licitation_process_ratification'

describe LicitationProcessRatificationItem do
  it { should belong_to :licitation_process_ratification }
  it { should belong_to :purchase_process_creditor_proposal }
  it { should belong_to :purchase_process_trading_item }
  it { should belong_to :realignment_price_item }

  it { should have_one(:licitation_process).through :purchase_process_creditor_proposal }
  it { should have_one(:creditor).through :licitation_process_ratification }

  it { should delegate(:description).to(:material).allowing_nil true }
  it { should delegate(:code).to(:material).allowing_nil true }
  it { should delegate(:reference_unit).to(:material).allowing_nil true }
  it { should delegate(:control_amount?).to(:material).allowing_nil true }
  it { should delegate(:unit_price).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:total_price).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:identity_document).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:material).to(:item).allowing_nil(true) }
  it { should delegate(:quantity).to(:item).allowing_nil(true) }
  it { should delegate(:lot).to(:item).allowing_nil(true) }
  it { should delegate(:price).to(:realignment_price_item).allowing_nil(true).prefix(true) }
  it { should delegate(:total_price).to(:realignment_price_item).allowing_nil(true).prefix(true) }
  it { should delegate(:has_realignment_price?).to(:licitation_process_ratification).allowing_nil(true) }

  it 'uses false as default for ratificated' do
    expect(subject.ratificated).to be false
  end

  describe '#unit_price' do
    context 'there is a realignment_price_item' do
      it 'should return the realignment_price_item price' do
        subject.stub realignment_price_item_price: 15

        expect(subject.unit_price).to eq 15
      end
    end

    context 'there is creditor proposal' do
      it 'returns creditor proposal unit price' do
        subject.stub(:creditor_proposal_unit_price).and_return 10

        expect(subject.unit_price).to eq 10
      end
    end

    context 'there is trading item and no creditor proposal' do
      it 'returns creditor proposal unit price' do
        subject.stub(:trading_item_unit_price).and_return 11

        expect(subject.unit_price).to eql 11
      end
    end

    context 'there is only purchase process item' do
      it 'returns creditor proposal unit price' do
        subject.stub(:purchase_process_item_unit_price).and_return 12

        expect(subject.unit_price).to eq 12
      end
    end
  end

  describe '#total_price' do
    context 'there is realignment_price_item' do
      it 'returns creditor proposal total price' do
        subject.stub realignment_price_item_total_price: 10

        expect(subject.total_price).to eq 10
      end
    end

    context 'there is creditor proposal' do
      it 'returns creditor proposal total price' do
        subject.stub(:creditor_proposal_total_price).and_return 13

        expect(subject.total_price).to eq 13
      end
    end

    context 'there is trading item and no creditor proposal' do
      it 'returns creditor proposal total price' do
        subject.stub(:trading_item_total_price).and_return 14

        expect(subject.total_price).to eq 14
      end
    end

    context 'there is only purchase process item' do
      it 'returns creditor proposal total price' do
        subject.stub(:purchase_process_total_price).and_return 15
        expect(subject.total_price).to eq 15
      end
    end
  end

  describe '#item' do
    let(:creditor_proposal_item) { double :creditor_proposal_item }
    let(:trading_item)           { double :trading_item }
    let(:purchase_process_item)  { double :purchase_process_item }

    context 'there is creditor proposal' do
      before { subject.stub(:creditor_proposal_item).and_return creditor_proposal_item }

      it 'returns creditor proposal total price' do
        subject.should_receive(:creditor_proposal_item)
        expect(subject.item).to eq creditor_proposal_item
      end
    end

    context 'there is trading item and no creditor proposal' do
      before do
        subject.stub(:creditor_proposal_item).and_return nil
        subject.stub(:trading_item).and_return trading_item
      end

      it 'returns creditor proposal total price' do
        subject.should_receive(:trading_item)
        expect(subject.item).to eq trading_item
      end
    end

    context 'there is only purchase process item' do
      before do
        subject.stub(:creditor_proposal_item).and_return nil
        subject.stub(:trading_item).and_return nil
        subject.stub(:purchase_process_item).and_return purchase_process_item
      end

      it 'returns creditor proposal total price' do
        subject.should_receive(:purchase_process_item)
        expect(subject.item).to eq purchase_process_item
      end
    end
  end

  describe '#authorized_quantity' do
    let(:supply_order_items) { double :supply_order_items }

    it 'returns the sum of supply items authorized quantity' do
      subject.stub(supply_order_items: supply_order_items)
      supply_order_items.should_receive(:sum).with(:authorization_quantity)

      subject.authorized_quantity
    end
  end

  describe '#authorized_value' do
    let(:supply_order_items) { double :supply_order_items }

    it 'returns the sum of supply items authorized value' do
      subject.stub(supply_order_items: supply_order_items)
      supply_order_items.should_receive(:sum).with(:authorization_value)

      subject.authorized_value
    end
  end

  describe '#supply_order_item_value_balance' do
    before do
      subject.stub(total_price: 10)
      subject.stub(authorized_value: 3)
    end

    it 'returns total_price - authorized_value' do
      expect(subject.supply_order_item_value_balance).to eq 7
    end
  end

  describe '#supply_order_item_balance' do
    pending
  end

  describe '#creditor_proposal_item' do
    pending
  end

  describe '#trading_item' do
    pending
  end

  describe '#creditor_proposal_unit_price' do
    pending
  end

  describe '#trading_item_unit_price' do
    pending
  end

  describe '#purchase_process_item_unit_price' do
    pending
  end

  describe '#creditor_proposal_total_price' do
    pending
  end

  describe '#purchase_process_total_price' do
    pending
  end

  describe '#trading_item_total_price' do
    pending
  end
end
