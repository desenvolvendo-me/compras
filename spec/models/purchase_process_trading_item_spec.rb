# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_process_trading_item'
require 'app/models/purchase_process_trading_item_bid'

describe PurchaseProcessTradingItem do
  it { should belong_to :trading }
  it { should belong_to :item }

  it { should have_many(:bids).dependent(:destroy) }
  it { should have_many(:purchase_process_accreditation_creditors).through(:item) }

  it { should delegate(:lot).to(:item).allowing_nil(true).prefix(true) }

  describe 'validations' do
    it 'cannot have 2 kind of reductions' do
      subject.reduction_rate_value = 10.0
      subject.reduction_rate_percent = 10.0

      subject.valid?

      expect(subject.errors[:reduction_rate_value]).to include('é permitido apenas um tipo de decréscimo')
    end

    it 'should allow reduction by value' do
      subject.reduction_rate_value = 10.0

      subject.valid?

      expect(subject.errors[:reduction_rate_value]).to_not include('é permitido apenas um tipo de decréscimo')
    end

    it 'should allow reduction by percentage' do
      subject.reduction_rate_percent = 10.0

      subject.valid?

      expect(subject.errors[:reduction_rate_value]).to_not include('é permitido apenas um tipo de decréscimo')
    end

    it 'should not allow a negative value for reduction_rato_value on update' do
      subject.reduction_rate_value = -1

      subject.stub(:validation_context).and_return(:update)

      subject.valid?

      expect(subject.errors[:reduction_rate_value]).to include('deve ser maior ou igual a 0')
    end

    it 'should not allow a negative value for reduction_rato_value on update' do
      subject.reduction_rate_percent = -1

      subject.stub(:validation_context).and_return(:update)

      subject.valid?

      expect(subject.errors[:reduction_rate_percent]).to include('deve ser maior ou igual a 0')
    end
  end

  describe '#to_s' do
    context 'when has lot' do
      before do
        subject.lot = 4
      end

      it 'should return the lot' do
        expect(subject.to_s).to eq '4'
      end
    end

    context 'when has not lot' do
      let(:item) { double(:item) }

      before do
        subject.stub(item: item)
      end

      it 'should return the item to_s' do
        item.should_receive(:to_s).and_return('item')

        expect(subject.to_s).to eq 'item'
      end
    end
  end

  describe '#last_bid' do
    it 'should return the last given bid for the item' do
      bids = double(:bids)

      subject.stub(bids: bids)

      bids.should_receive(:not_without_proposal).and_return(bids)
      bids.should_receive(:reorder).with(:id).and_return(['bid1', 'bid2'])

      expect(subject.last_bid).to eq 'bid2'
    end
  end

  describe '#lowest_proposal' do
    context 'when creditor_with_lowest_proposal is nil' do
      before do
        subject.stub(creditor_with_lowest_proposal: nil)
      end

      it 'should return nil' do
        expect(subject.lowest_proposal).to be_nil
      end
    end

    context 'when creditor_with_lowest_proposal is not nil' do
      let(:creditor) { double(:creditor) }
      let(:proposal) { double(:proposal) }
      let(:item) { double(:item) }

      before do
        subject.stub(creditor_with_lowest_proposal: creditor)
        subject.stub(item: item)
      end

      it 'should return the lowest proposal' do
        creditor.should_receive(:creditor_proposal_by_item).with(item).and_return(proposal)

        expect(subject.lowest_proposal).to eq proposal
      end
    end
  end

  describe '#creditors_selected' do
    it 'should return selected creditors ordered' do
      creditors_ordered = double(:creditors_ordered)

      subject.should_receive(:creditors_ordered).and_return(creditors_ordered)
      creditors_ordered.should_receive(:selected_creditors).and_return(['creditor1', 'creditor2'])

      expect(subject.creditors_selected).to eq ['creditor1', 'creditor2']
    end
  end

  describe '#creditors_ordered' do
    it 'should return all creditors ordered' do
      item = double(:item, id: 4)

      subject.stub(item: item)
      accreditation_creditors = double(:accreditation_creditors)

      subject.should_receive(:purchase_process_accreditation_creditors).and_return(accreditation_creditors)
      accreditation_creditors.should_receive(:by_lowest_proposal).with(4).and_return(['creditor1', 'creditor2'])

      expect(subject.creditors_ordered).to eq ['creditor1', 'creditor2']
    end
  end

  describe '#bids_historic' do
    let(:bids) { double(:bids) }

    it 'should remove bidders without_proposals and filter by item' do
      subject.stub(bids: bids)

      bids.should_receive(:not_without_proposal).and_return(bids)
      bids.should_receive(:reorder).with('number DESC')

      subject.bids_historic
    end
  end

  describe '#lowest_bid' do
    let(:bids) { double(:bids) }

    before do
      subject.stub(bids: bids)
    end

    context 'when there is bids with proposal' do
      before do
        bids.stub(with_proposal: ['bid_lower', 'bid_higher'])
      end

      it 'should return the bid with proposal with lowest value' do
        expect(subject.lowest_bid).to eq 'bid_lower'
      end
    end

    context 'when there is no bids with proposal' do
      before do
        bids.stub(with_proposal: [])
      end

      it 'should return nil' do
        expect(subject.lowest_bid).to be_nil
      end
    end
  end

  describe '#lowest_bid_or_proposal_amount' do
    context 'when has last_bid' do
      let(:lowest_bid) { double(:lowest_bid, amount: 10.0) }

      before do
        subject.stub(lowest_bid: lowest_bid)
      end

      it "should return lowest_bid's amount" do
        expect(subject.lowest_bid_or_proposal_amount).to eq 10.0
      end
    end

    context 'when has not last_bid' do
      let(:lowest_proposal) { double(:lowest_proposal, unit_price: 16.0) }

      before do
        subject.stub(lowest_proposal: lowest_proposal, last_bid: nil)
      end

      it "should return lowest_proposal's unit_price" do
        expect(subject.lowest_bid_or_proposal_amount).to eq 16.0
      end
    end
  end
end
