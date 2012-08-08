require 'decorator_helper'
require 'active_support/core_ext/array/grouping'
require 'app/decorators/registration_cadastral_certificate_decorator'

describe RegistrationCadastralCertificateDecorator do
  context '#number' do
    context 'count_crc is empty' do
      before do
        component.stub(:count_crc).and_return(0)
      end

      it 'should be empty when count_crc is 0' do
        expect(subject.number).to be_empty
      end
    end

    context 'when do not have count_crc' do
      before do
        component.stub(:count_crc).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.number).to be_nil
      end
    end

    context 'when have count_crc' do
      before do
        component.stub(:count_crc).and_return(3)
      end

      it 'should return count_crc' do
        expect(subject.number).to eq 3
      end
    end
  end

  context 'signatures' do
    context 'when do not have signatures' do
      before do
        component.stub(:signatures).and_return([])
      end

      it 'should return empty array' do
        expect(subject.signatures_grouped).to be_empty
      end
    end

    context 'when have signatures' do
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

      let :signature_configuration_item_store do
        double('SignatureConfigurationItemStore')
      end

      before do
        component.stub(:signatures).and_return(signature_configuration_items)
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
