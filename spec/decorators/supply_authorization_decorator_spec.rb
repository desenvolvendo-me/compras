# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/supply_authorization_decorator'

describe SupplyAuthorizationDecorator do
  context '#direct_purchase' do
    before do
      component.stub(:direct_purchase_id).and_return(1)
      component.stub(:direct_purchase_year).and_return(2012)
    end

    it 'should return id/year' do
      expect(subject.direct_purchase).to eq '1/2012'
    end
  end

  context '#date' do
    context 'when have date' do
      before do
        component.stub(:date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.date).to be_nil
      end
    end

    context 'when have date' do
      before do
        component.stub(:date).and_return(Date.new(2012, 12, 15))
      end

      it 'should localize' do
        expect(subject.date).to eq '15/12/2012'
      end
    end
  end

  context '#message' do
    it 'show singular message' do
      subject.stub(:items_count).and_return(1)
      expect(subject.message).to eq 'Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end

    it 'show pluralized message' do
      subject.stub(:items_count).and_return(2)
      expect(subject.message).to eq 'Pedimos fornecer-nos os materiais e ou execução dos serviços abaixo discriminados, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end
  end

  context '#pluralized_period_unit' do
    before do
      I18n.backend.store_translations 'pt-BR', :enumerations => {
          :period_unit => {
            :month => 'mês/meses'
        }
      }
    end

    it "should pluralize the delivery term period when delivery term is greater than 1" do
      component.stub(:direct_purchase).and_return(true)
      component.stub(:delivery_term).and_return(2)
      component.stub(:delivery_term_period).and_return('month')
      expect(subject.pluralized_delivery_term_period).to eq 'mês/meses'
    end

    it "should not pluralize the delivery term period when delivery term is less than 2" do
      component.stub(:direct_purchase).and_return(true)
      component.stub(:delivery_term).and_return(1)
      component.stub(:delivery_term_period).and_return('month')
      component.stub(:delivery_term_period_humanize).and_return("mês")
      expect(subject.pluralized_delivery_term_period).to eq 'mês'
    end

    it "should not pluralize the delivery term period when delivery term is nil" do
      component.stub(:direct_purchase).and_return(true)
      component.stub(:delivery_term).and_return(nil)
      expect(subject.pluralized_delivery_term_period).to be_nil
    end

    it "should not pluralize the delivery term period when direct_purchase is nill" do
      component.stub(:direct_purchase).and_return(nil)
      component.stub(:delivery_term).and_return(1)
      expect(subject.pluralized_delivery_term_period).to be_nil
    end
  end

  context '#status' do
    before do
      I18n.backend.store_translations 'pt-BR', :enumerations => {
          :status => {
            :active => 'Ativo',
            :inactive => 'Inativo'
        }
      }
    end

    it 'should translate the status when active' do
      component.stub(:status).and_return('active')

      expect(subject.status).to eq 'Ativo'
    end

    it 'should translate the status when inactive' do
      component.stub(:status).and_return('inactive')

      expect(subject.status).to eq 'Inativo'
    end
  end
end
