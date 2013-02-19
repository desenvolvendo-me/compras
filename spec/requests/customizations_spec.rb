# encoding: utf-8
# https://semaphoreapp.com/projects/288/branches/831/builds/1281
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
    select 'Paraná', :from => 'Estado'

    # Add a simple string field
    click_link 'Adicionar Dado da Customização'

    fill_in 'Dado', :with => 'Objeto social do credor'

    select 'Texto simples', :from => 'Tipo do dado'

    # Add a select field
    click_link 'Adicionar Dado da Customização'

    fill_in 'Dado', :with => 'Lista de opções'

    select 'Lista de opções', :from => 'Tipo do dado'

    fill_in 'Opções', :with => 'Opção 1, Opção 2, Opção 3'

    click_button 'Salvar'

    expect(page).to have_notice 'Customização criado com sucesso.'

    within_records do
      click_link 'Paraná'
    end

    expect(page).to have_select 'Tabela', :selected => 'Credor'
    expect(page).to have_select 'Estado', :selected => 'Paraná'

    expect(page).to have_field 'Dado', :with => 'Objeto social do credor'
    expect(page).to have_select 'Tipo do dado', :selected => 'Texto simples'

    expect(page).to have_field 'Dado', :with => 'Lista de opções'
    expect(page).to have_select 'Tipo do dado', :selected => 'Lista de opções'
    expect(page).to have_field 'Opções', :with => 'Opção 1, Opção 2, Opção 3'

    navigate 'Comum > Pessoas > Credores'

    click_link 'Nohup'

    within_tab 'Principal' do
      fill_in 'Objeto social do credor', :with => 'Conteúdo do objeto social do credor'
      select 'Opção 1', :on => 'Lista de opções'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credor editado com sucesso.'

    click_link 'Nohup'

    expect(page).to have_field 'Objeto social do credor', :with => 'Conteúdo do objeto social do credor'
    expect(page).to have_select 'Lista de opções', :with => 'Opção 1'

    # update an existent customization'

    navigate 'Geral > Parâmetros > Customizações'

    click_link 'Paraná'

    fill_in 'Dado', :with => 'Número do Registro CVM'

    click_button 'Salvar'

    expect(page).to have_notice 'Customização editado com sucesso.'

    click_link 'Paraná'

    expect(page).to have_select 'Tipo do dado', :selected => 'Texto simples'

    navigate 'Comum > Pessoas > Credores'

    click_link 'Nohup'

    within_tab 'Principal' do
      # assert that changing field name on customization, the name field is
      # changed on creditor with the same value.
      expect(page).to have_field 'Número do Registro CVM', :with => 'Conteúdo do objeto social do credor'
    end
  end

  scenario 'customization for licitation_commission' do
    Prefecture.make!(:belo_horizonte)
    State.make!(:pr)
    LicitationCommission.make!(:comissao)

    navigate 'Geral > Parâmetros > Customizações'

    click_link 'Criar Customização'

    select 'Comissão de Licitação', :from => 'Tabela'
    select 'Paraná', :from => 'Estado'

    click_link 'Adicionar Dado da Customização'

    fill_in 'Dado', :with => 'Campo novo'

    select 'Texto simples', :from => 'Tipo do dado'

    click_button 'Salvar'

    expect(page).to have_notice 'Customização criado com sucesso.'


    navigate 'Processo Administrativo/Licitatório > Auxiliar > Comissões de Licitação'

    within_records do
      click_link 'descricao da comissao'
    end

    within_tab 'Principal' do
      fill_in 'Campo novo', :with => 'Conteúdo do campo novo'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Comissão de Licitação editada com sucesso.'

    within_records do
      click_link 'descricao da comissao'
    end

    expect(page).to have_field 'Campo novo', :with => 'Conteúdo do campo novo'
  end

  scenario 'customization for regulatory_act_type' do
    Prefecture.make!(:belo_horizonte)
    State.make!(:pr)
    RegulatoryActType.make!(:lei)

    navigate 'Geral > Parâmetros > Customizações'

    click_link 'Criar Customização'

    select 'Tipo de Ato Regulamentador', :from => 'Tabela'
    select 'Paraná', :from => 'Estado'

    click_link 'Adicionar Dado da Customização'

    fill_in 'Dado', :with => 'Lista de opções'

    select 'Lista de opções', :from => 'Tipo do dado'

    fill_in 'Opções', :with => 'Opção 1, Opção 2, Opção 3'

    click_button 'Salvar'

    expect(page).to have_notice 'Customização criado com sucesso.'

    navigate 'Comum > Legislação > Ato Regulamentador > Tipos de Ato Regulamentador'

    within_records do
      click_link 'Lei'
    end

    select 'Opção 2', :on => 'Lista de opções'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Ato Regulamentador editado com sucesso.'

    within_records do
        click_link 'Lei'
    end

    expect(page).to have_select 'Lista de opções', :selected => 'Opção 2'
  end


  scenario 'destroy an existent customization' do
    Prefecture.make! :belo_horizonte
    Customization.make! :campo_string

    navigate 'Geral > Parâmetros > Customizações'

    click_link 'Minas Gerais'

    click_link 'Apagar'

    expect(page).to have_notice 'Customização apagado com sucesso.'

    expect(page).to_not have_content 'Minas Gerais - Credor'
  end
end
