# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_decorator'

describe PriceCollectionDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have budget_structure, creditor and status' do
      expect(described_class.header_attributes).to include :status
      expect(described_class.header_attributes).to include :code_and_year
    end
  end

  describe '#is_annulled_message' do
    it 'when is annulled' do
      I18n.backend.store_translations 'pt-BR', :price_collection => {
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

  describe '#proposals_not_allowed_message' do
    let(:creditors) { double(:creditors) }

    before do
      component.stub(:creditors).and_return(creditors)
    end

    context 'with creditors' do
      it 'should return nil' do
        creditors.stub(:empty?).and_return(false)

        expect(subject.proposals_not_allowed_message).to be_nil
      end
    end

    context 'without creditors' do
      it 'should return message' do
        I18n.backend.store_translations 'pt-BR', :price_collection => {
          :messages => {
            :proposals_not_allowed => 'sem creditor'
          }
        }

        creditors.stub(:empty?).and_return(true)

        expect(subject.proposals_not_allowed_message).to eq 'sem creditor'
      end
    end
  end
end
