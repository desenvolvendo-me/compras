require 'unit_helper'
require 'app/business/licitation_process_bidder_proposal_builder'

describe LicitationProcessBidderProposalBuilder do

  let(:bidder) do
    double(:bidder,
      :id => 1,
      :items => [ item ],
      :proposals => [ ]
    )
  end

  let(:item) do
    double(:item,
      :licitation_process_bidder_proposals => [ ]
    )
  end

  let(:licitation_process_bidder_proposal) do
    double(:licitation_process_bidder_proposal)
  end

  it "should build proposals" do
    item.licitation_process_bidder_proposals.should_receive(:where).and_return( [ ] )
    bidder.proposals.should_receive(:build)
    LicitationProcessBidderProposalBuilder.new(bidder).build!
  end

  it "should not build proposals when already exists" do
    item.licitation_process_bidder_proposals.should_receive(:where).and_return( [ true ] )
    bidder.proposals.should_not_receive(:build)
    LicitationProcessBidderProposalBuilder.new(bidder).build!
  end
end
