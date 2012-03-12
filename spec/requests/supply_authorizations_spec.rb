# encoding: utf-8
require 'spec_helper'

feature "SupplyAuthorizations" do
  background do
    sign_in
  end

  scenario 'create a new supply_authorization' do
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    click_link 'Criar Autorização de Fornecimento'

    fill_in 'Exercício', :with => '2012'
    fill_modal 'Solicitação de compra direta', :with => '2012', :field => 'Ano'

    click_button 'Criar Autorização de Fornecimento'

    page.should have_notice 'Autorização de Fornecimento criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Código', :with => '1'
    page.should have_field 'Solicitação de compra direta', :with => "#{direct_purchase.id}"
  end

  scenario 'should use unauthorized as status to search direct_purchases' do
    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    click_link 'Criar Autorização de Fornecimento'

    within_modal 'Solicitação de compra direta' do
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Não autorizado'
    end
  end

  scenario 'should filter only by unauthorized' do
    SupplyAuthorization.make!(:compra_2012)
    DirectPurchase.make!(:compra_2011)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    click_link 'Criar Autorização de Fornecimento'

    within_modal 'Solicitação de compra direta' do
      click_button 'Pesquisar'

      page.should have_content '11/11/2011'
      page.should_not have_content '01/12/2012'
    end
  end

  scenario 'should show all fields as disabled' do
    SupplyAuthorization.make!(:compra_2012)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    within_records do
      page.find('a').click
    end

    page.should have_disabled_field 'Exercício'
    page.should have_disabled_field 'Código'
    page.should have_disabled_field 'Solicitação de compra direta'
  end

  scenario 'should not have destroy button when edit' do
    SupplyAuthorization.make!(:compra_2012)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Apagar'
  end
end
