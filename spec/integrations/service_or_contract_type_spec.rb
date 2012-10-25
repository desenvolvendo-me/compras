# encoding: UTF-8
require 'spec_helper'

describe ServiceOrContractType do
  context 'uniqueness validation' do
    before { ServiceOrContractType.make!(:trainees) }

    it { should validate_uniqueness_of(:description) }
  end
end
