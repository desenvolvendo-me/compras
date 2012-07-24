require 'decorator_helper'
require 'app/decorators/registration_cadastral_certificate_decorator'

describe RegistrationCadastralCertificateDecorator do
  context '#number' do
    it 'should be empty when count_crc is 0' do
      component.stub(:count_crc).and_return(0)

      subject.number.should be_empty
    end

    it 'should return number when count_crc greater than 0' do
      component.stub(:count_crc).and_return(3)

      subject.number.should eq 3
    end
  end

  context 'signatures' do
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

    let :signature_configuration_items_grouped do
      [
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

    it "should group signatures" do
      subject.stub(:signatures_grouped).and_return(signature_configuration_items_grouped)
      subject.stub(:signatures => signature_configuration_items)
      subject.signatures_grouped.should eq [
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
