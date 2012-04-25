# encoding: utf-8
require 'spec_helper'

feature "BudgetUnitConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new budget_unit_configuration' do
    Entity.make!(:detran)
    RegulatoryAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Configurações de Unidade Orçamentária'

    click_link 'Criar Configuração de Unidade Orçamentária'

    fill_in 'Descrição', :with => 'Nome da Configuração'
    fill_modal 'Entidade', :with => 'Detran'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    click_button 'Adicionar Estrutura'
    fill_in 'Nível', :with => '1'
    fill_in 'budget_unit_configuration_budget_unit_levels_attributes_fresh-0_description', :with => 'Órgão'
    fill_in 'Dígitos', :with => '2'
    select 'Ponto', :from => 'Separador'
    click_button 'Salvar'

    page.should have_notice 'Configuração de Unidade Orçamentária criado com sucesso.'

    click_link 'Nome da Configuração'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Ato regulamentador', :with => '1234'
    page.should have_field 'Máscara', :with => '99'
    page.should have_field 'Descrição', :with => 'Nome da Configuração'
    page.should have_field 'Nível', :with => '1'
    page.should have_field 'budget_unit_configuration_budget_unit_levels_attributes_0_description', :with => 'Órgão'
    page.should have_field 'Dígitos', :with => '2'
    page.should have_select 'Separador', :selected => 'Ponto'
  end

  scenario 'calculate mask with javascript' do
    click_link 'Contabilidade'

    click_link 'Configurações de Unidade Orçamentária'

    click_link 'Criar Configuração de Unidade Orçamentária'

    click_button 'Adicionar Estrutura'

    fill_in 'Nível', :with => '2'

    fill_in 'Dígitos', :with => '2'

    click_button 'Adicionar Estrutura'

    within 'fieldset:first' do
      fill_in 'Nível', :with => '1'

      fill_in 'Dígitos', :with => '3'

      select 'Ponto', :from => 'Separador'
    end

    page.should have_field 'Máscara', :with => '999.99'
  end

  scenario 'update an existent budget_unit_configuration' do
    BudgetUnitConfiguration.make!(:detran_sopa)

    click_link 'Contabilidade'

    click_link 'Configurações de Unidade Orçamentária'

    click_link 'Configuração do Detran'

    fill_in 'Descrição', :with => 'Outro Nome da Configuração'

    click_button 'Salvar'

    page.should have_notice 'Configuração de Unidade Orçamentária editado com sucesso.'

    click_link 'Outro Nome da Configuração'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Ato regulamentador', :with => '1234'
    page.should have_field 'Descrição', :with => 'Outro Nome da Configuração'
  end

  scenario 'destroy an existent budget_unit_configuration' do
    BudgetUnitConfiguration.make!(:detran_sopa)

    click_link 'Contabilidade'

    click_link 'Configurações de Unidade Orçamentária'

    click_link 'Configuração do Detran'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Configuração de Unidade Orçamentária apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '1234'
    page.should_not have_content 'Configuração do Detran'
  end
end
