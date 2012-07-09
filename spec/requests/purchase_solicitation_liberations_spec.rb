# encoding: utf-8
require 'spec_helper'

feature "PurchaseSolicitationLiberations" do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    sign_in
  end

  scenario 'create a new purchase_solicitation_liberation' do
    PurchaseSolicitation.make!(:reparo)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    page.should have_select 'Status de atendimento', :selected => 'Pendente'

    # button liberate can be seen when purchase_solicitation is pending
    click_link 'Liberar'

    page.should have_content 'Liberar a Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
    page.should have_field 'Data', :with => I18n.l(Date.current)
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'

    fill_in 'Justificativa', :with => 'Compra justificada'

    click_button 'Salvar'

    page.should have_notice 'Solicitação de Compras liberada com sucesso'

    page.should have_select 'Status de atendimento', :selected => 'Liberada'

    click_link 'Liberação'

    page.should have_disabled_field 'Justificativa'
    page.should have_disabled_field 'Data'
    page.should have_disabled_field 'Responsável'

    page.should have_content 'Liberação da Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
    page.should have_field 'Justificativa', :with => 'Compra justificada'
    page.should have_field 'Data', :with =>  I18n.l(Date.current)
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
  end
end
