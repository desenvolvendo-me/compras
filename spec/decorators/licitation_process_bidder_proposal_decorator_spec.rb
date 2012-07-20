# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_bidder_proposal_decorator'

describe LicitationProcessBidderProposalDecorator do
  context '#unit_price' do
    before do
      component.stub(:unit_price).and_return(5000.0)
    end

    it 'should applies precision' do
      subject.unit_price.should eq '5.000,00'
    end
  end

  context '#total_price' do
    before do
      component.stub(:total_price).and_return(5000.0)
    end

    it 'should applies precision' do
      subject.total_price.should eq '5.000,00'
    end
  end
end
