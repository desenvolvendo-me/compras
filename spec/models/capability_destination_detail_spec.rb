# encoding: utf-8
require 'model_helper'
require 'app/models/capability_destination_detail'

describe CapabilityDestinationDetail do
  it { should belong_to :capability_allocation_detail }
  it { should belong_to :capability_destination }

  it { should validate_presence_of :status }
  it { should validate_presence_of :capability_allocation_detail }
end
