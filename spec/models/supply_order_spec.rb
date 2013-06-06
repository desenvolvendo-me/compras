# encoding: utf-8
require 'model_helper'
require 'app/models/supply_order'

describe SupplyOrder do
  it { should belong_to :creditor }
  it { should belong_to :licitation_process }

  it { should validate_presence_of :authorization_date }
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :licitation_process }
end
