require 'model_helper'
require 'app/models/bidder_disqualification'

describe BidderDisqualification do
  it { should validate_presence_of :bidder }
  it { should validate_presence_of :reason }

  it { should belong_to :bidder }
end
