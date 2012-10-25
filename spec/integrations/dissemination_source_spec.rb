# encoding: UTF-8
require 'spec_helper'

describe DisseminationSource do
  context 'uniqueness validations' do
    before { DisseminationSource.make!(:jornal_municipal) }

    it { should validate_uniqueness_of(:description) }
  end
end