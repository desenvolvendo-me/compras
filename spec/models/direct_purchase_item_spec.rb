# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase_item'
require 'app/models/direct_purchase'
require 'app/models/material'

describe DirectPurchaseItem do
  it { should belong_to :material }
  it { should belong_to :direct_purchase }

  it "should calculate the estimated_total_price" do
    subject.estimated_total_price.should eq(0)

    subject.quantity = 10
    subject.unit_price = 50

    subject.estimated_total_price.should eq(500)
  end
end
