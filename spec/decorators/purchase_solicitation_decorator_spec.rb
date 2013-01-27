# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_decorator'

describe PurchaseSolicitationDecorator do
  context '#quantity_by_material' do
    before do
      component.stub(:quantity_by_material).with(material.id).and_return(400)
    end

    let :material do
      double :material, :id => 1
    end

    it 'should applies precision' do
      expect(subject.quantity_by_material(material.id)).to eq '400,00'
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have budget_structure, creditor and status' do
      expect(described_class.header_attributes).to include :code_and_year
      expect(described_class.header_attributes).to include :budget_structure
      expect(described_class.header_attributes).to include :responsible
      expect(described_class.header_attributes).to include :service_status
    end
  end

  context '#not_editable_message' do
    it 'when is not editable' do
      I18n.backend.store_translations 'pt-BR', :purchase_solicitation => {
          :messages => {
            :not_editable => 'não pode'
        }
      }

      component.stub(:editable? => false)

      expect(subject.not_editable_message).to eq 'não pode'
    end

    it 'when is editable' do
      component.stub(:editable? => true)

      expect(subject.not_editable_message).to be_nil
    end
  end

  context '#is_annulled_message' do
    it 'when is annulled' do
      I18n.backend.store_translations 'pt-BR', :purchase_solicitation => {
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

  context '#not_persisted_message' do
    it 'when is not persisted' do
      I18n.backend.store_translations 'pt-BR', :purchase_solicitation => {
          :messages => {
            :not_persisted => 'salve a solicitação primeiro'
        }
      }

      component.stub(:persisted? => false)

      expect(subject.not_persisted_message).to eq 'salve a solicitação primeiro'
    end

    it 'when is not annulled' do
      component.stub(:persisted? => true)

      expect(subject.not_persisted_message).to be_nil
    end
  end

  describe '#code_and_year' do
    it "should return code_and_year" do
      component.stub(:code => 1, :accounting_year => 2013)

      expect(subject.code_and_year).to eq '1/2013'
    end
  end
end
