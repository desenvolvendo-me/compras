# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/supply_authorization_presenter'

describe SupplyAuthorizationPresenter do
  subject do
    described_class.new(supply_authorization, nil, helpers)
  end

  let :supply_authorization do
    double('SupplyAuthorization')
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:l).with(date).and_return('01/12/2012')
    end
  end

  it 'should return localized direct_purchase date' do
    supply_authorization.stub(:date).and_return(date)
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
end
