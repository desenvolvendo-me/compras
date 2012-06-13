# encoding: utf-8
require 'model_helper'
require 'app/models/unico/street_type'
require 'app/models/unico/street'
require 'app/models/street_type'
require 'app/models/street'

describe StreetType do
  it 'return name when converted to string' do
    subject.name = 'Avenida'
    subject.name.should eq subject.to_s
  end

  describe 'acronym' do
    it 'should be valid when size is equal to three' do
      subject.acronym = 'RUA'
      subject.should be_invalid
      subject.errors[:acronym].should be_empty
    end

    it "should validates the mask" do
      subject.acronym = '123'
      subject.should be_invalid
      subject.errors[:acronym].should include 'não é válido'
    end
  end

  it { should have_many :streets }

  it { should validate_presence_of :name }
  it { should ensure_length_of(:acronym).is_equal_to(3) }

end
