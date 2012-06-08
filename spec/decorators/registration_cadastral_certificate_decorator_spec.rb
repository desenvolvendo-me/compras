require 'decorator_helper'
require 'app/decorators/registration_cadastral_certificate_decorator'

describe RegistrationCadastralCertificateDecorator do
  it 'should not return number when count_crc greater than 0' do
    component.stub(:count_crc).and_return(0)

    subject.number.should == ''
  end

  it 'should return number when count_crc greater than 0' do
    component.stub(:count_crc).and_return(3)

    subject.number.should eq 3
  end
end
