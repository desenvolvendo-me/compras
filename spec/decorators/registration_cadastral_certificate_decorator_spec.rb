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
end
