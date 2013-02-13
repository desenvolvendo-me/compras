#encoding: UTF-8
require 'model_helper'
require 'app/models/holiday'

describe Holiday do
  context "Validations" do
    it { should validate_presence_of :day }
    it { should validate_presence_of :month }
    it { should validate_presence_of :year }
    it { should validate_presence_of :name }

    it { should validate_numericality_of :month }
    it { should validate_numericality_of :day }

    it { should ensure_inclusion_of(:month).in_range(1..12) }
    it { should ensure_inclusion_of(:day).in_range(1..31) }

    it "should validate the date is valid" do
      subject.attributes = { :year => 2013, :month => 2, :day => 30 }
      expect(subject).to_not be_valid
      expect(subject.errors[:day]).to eq ["O mês informado não possui este dia"]
    end

    it "should user false as default value for recurrent" do
      expect(subject.recurrent).to be false
    end
  end

  describe "#to_s" do
    it "returns the holiday name" do
      subject.name = "Feriado"
      subject.to_s.should eql "Feriado"
    end
  end

  describe "#date" do
    it "returns a date object with the year, month and day attributes" do
      subject.attributes = { :year => 2013, :month => 2, :day => 15 }
      expect(subject.date).to eq Date.new(2013, 2, 15)
    end
  end

end
