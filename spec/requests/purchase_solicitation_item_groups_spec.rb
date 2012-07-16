# encoding: utf-8
require 'spec_helper'

feature "PurchaseSolicitationItemGroups" do
  background do
    sign_in
  end

  scenario 'create a new purchase_solicitation_item_group' do
    PurchaseSolicitation.make!(:reparo)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
    fill_modal 'Solicitação de compra', :with => '2012', :field => 'Ano'

    click_button 'Salvar'

    page.should have_notice 'Agrupamento de Item de Solicitação de Compra criado com sucesso.'

    click_link '01.01.00001 - Antivirus - 1'

    within '.records' do
      page.should have_content '1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
      page.should have_content '3'
    end
  end

  scenario 'update an existent purchase_solicitation_item_group' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link '01.01.00001 - Antivirus - 1'

    click_button 'Remover'

    fill_modal 'Solicitação de compra', :with => '2013', :field => 'Ano'

    click_button 'Salvar'

    page.should have_notice 'Agrupamento de Item de Solicitação de Compra editado com sucesso.'

    click_link '01.01.00001 - Antivirus - 1'

    within '.records' do
      page.should have_content '1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
      page.should have_content '99'
    end
  end

  scenario 'destroy an existent purchase_solicitation_item_group' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link '01.01.00001 - Antivirus - 1'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Agrupamento de Item de Solicitação de Compra apagado com sucesso.'

    page.should_not have_content 'Antivirus'
  end
end
