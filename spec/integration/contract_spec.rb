require 'spec_helper'

describe Contract do
  context 'scope' do
    it 'return all contracts exepect when licitation_process is removal_by_limit' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      direct_purchase = LicitationProcess.make!(:compra_direta,
        type_of_removal: TypeOfRemoval::REMOVAL_BY_LIMIT)

      contract_one = Contract.make!(:primeiro_contrato, licitation_process: licitation_process)

      contract_two = Contract.make!(:primeiro_contrato, licitation_process: direct_purchase)

      expect(Contract.except_type_of_removal(TypeOfRemoval::REMOVAL_BY_LIMIT)).to include(contract_one)
      expect(Contract.except_type_of_removal(TypeOfRemoval::REMOVAL_BY_LIMIT)).to_not include(contract_two)
    end
  end
end
