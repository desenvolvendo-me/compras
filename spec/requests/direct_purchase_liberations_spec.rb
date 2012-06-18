#encoding: utf-8
require 'spec_helper'

feature 'DirectPurchaseLiberations' do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'the liberation button should not be visible on new direct purchases' do
    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Gerar Compra Direta'

    page.should_not have_link 'Avaliações'
  end

  scenario 'viewing all liberations from a direct purchase' do
    liberation = DirectPurchaseLiberation.make!(:compra_liberada)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link "1/2012"

    click_link 'Avaliações'

    page.should have_content "Avaliações da Solicitação de Compra 1/2012"

    within_records do
      page.should have_content "#{liberation}"
    end
  end

  scenario 'creating a new liberation' do
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)
    Employee.make!(:wenderson)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link "2/2012"

    click_link 'Avaliações'

    click_link 'Criar Liberação de Compra Direta'

    page.should have_content 'Criar Avaliação para Solicitação de Compra 2/2012'

    fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
    page.should have_field 'Responsável', :with => 'Wenderson Malheiros'

    select 'Autorizado', :from => 'Avaliação'
    fill_in 'Justificativa', :with => 'Foo Bar'

    click_button 'Salvar'

    page.should have_content 'Liberação de Compra Direta criado com sucesso.'

    within_records do
      find('a').click
    end

    page.should have_disabled_field 'Responsável'
    page.should have_field 'Responsável', :with => 'Wenderson Malheiros'

    page.should have_disabled_field 'Avaliação'
    page.should have_select 'Avaliação', :selected => 'Autorizado'

    page.should have_disabled_field 'Justificativa'
    page.should have_field 'Justificativa', :with => 'Foo Bar'

    page.should_not have_button 'Salvar'

    #be sure that the direct purchase status has changed
    visit "/direct_purchases/#{direct_purchase.id}/edit"

    page.should have_select 'Status', :selected => 'Autorizado'
  end
end
