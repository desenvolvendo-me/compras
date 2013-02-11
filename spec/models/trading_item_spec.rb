# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/trading'
require 'app/models/trading_item'
require 'app/models/trading_item_bid'
require 'app/models/licitation_process'
require 'app/models/bidder'
require 'app/models/bidder_disqualification'
require 'app/models/trading_item_closing'
require 'app/business/trading_item_bidders'

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
    let(:bidders) { double(:bidders) }
    let(:with_proposal_for_trading_item) { double(:with_proposal_for_trading_item) }

    before do
      subject.stub(:id => 5)
      subject.stub(:bidders => bidders)
    end

    it 'should return bidders ordered by lowest proposal by bidder' do
      bidders.
        should_receive(:with_proposal_for_trading_item).
        with(5).
        and_return(with_proposal_for_trading_item)

      with_proposal_for_trading_item.
        should_receive(:ordered_by_trading_item_bid_amount).with(5)

      subject.bidders_by_lowest_proposal
    end
  end

  describe '#bidders_by_lowest_proposal_at_stage_of_round_of_bids' do
    let(:bidders) { double(:bidders) }
    let(:with_proposal_for_trading_item_at_stage_of_round_of_bids) { double(:with_proposal_for_trading_item_at_stage_of_round_of_bids) }

    before do
      subject.stub(:id => 5)
      subject.stub(:bidders => bidders)
    end

    it 'should return bidders ordered by lowest proposal by bidder' do
      bidders.
        should_receive(:with_proposal_for_trading_item_at_stage_of_round_of_bids).
        with(5).
        and_return(with_proposal_for_trading_item_at_stage_of_round_of_bids)

      with_proposal_for_trading_item_at_stage_of_round_of_bids.
        should_receive(:ordered_by_trading_item_bid_amount).with(5)

      subject.bidders_by_lowest_proposal_at_stage_of_round_of_bids
    end
  end

  describe '#bidders_benefited_by_lowest_proposal_at_stage_of_round_of_bids' do
    let(:bidders) { double(:bidders) }
    let(:with_proposal_for_trading_item_at_stage_of_round_of_bids) { double(:with_proposal_for_trading_item_at_stage_of_round_of_bids) }
    let(:benefited) { double(:benefited) }

    before do
      subject.stub(:id => 5)
      subject.stub(:bidders => bidders)
    end

    it 'should return bidders ordered by lowest proposal by bidder' do
      bidders.should_receive(:benefited).and_return(benefited)

      benefited.
        should_receive(:with_proposal_for_trading_item_at_stage_of_round_of_bids).
        with(5).
        and_return(with_proposal_for_trading_item_at_stage_of_round_of_bids)

      with_proposal_for_trading_item_at_stage_of_round_of_bids.
        should_receive(:ordered_by_trading_item_bid_amount).with(5)

      subject.bidders_benefited_by_lowest_proposal_at_stage_of_round_of_bids
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

  describe "#allow_winner?" do
    let(:winner) { double(:benefited => false) }
    let(:trading_item_winner) { double(:trading_item_winner) }

    before do
      subject.stub(:bidder_with_lowest_proposal => winner)
    end

    context 'when not closed' do
      before do
        subject.stub(:closed? => false, :started? => true)
      end

      it "returns true if there ia a winner" do
        trading_item_winner.should_receive(:winner).with(subject).and_return('winner')

        expect(subject.allow_winner?(trading_item_winner)).to be_true
      end

      it 'returns false when there is no winner' do
        trading_item_winner.should_receive(:winner).with(subject).and_return(nil)
        winner.stub(:benefited => false)

        expect(subject.allow_winner?(trading_item_winner)).to be_false
      end
    end

    context 'when not closed and not started' do
      before do
        subject.stub(:closed? => false, :started? => false)
      end

      it { expect(subject.allow_winner?(trading_item_winner)).to be_false }
    end

    context 'when closed' do
      before do
        subject.stub(:closed? => true)
      end

      it { expect(subject.allow_winner?(trading_item_winner)).to be_false }
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
      it 'should order by amount bidders with proposal and enabled' do
        TradingItemBidders.any_instance.should_receive(:bidders_ordered_by_amount).and_return([])
        expect(subject.bidder_with_lowest_proposal).to be_nil
      end
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

  describe '#block_minimum_reduction?' do
    context 'when closed' do
      before do
        subject.stub(:closed? => true)
      end

      it { expect(subject.block_minimum_reduction?).to be_true }
    end

    context 'when started' do
      before do
        subject.stub(:started? => true)
      end

      it { expect(subject.block_minimum_reduction?).to be_true }
    end

    context 'when not started neither closed' do
      before do
        subject.stub(:started? => false)
        subject.stub(:closed? => false)
      end

      it { expect(subject.block_minimum_reduction?).to be_false }
    end
  end

  describe 'validate minimum_reductions' do
    context 'when block_minimum_reduction' do
      before do
        subject.stub(:block_minimum_reduction? => true)
      end

      context 'when changed minimum_reduction_value' do
        it 'should not be valid' do
          subject.stub(:changed_attributes => { 'minimum_reduction_value' => 10.1 })
          subject.stub(:validation_context).and_return(:update)

          subject.valid?

          expect(subject.errors[:minimum_reduction_value]).to include("não pode ser alterado quando o item já estiver em andamento ou fechado")
        end
      end

      context 'when changed minimum_reduction_percent' do
        it 'should not be valid' do
          subject.stub(:changed_attributes => { 'minimum_reduction_percent' => 10.1 })
          subject.stub(:validation_context).and_return(:update)

          subject.valid?

          expect(subject.errors[:minimum_reduction_percent]).to include("não pode ser alterado quando o item já estiver em andamento ou fechado")
        end
      end

      context 'when no one minimum_reduction is changed' do
        it 'should be valid' do
          subject.stub(:validation_context).and_return(:update)

          subject.valid?

          expect(subject.errors[:minimum_reduction_value]).to_not include("não pode ser alterado quando o item já estiver em andamento ou fechado")
          expect(subject.errors[:minimum_reduction_percent]).to_not include("não pode ser alterado quando o item já estiver em andamento ou fechado")
        end
      end
    end

    context 'when not block_minimum_reduction' do
      before do
        subject.stub(:block_minimum_reduction? => false)
      end

      context 'when changed minimum_reduction_value' do
        it 'should be valid' do
          subject.stub(:changed_attributes => { :minimum_reduction_value => 10.1 })
          subject.stub(:validation_context).and_return(:update)

          subject.valid?

          expect(subject.errors[:minimum_reduction_value]).to_not include("não pode ser alterado quando o item já estiver em andamento ou fechado")
        end
      end

      context 'when changed minimum_reduction_percent' do
        it 'should be valid' do
          subject.stub(:changed_attributes => { :minimum_reduction_percent => 10.1 })
          subject.stub(:validation_context).and_return(:update)

          subject.valid?

          expect(subject.errors[:minimum_reduction_percent]).to_not include("não pode ser alterado quando o item já estiver em andamento ou fechado")
        end
      end

      context 'when no one minimum_reduction is changed' do
        it 'should be valid' do
          subject.stub(:validation_context).and_return(:update)

          subject.valid?

          expect(subject.errors[:minimum_reduction_value]).to_not include("não pode ser alterado quando o item já estiver em andamento ou fechado")
          expect(subject.errors[:minimum_reduction_percent]).to_not include("não pode ser alterado quando o item já estiver em andamento ou fechado")
        end
      end
    end
  end
end
