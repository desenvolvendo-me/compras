require 'model_helper'
require 'app/models/pledge_category'
require 'app/models/pledge'

describe PledgeCategory do
  it "should return the description as to_s method" do
    subject.description = "Geral"

    subject.to_s.should eq "Geral"
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :status }

  it { should have_many(:pledges).dependent(:restrict) }
end
