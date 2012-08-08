# encoding: utf-8
require 'decorator_helper'
require 'active_support/core_ext/array/grouping'
require 'app/decorators/administrative_process_decorator'

describe AdministrativeProcessDecorator do
  context '#value_estimated' do
    context 'when do not have value_estimated' do
      before do
        subject.stub(:value_estimated).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.value_estimated).to be_nil
      end
    end

    context 'when have value_estimated' do
      before do
        component.stub(:value_estimated).and_return(500)
      end

      it 'should applies currency' do
        expect(subject.value_estimated).to eq 'R$ 500,00'
      end
    end
  end

  context '#total_allocations_value' do
    context 'when do not have total_allocations_value' do
      before do
        component.stub(:total_allocations_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_allocations_value).to be_nil
      end
    end

    context 'when have total_allocations_value' do
      before do
        component.stub(:total_allocations_value).and_return(400)
      end

      it 'should applies precision' do
        expect(subject.total_allocations_value).to eq '400,00'
      end
    end
  end

  context '#date' do
    context 'when do not have date' do
      before do
        component.stub(:date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.date).to eq nil
      end
    end

    context 'when have date' do
      before do
        component.stub(:date).and_return(Date.new(2012, 12, 31))
      end

      it 'should localize' do
        expect(subject.date).to eq '31/12/2012'
      end
    end
  end

  context 'signatures' do
    context 'when do not have signatures' do
      before do
        component.stub(:signatures).and_return([])
      end

      it 'should return empty array' do
        expect(subject.signatures_grouped).to eq []
      end
    end

    context 'when have signatures' do
      before do
        component.stub(:signatures).and_return(signature_configuration_items)
      end

      let :signature_configuration_item1 do
        double('SignatureConfigurationItem1')
      end

      let :signature_configuration_item2 do
        double('SignatureConfigurationItem2')
      end

      let :signature_configuration_item3 do
        double('SignatureConfigurationItem3')
      end

      let :signature_configuration_item4 do
        double('SignatureConfigurationItem4')
      end

      let :signature_configuration_item5 do
        double('SignatureConfigurationItem5')
      end

      let :signature_configuration_items do
        [
          signature_configuration_item1,
          signature_configuration_item2,
          signature_configuration_item3,
          signature_configuration_item4,
          signature_configuration_item5
        ]
      end

      it "should group signatures" do
        expect(subject.signatures_grouped).to eq [
          [
            signature_configuration_item1,
            signature_configuration_item2,
            signature_configuration_item3,
            signature_configuration_item4
          ],
          [
            signature_configuration_item5
          ]
        ]
      end
    end
  end
end
