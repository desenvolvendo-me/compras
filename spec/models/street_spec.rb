require 'model_helper'
require 'app/models/street'
require 'app/models/address'
require 'app/models/neighborhood'

describe Street do
  it 'return name when converted to string' do
    subject.name = 'Amazonas'
    subject.name.should eq subject.to_s
  end

  it { should belong_to :street_type }
  it { should have_many :addresses }
  it { should have_and_belong_to_many :neighborhoods }

  it { should validate_presence_of :name }
  it { should validate_presence_of :street_type }
  it { should validate_presence_of :neighborhoods }

end
