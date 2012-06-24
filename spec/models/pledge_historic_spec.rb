require 'model_helper'
require 'app/models/pledge_historic'
require 'app/models/pledge'

describe PledgeHistoric do
  it "should return the description as to_s method" do
    subject.description = "Historico"

    subject.to_s.should eq "Historico"
  end

  it { should belong_to :descriptor }

  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :description }

  it 'should validate descriptor presence if source is manual' do
    subject.source = Source::MANUAL
    subject.should validate_presence_of(:descriptor)
  end

  it 'should not validate descriptor presence if source is default' do
    subject.source = Source::DEFAULT
    subject.should_not validate_presence_of(:descriptor)
  end
end
