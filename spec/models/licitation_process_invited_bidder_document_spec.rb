# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_invited_bidder_document'
require 'app/models/licitation_process_invited_bidder'
require 'app/models/document_type'

describe LicitationProcessInvitedBidderDocument do
  it { should belong_to :licitation_process_invited_bidder }
  it { should belong_to :document_type }

  it { should validate_presence_of :document_type }
end
