require 'model_helper'
require 'app/models/management_unit'

describe ManagementUnit do
  it "should return the description as to_s method" do
    subject.description = "Central Unit"

    subject.to_s.should eq "Central Unit"
  end

  it { should validate_presence_of(:year) }
  it { should validate_presence_of(:entity) }

  it { should have_many(:pledges).dependent(:restrict) }
  it { should belong_to(:entity) }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }
end
