# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_decorator'

describe PurchaseSolicitationDecorator do
  context '#summary' do
    before do
      subject.stub(:budget_structure).and_return('Secretaria de educação')
      subject.stub(:responsible).and_return('Nohup')
      subject.stub(:service_status_humanize).and_return('Pendente')
    end

    it 'should use budget_structure, responsible and status' do
      subject.summary.should eq "Estrutura orçamentaria solicitante: Secretaria de educação / Responsável pela solicitação: Nohup / Status: Pendente"
    end
  end

  context '#quantity_by_material' do
    before do
      component.stub(:quantity_by_material).with(material.id).and_return(400)
    end

    let :material do
      double :material, :id => 1
    end

    it 'should applies precision' do
      subject.quantity_by_material(material.id).should eq '400,00'
    end
  end
end
