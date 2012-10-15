# encoding: utf-8
require 'spec_helper'

feature "BudgetStructureConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new budget_structure_configuration' do
    Entity.make!(:detran)
    RegulatoryAct.make!(:sopa)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

    click_link 'Criar Configuração de Estrutura Orçamentaria'

    fill_in 'Descrição', :with => 'Nome da Configuração'
    fill_modal 'Entidade', :with => 'Detran'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    click_button 'Adicionar Estrutura'
    within 'div.nested-budget-structure-level:first' do
      fill_in 'Nível', :with => '1'
      fill_in 'Descrição', :with => 'Órgão'
      fill_in 'Dígitos', :with => '2'
      select 'Ponto', :from => 'Separador'
    end
    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Estrutura Orçamentaria criado com sucesso.'

    click_link 'Nome da Configuração'

    expect(page).to have_field 'Entidade', :with => 'Detran'
    expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
    expect(page).to have_field 'Máscara', :with => '99'
    expect(page).to have_field 'Descrição', :with => 'Nome da Configuração'
    within 'div.nested-budget-structure-level:first' do
      expect(page).to have_field 'Nível', :with => '1'
      expect(page).to have_field 'Descrição', :with => 'Órgão'
      expect(page).to have_field 'Dígitos', :with => '2'
      expect(page).to have_select 'Separador', :selected => 'Ponto'
    end
  end

  scenario 'calculate mask with javascript' do
    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

    click_link 'Criar Configuração de Estrutura Orçamentaria'

    click_button 'Adicionar Estrutura'

    fill_in 'Nível', :with => '2'

    fill_in 'Dígitos', :with => '2'

    click_button 'Adicionar Estrutura'

    within 'div.nested-budget-structure-level:last' do
      fill_in 'Nível', :with => '1'

      fill_in 'Dígitos', :with => '3'

      select 'Ponto', :from => 'Separador'
    end

    expect(page).to have_field 'Máscara', :with => '999.99'

    within 'div.nested-budget-structure-level:last' do
      click_button 'Remover'
    end

    expect(page).to have_field 'Máscara', :with => '99'
  end

  scenario 'update an existent budget_structure_configuration' do
    BudgetStructureConfiguration.make!(:detran_sopa)

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

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

    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

    click_link 'Configuração do Detran'

    click_link 'Apagar'

    expect(page).to have_notice 'Configuração de Estrutura Orçamentaria apagado com sucesso.'

    expect(page).to_not have_content 'Detran'
    expect(page).to_not have_content '1234'
    expect(page).to_not have_content 'Configuração do Detran'
  end

  scenario 'create with error' do
    navigate 'Outros > Contabilidade > Orçamento > Estrutura Organizacional > Configurações de Estrutura Orçamentaria'

    click_link 'Criar Configuração de Estrutura Orçamentaria'

    click_button 'Adicionar Estrutura'

    within 'div.nested-budget-structure-level' do
      fill_in 'Nível', :with => '1'
      fill_in 'Descrição', :with => 'Uso interno'
      fill_in 'Dígitos', :with => '2'
      select 'Barra', :from => 'Separador'
    end

    click_button 'Adicionar Estrutura'

    within 'div.nested-budget-structure-level:nth-child(2)' do
      fill_in 'Nível', :with => '2'
      fill_in 'Descrição', :with => 'Indicador de quantidade'
      fill_in 'Dígitos', :with => '2'
      select 'Hífem', :from => 'Separador'
    end

    click_button 'Adicionar Estrutura'

    within 'div.nested-budget-structure-level:nth-child(3)' do
      fill_in 'Nível', :with => '3'
      fill_in 'Descrição', :with => 'Definido pelo fornecedor'
      fill_in 'Dígitos', :with => '2'
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Configuração de Estrutura Orçamentaria criado com sucesso.'

    within 'div.nested-budget-structure-level:nth-child(1)' do
      expect(page).to have_field 'Nível', :with => '1'
      expect(page).to have_field 'Descrição', :with => 'Uso interno'
      expect(page).to have_field 'Dígitos', :with => '2'
    end

    within 'div.nested-budget-structure-level:nth-child(2)' do
      expect(page).to have_field 'Nível', :with => '2'
      expect(page).to have_field 'Descrição', :with => 'Indicador de quantidade'
      expect(page).to have_field 'Dígitos', :with => '2'
    end

    within 'div.nested-budget-structure-level:nth-child(3)' do
      expect(page).to have_field 'Nível', :with => '3'
      expect(page).to have_field 'Descrição', :with => 'Definido pelo fornecedor'
      expect(page).to have_field 'Dígitos', :with => '2'
    end
  end
end
