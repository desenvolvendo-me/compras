# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_lot'

describe LicitationProcessLot do
  it { should belong_to :licitation_process }

  it "should return the observations as to_s method" do
    subject.observations = "some observation"

    subject.to_s.should eq "some observation"
  end
end
