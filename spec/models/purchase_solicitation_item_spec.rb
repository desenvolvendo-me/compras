# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_item'

describe PurchaseSolicitationItem do
  it { should belong_to :purchase_solicitation }
  it { should belong_to :material }

  it { should validate_presence_of :material_id }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }

  it "should calculate the estimated_total_price" do
    subject.estimated_total_price.should eq(0)

    subject.quantity = 10
    subject.unit_price = 50

    subject.estimated_total_price.should eq(500)
  end

  it "should have false as the default value of grouped" do
    subject.grouped.should eq false
  end
end
