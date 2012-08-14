# encoding: utf-8
require 'model_helper'
require 'app/models/capability_allocation_detail'

describe CapabilityAllocationDetail do
  it 'should return description as to_s' do
    subject.description = 'Educação'
    expect(subject.to_s).to eq 'Educação'
  end

  it { should validate_presence_of :description }
end
