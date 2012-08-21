# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/licitation_process_bidder_proposal'

describe AdministrativeProcessBudgetAllocationItem do
  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }

  it { should belong_to :administrative_process_budget_allocation }
  it { should belong_to :material }
  it { should belong_to :licitation_process_lot }
  it { should have_many :licitation_process_bidder_proposals }

  it { should have_many :licitation_process_bidder_proposals }

  context 'with material' do
    let :material do
      double(:material)
    end

    it 'should return materiali.to_s as to_s' do
      subject.stub(:material).and_return(material)

      material.stub(:to_s).and_return('Cadeira')

      expect(subject.to_s).to eq 'Cadeira'
    end
  end

  it 'should calculate the estimated total price' do
    expect(subject.estimated_total_price).to eq 0

    subject.quantity = 5
    subject.unit_price = 10.1

    expect(subject.estimated_total_price).to eq 50.5
  end

  it "should without_lot? be true when has not lot" do
    described_class.stub(:without_lot?).and_return(true)
    described_class.should be_without_lot
  end

  it "should without_lot? be false when has not lot" do
    described_class.stub(:without_lot?).and_return(false)
    described_class.should_not be_without_lot
  end

  context 'unit price and total value in a licitation_process' do
    let :bidder do
      double('LicitationProcessBidder', :proposals => [proposal])
    end

    let :proposal do
      double('LicitationProcessProposal', :id => 1, :administrative_process_budget_allocation_item => subject, :unit_price => 10)
    end

    it 'should return unit price by bidder' do
      expect(subject.unit_price_by_bidder(bidder)).to eq 10
    end

    it 'should return total value by bidder' do
      subject.quantity = 4
      expect(subject.total_value_by_bidder(bidder)).to eq 40
    end

    it 'should return zero when unit price equals nil' do
      proposal.stub(:unit_price => nil)
      subject.quantity = 3

      expect(subject.total_value_by_bidder(bidder)).to eq 0
    end
  end
end
