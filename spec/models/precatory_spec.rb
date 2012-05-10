require 'model_helper'
require 'app/models/precatory'
require 'app/models/provider'
require 'app/models/precatory_type'

describe Precatory do
  it { should validate_presence_of :number }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :date }
  it { should validate_presence_of :judgment_date }
  it { should validate_presence_of :apresentation_date }
  it { should validate_presence_of :precatory_type }
  it { should validate_presence_of :historic }

  it { should belong_to :provider }
  it { should belong_to :precatory_type }

  it "should return id when call to_s method" do
    subject.id = 1

    subject.to_s.should eq "1"
  end
end
