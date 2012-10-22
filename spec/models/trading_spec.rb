#encoding: utf-8
require 'model_helper'
require 'app/models/trading'

describe Trading do

  subject do
    Trading.new(:code => 1, :year => 2012)
  end

  it { should belong_to :entity }
  it { should belong_to :licitation_commission }
  it { should belong_to :licitation_process }
  it { should belong_to :licitating_unit }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :year }

  describe "#to_s" do

    it "returns the code and year of the trading formatted as 1/2012" do
      expect(subject.to_s).to eq "1/2012"
    end
  end

  describe "validations" do
    it "validates if the licitation modality is of 'trading' type" do
      licitation_process = double(:presence_trading? => false)
      subject.stub(:licitation_process => licitation_process)

      subject.valid?

      expect(subject.errors[:licitation_process]).to include "deve ser do tipo Pregão presencial"
    end
  end
end
