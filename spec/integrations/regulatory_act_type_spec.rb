# encoding: UTF-8
require 'spec_helper'

describe RegulatoryActType do
  context 'uniqueness validations' do
    before { RegulatoryActType.make!(:lei) }

    it { should validate_uniqueness_of(:description) }
  end
end