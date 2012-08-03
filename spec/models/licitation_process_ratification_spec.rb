# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_ratification'
require 'app/models/licitation_process_bidder_proposal'

describe LicitationProcessRatification do
  it 'should return sequence as to_s' do
    subject.stub(:sequence => 1)
    subject.to_s.should eq '1'
  end

  it { should belong_to :licitation_process }
  it { should belong_to :licitation_process_bidder }

  it { should have_many(:licitation_process_bidder_proposals).dependent(:restrict).order(:id) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :ratification_date }
  it { should validate_presence_of :adjudication_date }
  it { should validate_presence_of :licitation_process_bidder }

  context 'bidder should belongs to licitation process' do
    let :bidder_with_licitation_process do
      double(:licitation_process => licitation_process)
    end

    let :bidder_with_new_licitation_process do
      double(:licitation_process => double)
    end

    let :licitation_process do
      double(:to_s => '1/2012')
    end

    before do
      subject.stub(:licitation_process => licitation_process)
    end

    it 'should be valid' do
      subject.stub(:licitation_process_bidder => bidder_with_licitation_process)

      subject.valid?

      subject.errors[:licitation_process_bidder].should be_empty
    end

    it 'should be invalid' do
      subject.stub(:licitation_process_bidder => bidder_with_new_licitation_process)

      subject.valid?

      subject.errors[:licitation_process_bidder].should include "deve pertencer ao processo licitatório 1/2012"
    end
  end
end
