# encoding: utf-8
require 'spec_helper'

feature "PrecatoryTypes" do
  background do
    sign_in
  end

  scenario 'create a new precatory_type' do
    navigate_through 'Contabilidade > Comum > Precatório > Tipos de Precatório'

    click_link 'Criar Tipos de Precatório'

    fill_in 'Descrição', :with => 'Precatórios Alimentares'
    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    page.should have_notice 'Tipos de Precatório criado com sucesso.'

    within_records do
      click_link 'Precatórios Alimentares'
    end 

    page.should have_field 'Descrição', :with => 'Precatórios Alimentares'
    page.should have_select 'Status', :selected => 'Ativo'
    page.should have_disabled_field 'Data de desativação'
    page.should have_field 'Data de desativação', :with => ''
  end

  scenario 'update an existent precatory_type' do
    PrecatoryType.make!(:tipo_de_precatorio_ativo)

    navigate_through 'Contabilidade > Comum > Precatório > Tipos de Precatório'

    within_records do
      click_link 'Precatórios Alimentares'
    end

    fill_in 'Descrição', :with => 'De pequeno valor'
    select 'Inativo',  :from => 'Status'
    fill_in 'Data de desativação', :with => '08/05/2012'

    click_button 'Salvar'

    page.should have_notice 'Tipos de Precatório editado com sucesso.'

    within_records do
      click_link 'De pequeno valor'
    end

    page.should have_field 'Descrição', :with => 'De pequeno valor'
    page.should have_select 'Status', :selected => 'Inativo'
    page.should have_field 'Data de desativação', :with => '08/05/2012'
  end

  scenario 'destroy an existent precatory_type' do
    PrecatoryType.make!(:tipo_de_precatorio_ativo)

    navigate_through 'Contabilidade > Comum > Precatório > Tipos de Precatório'

    within_records do
      click_link 'Precatórios Alimentares'
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Tipos de Precatório apagado com sucesso.'

    page.should_not have_content 'Precatórios Alimentares'
    page.should_not have_content 'Ativo'
  end

  scenario "disable deactivation_date when status is not inactive" do
    navigate_through 'Contabilidade > Comum > Precatório > Tipos de Precatório'

    click_link 'Criar Tipos de Precatório'

    select 'Ativo', :from => 'Status'

    page.should have_disabled_field 'Data de desativação'
  end

  scenario "enable deactivation_date when status is inactive" do
    navigate_through 'Contabilidade > Comum > Precatório > Tipos de Precatório'

    click_link 'Criar Tipos de Precatório'

    select 'Inativo', :from => 'Status'

    page.should_not have_disabled_field 'Data de desativação *'
  end
end
