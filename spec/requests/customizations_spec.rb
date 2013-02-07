# encoding: utf-8
require 'spec_helper'

feature "Customizations" do
  background do
    sign_in
  end

  scenario 'create and update a customization' do
    Prefecture.make! :belo_horizonte
    State.make! :pr
    Creditor.make! :nohup

    navigate 'Geral > Parâmetros > Customizações'

    click_link 'Criar Customização'

    select 'Credor', :from => 'Tabela'
    fill_modal 'Estado', :with => 'Paraná'

    click_link 'Adicionar Dado da Customização'

    fill_in 'Dado', :with => 'Objeto social do credor'

    select 'Texto simples', :from => 'Tipo do dado'

    click_button 'Salvar'

    expect(page).to have_notice 'Customização criado com sucesso.'

    within_records do
      click_link 'Paraná - Credor'
    end

    expect(page).to have_select 'Tabela', :selected => 'Credor'
    expect(page).to have_field 'Estado', :with => 'Paraná'

    expect(page).to have_field 'Dado', :with => 'Objeto social do credor'
    expect(page).to have_select 'Tipo do dado', :selected => 'Texto simples'

    navigate 'Comum > Pessoas > Credores'

    click_link 'Nohup'

    within_tab 'Principal' do
      fill_in 'Objeto social do credor', :with => 'Conteúdo do objeto social do credor'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credor editado com sucesso.'

    click_link 'Nohup'

    expect(page).to have_field 'Objeto social do credor', :with => 'Conteúdo do objeto social do credor'

    # update an existent customization'

    navigate 'Geral > Parâmetros > Customizações'

    click_link 'Paraná - Credor'

    fill_in 'Dado', :with => 'Número do Registro CVM'

    click_button 'Salvar'

    expect(page).to have_notice 'Customização editado com sucesso.'

    click_link 'Paraná - Credor'

    expect(page).to have_select 'Tipo do dado', :selected => 'Texto simples'

    navigate 'Comum > Pessoas > Credores'

    click_link 'Nohup'

    within_tab 'Principal' do
      # assert that changing field name on customization, the name field is
      # changed on creditor with the same value.
      expect(page).to have_field 'Número do Registro CVM', :with => 'Conteúdo do objeto social do credor'
    end
  end

  scenario 'destroy an existent customization' do
    Prefecture.make! :belo_horizonte
    Customization.make! :campo_string

    navigate 'Geral > Parâmetros > Customizações'

    click_link 'Minas Gerais - Credor'

    click_link 'Apagar'

    expect(page).to have_notice 'Customização apagado com sucesso.'

    expect(page).to_not have_content 'Minas Gerais - Credor'
  end
end
