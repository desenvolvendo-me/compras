# encoding: utf-8
require 'spec_helper'

feature "Capabilities" do
  background do
    sign_in
  end

  scenario 'create a new capability' do
    Entity.make!(:detran)

    click_link 'Contabilidade'

    click_link 'Recursos'

    click_link 'Criar Recurso'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_in 'Descrição', :with => 'Reforma e Ampliação'
    fill_in 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios'
    select 'Ordinário', :from => 'Tipo'
    select 'Ativo', :from => 'Status'

    click_button 'Criar Recurso'

    page.should have_notice 'Recurso criado com sucesso.'

    click_link 'Reforma e Ampliação'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Descrição', :with => 'Reforma e Ampliação'
    page.should have_field 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios'
    page.should have_select 'Tipo', :selected => 'Ordinário'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent capability' do
    Capability.make!(:reforma)
    Entity.make!(:secretaria_de_educacao)

    click_link 'Contabilidade'

    click_link 'Recursos'

    click_link 'Reforma e Ampliação'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Exercício', :with => '2013'
    fill_in 'Descrição', :with => 'Reforma e Ampliação do Posto'
    fill_in 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios no posto'
    select 'Vinculado', :from => 'Tipo'
    select 'Inativo', :from => 'Status'

    click_button 'Atualizar Recurso'

    page.should have_notice 'Recurso editado com sucesso.'

    click_link 'Reforma e Ampliação do Posto'

    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Exercício', :with => '2013'
    page.should have_field 'Descrição', :with => 'Reforma e Ampliação do Posto'
    page.should have_field 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios no posto'
    page.should have_select 'Tipo', :selected => 'Vinculado'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent capability' do
    Capability.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Recursos'

    click_link 'Reforma e Ampliação'

    click_link 'Apagar Reforma e Ampliação', :confirm => true

    page.should have_notice 'Recurso apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '2012'
    page.should_not have_content 'Reforma e Ampliação'
    page.should_not have_content 'Ordinário'
    page.should_not have_content 'Ativo'
  end
end
