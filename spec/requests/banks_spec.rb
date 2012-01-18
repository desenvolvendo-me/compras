# encoding: utf-8
require 'spec_helper'

feature "Banks" do
  background do
    sign_in
  end

  scenario 'create a new bank' do
    click_link 'Cadastros Diversos'

    click_link 'Bancos'

    click_link 'Criar Banco'

    fill_in 'Nome', :with => 'Banco do Brasil'
    fill_in 'Código', :with => '1'
    fill_in 'Sigla', :with => 'BB'

    click_button 'Criar Banco'

    page.should have_notice 'Banco criado com sucesso.'

    click_link 'Banco do Brasil'

    page.should have_field 'Nome', :with => 'Banco do Brasil'
    page.should have_field 'Código', :with => '1'
    page.should have_field 'Sigla', :with => 'BB'
  end

  scenario 'update an existent bank' do
    Bank.make!(:santander)

    click_link 'Cadastros Diversos'

    click_link 'Bancos'

    click_link 'Santander'

    fill_in 'Nome', :with => 'Banco Real'
    fill_in 'Código', :with => '123'
    fill_in 'Sigla', :with => 'BRE'

    click_button 'Atualizar Banco'

    page.should have_notice 'Banco editado com sucesso.'

    click_link 'Banco Real'

    page.should have_field 'Nome', :with => 'Banco Real'
    page.should have_field 'Código', :with => '123'
    page.should have_field 'Sigla', :with => 'BRE'
  end

  scenario 'destroy an existent bank' do
    Bank.make!(:itau)

    click_link 'Cadastros Diversos'

    click_link 'Bancos'

    click_link 'Itaú'

    click_link 'Apagar Itaú', :confirm => true

    page.should have_notice 'Banco apagado com sucesso.'

    page.should_not have_content 'Itaú'
  end
end
