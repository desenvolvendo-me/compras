require 'model_helper'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/trading'
require 'app/models/trading_item'
require 'app/models/trading_item_bid'
require 'app/models/licitation_process'
require 'app/models/bidder'
require 'app/models/bidder_disqualification'
require 'app/models/trading_item_closing'

describe TradingItem do
  it { should belong_to :trading }
  it { should belong_to :administrative_process_budget_allocation_item }

  it { should have_many(:trading_item_bids).dependent(:destroy) }
  it { should have_many(:bidders).through(:trading).order(:id) }

  it { should have_one(:closing).dependent(:destroy) }

  it { should delegate(:material).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:material_id).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:reference_unit).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:quantity).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:unit_price).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:licitation_process_id).to(:trading) }

  it { should auto_increment(:order).by(:trading_id) }

  it "has a default value of 0 to minimum_reduction_percent" do
    expect(TradingItem.new.minimum_reduction_percent).to eq 0.0
  end

  it "has a default value of 0 to minimum_reduction_value" do
    expect(TradingItem.new.minimum_reduction_value).to eq 0.0
  end

  context "delegates" do
    let(:administrative_process_item) { double(:process_item) }

    before do
      subject.stub(:administrative_process_budget_allocation_item => administrative_process_item)
    end

    describe "#to_s" do
      it "delegates to administrative_process_budget_allocation_item" do
        administrative_process_item.should_receive(:to_s)
        subject.to_s
      end
    end
  end

  describe '#last_proposal' do
    it 'should return the last bid proposal value for the item' do
      first_bid = double(:first_bid, :amount => 50.0)
      second_bid = double(:second_bid, :amount => 40.0)
      third_bid = double(:third_bid, :amount => 30.0)

      trading_item_bids = double(:trading_item_bids, :with_proposal => [first_bid, second_bid, third_bid])
      trading_item_bids.should_receive(:with_valid_proposal).and_return(trading_item_bids)
      trading_item_bids.should_receive(:reorder).and_return(trading_item_bids)
      trading_item_bids.should_receive(:first).and_return(third_bid)

      subject.should_receive(:trading_item_bids).and_return(trading_item_bids)

      expect(subject.lowest_proposal_value).to eq 30.0
    end

    it 'should return zero when there is no proposal for the item' do
      trading_item_bids = double(:trading_item_bids)

      trading_item_bids.should_receive(:with_valid_proposal).and_return(trading_item_bids)
      trading_item_bids.should_receive(:reorder).and_return([])

      subject.should_receive(:trading_item_bids).and_return(trading_item_bids)

      expect(subject.lowest_proposal_value).to eq 0
    end
  end

  describe '#lowest_proposal_bidder' do
    it 'should return the last bid proposal bidder for the item' do
      first_bid = double(:first_bid, :bidder => 'foo')
      second_bid = double(:second_bid, :bidder => 'bar')
      third_bid = double(:third_bid, :bidder => 'baz')

      trading_item_bids = double(:trading_item_bids, :with_proposal => [first_bid, second_bid, third_bid])
      trading_item_bids.should_receive(:with_valid_proposal).and_return(trading_item_bids)
      trading_item_bids.should_receive(:reorder).and_return(trading_item_bids)
      trading_item_bids.should_receive(:first).and_return(third_bid)

      subject.should_receive(:trading_item_bids).and_return(trading_item_bids)

      expect(subject.lowest_proposal_bidder).to eq 'baz'
    end

    it 'should return nil when there is no proposal for the item' do
      trading_item_bids = double(:trading_item_bids)

      trading_item_bids.should_receive(:with_valid_proposal).and_return(trading_item_bids)
      trading_item_bids.should_receive(:reorder).and_return([])

      subject.should_receive(:trading_item_bids).and_return(trading_item_bids)

      expect(subject.lowest_proposal_bidder).to eq ''
    end
  end

  describe '#bidders_by_lowest_proposal' do
    it 'should return bidders ordered by lowest proposal by bidder' do
      bidder1 = double(:bidder1)
      bidder2 = double(:bidder2)
      bidder3 = double(:bidder3)
      bidders = double(:bidders)

      subject.stub(:id).and_return(1)
      subject.stub(:bidders).and_return(bidders)

      bidder1.should_receive(:lower_trading_item_bid_amount).
              at_least(1).times.with(subject).and_return(90)

      bidder2.should_receive(:lower_trading_item_bid_amount).
              at_least(1).times.with(subject).and_return(80)

      bidder3.should_receive(:lower_trading_item_bid_amount).
              at_least(1).times.with(subject).and_return(100)

      bidders.should_receive(:with_proposal_for_trading_item).
              with(1).and_return([bidder1, bidder2, bidder3])

      expect(subject.bidders_by_lowest_proposal).to eq [bidder2, bidder1, bidder3]
    end
  end

  describe '#enabled_bidders_by_lowest_proposal' do
    let(:bidder1) { double(:bidder1) }
    let(:bidder2) { double(:bidder2) }
    let(:bidder3) { double(:bidder3) }
    let(:bidders_with_proposals) { double(:bidders_with_proposals) }

    context 'with all bidders' do
      it 'should return bidders ordered by lowest proposal by bidder' do
        bidders_with_proposals.stub(:enabled).and_return([bidder1, bidder3])

        subject.stub(:bidders_with_proposals).and_return(bidders_with_proposals)

        bidder1.should_receive(:lower_trading_item_bid_amount).
                at_least(1).times.with(subject).and_return(90)

        bidder2.should_not_receive(:lower_trading_item_bid_amount)

        bidder3.should_receive(:lower_trading_item_bid_amount).
                at_least(1).times.with(subject).and_return(100)

        expect(subject.enabled_bidders_by_lowest_proposal).to eq [bidder1, bidder3]
      end
    end

    context 'with selected bidders' do
      let(:enabled) { double(:enabled, :selected_for_trading_item => [bidder1, bidder2]) }

      it 'should return bidders ordered by lowest proposal by bidder' do
        bidders_with_proposals.stub(:enabled => enabled)

        subject.stub(:bidders_with_proposals).and_return(bidders_with_proposals)

        bidder1.should_receive(:lower_trading_item_bid_amount).
                at_least(1).times.with(subject).and_return(90)

        bidder2.should_receive(:lower_trading_item_bid_amount).
                at_least(1).times.with(subject).and_return(100)

        bidder3.should_not_receive(:lower_trading_item_bid_amount)

        expect(subject.enabled_bidders_by_lowest_proposal(:filter => :selected)).to eq [bidder1, bidder2]
      end
    end

    context 'with no selected bidders' do
      let(:enabled) { double(:enabled, :not_selected_for_trading_item => [bidder2, bidder3]) }

      it 'should return bidders ordered by lowest proposal by bidder' do
        bidders_with_proposals.stub(:enabled => enabled)

        subject.stub(:bidders_with_proposals).and_return(bidders_with_proposals)

        bidder2.should_receive(:lower_trading_item_bid_amount).
                at_least(1).times.with(subject).and_return(90)

        bidder3.should_receive(:lower_trading_item_bid_amount).
                at_least(1).times.with(subject).and_return(100)

        bidder1.should_not_receive(:lower_trading_item_bid_amount)

        expect(subject.enabled_bidders_by_lowest_proposal(:filter => :not_selected)).to eq [bidder2, bidder3]
      end
    end
  end

  describe '#bidders_by_lowest_proposal_at_stage_of_round_of_bids' do
    it 'should return bidders ordered by lowest proposal by bidder' do
      bidder1 = double(:bidder1)
      bidder2 = double(:bidder2)
      bidder3 = double(:bidder3)
      bidders = double(:bidders)

      subject.stub(:id).and_return(1)
      subject.stub(:bidders).and_return(bidders)

      bidder1.should_receive(:lower_trading_item_bid_amount_at_stage_of_round_of_bids).
              at_least(1).times.with(subject).and_return(90)

      bidder2.should_receive(:lower_trading_item_bid_amount_at_stage_of_round_of_bids).
              at_least(1).times.with(subject).and_return(80)

      bidder3.should_receive(:lower_trading_item_bid_amount_at_stage_of_round_of_bids).
              at_least(1).times.with(subject).and_return(100)

      bidders.should_receive(:with_proposal_for_trading_item_at_stage_of_round_of_bids).
              with(1).and_return([bidder1, bidder2, bidder3])

      expect(subject.bidders_by_lowest_proposal_at_stage_of_round_of_bids).to eq [bidder2, bidder1, bidder3]
    end
  end

  describe '#bidders_benefited_by_lowest_proposal_at_stage_of_round_of_bids' do
    it 'should return bidders ordered by lowest proposal by bidder' do
      bidder1 = double(:bidder1)
      bidder2 = double(:bidder2)
      bidder3 = double(:bidder3)
      bidders = double(:bidders)
      benefited = double([bidder1, bidder2])

      subject.stub(:id).and_return(1)
      subject.stub(:bidders).and_return(bidders)

      bidder1.should_receive(:lower_trading_item_bid_amount_at_stage_of_round_of_bids).
              at_least(1).times.with(subject).and_return(90)

      bidder2.should_receive(:lower_trading_item_bid_amount_at_stage_of_round_of_bids).
              at_least(1).times.with(subject).and_return(80)

      bidder3.should_receive(:lower_trading_item_bid_amount_at_stage_of_round_of_bids).exactly(0).times

      bidders.should_receive(:benefited).and_return(benefited)

      benefited.should_receive(:with_proposal_for_trading_item_at_stage_of_round_of_bids).
              with(1).and_return([bidder1, bidder2])

      expect(subject.bidders_benefited_by_lowest_proposal_at_stage_of_round_of_bids).to eq [bidder2, bidder1]
    end
  end

  describe '#bidders_by_lowest_proposal_at_stage_of_negotiation' do
    it 'should return bidders ordered by lowest proposal by bidder' do
      bidder1 = double(:bidder1)
      bidder2 = double(:bidder2)
      bidder3 = double(:bidder3)
      bidders = double(:bidders)

      subject.stub(:id).and_return(1)
      subject.stub(:bidders).and_return(bidders)

      bidder1.should_receive(:lower_trading_item_bid_amount_at_stage_of_negotiation).
              at_least(1).times.with(subject).and_return(90)

      bidder2.should_receive(:lower_trading_item_bid_amount_at_stage_of_negotiation).
              at_least(1).times.with(subject).and_return(80)

      bidder3.should_receive(:lower_trading_item_bid_amount_at_stage_of_negotiation).
              at_least(1).times.with(subject).and_return(100)

      bidders.should_receive(:with_proposal_for_trading_item_at_stage_of_negotiation).
              with(1).and_return([bidder1, bidder2, bidder3])

      expect(subject.bidders_by_lowest_proposal_at_stage_of_negotiation).to eq [bidder2, bidder1, bidder3]
    end
  end

  describe '#lowest_proposal_amount' do
    it 'should return the lowest bid proposal for the item' do
      bidder1 = double(:bidder1)

      subject.should_receive(:bidder_with_lowest_proposal).
              at_least(1).times.and_return(bidder1)

      bidder1.should_receive(:lower_trading_item_bid_amount).
              with(subject).and_return(10)

      expect(subject.lowest_proposal_amount).to eq 10
    end

    it 'should return nil when there are no proposals' do
      subject.should_receive(:bidder_with_lowest_proposal).
              at_least(1).times.and_return(nil)

      expect(subject.lowest_proposal_amount).to be_nil
    end
  end

  describe '#value_limit_to_participate_in_bids' do
    it 'should calculate the limit to participate in bids' do
      subject.should_receive(:lowest_proposal_amount_at_stage_of_proposals).exactly(2).times.and_return(100)
      subject.should_receive(:percentage_limit_to_participate_in_bids).and_return(10.0)

      expect(subject.value_limit_to_participate_in_bids).to eq 110
    end
  end

  describe "#allow_winner?" do
    let(:winner) { double(:benefited => false) }

    before do
      subject.stub(:bidder_with_lowest_proposal => winner)
    end

    context 'when not closed' do
      before do
        subject.stub(:closed? => false, :started? => true)
      end

      it "returns true if there are no bidders for negotiation" do
        subject.stub(:bidders_selected_for_negotiation => [])

        expect(subject.allow_winner?).to be_true
      end

      it "returns true if the winning bidder is benefited" do
        winner.stub(:benefited => true)

        expect(subject.allow_winner?).to be_true
      end

      it 'returns false when there are bidders for negotiation and the winner is not benefited' do
        subject.stub(:bidders_selected_for_negotiation => ['bidder'])
        winner.stub(:benefited => false)

        expect(subject.allow_winner?).to be_false
      end
    end

    context 'when not closed and not started' do
      before do
        subject.stub(:closed? => false, :started? => false)
      end

      it { expect(subject.allow_winner?).to be_false }
    end

    context 'when closed' do
      before do
        subject.stub(:closed? => true)
      end

      it { expect(subject.allow_winner?).to be_false }
    end
  end

  describe "closed?" do
    context 'when there is a closing' do
      before do
        subject.stub(:closing => 'closing')
      end

      it { expect(subject).to be_closed }
    end

    context 'when there is not closing' do

      it { expect(subject).not_to be_closed }
    end
  end

  describe 'last_bid' do
    it 'should return the last trading_item_bid' do
      subject.stub(:trading_item_bids).and_return(['bid1', 'bid2'])

      expect(subject.last_bid).to eq 'bid2'
    end

    it 'should return nil when there is no trading_item_bids' do
      expect(subject.last_bid).to eq nil
    end
  end

  describe '#proposals_for_round_of_bids?' do
    it 'should return true when there are proposals at round of bid' do
      bids = double(:bids, :at_stage_of_round_of_bids => ['proposal'])

      subject.stub(:trading_item_bids).and_return(bids)

      expect(subject.proposals_for_round_of_bids?).to be_true
    end

    it 'should return false when there are no proposals at round of bid' do
      bids = double(:bids, :at_stage_of_round_of_bids => [])

      subject.stub(:trading_item_bids).and_return(bids)

      expect(subject.proposals_for_round_of_bids?).to be_false
    end
  end

  describe '#started?' do
    it 'should be true when have bids' do
      subject.stub(:trading_item_bids).and_return(['bid'])

      expect(subject.started?).to be_true
    end

    it 'should be false when have not bids' do
      subject.stub(:trading_item_bids).and_return([])

      expect(subject.started?).to be_false
    end
  end

  describe 'valid_bidder_for_negotiation?' do
    it 'should be true if there is no one valid proposal for negotiation' do
      subject.stub(:bidders_selected_for_negotiation).and_return(['bidder'])
      subject.stub(:valid_proposal_for_negotiation?).and_return(false)

      expect(subject.valid_bidder_for_negotiation?).to be_true
    end

    it 'should be false if there is not valid proposal for negotiation' do
      subject.stub(:bidders_selected_for_negotiation).and_return([])
      subject.stub(:valid_proposal_for_negotiation?).and_return(true)

      expect(subject.valid_bidder_for_negotiation?).to be_false
    end

    it 'should be false if there is a valid proposal for negotiation and have bidder for negotiation' do
      subject.stub(:bidders_selected_for_negotiation).and_return(['bidder'])
      subject.stub(:valid_proposal_for_negotiation?).and_return(true)

      expect(subject.valid_bidder_for_negotiation?).to be_false
    end
  end

  describe '#with_proposal_for_round_of_proposals?' do
    let(:at_stage_of_proposals) { double(:at_stage_of_proposals) }

    let(:trading_item_bids) do
      double(:trading_item_bids, :at_stage_of_proposals => at_stage_of_proposals)
    end

    before do
      subject.stub(:trading_item_bids => trading_item_bids)
    end

    context 'with proposals' do
      before do
        at_stage_of_proposals.should_receive(:with_proposal).and_return(['proposal'])
      end

      it { expect(subject.with_proposal_for_round_of_proposals?).to be_true }
    end

    context 'without proposals' do
      before do
        at_stage_of_proposals.should_receive(:with_proposal).and_return([])
      end

      it { expect(subject.with_proposal_for_round_of_proposals?).to be_false }
    end
  end

  describe '#bidder_with_lowest_proposal' do
    context 'when there are no bidder with lowest proposal' do
      it { expect(subject.bidder_with_lowest_proposal).to be_nil }
    end

    context 'when there are bidder with lowest proposal' do
      before do
        subject.stub(:enabled_bidders_by_lowest_proposal => ['bidder1', 'bidder2'])
      end

      it 'should retuns the first bidder with lowest proposal' do
        expect(subject.bidder_with_lowest_proposal).to eq 'bidder1'
      end
    end
  end

  describe '#lowest_proposal_at_stage_of_proposals_amount' do
    let(:enabled) { double(:enabled) }
    let(:trading_item_bids) { double(:trading_item_bids, :enabled => enabled) }

    before do
      subject.stub(:trading_item_bids => trading_item_bids)
    end

    it 'should returns the lowest proposal' do
      enabled.should_receive(:lowest_proposal_by_item_at_stage_of_proposals).
              with(subject).and_return(50)

      expect(subject.lowest_proposal_at_stage_of_proposals_amount).to eq 50
    end

    it 'should returns 0 when there is no the lowest proposal' do
      enabled.should_receive(:lowest_proposal_by_item_at_stage_of_proposals).
              with(subject).and_return(nil)

      expect(subject.lowest_proposal_at_stage_of_proposals_amount).to eq 0
    end
  end

  describe '#allow_negotiation?' do
    context 'when there are not bidders for negotiation' do
      before do
        subject.stub(:bidders_selected_for_negotiation => [])
      end

      it { expect(subject.allow_negotiation?).to be_false }
    end

    context 'when there are bidders for negotiation' do
      before do
        subject.stub(:bidders_selected_for_negotiation => ['bidder'])
      end

      it { expect(subject.allow_negotiation?).to be_true }
    end
  end
end
