require 'spec_helper'

describe ContractProvider do
  let(:sobrinho) { Creditor.make!(:sobrinho) }
  let(:wenderson) { Creditor.make!(:wenderson_sa) }

  let(:contract) do
    Contract.make!(:primeiro_contrato,
      consortium_agreement: true,
      creditors: [sobrinho, wenderson])
  end

  subject do
    ContractProvider.new(contract)
  end

  describe 'providing data' do
    it { should provide :id }
    it { should provide :to_s }
    it { should provide :creditors }
    it { should provide :contract_number }
    it { should provide :signature_date }
  end

  describe '#creditors' do
    it 'should return the ids of related creditors' do
      expect(subject.creditors).to eq [sobrinho.id, wenderson.id]
    end
  end

  describe '#id' do
    it "should return the contract's id" do
      expect(subject.id).to eq contract.id
    end
  end

  describe '#to_s' do
    it "should return the contract's to_s" do
      expect(subject.to_s).to eq contract.to_s
    end
  end
end
