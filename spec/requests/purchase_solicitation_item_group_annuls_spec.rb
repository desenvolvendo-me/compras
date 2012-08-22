#encoding: utf-8
require 'spec_helper'

feature 'PurchaseSolicitationAnnul' do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'should not have a annul link when was creating a new purchase_solicitation_item_group' do
    navigate 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    expect(page).not_to have_link 'Anular'
    expect(page).not_to have_link 'Anulação'
  end

  scenario 'should see the default values on the screen' do
    purchase_solicitation_item_group = PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate 'Compras e Licitações > Solicitações de Compra'

    click_link "#{purchase_solicitation_item_group}"

    click_link 'Anular'

    expect(page).to have_content "Anular Solicitação de Compra #{purchase_solicitation_item_group}"

    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_button 'Salvar'
    expect(page).not_to have_link 'Apagar'
  end


  scenario 'annul an existent purchase_solicitation_item_group' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link '1'

    click_link 'Anular', :confirm => true

    fill_modal 'Responsável', :field => 'Matrícula', :with => '958473'

    fill_in 'Data', :with => '21/08/2012'
    fill_in 'Justificativa', :with => 'Foo Bar'

    click_button 'Salvar'

    expect(page).to have_content 'Anulação de Recurso criado com sucesso.'

    expect(page).not_to have_button 'Salvar'
    expect(page).not_to have_link 'Anular'

    click_link 'Anulação'

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Data', :with => '21/08/2012'
    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Justificativa', :with => 'Foo Bar'
    expect(page).to have_disabled_field 'Justificativa'

    expect(page).not_to have_button 'Salvar'
    expect(page).not_to have_link 'Apagar'
    expect(page).to have_link 'Cancelar'
  end

  scenario 'does not show destroy button if not annullable' do
    PurchaseSolicitationItemGroup.make!(:antivirus,
                                        :administrative_processes => [
                                          AdministrativeProcess.make!(:compra_de_cadeiras)
                                        ])

    navigate 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link '1'

    expect(page).not_to have_button 'Anular'
  end
end
