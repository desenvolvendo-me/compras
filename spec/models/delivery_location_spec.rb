require 'model_helper'
require 'app/models/delivery_location'

describe DeliveryLocation do
  context "#to_s" do
    it "should return name" do
      subject.name = "Secretaria"
      subject.to_s.should eq("Secretaria")
    end
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
  end

  context "associations" do
    it { should belong_to :address }
  end
end
