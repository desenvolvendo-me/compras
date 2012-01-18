require 'model_helper'
require 'app/models/land_subdivision'
require 'app/models/address'

describe LandSubdivision do
  it 'return name when converted to string' do
    subject.name = 'Terra Boa'
    subject.name.should eq subject.to_s
  end

  it { should have_many :addresses }

  it { should validate_presence_of :name }
end
