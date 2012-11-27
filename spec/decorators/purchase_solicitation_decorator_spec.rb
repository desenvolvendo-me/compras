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
      expect(described_class.header_attributes).to include :budget_structure
      expect(described_class.header_attributes).to include :responsible
      expect(described_class.header_attributes).to include :service_status
    end
  end
end
