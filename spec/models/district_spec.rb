require 'model_helper'
require 'app/models/district'
require 'app/models/neighborhood'
require 'app/models/land_subdivision'

describe District do
  it "return name on to_s" do
    subject.name = 'Centro'
    subject.name.should eq subject.to_s
  end

  it { should belong_to :city }
  it { should have_many(:neighborhoods).dependent(:restrict) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :city }
end
