# encoding: UTF-8
require 'spec_helper'

describe ContractTermination do
  context 'uniqueness validations' do
    before { ContractTermination.make!(:contrato_rescindido) }

    it { should validate_uniqueness_of(:contract_id) }
  end
end
