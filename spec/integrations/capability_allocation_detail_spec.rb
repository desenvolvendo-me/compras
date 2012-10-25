# encoding: UTF-8
require 'spec_helper'

describe CapabilityAllocationDetail do
  context 'uniqueness validations' do
    before { CapabilityAllocationDetail.make!(:educacao) }

    it { should validate_uniqueness_of(:description) }
  end
end