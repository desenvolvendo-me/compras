require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/bidder_status_changer'

describe BidderStatusChanger do
  subject do
    described_class.new(licitation_process, status)
  end

  let :licitation_process do
    double('licitation_process', :bidders => bidders)
  end

  let :status do
    double("Status")
  end

  let :bidder do
    double('bidder')
  end

  let :bidders do
    [bidder]
  end

  context 'when the bidder has not filled documents' do
    it 'should be inactive' do
      bidder.stub(:filled_documents?).and_return(false)

      status.should_receive(:value_for).with(:INACTIVE).and_return(false)
      bidder.should_receive("status=").with(false)

      subject.change
    end
  end

  context 'when the bidder has filled documents' do
    it 'should be active' do
      bidder.stub(:filled_documents?).and_return(true)

      status.should_receive(:value_for).with(:ACTIVE).and_return(true)

      bidder.should_receive("status=").with(true)

      subject.change
    end
  end
end
