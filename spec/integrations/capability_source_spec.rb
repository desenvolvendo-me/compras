# encoding: UTF-8
require 'spec_helper'

describe CapabilitySource do
  context 'uniqueness validations' do
    before { CapabilitySource.make!(:imposto) }

    it { should validate_uniqueness_of(:code) }
  end
end