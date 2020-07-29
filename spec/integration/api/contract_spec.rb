require 'spec_helper'

describe ContractProvider do
  let(:sobrinho) { Creditor.make!(:sobrinho) }

  let(:contract) do
    Contract.make!(:primeiro_contrato,
      consortium_agreement: true,
      creditor: sobrinho,
      licitation_process: licitation_process)
  end

  let(:licitation_process) do
    LicitationProcess.make!(:processo_licitatorio)
  end

  subject do
    ContractProvider.new(contract)
  end

  describe 'providing data' do
    it { should provide :id }
    it { should provide :to_s }
    it { should provide :budget_allocations }
    it { should provide :creditor }
    it { should provide :licitation_process_id }
    it { should provide :licitation_process_year }
    it { should provide :contract_number }
    it { should provide :signature_date }
    it { should provide :year }
  end

  describe '#budget_allocations' do
    it 'should return the ids of related budget allocations through licitation process' do
      expect(subject.budget_allocations).to eq licitation_process.budget_allocations_ids
    end
  end

  describe '#creditor' do
    it "should return the id of related creditor" do
      expect(subject.creditor).to eq sobrinho.id
    end
  end

  describe '#id' do
    it "should return the contract's id" do
      expect(subject.id).to eq contract.id
    end
  end

  describe '#licitation_process_id' do
    it "should return the licitatiion process's id" do
      expect(subject.licitation_process_id).to eq licitation_process.id
    end
  end

  describe '#licitation_process_year' do
    it "should return the licitatiion process's year" do
      expect(subject.licitation_process_year).to eq licitation_process.year
    end
  end

  describe '#to_s' do
    it "should return the contract's to_s" do
      expect(subject.to_s).to eq contract.to_s
    end
  end
end
