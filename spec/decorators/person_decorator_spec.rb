# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/person_decorator'

describe PersonDecorator do
  context '#commercial_registration_date' do
    context 'when have commercial_registration_date' do
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
end
