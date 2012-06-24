require 'model_helper'
require 'app/models/management_unit'
require 'app/models/pledge'

describe ManagementUnit do
  it "should return the description as to_s method" do
    subject.description = "Central Unit"

    subject.to_s.should eq "Central Unit"
  end

  it { should validate_presence_of(:descriptor) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:acronym) }
  it { should validate_presence_of(:status) }

  it { should belong_to(:descriptor) }

  it { should have_many(:pledges).dependent(:restrict) }
end
