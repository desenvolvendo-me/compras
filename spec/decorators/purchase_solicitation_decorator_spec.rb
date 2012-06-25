# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_decorator'

describe PurchaseSolicitationDecorator do
  it 'should return budget_structure, responsible and status on summary' do
    subject.stub(:budget_structure).and_return('Secretaria de educação')
    subject.stub(:responsible).and_return('Nohup')
    subject.stub(:service_status_humanize).and_return('Pendente')

    subject.summary.should eq "Estrutura orçamentaria solicitante: Secretaria de educação / Responsável pela solicitação: Nohup / Status: Pendente"
  end
end
