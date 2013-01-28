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

  it { should have_many(:bids).dependent(:destroy) }
  it { should have_many(:bidders).through(:trading).order(:id) }

  it { should have_one(:closing).dependent(:destroy) }

  it { should delegate(:material).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:material_id).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:reference_unit).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:quantity).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:unit_price).to(:administrative_process_budget_allocation_item).allowing_nil(true) }
  it { should delegate(:licitation_process_id).to(:trading) }
  it { should delegate(:allow_closing?).to(:trading).prefix(true) }

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

  describe '#lowest_proposal_value' do
    context 'with proposals_activated_at nil' do
      it 'should return the last bid proposal value for the item' do
        first_bid  = double(:first_bid, :amount => 50.0)
        second_bid = double(:second_bid, :amount => 40.0)
        third_bid  = double(:third_bid, :amount => 30.0)
        bids = double(:bids, :with_proposal => [first_bid, second_bid, third_bid])
        enabled    = double(:enabled, :with_proposal => bids)
        bids.should_receive(:enabled).and_return(enabled)
        bids.should_receive(:reorder).and_return(bids)
        bids.should_receive(:first).and_return(third_bid)

        subject.should_receive(:bids).and_return(bids)

        expect(subject.lowest_proposal_value).to eq 30.0
      end

      it 'should return zero when there is no proposal for the item' do
        bids = double(:bids)
        enabled           = double(:enabled, :with_proposal => bids)

        bids.should_receive(:enabled).and_return(enabled)
        bids.should_receive(:reorder).and_return([])

        subject.should_receive(:bids).and_return(bids)

        expect(subject.lowest_proposal_value).to eq 0
      end
    end

    context 'with proposals_activated_at not nil' do
      before do
        subject.stub(:proposals_activated_at => DateTime.current)
      end

      it 'should return the last bid proposal value for the item' do
        first_bid = double(:first_bid, :amount => 50.0)
        second_bid = double(:second_bid, :amount => 40.0)
        third_bid = double(:third_bid, :amount => 30.0)

        bids = double(:bids, :with_proposal => [first_bid, second_bid, third_bid])
        bids.should_receive(:with_proposal).and_return(bids)
        bids.should_receive(:reorder).and_return(bids)
        bids.should_receive(:first).and_return(third_bid)

        subject.should_receive(:bids).and_return(bids)

        expect(subject.lowest_proposal_value).to eq 30.0
      end

      it 'should return zero when there is no proposal for the item' do
        bids = double(:bids)

        bids.should_receive(:with_proposal).and_return(bids)
        bids.should_receive(:reorder).and_return([])

        subject.should_receive(:bids).and_return(bids)

        expect(subject.lowest_proposal_value).to eq 0
      end
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
      subject.stub(:bids).and_return(['bid1', 'bid2'])

      expect(subject.last_bid).to eq 'bid2'
    end

    it 'should return nil when there is no bids' do
      expect(subject.last_bid).to eq nil
    end
  end

  describe '#proposals_for_round_of_bids?' do
    it 'should return true when there are proposals at round of bid' do
      bids = double(:bids, :at_stage_of_round_of_bids => ['proposal'])

      subject.stub(:bids).and_return(bids)

      expect(subject.proposals_for_round_of_bids?).to be_true
    end

    it 'should return false when there are no proposals at round of bid' do
      bids = double(:bids, :at_stage_of_round_of_bids => [])

      subject.stub(:bids).and_return(bids)

      expect(subject.proposals_for_round_of_bids?).to be_false
    end
  end

  describe '#started?' do
    it 'should be true when have bids' do
      subject.stub(:bids).and_return(['bid'])

      expect(subject.started?).to be_true
    end

    it 'should be false when have not bids' do
      subject.stub(:bids).and_return([])

      expect(subject.started?).to be_false
    end
  end

  describe '#valid_bidder_for_negotiation?' do
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

    let(:bids) do
      double(:bids, :at_stage_of_proposals => at_stage_of_proposals)
    end

    before do
      subject.stub(:bids => bids)
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
    let(:bids) { double(:bids, :enabled => enabled) }

    before do
      subject.stub(:bids => bids)
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

  describe '#activate_proposals_allowed?' do
    context 'when have no proposals not selected' do
      before do
        subject.stub(:bidders_enabled_not_selected => [])
      end

      it { expect(subject.activate_proposals_allowed?).to be_false }
    end

    context 'when have proposals not selected' do
      before do
        subject.stub(:bidders_enabled_not_selected => ['proposal'])
      end

      context 'when already has proposals activated' do
        before do
          subject.stub(:proposals_activated? => true)
        end

        it { expect(subject.activate_proposals_allowed?).to be_false }
      end

      context 'when has no proposals activated' do
        before do
          subject.stub(:proposals_activated? => false)
          subject.should_receive(:enabled_bidders_by_lowest_proposal).with(:filter => :selected).and_return(['bidder'])
        end

        it { expect(subject.activate_proposals_allowed?).to be_false }
      end

      context 'when has no_enabled_bidders_by_lowest_proposal_selected' do
        it 'should be true if proposals are not activated' do
          subject.should_receive(:enabled_bidders_by_lowest_proposal).with(:filter => :selected).and_return([])
          subject.stub(:proposals_activated? => false)

          expect(subject.activate_proposals_allowed?).to be_true
        end

        it 'should be false if proposals are not activated' do
          subject.stub(:proposals_activated? => true)

          expect(subject.activate_proposals_allowed?).to be_false
        end
      end
    end
  end

  describe '#proposals_activated?' do
    context 'when proposals_activated_at is nil' do
      it { expect(subject.proposals_activated?).to be_false }
    end

    context 'when proposals_activated_at is not nil' do
      before do
        subject.stub(:proposals_activated_at => DateTime.current)
      end

      it { expect(subject.proposals_activated?).to be_true }
    end
  end

  describe '#activate_proposals!' do
    context 'when activate proposals is not allowed' do
      before do
        subject.stub(:activate_proposals_allowed? => false)

        it "should do nothing and returns false" do
          subject.should_not_receive(:update_column)

          expect(subject.activate_proposals!).to be_false
        end
      end
    end

    context 'when activate proposals is allowed' do
      before do
        subject.stub(:activate_proposals_allowed? => true)

        it "should update proposals_activated_at to current DateTime and return true" do
          subject.should_receive(:update_column).with(:proposals_activated_at, DateTime.current).and_return(true)

          expect(subject.activate_proposals!).to be_true
        end
      end
    end
  end
end
