require 'model_helper'
require 'app/models/pledge_historic'

describe PledgeHistoric do
  it "should return the description as to_s method" do
    subject.description = "Historico"

    subject.to_s.should eq "Historico"
  end

  it { should belong_to :entity }

  it { should validate_presence_of :description }
  it { should validate_presence_of :entity_id }
end
