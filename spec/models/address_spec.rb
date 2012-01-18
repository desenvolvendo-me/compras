# encoding: utf-8
require 'model_helper'
require 'app/models/address'

describe Address do
  it { should validate_numericality_of :number }

  it 'cast to string using street, number and neighborhood' do
    subject.should_receive(:street).and_return(mock('street', :to_s => 'Amazonas'))
    subject.should_receive(:neighborhood).and_return(mock('neighborhood', :to_s => 'Centro'))
    subject.should_receive(:number).and_return(13140)

    subject.to_s.should eq 'Amazonas, 13140 - Centro'
  end

  it { should belong_to :neighborhood }
  it { should belong_to :street }
  it { should belong_to :district }
  it { should belong_to :land_subdivision }
  it { should belong_to :condominium }
  it { should belong_to :addressable }

  it { should validate_presence_of :neighborhood }
  it { should validate_presence_of :zip_code }
  it { should validate_presence_of :street }
  it { should validate_numericality_of :number }

end
