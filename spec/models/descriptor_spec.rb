require 'model_helper'
require 'app/parsers/month_and_year_parser'
require 'app/models/descriptor'

describe Descriptor do
  it 'should return year and entity as to_s' do
    subject.period = Date.new(2012, 10, 1)
    subject.stub(:entity).and_return(double(:to_s => 'Detran'))
    expect(subject.to_s).to eq '2012 - Detran'
  end

  it { should belong_to :entity }

  describe '#year' do
    it 'should be 2012' do
      subject.stub(:period).and_return(Date.new(2012, 01, 02))

      expect(subject.year).to eq 2012
    end

    it 'should be nil' do
      subject.stub(:period).and_return(nil)

      expect(subject.year).to eq nil
    end
  end

  describe '#month' do
    it 'should be 1' do
      subject.stub(:period).and_return(Date.new(2012, 01, 02))

      expect(subject.month).to eq 1
    end

    it 'should be nil' do
      subject.stub(:period).and_return(nil)

      expect(subject.month).to eq nil
    end
  end
end
