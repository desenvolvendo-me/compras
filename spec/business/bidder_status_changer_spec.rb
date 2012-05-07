require 'unit_helper'
require 'enumerate_it'
require 'active_support/core_ext/module/delegation'
require 'app/business/bidder_status_changer'
require 'app/enumerations/licitation_process_bidder_status'

describe BidderStatusChanger do
  subject do
    described_class.new(licitation_process, LicitationProcessBidderStatus)
  end

  before do
    subject.stub(:enabled_status).and_return(true)
    subject.stub(:disabled_status).and_return(false)
  end

  let :licitation_process do
    double('licitation_process', :licitation_process_bidders => bidders)
  end

  let :bidder do
    double('bidder')
  end

  let :bidders do
    [bidder]
  end

  context 'when the bidder has not filled documents' do
    before do
      bidder.stub(:filled_documents?).and_return(false)
    end

    it 'should be disabled' do
      bidder.should_receive("status=").with(false)

      subject.change
    end
  end

  context 'when the bidder has filled documents' do
    before do
      bidder.stub(:filled_documents?).and_return(true)
    end

    it 'should be enabled' do
      bidder.should_receive("status=").with(true)

      subject.change
    end
  end
end
