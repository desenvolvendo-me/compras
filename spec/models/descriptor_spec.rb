require 'model_helper'
require 'app/models/descriptor'

describe Descriptor do
  it 'should return year and entity as to_s' do
    subject.year = 2012
    subject.stub(:entity).and_return(double(:to_s => 'Detran'))
    subject.to_s.should eq '2012 - Detran'
  end

  it { should belong_to :entity }

  it { should validate_presence_of :year }
  it { should validate_presence_of :entity }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }
end
