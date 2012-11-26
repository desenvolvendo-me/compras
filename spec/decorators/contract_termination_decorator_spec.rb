# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/contract_termination_decorator'

describe ContractTerminationDecorator do
  describe '#is_annulled_message' do
    it 'when is annulled' do
      I18n.backend.store_translations 'pt-BR', :contract_termination => {
          :messages => {
            :is_annulled => 'não pode'
        }
      }

      component.stub(:annulled? => true)

      expect(subject.is_annulled_message).to eq 'não pode'
    end

    it 'when is not annulled' do
      component.stub(:annulled? => false)

      expect(subject.is_annulled_message).to be_nil
    end
  end

    context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have budget_structure, creditor and status' do
      expect(described_class.header_attributes).to include :status
    end
  end
end
