#: encoding: utf-8
require 'spec_helper'

feature "BankAccounts" do
  background do
    sign_in
  end

  scenario 'create a new bank_account' do
    Agency.make!(:itau)

    click_link 'Cadastros Diversos'

    click_link 'Contas Bancárias / Convênios'

    click_link 'Criar Conta Bancária / Convênio'

    fill_in 'Nome', :with => 'IPTU'

    fill_modal 'Banco', :with => 'Itaú'

    within_modal 'Agência' do
      page.should have_field 'Banco', :with => 'Itaú'

      fill_in 'Nome', :with => 'Agência Itaú'
      click_button 'Pesquisar'

      click_record 'Agência Itaú'
    end

    fill_in 'Número da conta corrente', :with => '1111113'
    fill_in 'Código do cedente', :with => '00000000003'
    fill_in 'Número do contrato', :with => '000003-2011'

    click_button 'Salvar'

    page.should have_notice 'Conta Bancária / Convênio criado com sucesso.'

    click_link 'IPTU'

    page.should have_field 'Nome', :with => 'IPTU'
    page.should have_field 'Agência', :with => 'Agência Itaú'
    page.should have_field 'Número da conta corrente', :with => '1111113'
    page.should have_field 'Código do cedente', :with => '00000000003'
    page.should have_field 'Número do contrato', :with => '000003-2011'
  end

  scenario 'update an existent bank_account' do
    BankAccount.make!(:itau_tributos)

    click_link 'Cadastros Diversos'

    click_link 'Contas Bancárias / Convênios'

    click_link 'Itaú Tributos'

    fill_in 'Nome', :with => 'IPTU'

    fill_in 'Número da conta corrente', :with => '1111114'
    fill_in 'Código do cedente', :with => '00000000004'
    fill_in 'Número do contrato', :with => '000004-2011'

    click_button 'Salvar'

    page.should have_notice 'Conta Bancária / Convênio editado com sucesso.'

    click_link 'IPTU'

    page.should have_field 'Nome', :with => 'IPTU'
    page.should have_field 'Número da conta corrente', :with => '1111114'
    page.should have_field 'Código do cedente', :with => '00000000004'
    page.should have_field 'Número do contrato', :with => '000004-2011'
  end

  scenario 'destroy an existent bank_account' do
    BankAccount.make!(:itau_tributos)

    click_link 'Cadastros Diversos'

    click_link 'Contas Bancárias / Convênios'

    click_link 'Itaú Tributos'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Conta Bancária / Convênio apagado com sucesso.'

    page.should_not have_content 'Itaú Tributos'
  end
end
