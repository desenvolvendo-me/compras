# encoding: utf-8
require 'spec_helper'

feature "PrecatoryTypes" do
  background do
    sign_in
  end

  scenario 'create a new precatory_type' do
    click_link 'Contabilidade'

    click_link 'Tipos de Precatório'

    click_link 'Criar Tipos de Precatório'

    fill_in 'Descrição', :with => 'Precatórios Alimentares'
    select 'Ativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Tipos de Precatório criado com sucesso.'

    precatory_type = PrecatoryType.last

    within_records do
      click_link precatory_type.to_s
    end 

    page.should have_field 'Descrição', :with => 'Precatórios Alimentares'
    page.should have_select 'Status', :selected => 'Ativo'
    page.should have_disabled_field 'Data de desativação'
    page.should have_field 'Data de desativação', :with => ''
  end

  scenario 'update an existent precatory_type' do
    precatory_type = PrecatoryType.make!(:tipo_de_precatorio_ativo)

    click_link 'Contabilidade'

    click_link 'Tipos de Precatório'

    within_records do
      click_link precatory_type.to_s
    end

    fill_in 'Descrição', :with => 'De pequeno valor'
    select 'Inativo',  :from => 'Status'
    fill_mask 'Data de desativação', :with => '08/05/2012'

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
    precatory_type = PrecatoryType.make!(:tipo_de_precatorio_ativo)

    click_link 'Contabilidade'

    click_link 'Tipos de Precatório'

    within_records do
      click_link precatory_type.to_s
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Tipos de Precatório apagado com sucesso.'

    page.should_not have_content 'Precatórios Alimentares'
    page.should_not have_content 'Ativo'
  end

  scenario "disable deactivation_date when status is not inactive" do
    click_link 'Contabilidade'

    click_link 'Tipos de Precatório'

    click_link 'Criar Tipos de Precatório'

    select 'Ativo', :from => 'Status'

    page.should have_disabled_field 'Data de desativação'
  end

  scenario "enable deactivation_date when status is inactive" do
    click_link 'Contabilidade'

    click_link 'Tipos de Precatório'

    click_link 'Criar Tipos de Precatório'

    select 'Inativo', :from => 'Status'

    page.should_not have_disabled_field 'Data de desativação *'
  end
end
