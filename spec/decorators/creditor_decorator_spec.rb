# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/creditor_decorator'

describe CreditorDecorator do
  context '#commercial_registration_date' do
    context 'when do not have commercial_registration_date' do
      before do
        component.stub(:commercial_registration_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.commercial_registration_date).to be_nil
      end
    end

    context 'when have commercial_registration_date' do
      before do
        component.stub(:commercial_registration_date).and_return(Date.new(2012, 12, 14))
      end

      it 'should localize' do
        expect(subject.commercial_registration_date).to eq '14/12/2012'
      end
    end
  end

  context '#cant_have_crc_message' do
    it 'when is individual' do
      I18n.backend.store_translations 'pt-BR', :creditor => {
        :messages => {
          :cant_have_crc => 'não pode'
        }
      }

      component.stub(:company?).and_return(false)

      expect(subject.cant_have_crc_message).to eq 'não pode'
    end

    it 'when is company' do
      component.stub(:company?).and_return(true)

      expect(subject.cant_have_crc_message).to be_nil
    end
  end
end
