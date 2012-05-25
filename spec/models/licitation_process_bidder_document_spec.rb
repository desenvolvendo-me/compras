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

  it "should not allow validity before emission_date" do
    subject.emission_date = Date.current

    subject.should_not allow_value(Date.yesterday).for(:validity)
  end

  it "should allow validity on or after emission_date" do
    subject.emission_date = Date.current

    subject.should allow_value(Date.current).for(:validity)
    subject.should allow_value(Date.tomorrow).for(:validity)
  end
end
