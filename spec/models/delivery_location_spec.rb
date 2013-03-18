require 'model_helper'
require 'app/models/delivery_location'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation'
require 'app/models/direct_purchase'
require 'app/models/price_registration'
require 'app/models/price_collection'

describe DeliveryLocation do
  context "#to_s" do
    it "should return description" do
      subject.description = "Secretaria"
      expect(subject.to_s).to eq("Secretaria")
    end
  end

  context "validations" do
    it { should validate_presence_of :description }
    it { should validate_presence_of :address }
  end

  context "associations" do
    it { should belong_to :address }
    it { should have_many(:purchase_solicitations).dependent(:restrict) }
    it { should have_many(:direct_purchases).dependent(:restrict) }
    it { should have_many(:price_collections).dependent(:restrict) }
    it { should have_many(:price_registrations).dependent(:restrict) }
  end
end
