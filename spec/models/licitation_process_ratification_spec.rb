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
end
