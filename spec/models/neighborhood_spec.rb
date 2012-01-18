require 'model_helper'
require 'app/models/neighborhood'
require 'app/models/address'
require 'app/models/land_subdivision'

describe Neighborhood do
  it 'delegate state to city' do
    city = mock('city', :state => 'Minas Gerais')
    subject.should_receive(:city).and_return(city)

    subject.state.should eq 'Minas Gerais'
  end

  it 'return name when converted to string' do
    subject.name = 'Centro'
    subject.name.should eq subject.to_s
  end

  it { should have_and_belong_to_many :streets }
  it { should belong_to :city }
  it { should have_many :addresses }

  it { should validate_presence_of :name }
  it { should validate_presence_of :city }

end
