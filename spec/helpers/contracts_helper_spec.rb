require 'spec_helper'

describe ContractsHelper do
  let(:resource) { double(:resource, :id => 5)}

  before do
    helper.stub(:resource).and_return(resource)
  end

  describe '#contract_termination_path' do
    context 'when had no contract termination' do
      before do
        resource.stub(:allow_termination?).and_return(true)
      end

      it 'should returns the new contract termination' do
        expect(helper.contract_termination_path).to eq '/contract_terminations/new?contract_id=5'
      end
    end

    context 'when had a contract termination' do
      let(:contract_termination) { double(:contract_termination, :to_param => '3')}

      before do
        resource.stub(:allow_termination?).and_return(false)
        resource.stub(:contract_termination).and_return(contract_termination)
      end

      it 'should returns the edit contract termination' do
        expect(helper.contract_termination_path).to eq '/contract_terminations/3/edit?contract_id=5'
      end
    end
  end
end
