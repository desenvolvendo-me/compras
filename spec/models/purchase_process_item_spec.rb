# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_process_item'
require 'app/models/licitation_process_classification'
require 'app/models/trading_item'
require 'app/models/bidder_proposal'
require 'app/models/purchase_process_creditor_proposal'
require 'app/models/purchase_process_trading_bid'

describe PurchaseProcessItem do
  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :lot }

  it { should belong_to :material }
  it { should belong_to :licitation_process }
  it { should belong_to :creditor }

  it { should have_many :bidder_proposals }
  it { should have_many(:creditor_proposals).dependent(:destroy) }
  it { should have_many(:licitation_process_classifications).dependent(:destroy) }
  it { should have_many(:trading_bids).dependent(:restrict) }
  it { should have_many(:purchase_process_accreditation_creditors) }

  it { should have_one(:trading_item).dependent(:restrict) }
  it { should have_one(:purchase_process_accreditation) }

  it { should delegate(:reference_unit).to(:material).allowing_nil(true) }
  it { should delegate(:description).to(:material).allowing_nil(true) }
  it { should delegate(:direct_purchase?).to(:licitation_process).allowing_nil(true) }

  describe "creditor validation" do
    it 'validates presence when direct purchase' do
      subject.stub(:direct_purchase?).and_return true
      subject.valid?
      expect(subject.errors[:creditor]).to_not be_empty
    end

    it 'does not validate presence when not direct purchase' do
      subject.stub(:direct_purchase?).and_return false
      subject.valid?
      expect(subject.errors[:creditor]).to be_empty
    end
  end

  context 'with material' do
    let :material do
      double(:material)
    end

    it 'should return material.to_s as to_s' do
      subject.stub(:material).and_return(material)

      material.stub(:to_s).and_return('Cadeira')

      expect(subject.to_s).to eq 'Cadeira'
    end
  end

  it 'should calculate the estimated total price' do
    expect(subject.estimated_total_price).to eq 0

    subject.quantity = 5
    subject.unit_price = 10.1

    expect(subject.estimated_total_price).to eq 50.5
  end

  it "should without_lot? be true when has not lot" do
    described_class.stub(:without_lot?).and_return(true)
    described_class.should be_without_lot
  end

  it "should without_lot? be false when has not lot" do
    described_class.stub(:without_lot?).and_return(false)
    described_class.should_not be_without_lot
  end

  context 'unit price and total value in a licitation_process' do
    let :bidder do
      double('Bidder', proposals: [proposal])
    end

    let :proposal do
      double('LicitationProcessProposal', id: 1, purchase_process_item: subject, unit_price: 10)
    end

    it 'should return unit price by bidder' do
      expect(subject.unit_price_by_bidder(bidder)).to eq 10
    end

    it 'should return total value by bidder' do
      subject.quantity = 4
      expect(subject.total_value_by_bidder(bidder)).to eq 40
    end

    it 'should return zero when unit price equals nil' do
      proposal.stub(unit_price: nil)
      subject.quantity = 3

      expect(subject.total_value_by_bidder(bidder)).to eq 0
    end
  end

  context "#winning_bid" do
    it 'returns the classification that has won the bid' do
      classification_1 = double(:classification, situation: SituationOfProposal::LOST)
      classification_2 = double(:classification, situation: SituationOfProposal::WON)

      subject.stub(licitation_process_classifications: [classification_1, classification_2])

      expect(subject.winning_bid).to eq classification_2
    end
  end

  describe '#lowest_trading_bid' do
    let(:trading_bids) { double(:trading_bids) }

    before do
      subject.stub(trading_bids: trading_bids)
    end

    context 'when there is bids with proposal' do
      before do
        trading_bids.stub(with_proposal: ['bid_lower', 'bid_higher'])
      end

      it 'should return the bid with proposal with lowest value' do
        expect(subject.lowest_trading_bid).to eq 'bid_lower'
      end
    end

    context 'when there is no bids with proposal' do
      before do
        trading_bids.stub(with_proposal: [])
      end

      it 'should return nil' do
        expect(subject.lowest_trading_bid).to be_nil
      end
    end
  end

  describe '#bids_historic' do
    let(:bids) { double(:bids) }

    it 'should remove bidders without_proposals and filter by item' do
      subject.stub(trading_bids: bids)

      bids.should_receive(:not_without_proposal).and_return(bids)
      bids.should_receive(:reorder).with('number DESC')

      subject.bids_historic
    end
  end

  describe '#trading_creditors_ordered' do
    it 'should return all creditors ordered' do
      subject.stub(id: 4)
      accreditation_creditors = double(:accreditation_creditors)

      subject.should_receive(:purchase_process_accreditation_creditors).and_return(accreditation_creditors)
      accreditation_creditors.should_receive(:by_lowest_proposal).with(4).and_return(['creditor1', 'creditor2'])

      expect(subject.trading_creditors_ordered).to eq ['creditor1', 'creditor2']
    end
  end

  describe '#trading_creditors_selected' do
    it 'should return all creditors ordered' do
      creditors_ordered = double(:creditors_ordered)

      subject.should_receive(:trading_creditors_ordered).and_return(creditors_ordered)
      creditors_ordered.should_receive(:selected_creditors).and_return(['creditor1', 'creditor2'])

      expect(subject.trading_creditors_selected).to eq ['creditor1', 'creditor2']
    end
  end

  describe '#trading_lowest_proposal' do
    context 'when trading_creditor_with_lowest_proposal is nil' do
      before do
        subject.stub(trading_creditor_with_lowest_proposal: nil)
      end

      it 'should return nil' do
        expect(subject.trading_lowest_proposal).to be_nil
      end
    end

    context 'when trading_creditor_with_lowest_proposal is nil' do
      let(:creditor) { double(:creditor) }
      let(:proposal) { double(:proposal) }

      before do
        subject.stub(trading_creditor_with_lowest_proposal: creditor)
      end

      it 'should return the lowest proposal' do
        creditor.should_receive(:creditor_proposal_by_item).with(subject).and_return(proposal)

        expect(subject.trading_lowest_proposal).to eq proposal
      end
    end
  end

  describe '#last_trading_bid' do
    it 'should return the last given bid for the item' do
      trading_bids = double(:trading_bids)

      subject.stub(trading_bids: trading_bids)

      trading_bids.should_receive(:not_without_proposal).and_return(trading_bids)
      trading_bids.should_receive(:reorder).with(:id).and_return(['bid1', 'bid2'])

      expect(subject.last_trading_bid).to eq 'bid2'
    end
  end
end
