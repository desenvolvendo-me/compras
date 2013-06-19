require 'model_helper'
require 'lib/signable'
require 'app/models/licitation_process_ratification_item'
require 'app/models/licitation_process_ratification'

describe LicitationProcessRatificationItem do
  it { should belong_to :licitation_process_ratification }
  it { should belong_to :purchase_process_creditor_proposal }

  it { should have_one(:licitation_process).through :purchase_process_creditor_proposal }
  it { should have_one(:creditor).through :licitation_process_ratification }

  it { should delegate(:description).to(:material).allowing_nil true }
  it { should delegate(:code).to(:material).allowing_nil true }
  it { should delegate(:reference_unit).to(:material).allowing_nil true }
  it { should delegate(:control_amount?).to(:material).allowing_nil true }
  it { should delegate(:unit_price).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:total_price).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:execution_unit_responsible).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:identity_document).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:material).to(:item).allowing_nil(true) }
  it { should delegate(:quantity).to(:item).allowing_nil(true) }
  it { should delegate(:lot).to(:item).allowing_nil(true) }

  it 'uses false as default for ratificated' do
    expect(subject.ratificated).to be false
  end

  describe '#unit_price' do
    let(:purchase_process_creditor_proposal) { double(:purchase_process_creditor_proposal) }
    let(:purchase_process_item) { double(:purchase_process_item) }

    context 'when there is an purchase_process_creditor_proposal' do
      before do
        subject.stub(purchase_process_creditor_proposal: purchase_process_creditor_proposal)
      end

      it "should try the purchase_process_creditor_proposal's unit_price" do
        purchase_process_creditor_proposal.should_receive(:try).with(:unit_price).and_return('unit_price')

        expect(subject.unit_price).to eq 'unit_price'
      end
    end

    context 'when there is not an item' do
      before do
        subject.stub(
          purchase_process_creditor_proposal: nil,
          purchase_process_item: purchase_process_item)
      end

      it "should try the purchase_process_item's unit_price" do
        purchase_process_item.should_receive(:try).with(:unit_price).and_return('unit_price')

        expect(subject.unit_price).to eq 'unit_price'
      end
    end
  end

  describe '#total_price' do
    let(:purchase_process_creditor_proposal) { double(:purchase_process_creditor_proposal) }
    let(:purchase_process_item) { double(:purchase_process_item) }

    context 'when there is an purchase_process_creditor_proposal' do
      before do
        subject.stub(purchase_process_creditor_proposal: purchase_process_creditor_proposal)
      end

      it "should try the purchase_process_creditor_proposal's total_price" do
        purchase_process_creditor_proposal.should_receive(:try).with(:total_price).and_return('total_price')

        expect(subject.total_price).to eq 'total_price'
      end
    end

    context 'when there is not an item' do
      before do
        subject.stub(
          purchase_process_creditor_proposal: nil,
          purchase_process_item: purchase_process_item)
      end

      it "should try the purchase_process_item's estimated_total_price" do
        purchase_process_item.should_receive(:try).with(:estimated_total_price).and_return('total_price')

        expect(subject.total_price).to eq 'total_price'
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
end
