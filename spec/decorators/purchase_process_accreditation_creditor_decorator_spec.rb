# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_process_accreditation_creditor_decorator'

describe PurchaseProcessAccreditationCreditorDecorator do
  describe '#creditor_representative' do
    context 'without creditor_representative' do
      before do
        component.stub(:creditor_representative => nil)
      end

      it 'should return "Não possui representante"' do
        expect(subject.creditor_representative).to eq 'Não possui representante'
      end
    end

    context 'with creditor_representative' do
      before do
        component.stub(:creditor_representative => 'creditor')
      end

      it 'should return creditor_representative' do
        expect(subject.creditor_representative).to eq 'creditor'
      end
    end
  end
end
