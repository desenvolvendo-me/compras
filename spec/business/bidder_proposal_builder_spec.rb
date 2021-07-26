require 'unit_helper'
require 'app/business/bidder_proposal_builder'

describe BidderProposalBuilder do

  let(:bidder) do
    double(:bidder,
      :id => 1,
      :items => [ item ],
      :proposals => [ ]
    )
  end

  let(:item) do
    double(:item,
      :bidder_proposals => [ ]
    )
  end

  let(:bidder_proposal) do
    double(:bidder_proposal)
  end

  it "should build proposals" do
    item.stub(:bidder_proposal?).and_return( false )
    bidder.proposals.should_receive(:build)
    BidderProposalBuilder.new(bidder).build!
  end

  it "should not build proposals when already exists" do
    item.stub(:bidder_proposal?).and_return( true )
    bidder.proposals.should_not_receive(:build)
    BidderProposalBuilder.new(bidder).build!
  end
end
