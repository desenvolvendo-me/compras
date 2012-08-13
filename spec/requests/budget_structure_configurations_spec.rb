# encoding: utf-8
require 'spec_helper'

feature "BudgetStructureConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new budget_structure_configuration' do

    Entity.make!(:detran)
    RegulatoryAct.make!(:sopa)

    navigate 'Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

    click_link 'Criar Configuração de Estrutura Orçamentaria'

    fill_in 'Descrição', :with => 'Nome da Configuração'
    fill_modal 'Entidade', :with => 'Detran'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    click_button 'Adicionar Estrutura'
    fill_in 'Nível', :with => '1'
    fill_in 'budget_structure_configuration_budget_structure_levels_attributes_fresh-0_description', :with => 'Órgão'
    fill_in 'Dígitos', :with => '2'
    select 'Ponto', :from => 'Separador'
    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Estrutura Orçamentaria criado com sucesso.'

    click_link 'Nome da Configuração'

    expect(page).to have_field 'Entidade', :with => 'Detran'
    expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
    expect(page).to have_field 'Máscara', :with => '99'
    expect(page).to have_field 'Descrição', :with => 'Nome da Configuração'
    expect(page).to have_field 'Nível', :with => '1'
    expect(page).to have_field 'budget_structure_configuration_budget_structure_levels_attributes_0_description', :with => 'Órgão'
    expect(page).to have_field 'Dígitos', :with => '2'
    expect(page).to have_select 'Separador', :selected => 'Ponto'
  end

  scenario 'calculate mask with javascript' do
    navigate 'Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

    click_link 'Criar Configuração de Estrutura Orçamentaria'

    click_button 'Adicionar Estrutura'

    fill_in 'Nível', :with => '2'

    fill_in 'Dígitos', :with => '2'

    click_button 'Adicionar Estrutura'

    within 'div.budget-structure-level:first' do
      fill_in 'Nível', :with => '1'

      fill_in 'Dígitos', :with => '3'

      select 'Ponto', :from => 'Separador'
    end

    expect(page).to have_field 'Máscara', :with => '999.99'
  end

  scenario 'update an existent budget_structure_configuration' do
    BudgetStructureConfiguration.make!(:detran_sopa)

    navigate 'Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

    click_link 'Configuração do Detran'

    fill_in 'Descrição', :with => 'Outro Nome da Configuração'

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Estrutura Orçamentaria editado com sucesso.'

    click_link 'Outro Nome da Configuração'

    expect(page).to have_field 'Entidade', :with => 'Detran'
    expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
    expect(page).to have_field 'Descrição', :with => 'Outro Nome da Configuração'
  end

  scenario 'destroy an existent budget_structure_configuration' do
    BudgetStructureConfiguration.make!(:detran_sopa)

    navigate 'Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

    click_link 'Configuração do Detran'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Configuração de Estrutura Orçamentaria apagado com sucesso.'

    expect(page).not_to have_content 'Detran'
    expect(page).not_to have_content '1234'
    expect(page).not_to have_content 'Configuração do Detran'
  end
end
