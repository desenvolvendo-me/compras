# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_bidder_proposal_decorator'

describe LicitationProcessBidderProposalDecorator do

  it 'should return unit_price with precision' do
    component.stub(:unit_price).and_return(5000.0)
    helpers.stub(:number_to_currency).with(5000.0, {:format => "%n"}).and_return("5.000,00", {:format => "%n"} )

    subject.unit_price.should eq '5.000,00'
  end

  it 'should return total_price with precision' do
    component.stub(:total_price).and_return(5000.0)
    helpers.stub(:number_to_currency).with(5000.0, {:format => "%n"}).and_return("5.000,00", {:format => "%n"} )

    subject.total_price.should eq '5.000,00'
  end
end
