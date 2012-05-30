# encoding: utf-8
require 'model_helper'
require 'app/models/neighborhood'
require 'app/models/address'
require 'app/models/land_subdivision'

describe Neighborhood do
  it { should belong_to :city }
  it { should belong_to :district }
  it { should have_many :addresses }

  it { should validate_presence_of :name }
  it { should validate_presence_of :city }

  it 'delegate state to city' do
    city = mock('city', :state => 'Minas Gerais')
    subject.stub(:city).and_return(city)

    subject.state.should eq 'Minas Gerais'
  end

  it 'return name when converted to string' do
    subject.name = 'Centro'
    subject.name.should eq subject.to_s
  end

  context 'validations' do
    let :city do
      double(:name => "Belo Horizonte")
    end

    let :district do
      double(:name => "Sul", :city => city)
    end

    describe 'district_city' do
      it 'should validates when district selected belongs to selected city' do
        subject.stub(:city).and_return(city)
        subject.stub(:district).and_return(district)
        subject.stub_chain(:city, :districts, :exclude?).and_return(false)

        subject.valid?

        subject.errors.messages[:district].should be_nil
      end

      it 'should not validates when district selected not belongs to selected city' do
        district.stub(:city => nil)

        subject.stub(:city).and_return(double(:name => 'Curitiba'))
        subject.stub(:district).and_return(district)
        subject.stub_chain(:city, :districts, :exclude?).and_return(true)

        subject.valid?

        subject.errors.messages[:district].should include('não é válido')
      end
    end
  end
end
