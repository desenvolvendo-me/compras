# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/contract_decorator'

describe ContractDecorator do
  it 'should return formatted total pledges value as currency' do
    component.stub(:pledges_total_value => 100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.pledges_total_value.should eq 'R$ 100,00'
  end

  describe '#modality' do
    context 'given a licitation process' do
      before do
        component.stub_chain(:licitation_process, :present?).and_return true
        component.stub(:modality).and_return 'xpto'
      end

      it 'should translate the enumeration' do
        helpers.should_receive(:t).with('enumerations.administrative_process_modality.xpto')

        subject.modality
      end
    end

    context 'given no licitation process' do
      before do
        component.stub_chain(:licitation_process, :present?).and_return false
        component.stub(:modality).and_return 'xpto'
      end

      it 'should translate the enumeration' do
        helpers.should_receive(:t).with('enumerations.direct_purchase_modality.xpto')

        subject.modality
      end
    end
  end
end
