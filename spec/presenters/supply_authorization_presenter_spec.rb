# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/supply_authorization_presenter'

describe SupplyAuthorizationPresenter do
  context '#message' do
    it 'show singular message' do
      subject = described_class.new(double(:items_count => 1))
      subject.message.should eq 'Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end

    it 'show pluralized message' do
      subject = described_class.new(double(:items_count => 2))
      subject.message.should eq 'Pedimos fornecer-nos os materiais e ou execução dos serviços abaixo discriminados, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end
  end
end
