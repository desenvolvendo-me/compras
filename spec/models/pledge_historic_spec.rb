require 'model_helper'
require 'app/models/pledge_historic'
require 'app/models/pledge'

describe PledgeHistoric do
  it "should return the description as to_s method" do
    subject.description = "Historico"

    subject.to_s.should eq "Historico"
  end

  it { should belong_to :entity }
  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of :description }

  it "should validate presence of year and entity dependent of source" do
    subject.source = Source::MANUAL
    
    subject.should validate_presence_of(:year)
    subject.should validate_presence_of(:entity)
    
    subject.source = Source::DEFAULT

    subject.should_not validate_presence_of(:year)
    subject.should_not validate_presence_of(:entity)
  end
  
  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }
end
