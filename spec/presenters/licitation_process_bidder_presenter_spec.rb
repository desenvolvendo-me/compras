# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/licitation_process_bidder_presenter'

describe LicitationProcessBidderPresenter do
  subject do
    described_class.new(licitation_process_bidder, nil, helpers)
  end

  let :licitation_process_bidder do
    double :licitation_process_bidder
  end

  let :helpers do
    double :helpers
  end

  let :administrative_process do
    double :administrative_process
  end

  let :licitation_process do
    double(:licitation_process, 
      :administrative_process => administrative_process
    )
  end
end
