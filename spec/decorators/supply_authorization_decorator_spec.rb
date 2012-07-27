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
      subject.direct_purchase.should eq '1/2012'
    end
  end

  context '#date' do
    context 'when have date' do
      before do
        component.stub(:date).and_return(nil)
      end

      it 'should be nil' do
        subject.date.should be_nil
      end
    end

    context 'when have date' do
      before do
        component.stub(:date).and_return(Date.new(2012, 12, 15))
      end

      it 'should localize' do
        subject.date.should eq '15/12/2012'
      end
    end
  end

  context '#message' do
    it 'show singular message' do
      subject.stub(:items_count).and_return(1)
      subject.message.should eq 'Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end

    it 'show pluralized message' do
      subject.stub(:items_count).and_return(2)
      subject.message.should eq 'Pedimos fornecer-nos os materiais e ou execução dos serviços abaixo discriminados, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
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

    it "should pluralize the period unit when period is greater than 1" do
      component.stub(:direct_purchase).and_return(true)
      component.stub(:period).and_return(2)
      component.stub(:period_unit).and_return('month')
      subject.pluralized_period_unit.should eq 'mês/meses'
    end

    it "should not pluralize the period unit when period is less than 2" do
      component.stub(:direct_purchase).and_return(true)
      component.stub(:period).and_return(1)
      component.stub(:period_unit).and_return('month')
      component.stub(:period_unit_humanize).and_return("mês")
      subject.pluralized_period_unit.should eq 'mês'
    end

    it "should not pluralize the period unit when period is nil" do
      component.stub(:direct_purchase).and_return(true)
      component.stub(:period).and_return(nil)
      subject.pluralized_period_unit.should be_nil
    end

    it "should not pluralize the period unit when direct_purchase is nill" do
      component.stub(:direct_purchase).and_return(nil)
      component.stub(:period).and_return(1)
      subject.pluralized_period_unit.should be_nil
    end
  end

  context 'signatures' do
    context 'when do not have signatures' do
      before do
        component.stub(:signatures).and_return([])
      end

      it 'should return empty array' do
        subject.signatures_grouped.should be_empty
      end
    end

    context 'when have signatures' do
      let :signature_configuration_item1 do
        double('SignatureConfigurationItem1')
      end

      let :signature_configuration_item2 do
        double('SignatureConfigurationItem2')
      end

      let :signature_configuration_item3 do
        double('SignatureConfigurationItem3')
      end

      let :signature_configuration_item4 do
        double('SignatureConfigurationItem4')
      end

      let :signature_configuration_item5 do
        double('SignatureConfigurationItem5')
      end

      let :signature_configuration_items do
        [
          signature_configuration_item1,
          signature_configuration_item2,
          signature_configuration_item3,
          signature_configuration_item4,
          signature_configuration_item5
        ]
      end

      let :signature_configuration_item_store do
        double('SignatureConfigurationItemStore')
      end

      let :signature_configuration_items_grouped do
        [
          [
            signature_configuration_item1,
            signature_configuration_item2,
            signature_configuration_item3,
            signature_configuration_item4
          ],
          [
            signature_configuration_item5
          ]
        ]
      end

      it "should group signatures" do
        subject.stub(:signatures_grouped).and_return(signature_configuration_items_grouped)
        subject.stub(:signatures).and_return(signature_configuration_items)
        subject.signatures_grouped.should eq [
          [
            signature_configuration_item1,
            signature_configuration_item2,
            signature_configuration_item3,
            signature_configuration_item4
          ],
          [
            signature_configuration_item5
          ]
        ]
      end
    end
  end
end
