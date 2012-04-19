require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/invited_bidder_status_changer'

describe InvitedBidderStatusChanger do
  subject do
    described_class.new(licitation_process)
  end

  before do
    subject.stub(:enabled_status).and_return(true)
    subject.stub(:disabled_status).and_return(false)
  end

  let :licitation_process do
    double('licitation_process', :licitation_process_invited_bidders => invited_bidders)
  end

  let :invited_bidder do
    double('invited_bidder')
  end

  let :invited_bidders do
    [invited_bidder]
  end

  context 'when the invited bidder has not filled documents' do
    before do
      invited_bidder.stub(:filled_documents?).and_return(false)
    end

    it 'should be disabled' do
      invited_bidder.should_receive("status=").with(false)

      subject.change
    end
  end

  context 'when the invited bidder has filled documents' do
    before do
      invited_bidder.stub(:filled_documents?).and_return(true)
    end

    it 'should be enabled' do
      invited_bidder.should_receive("status=").with(true)

      subject.change
    end
  end
end
