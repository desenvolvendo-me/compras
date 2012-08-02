#encoding: utf-8
require 'spec_helper'

feature 'PurchaseSolicitationAnnul' do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'should not have a annul link when was creating a new solicitation' do
    navigate 'Compras e Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    page.should_not have_link 'Anular'
    page.should_not have_link 'Anulação'
  end

  scenario 'should see the default values on the screen' do
    solicitation = PurchaseSolicitation.make!(:reparo)

    navigate 'Compras e Licitações > Solicitações de Compra'

    click_link "#{solicitation}"

    click_link 'Anular'

    page.should have_content "Anular Solicitação de Compra #{solicitation}"

    page.should have_field 'Data', :with => I18n.l(Date.current)
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'

    page.should have_button 'Salvar'
    page.should_not have_link 'Apagar'
  end

  scenario 'annuling a purchase solicitation' do
    solicitation = PurchaseSolicitation.make!(:reparo)

    navigate 'Compras e Licitações > Solicitações de Compra'

    click_link "#{solicitation}"

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'

      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Data', :with => '10/06/2012'
    fill_in 'Justificativa', :with => 'Foo Bar'

    click_button 'Salvar'

    page.should have_content 'Anulação de Recurso criado com sucesso.'

    page.should have_content "Editar #{solicitation}"
    page.should have_select 'Status de atendimento', :selected => 'Anulada'

    within_tab 'Principal' do
      page.should have_disabled_field 'Ano'
      page.should have_disabled_field 'Data da solicitação'
      page.should have_disabled_field 'Estrutura orçamentaria solicitante'
      page.should have_disabled_field 'Responsável pela solicitação'
      page.should have_disabled_field 'Justificativa da solicitação'
      page.should have_disabled_field 'Local para entrega'
      page.should have_disabled_field 'Tipo de solicitação'
      page.should have_disabled_field 'Observações gerais'
      page.should have_disabled_field 'Status de atendimento'
      page.should have_disabled_field 'Liberação'
      page.should have_disabled_field 'Por'
      page.should have_disabled_field 'Observações do atendimento'
      page.should have_disabled_field 'Justificativa para não atendimento'
    end

    within_tab 'Dotações orçamentarias' do
      page.should have_disabled_field 'Valor total dos itens'

      page.should_not have_button 'Adicionar Dotação'

      page.should have_disabled_field 'Dotação'
      page.should have_disabled_field 'Natureza da despesa'

      page.should_not have_button 'Adicionar Item'

      page.should have_disabled_field 'Item'
      page.should have_disabled_field 'Material'
      page.should have_disabled_field 'Marca/Referência'
      page.should have_disabled_field 'Unidade'
      page.should have_disabled_field 'Quantidade'
      page.should have_disabled_field 'Valor unitário'
      page.should have_disabled_field 'Valor total'

      page.should_not have_button 'Remover Item'
      page.should_not have_button 'Remover Dotação'
    end

    page.should_not have_button 'Salvar'

    click_link 'Anulação'

    page.should have_disabled_field 'Responsável'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'

    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => '10/06/2012'

    page.should have_disabled_field 'Justificativa'
    page.should have_field 'Justificativa', :with => 'Foo Bar'

    page.should_not have_button 'Salvar'
    page.should_not have_link 'Apagar'
  end
end
