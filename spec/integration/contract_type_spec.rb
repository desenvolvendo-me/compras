# encoding: UTF-8
require 'spec_helper'

describe ContractType do
  context 'uniqueness validation' do
    before { ContractType.make!(:trainees) }

    it { should validate_uniqueness_of(:description) }
  end
end
