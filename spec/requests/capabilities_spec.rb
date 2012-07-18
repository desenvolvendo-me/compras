# encoding: utf-8
require 'spec_helper'

feature "Capabilities" do
  background do
    sign_in
  end

  scenario 'create a new capability' do
    Descriptor.make!(:detran_2012)

    navigate_through 'Contabilidade > Orçamento > Recursos'

    click_link 'Criar Recurso'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Reforma e Ampliação'
    fill_in 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios'
    select 'Ordinário', :from => 'Tipo'

    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    page.should have_notice 'Recurso criado com sucesso.'

    click_link 'Reforma e Ampliação'

    page.should have_field 'Descritor', :with => '2012 - Detran'
    page.should have_field 'Descrição', :with => 'Reforma e Ampliação'
    page.should have_field 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios'
    page.should have_select 'Tipo', :selected => 'Ordinário'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent capability' do
    Capability.make!(:reforma)
    Descriptor.make!(:secretaria_de_educacao_2013)

    navigate_through 'Contabilidade > Orçamento > Recursos'

    click_link 'Reforma e Ampliação'

    fill_modal 'Descritor', :with => '2013', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Reforma e Ampliação do Posto'
    fill_in 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios no posto'
    select 'Vinculado', :from => 'Tipo'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Recurso editado com sucesso.'

    click_link 'Reforma e Ampliação do Posto'

    page.should have_field 'Descritor', :with => '2013 - Secretaria de Educação'
    page.should have_field 'Descrição', :with => 'Reforma e Ampliação do Posto'
    page.should have_field 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios no posto'
    page.should have_select 'Tipo', :selected => 'Vinculado'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent capability' do
    Capability.make!(:reforma)

    navigate_through 'Contabilidade > Orçamento > Recursos'

    click_link 'Reforma e Ampliação'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Recurso apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '2012'
    page.should_not have_content 'Reforma e Ampliação'
    page.should_not have_content 'Ordinário'
    page.should_not have_content 'Ativo'
  end
end
