# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_bidder_proposal'
require 'app/enumerations/situation_of_proposal'

describe LicitationProcessBidderProposal do

  it { should belong_to :licitation_process_bidder }
  it { should belong_to :administrative_process_budget_allocation_item }
  it { should belong_to :licitation_process_ratification }
  it { should have_one(:licitation_process_lot).through(:administrative_process_budget_allocation_item) }

  it "should return total price when has unit_price and quantity" do
    subject.unit_price = 3
    subject.stub(:quantity).and_return(14)
    subject.total_price.should eq 42
  end

  it "should return 0 when unit_price is 0" do
    subject.unit_price = 0
    subject.stub(:quantity).and_return(14)
    subject.total_price.should eq 0
  end

  it "should return 0 when has not quantity" do
    subject.unit_price = 3
    subject.stub(:quantity).and_return(nil)
    subject.total_price.should eq 0
  end

  it 'uses false as default for ratification' do
    subject.ratificated.should be false
  end

  it 'situation should be by default undefined' do
    subject.should_receive(:situation=).with(SituationOfProposal::UNDEFINED)
    subject.send(:initialize)
  end
end
