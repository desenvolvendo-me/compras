# encoding: utf-8
require 'spec_helper'

feature "Banks" do
  background do
    sign_in
  end

  scenario 'create a new bank' do
    navigate 'Comum > Bancos > Bancos'

    click_link 'Criar Banco'

    fill_in 'Nome', :with => 'Banco do Brasil'
    fill_in 'Código', :with => '1'
    fill_in 'Sigla', :with => 'BB'

    click_button 'Salvar'

    expect(page).to have_notice 'Banco criado com sucesso.'

    click_link 'Banco do Brasil'

    expect(page).to have_field 'Nome', :with => 'Banco do Brasil'
    expect(page).to have_field 'Código', :with => '1'
    expect(page).to have_field 'Sigla', :with => 'BB'
  end

  scenario 'update an existent bank' do
    Bank.make!(:santander)

    navigate 'Comum > Bancos > Bancos'

    click_link 'Santander'

    fill_in 'Nome', :with => 'Banco Real'
    fill_in 'Código', :with => '123'
    fill_in 'Sigla', :with => 'BRE'

    click_button 'Salvar'

    expect(page).to have_notice 'Banco editado com sucesso.'

    click_link 'Banco Real'

    expect(page).to have_field 'Nome', :with => 'Banco Real'
    expect(page).to have_field 'Código', :with => '123'
    expect(page).to have_field 'Sigla', :with => 'BRE'
  end

  scenario 'destroy an existent bank' do
    Bank.make!(:itau)

    navigate 'Comum > Bancos > Bancos'

    click_link 'Itaú'

    click_link 'Apagar'

    expect(page).to have_notice 'Banco apagado com sucesso.'

    expect(page).to_not have_content 'Itaú'
  end
end
