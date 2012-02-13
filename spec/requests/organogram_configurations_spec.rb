# encoding: utf-8
require 'spec_helper'

feature "OrganogramConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new organogram_configuration' do
    Entity.make!(:detran)
    AdministractiveAct.make!(:sopa)

    click_link 'Cadastros Diversos'

    click_link 'Configurações de Organograma'

    click_link 'Criar Configuração de Organograma'

    fill_in 'Descrição', :with => 'Nome da Configuração'

    fill_modal 'Entidade', :with => 'Detran'

    fill_modal 'Ato administrativo', :with => '1234', :field => 'Número'

    click_button 'Adicionar'

    fill_in 'Nível', :with => '1'

    fill_in 'organogram_configuration_organogram_levels_attributes_fresh-0_description', :with => 'Orgão'

    fill_in 'Dígitos', :with => '2'

    select 'Ponto', :from => 'Separador'

    click_button 'Criar Configuração de Organograma'

    page.should have_notice 'Configuração de Organograma criado com sucesso.'

    click_link 'Nome da Configuração'

    page.should have_field 'Entidade', :with => 'Detran'

    page.should have_field 'Ato administrativo', :with => '1234'

    page.should have_field 'Máscara', :with => '99'

    page.should have_field 'Descrição', :with => 'Nome da Configuração'

    page.should have_field 'Nível', :with => '1'

    page.should have_field 'organogram_configuration_organogram_levels_attributes_0_description', :with => 'Orgão'

    page.should have_field 'Dígitos', :with => '2'

    page.should have_select 'Separador', :with => 'Ponto'
  end

  scenario 'calculate mask with javascript' do
    click_link 'Cadastros Diversos'

    click_link 'Configurações de Organograma'

    click_link 'Criar Configuração de Organograma'

    click_button 'Adicionar'

    fill_in 'Nível', :with => '2'

    fill_in 'Dígitos', :with => '2'

    click_button 'Adicionar'

    within '.organogram-level:last' do
      fill_in 'Nível', :with => '1'

      fill_in 'Dígitos', :with => '3'

      select 'Ponto', :from => 'Separador'
    end

    page.should have_field 'Máscara', :with => '999.99'
  end

  scenario 'update an existent organogram_configuration' do
    OrganogramConfiguration.make!(:detran_sopa)

    click_link 'Cadastros Diversos'

    click_link 'Configurações de Organograma'

    click_link 'Configuração do Detran'

    fill_in 'Descrição', :with => 'Outro Nome da Configuração'

    click_button 'Atualizar Configuração de Organograma'

    page.should have_notice 'Configuração de Organograma editado com sucesso.'

    click_link 'Outro Nome da Configuração'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Ato administrativo', :with => '1234'
    page.should have_field 'Descrição', :with => 'Outro Nome da Configuração'
  end

  scenario 'destroy an existent organogram_configuration' do
    OrganogramConfiguration.make!(:detran_sopa)

    click_link 'Cadastros Diversos'

    click_link 'Configurações de Organograma'

    click_link 'Configuração do Detran'

    click_link 'Apagar Configuração do Detran', :confirm => true

    page.should have_notice 'Configuração de Organograma apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '1234'
    page.should_not have_content 'Configuração do Detran'
  end
end
