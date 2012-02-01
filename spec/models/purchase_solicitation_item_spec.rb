# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_item'

describe PurchaseSolicitationItem do
  it { should belong_to :purchase_solicitation }
  it { should belong_to :material }

  it { should validate_presence_of :material_id }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :unit_price }
  it { should validate_presence_of :estimated_total_price }
end
