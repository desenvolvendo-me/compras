# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/supply_authorization_decorator'
require 'enumerate_it'
require 'app/enumerations/period_unit'

describe SupplyAuthorizationDecorator do
  let :direct_purchase do
    double(:id => 1, :year => 2012)
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  it 'should return formatted direct_purchase' do
    helpers.stub(:l).with(date).and_return('01/12/2012')
    subject.stub(:direct_purchase).and_return(direct_purchase)

    subject.direct_purchase.should eq '1/2012'
  end

  it 'should return localized direct_purchase date' do
    helpers.stub(:l).with(date).and_return('01/12/2012')
    component.stub(:date).and_return(date)

    subject.date.should eq '01/12/2012'
  end

  context '#message' do
    it 'show singular message' do
      subject.stub(:items_count => 1)
      subject.message.should eq 'Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end

    it 'show pluralized message' do
      subject.stub(:items_count => 2)
      subject.message.should eq 'Pedimos fornecer-nos os materiais e ou execução dos serviços abaixo discriminados, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end
  end

  it "should pluralize the period unit when period is greater than 1" do
    helpers.stub(:t).with("enumerations.period_unit_plural.month").and_return("meses")
    component.stub(:direct_purchase => direct_purchase)
    component.stub(:period => 2)
    component.stub(:period_unit => PeriodUnit::MONTH)
    subject.pluralized_period_unit.should eq 'meses'
  end

  it "should not pluralize the period unit when period is less than 2" do
    component.stub(:direct_purchase => direct_purchase)
    component.stub(:period => 1)
    component.stub(:period_unit => PeriodUnit::MONTH)
    component.stub(:period_unit_humanize).and_return("mês")
    subject.pluralized_period_unit.should eq 'mês'
  end
end
