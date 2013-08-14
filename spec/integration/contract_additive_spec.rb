require 'spec_helper'

describe ContractAdditive do
  context "scopes" do
    it 'return additives by contract id' do
      contract_one = Contract.make!(:primeiro_contrato)
      contract_two = Contract.make!(:contrato_detran)

      additive_one = ContractAdditive.make!(:aditivo, contract: contract_one)
      additive_two = ContractAdditive.make!(:aditivo, number: "667", contract: contract_one)
      additive_three = ContractAdditive.make!(:aditivo, number: "668", contract: contract_two)

      expect(ContractAdditive.by_contract_id(contract_one.id)).to include(additive_one, additive_two)
      expect(ContractAdditive.by_contract_id(contract_one.id)).to_not include(additive_three)
    end
  end
end
