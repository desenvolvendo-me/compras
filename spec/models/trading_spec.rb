require 'model_helper'
require 'app/models/trading'

describe Trading do

  subject do
    Trading.new(:code => 1, :year => 2012)
  end

  it { should belong_to :entity }
  it { should belong_to :licitating_unit }

  describe "#to_s" do

    it "returns the code and year of the trading formatted as 1/2012" do
      expect(subject.to_s).to eq "1/2012"
    end
  end
end
