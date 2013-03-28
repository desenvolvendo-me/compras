# encoding: utf-8
require 'decorator_helper'
require 'enumerate_it'
require 'app/enumerations/material_type'
require 'app/decorators/purchase_solicitation_item_decorator'

describe PurchaseSolicitationItemDecorator do
  context '#estimated_total_price' do
    context 'when do not have estimated_total_price' do
      before do
        component.stub(:estimated_total_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.estimated_total_price).to be_nil
      end
    end

    context 'when have estimated_total_price' do
      before do
        component.stub(:estimated_total_price).and_return(300.0)
      end

      it 'should applies precision' do
        expect(subject.estimated_total_price).to eq '300,00'
      end
    end
  end

  context '#material_label' do
    it 'returns "Serviço" if solicitation is for purchase of services' do
      component.stub(:services? => true)

      expect(subject.material_label).to eq 'Serviço'
    end

    it 'returns "Material" if solicitation is for purchase of products or goods' do
      component.stub(:services? => false)

      expect(subject.material_label).to eq 'Material'
    end
  end

  context '#material_type_filter' do
    it 'returns "service" if solicitation is for purchase of services' do
      component.stub(:services? => true)

      expect(subject.material_type_filter).to eq MaterialType::SERVICE
    end

    it 'returns nil if solicitation is for purchase of products or goods' do
      component.stub(:services? => false)

      expect(subject.material_type_filter).to be_nil
    end
  end
end
