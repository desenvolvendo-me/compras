require 'model_helper'
require 'lib/signable'
require 'app/models/licitation_process_ratification_item'
require 'app/models/licitation_process_ratification'

describe LicitationProcessRatificationItem do
  it { should belong_to :licitation_process_ratification }
  it { should belong_to :purchase_process_creditor_proposal }

  it { should have_one(:licitation_process).through :purchase_process_creditor_proposal }
  it { should have_one(:item).through :purchase_process_creditor_proposal }
  it { should have_one(:creditor).through :licitation_process_ratification }

  it { should delegate(:quantity).to(:item).allowing_nil true }
  it { should delegate(:description).to(:material).allowing_nil true }
  it { should delegate(:code).to(:material).allowing_nil true }
  it { should delegate(:reference_unit).to(:material).allowing_nil true }
  it { should delegate(:unit_price).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:total_price).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:lot).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:execution_unit_responsible).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:identity_document).to(:creditor).allowing_nil(true).prefix(true) }

  it 'uses false as default for ratificated' do
    expect(subject.ratificated).to be false
  end

  describe '#material' do
    let(:item) { double(:item) }
    let(:purchase_process_item) { double(:purchase_process_item) }

    context 'when there is an item' do
      before do
        subject.stub(item: item)
      end

      it "should try the item's material" do
        item.should_receive(:try).with(:material).and_return('material')

        expect(subject.material).to eq 'material'
      end
    end

    context 'when there is not an item' do
      before do
        subject.stub(
          item: nil,
          purchase_process_item: purchase_process_item)
      end

      it "should try the item's material" do
        purchase_process_item.should_receive(:try).with(:material).and_return('material')

        expect(subject.material).to eq 'material'
      end
    end
  end

  describe '#quantity' do
    let(:item) { double(:item) }
    let(:purchase_process_item) { double(:purchase_process_item) }

    context 'when there is an item' do
      before do
        subject.stub(item: item)
      end

      it "should try the item's quantity" do
        item.should_receive(:try).with(:quantity).and_return('quantity')

        expect(subject.quantity).to eq 'quantity'
      end
    end

    context 'when there is not an item' do
      before do
        subject.stub(
          item: nil,
          purchase_process_item: purchase_process_item)
      end

      it "should try the purchase_process_item's quantity" do
        purchase_process_item.should_receive(:try).with(:quantity).and_return('quantity')

        expect(subject.quantity).to eq 'quantity'
      end
    end
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

  describe '#lot' do
    let(:purchase_process_creditor_proposal) { double(:purchase_process_creditor_proposal) }
    let(:purchase_process_item) { double(:purchase_process_item) }

    context 'when there is an purchase_process_creditor_proposal' do
      before do
        subject.stub(purchase_process_creditor_proposal: purchase_process_creditor_proposal)
      end

      it "should try the purchase_process_creditor_proposal's lot" do
        purchase_process_creditor_proposal.should_receive(:try).with(:lot).and_return('lot')

        expect(subject.lot).to eq 'lot'
      end
    end

    context 'when there is not an item' do
      before do
        subject.stub(
          purchase_process_creditor_proposal: nil,
          purchase_process_item: purchase_process_item)
      end

      it "should try the purchase_process_item's lot" do
        purchase_process_item.should_receive(:try).with(:lot).and_return('lot')

        expect(subject.lot).to eq 'lot'
      end
   end
  end
end
