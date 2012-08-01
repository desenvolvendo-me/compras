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

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
    fill_modal 'Solicitação de compra', :with => '2012', :field => 'Ano'

    click_button 'Salvar'

    page.should have_notice 'Agrupamento de Item de Solicitação de Compra criado com sucesso.'

    click_link '1'

    page.should have_field 'Material', :with => '01.01.00001 - Antivirus'

    within '.records' do
      page.should have_content '1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
      page.should have_content '3'
    end
  end

  scenario 'update an existent purchase_solicitation_item_group' do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link '1'

    click_button 'Remover Material'

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'
    fill_modal 'Solicitação de compra', :with => '2013', :field => 'Ano'

    click_button 'Salvar'

    page.should have_notice 'Agrupamento de Item de Solicitação de Compra editado com sucesso.'

    click_link '1'

    page.should have_field 'Material', :with => '02.02.00001 - Arame farpado'

    within '.records' do
      page.should have_content '1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
      page.should have_content '99'
    end
  end

  scenario 'validating modal of purchase solicitation' do
    pending 'is not possible to simulate the event focus of a modal on nested.'
    PurchaseSolicitation.make!(:reparo)
    PurchaseSolicitation.make!(:reparo_2013)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

    page.execute_script 'purchaseSolicitationModalUrl();'

    within_modal 'Solicitação de compra' do

      click_button 'Pesquisar'

      page.should have_content '2012'

      page.should have_css 'table.records tbody tr', :count => 2

      fill_in 'Ano', :with => '2012'

      click_button 'Pesquisar'

      click_record '2012'
    end

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a purchase solicitation cannot be seletected twice
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      page.should have_content '2013'

      page.should have_css 'table.records tbody tr', :count => 1

      fill_in 'Ano', :with => '2013'

      click_button 'Pesquisar'

      click_record '2013'
    end

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a purchase solicitation cannot be seletected twice
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      page.should_not have_css 'table.records tbody tr'

      click_link 'Cancelar'
    end

    click_button 'Salvar'

    click_link '1'

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a purchase solicitation cannot be seletected twice
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      page.should_not have_css 'table.records tbody tr'

      click_link 'Cancelar'
    end

    within 'table.records' do
      click_button 'Remover'
    end

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a purchase solicitation removed can be seletected again
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      page.should have_content '2012'

      page.should have_css 'table.records tbody tr', :count => 1

      fill_in 'Ano', :with => '2012'

      click_button 'Pesquisar'

      click_record '2012'
    end

    within 'table.records' do
      click_button 'Remover'
      click_button 'Remover'
    end

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a removing all purchase solicitation, all can be seletect again
    within_modal 'Solicitação de compra' do

      click_button 'Pesquisar'

      page.should have_css 'table.records tbody tr', :count => 2
    end
  end

  scenario 'destroy an existent purchase_solicitation_item_group' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Agrupamentos de Itens de Solicitações de Compra'

    click_link '1'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Agrupamento de Item de Solicitação de Compra apagado com sucesso.'

    page.should_not have_content 'Antivirus'
  end
end
