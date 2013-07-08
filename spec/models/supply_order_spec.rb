# encoding: utf-8
require 'model_helper'
require 'app/models/supply_order'
require 'app/models/supply_order_item'

describe SupplyOrder do
  it { should belong_to :creditor }
  it { should belong_to :licitation_process }
  it { should belong_to :pledge }

  it { should have_many(:items).class_name('SupplyOrderItem').dependent(:destroy) }

  it { should validate_presence_of :authorization_date }
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :licitation_process }
end
