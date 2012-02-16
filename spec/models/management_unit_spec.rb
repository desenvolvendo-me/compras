require 'model_helper'
require 'app/models/management_unit'

describe ManagementUnit do
  it "should return the description as to_s method" do
    subject.description = "Central Unit"

    subject.to_s.should eq "Central Unit"
  end
end
