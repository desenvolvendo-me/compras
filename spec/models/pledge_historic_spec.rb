require 'model_helper'
require 'app/models/pledge_historic'

describe PledgeHistoric do
  it "should return the description as to_s method" do
    subject.description = "Historico"

    subject.to_s.should eq "Historico"
  end

  it { should belong_to :entity }
  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of :description }

  it "year and entity nulls permitted to Source::DEFAULT" do
    subject.source = Source::DEFAULT
    subject.description = 'Description test'
    subject.year = nil
    subject.entity = nil

    subject.should be_valid
    
    subject.errors.messages[:year].should be_nil
    subject.errors.messages[:entity].should be_nil
  end

  it "year and entity nulls not permitted to Source::MANUAL" do
    subject.source = Source::MANUAL
    subject.description = 'Description test'
    subject.year = nil
    subject.entity = nil

    subject.should_not be_valid
    
    subject.errors.messages[:year].should_not be_nil
    subject.errors.messages[:entity].should_not be_nil
  end
  
  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }
end
