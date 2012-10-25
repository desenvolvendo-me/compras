# encoding: UTF-8
require 'spec_helper'

describe RegulatoryActTypeClassification do
  context 'uniqueness validations' do
    before { RegulatoryActTypeClassification.make!(:primeiro_tipo) }

    it { should validate_uniqueness_of(:description) }
  end
end