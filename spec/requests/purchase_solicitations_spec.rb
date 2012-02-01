# encoding: utf-8
require 'spec_helper'

feature "PurchaseSolicitations" do
  background do
    sign_in
  end

  scenario 'create a new purchase_solicitation' do
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    page.should have_disabled_field 'Liberação'
    page.should have_disabled_field 'Liberador'
    page.should have_disabled_field 'Observações do atendimento'
    page.should have_disabled_field 'Justificativa para não atendimento'
    page.should have_disabled_field 'Status de atendimento'

    fill_in 'Ano contábil', :with => '2012'
    fill_in 'Data da solicitação', :with => '01/02/2012'
    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
    fill_modal 'Dotação orçamentária', :with => 'Alocação', :field => 'Nome'
    fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Nome'
    select 'Bens', :from => 'Tipo de solicitação'
    fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

    click_button 'Criar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra criada com sucesso.'

    click_link 'Novas cadeiras'

    page.should have_field 'Ano contábil', :with => '2012'
    page.should have_field 'Data da solicitação', :with => '01/02/2012'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho', :field => 'Matrícula'
    page.should have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
    page.should have_field 'Dotação orçamentária', :with => 'Alocação', :field => 'Nome'
    page.should have_field 'Local para entrega', :selected => 'Secretaria da Educação', :field => 'Nome'
    page.should have_select 'Tipo de solicitação', :with => 'Bens'
    page.should have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

    # Testing the pending status applied automatically
    page.should have_select 'Status de atendimento', :selected => 'Pendente'
  end

  scenario 'update an existent purchase_solicitation' do
    make_dependencies!

    PurchaseSolicitation.make!(:reparo)
    Employee.make!(:wenderson)
    BudgetAllocation.make!(:alocacao_extra)
    DeliveryLocation.make!(:health)

    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Reparo nas instalações'

    fill_in 'Ano contábil', :with => '2013'
    fill_in 'Data da solicitação', :with => '01/02/2013'
    fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
    fill_in 'Justificativa da solicitação', :with => 'Novas mesas'
    fill_modal 'Dotação orçamentária', :with => 'Alocação extra', :field => 'Nome'
    fill_modal 'Local para entrega', :with => 'Secretaria da Saúde', :field => 'Nome'
    select 'Serviços', :from => 'Tipo de solicitação'
    fill_in 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'

    click_button 'Atualizar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra editada com sucesso.'

    click_link 'Novas mesas'

    page.should have_field 'Ano contábil', :with => '2013'
    page.should have_field 'Data da solicitação', :with => '01/02/2013'
    page.should have_field 'Responsável', :with => 'Wenderson Malheiros', :field => 'Matrícula'
    page.should have_field 'Justificativa da solicitação', :with => 'Novas mesas'
    page.should have_field 'Dotação orçamentária', :with => 'Alocação extra', :field => 'Nome'
    page.should have_field 'Local para entrega', :with => 'Secretaria da Saúde', :field => 'Nome'
    page.should have_select 'Tipo de solicitação', :selected => 'Serviços'
    page.should have_field 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
  end

  scenario 'destroy an existent purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo)
    click_link 'Cadastros Diversos'

    click_link 'Solicitações de Compra'

    click_link 'Reparo nas instalações'

    click_link 'Apagar Reparo nas instalações', :confirm => true

    page.should have_notice 'Solicitação de Compra apagada com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content '31/01/2012'
    page.should_not have_content 'Gabriel Sobrinho'
    page.should_not have_content 'Reparo nas instalações'
    page.should_not have_content 'Bens'
  end

  def make_dependencies!
    Employee.make!(:sobrinho)
    BudgetAllocation.make!(:alocacao)
    DeliveryLocation.make!(:education)
  end
end
