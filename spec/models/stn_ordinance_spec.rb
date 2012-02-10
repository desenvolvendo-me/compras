require 'model_helper'
require 'app/models/stn_ordinance'

describe StnOrdinance do
  it "should return description as to_s method" do
    subject.description = "Portaria Geral"

    subject.to_s.should eq "Portaria Geral"
  end

  it { should validate_presence_of :description }
end
