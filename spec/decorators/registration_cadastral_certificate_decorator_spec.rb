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
end
