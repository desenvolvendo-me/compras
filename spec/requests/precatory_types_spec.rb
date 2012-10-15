# encoding: utf-8
require 'spec_helper'

feature "PrecatoryTypes" do
  background do
    sign_in
  end

  scenario 'create a new precatory_type' do
    navigate 'Cadastros Gerais > Precatório > Tipos de Precatório'

    click_link 'Criar Tipos de Precatório'

    fill_in 'Descrição', :with => 'Precatórios Alimentares'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipos de Precatório criado com sucesso.'

    within_records do
      click_link 'Precatórios Alimentares'
    end

    expect(page).to have_field 'Descrição', :with => 'Precatórios Alimentares'
    expect(page).to have_select 'Status', :selected => 'Ativo'
    expect(page).to have_disabled_field 'Data de desativação'
    expect(page).to have_field 'Data de desativação', :with => ''
  end

  scenario 'update an existent precatory_type' do
    PrecatoryType.make!(:tipo_de_precatorio_ativo)

    navigate 'Cadastros Gerais > Precatório > Tipos de Precatório'

    within_records do
      click_link 'Precatórios Alimentares'
    end

    fill_in 'Descrição', :with => 'De pequeno valor'
    select 'Inativo',  :from => 'Status'
    fill_in 'Data de desativação', :with => '08/05/2012'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipos de Precatório editado com sucesso.'

    within_records do
      click_link 'De pequeno valor'
    end

    expect(page).to have_field 'Descrição', :with => 'De pequeno valor'
    expect(page).to have_select 'Status', :selected => 'Inativo'
    expect(page).to have_field 'Data de desativação', :with => '08/05/2012'
  end

  scenario 'destroy an existent precatory_type' do
    PrecatoryType.make!(:tipo_de_precatorio_ativo)

    navigate 'Cadastros Gerais > Precatório > Tipos de Precatório'

    within_records do
      click_link 'Precatórios Alimentares'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Tipos de Precatório apagado com sucesso.'

    expect(page).to_not have_content 'Precatórios Alimentares'
    expect(page).to_not have_content 'Ativo'
  end

  scenario "disable deactivation_date when status is not inactive" do
    PrecatoryType.make!(:tipo_de_precatorio_ativo)

    navigate 'Cadastros Gerais > Precatório > Tipos de Precatório'

    within_records do
      click_link 'Precatórios Alimentares'
    end

    select 'Ativo', :from => 'Status'

    expect(page).to have_disabled_field 'Data de desativação'
  end

  scenario "enable deactivation_date when status is inactive" do
    PrecatoryType.make!(:tipo_de_precatorio_ativo)

    navigate 'Cadastros Gerais > Precatório > Tipos de Precatório'

    within_records do
      click_link 'Precatórios Alimentares'
    end

    select 'Inativo', :from => 'Status'

    expect(page).to_not have_disabled_field 'Data de desativação *'
  end
end
