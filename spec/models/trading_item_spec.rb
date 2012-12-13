require 'model_helper'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/trading'
require 'app/models/trading_item'
require 'app/models/trading_item_bid'

describe TradingItem do
  it { should belong_to :trading }
  it { should belong_to :administrative_process_budget_allocation_item }

  it { should have_many(:trading_item_bids).dependent(:destroy) }
  it { should have_many(:bidders).through(:trading).order(:id) }

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

  describe "#allow_closing?" do
    let(:winner) { double(:benefited => false) }

    before do
      subject.stub(:bidder_with_lowest_proposal => winner)
    end

    it "returns true if there are no bidders for negotiation" do
      subject.stub(:bidders_selected_for_negociation => [])

      expect(subject.allow_closing?).to be_true
    end

    it "returns true if the winning bidder is benefited" do
      winner.stub(:benefited => true)

      expect(subject.allow_closing?).to be_true
    end
  end

  describe "#close!" do
    it "fills the closing date" do
      closing_date = Date.current

      subject.close!(closing_date)

      expect(subject.closing_date).to eq closing_date
    end
  end

  describe "closed?" do
    it "returns true if there is a closing date" do
      subject.closing_date = Date.current

      expect(subject).to be_closed
    end

    it "returns false otherwise" do
      expect(subject).not_to be_closed
    end
  end

  describe "#can_be_disabled?" do

    let(:bidder) { double(:benefited => false) }

    before do
      subject.stub(:bidder_with_lowest_proposal => bidder)
    end

    it "returns true if bidder has lowest bid" do
      expect(subject.can_be_disabled?(bidder)).to be_true
    end

    it "returns false if bidder is benefited" do
      bidder.stub(:benefited => true)

      expect(subject.can_be_disabled?(bidder)).to be_false
    end
  end
end
