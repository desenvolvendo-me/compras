# encoding: utf-8
require 'model_helper'
require 'app/models/inscriptio_cursualis/street_type'
require 'app/models/inscriptio_cursualis/street'
require 'app/models/street_type'
require 'app/models/street'

describe StreetType do
  it 'return name when converted to string' do
    subject.name = 'Avenida'
    expect(subject.name).to eq subject.to_s
  end

  describe 'acronym' do
    it 'should be valid when size is equal to three' do
      subject.acronym = 'RUA'
      expect(subject).to be_invalid
      expect(subject.errors[:acronym]).to be_empty
    end

    it "should validates the mask" do
      subject.acronym = '123'
      expect(subject).to be_invalid
      expect(subject.errors[:acronym]).to include 'não é válido'
    end
  end

  it { should have_many :streets }

  it { should validate_presence_of :name }
  it { should ensure_length_of(:acronym).is_equal_to(3) }

end
