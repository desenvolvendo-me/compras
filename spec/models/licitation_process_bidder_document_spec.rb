# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_bidder_document'
require 'app/models/licitation_process_bidder'
require 'app/models/document_type'

describe LicitationProcessBidderDocument do
  it { should belong_to :licitation_process_bidder }
  it { should belong_to :document_type }

  it { should validate_presence_of :document_type }

  it { should_not allow_value(Date.tomorrow).for(:emission_date) }
  it { should allow_value(Date.current).for(:emission_date) }
  it { should allow_value(Date.yesterday).for(:emission_date) }
end
