# encoding: utf-8
require 'spec_helper'

feature "PurchaseSolicitationLiberations" do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    sign_in
  end

  scenario 'create a new purchase_solicitation_liberation' do
    PurchaseSolicitation.make!(:reparo)
    Employee.make!(:wenderson)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    page.should have_select 'Status de atendimento', :selected => 'Pendente'

    # button liberate can be seen when purchase_solicitation is pending
    click_link 'Liberações'

    page.should have_content 'Liberações da Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'

    click_link 'Criar Liberação de Solicitação de Compra'

    page.should_not have_disabled_field 'Responsável'

    page.should have_content 'Criar Liberação para a Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'

    page.should have_field 'Data', :with => I18n.l(Date.current)
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'

    fill_modal 'Responsável', :field => 'Matrícula', :with => '12903412'
    fill_in 'Justificativa', :with => 'Compra justificada'

    select 'Liberada', :from => 'Status de atendimento'

    click_button 'Salvar'

    page.should have_notice 'Solicitação de Compras liberada com sucesso'

    click_link 'Voltar para a Solicitação de Compra'

    page.should have_select 'Status de atendimento', :selected => 'Liberada'

    click_link 'Liberações'

    page.should_not have_link 'Criar Liberação de Solicitação de Compra'

    within_records do
      page.find('a').click
    end

    page.should have_disabled_field 'Justificativa'
    page.should have_disabled_field 'Data'
    page.should have_disabled_field 'Responsável'
    page.should have_disabled_field 'Status de atendimento'

    page.should have_content 'Editar Liberação 1 da Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
    page.should have_field 'Justificativa', :with => 'Compra justificada'
    page.should have_field 'Data', :with =>  I18n.l(Date.current)
    page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
    page.should have_field 'Sequência', :with => '1'
  end
end
