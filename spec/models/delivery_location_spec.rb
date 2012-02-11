require 'model_helper'
require 'app/models/delivery_location'
require 'app/models/purchase_solicitation'

describe DeliveryLocation do
  context "#to_s" do
    it "should return description" do
      subject.description = "Secretaria"
      subject.to_s.should eq("Secretaria")
    end
  end

  context "validations" do
    it { should validate_presence_of :description }
    it { should validate_presence_of :address }
  end

  context "associations" do
    it { should belong_to :address }
    it { should have_many(:purchase_solicitations).dependent(:restrict) }
  end
end
