# encoding: utf-8
require 'spec_helper'

feature "BudgetAllocations" do
  background do
    sign_in
  end

  scenario 'create a new budget_allocation' do
    BudgetStructure.make!(:secretaria_de_educacao)
    Descriptor.make!(:detran_2012)
    Subfunction.make!(:geral)
    GovernmentProgram.make!(:habitacao)
    GovernmentAction.make!(:governamental)
    ExpenseNature.make!(:vencimento_e_salarios)
    Capability.make!(:reforma)
    BudgetAllocationType.make!(:administrativa)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Código'

      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Função', :with => 'Administração', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição'
      fill_modal 'Programa do governo', :with => 'Habitação', :field => 'Descrição'
      fill_modal 'Ação do governo', :with => 'Ação Governamental', :field => 'Descrição'
      fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Descrição', :with => 'Alocação'
      fill_in 'Objetivo', :with => 'Manutenção da Unidade Administrativa'
      select 'Nenhuma', :from => 'Tipo de dívida'
      fill_modal 'Tipo de dotação', :with => 'Dotação Administrativa', :field => 'Descrição'
      check 'Refinanciamento'
      fill_in 'Data', :with => '17/02/2012'
    end

    within_tab 'Programação' do
      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo da programação'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Dotação Orçamentaria criada com sucesso.'

    click_link '1 - Alocação'

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2012 - Detran'
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Função', :with => '04 - Administração'
      expect(page).to have_field 'Subfunção', :with => '01 - Administração Geral'
      expect(page).to have_field 'Programa do governo', :with => 'Habitação'
      expect(page).to have_field 'Ação do governo', :with => 'Ação Governamental'
      expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Recurso', :with => 'Reforma e Ampliação'
      expect(page).to have_field 'Descrição', :with => 'Alocação'
      expect(page).to have_field 'Objetivo', :with => 'Manutenção da Unidade Administrativa'
      expect(page).to have_select 'Tipo de dívida', :selected => 'Nenhuma'
      expect(page).to have_field 'Tipo de dotação', :with => 'Dotação Administrativa'
      expect(page).to have_checked_field 'Refinanciamento'
      expect(page).to_not have_checked_field 'Saúde'
      expect(page).to_not have_checked_field 'Recurso alienação'
      expect(page).to_not have_checked_field 'Educação'
      expect(page).to_not have_checked_field 'Previdência'
      expect(page).to_not have_checked_field 'Pessoal'
      expect(page).to have_field 'Data', :with => '17/02/2012'
    end

    within_tab 'Programação' do
      expect(page).to have_select 'Tipo da programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'create a new budget_allocation with 2 as code when is from same descriptor' do
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Código'

      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Função', :with => 'Execução', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Supervisor', :field => 'Descrição'
      fill_modal 'Programa do governo', :with => 'Educação', :field => 'Descrição'
      fill_modal 'Ação do governo', :with => 'Ação Nacional', :field => 'Descrição'
      fill_modal 'Natureza da despesa', :with => 'Compra de Material', :field => 'Descrição'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Descrição', :with => 'Alocação para o ano de 2011'
      fill_in 'Objetivo', :with => 'Manutenção da Unidade Administrativa do ano de 2011'
      select 'Nenhuma', :from => 'Tipo de dívida'
      fill_modal 'Tipo de dotação', :with => 'Dotação Administrativa', :field => 'Descrição'
      check 'Refinanciamento'
      fill_in 'Data', :with => '17/02/2012'
    end

    within_tab 'Programação' do
      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo da programação'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Dotação Orçamentaria criada com sucesso.'

    click_link '1 - Alocação para o ano de 2011'

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2011 - Secretaria de Educação'
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '2'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Função', :with => '05 - Execução'
      expect(page).to have_field 'Subfunção', :with => '02 - Supervisor'
      expect(page).to have_field 'Programa do governo', :with => 'Educação'
      expect(page).to have_field 'Ação do governo', :with => 'Ação Nacional'
      expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.11 - Compra de Material'
      expect(page).to have_field 'Recurso', :with => 'Reforma e Ampliação'
      expect(page).to have_field 'Descrição', :with => 'Alocação para o ano de 2011'
      expect(page).to have_field 'Objetivo', :with => 'Manutenção da Unidade Administrativa do ano de 2011'
      expect(page).to have_select 'Tipo de dívida', :selected => 'Nenhuma'
      expect(page).to have_field 'Tipo de dotação', :with => 'Dotação Administrativa'
      expect(page).to have_checked_field 'Refinanciamento'
      expect(page).to_not have_checked_field 'Saúde'
      expect(page).to_not have_checked_field 'Recurso alienação'
      expect(page).to_not have_checked_field 'Educação'
      expect(page).to_not have_checked_field 'Previdência'
      expect(page).to_not have_checked_field 'Pessoal'
      expect(page).to have_field 'Data', :with => '17/02/2012'
    end

    within_tab 'Programação' do
      expect(page).to have_select 'Tipo da programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'create a new budget_allocation with 1 as code when is other descriptor' do
    Descriptor.make!(:detran_2012)
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Código'

      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Função', :with => 'Execução', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Supervisor', :field => 'Descrição'
      fill_modal 'Programa do governo', :with => 'Educação', :field => 'Descrição'
      fill_modal 'Ação do governo', :with => 'Ação Nacional', :field => 'Descrição'
      fill_modal 'Natureza da despesa', :with => 'Compra de Material', :field => 'Descrição'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Descrição', :with => 'Alocação para o ano de 2012'
      fill_in 'Objetivo', :with => 'Manutenção da Unidade Administrativa do ano de 2012'
      select 'Nenhuma', :from => 'Tipo de dívida'
      fill_modal 'Tipo de dotação', :with => 'Dotação Administrativa', :field => 'Descrição'
      check 'Refinanciamento'
      fill_in 'Data', :with => '17/02/2012'
    end

    within_tab 'Programação' do
      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo da programação'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Dotação Orçamentaria criada com sucesso.'

    click_link '1 - Alocação para o ano de 2012'

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2012 - Detran'
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Função', :with => '05 - Execução'
      expect(page).to have_field 'Subfunção', :with => '02 - Supervisor'
      expect(page).to have_field 'Programa do governo', :with => 'Educação'
      expect(page).to have_field 'Ação do governo', :with => 'Ação Nacional'
      expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.11 - Compra de Material'
      expect(page).to have_field 'Recurso', :with => 'Reforma e Ampliação'
      expect(page).to have_field 'Descrição', :with => 'Alocação para o ano de 2012'
      expect(page).to have_field 'Objetivo', :with => 'Manutenção da Unidade Administrativa do ano de 2012'
      expect(page).to have_select 'Tipo de dívida', :selected => 'Nenhuma'
      expect(page).to have_field 'Tipo de dotação', :with => 'Dotação Administrativa'
      expect(page).to have_checked_field 'Refinanciamento'
      expect(page).to_not have_checked_field 'Saúde'
      expect(page).to_not have_checked_field 'Recurso alienação'
      expect(page).to_not have_checked_field 'Educação'
      expect(page).to_not have_checked_field 'Previdência'
      expect(page).to_not have_checked_field 'Pessoal'
      expect(page).to have_field 'Data', :with => '17/02/2012'
    end

    within_tab 'Programação' do
      expect(page).to have_select 'Tipo da programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'should apply month value based on kind and value' do
    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Programação' do
      expect(page).to have_disabled_field 'Valor'

      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
      expect(page).to have_field 'Valor', :with => ''
      expect(page).to have_disabled_field 'Valor'
      expect(page).to have_content '0,00'

      select 'Dividir valor previsto por 12', :from => 'Tipo'
      fill_in 'Valor', :with => '222,22'
      expect(page).to have_content '18,51'
      expect(page).to have_content '18,61'
    end
  end

  scenario 'update an existent budget_allocation' do
    BudgetAllocation.make!(:alocacao)
    parent = BudgetStructure.make!(:secretaria_de_educacao)
    BudgetStructure.make!(:secretaria_de_desenvolvimento, :parent => parent)
    Descriptor.make!(:secretaria_de_educacao_2013)
    Subfunction.make!(:gerente)
    GovernmentProgram.make!(:educacao)
    GovernmentAction.make!(:nacional)
    ExpenseNature.make!(:compra_de_material)
    Capability.make!(:construcao)
    BudgetAllocationType.make!(:presidencial)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
      fill_modal 'Função', :with => 'Administração', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Gerente Geral', :field => 'Descrição'
      fill_modal 'Programa do governo', :with => 'Educação', :field => 'Descrição'
      fill_modal 'Ação do governo', :with => 'Ação Nacional', :field => 'Descrição'
      fill_modal 'Natureza da despesa', :with => 'Compra de Material', :field => 'Descrição'
      fill_modal 'Recurso', :with => 'Construção', :field => 'Descrição'
      fill_in 'Descrição', :with => 'Novo nome'
      fill_in 'Objetivo', :with => 'Construção da Unidade Administrativa'
      select 'Contrato', :from => 'Tipo de dívida'
      fill_modal 'Tipo de dotação', :with => 'Dotação Presidencial', :field => 'Descrição'
      uncheck 'Refinanciamento'
      check 'Saúde'
      fill_in 'Data', :with => '01/02/2012'
    end

    within_tab 'Programação' do
      select 'Dividir valor previsto por 12', :from => 'Tipo da programação'
      fill_in 'Valor', :with => '800,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Dotação Orçamentaria editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Descritor'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1.29 - Secretaria de Desenvolvimento'
      expect(page).to have_field 'Função', :with => '04 - Administração'
      expect(page).to have_field 'Subfunção', :with => '02 - Gerente Geral'
      expect(page).to have_field 'Programa do governo', :with => 'Educação'
      expect(page).to have_field 'Ação do governo', :with => 'Ação Nacional'
      expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.11 - Compra de Material'
      expect(page).to have_field 'Recurso', :with => 'Construção'
      expect(page).to have_field 'Descrição', :with => 'Novo nome'
      expect(page).to have_field 'Objetivo', :with => 'Construção da Unidade Administrativa'
      expect(page).to have_select 'Tipo de dívida', :selected => 'Contrato'
      expect(page).to have_field 'Tipo de dotação', :with => 'Dotação Presidencial'
      expect(page).to_not have_checked_field 'Refinanciamento'
      expect(page).to have_checked_field 'Saúde'
      expect(page).to_not have_checked_field 'Recurso alienação'
      expect(page).to_not have_checked_field 'Educação'
      expect(page).to_not have_checked_field 'Previdência'
      expect(page).to_not have_checked_field 'Pessoal'
      expect(page).to have_field 'Data', :with => '01/02/2012'
    end

    within_tab 'Programação' do
      expect(page).to have_select 'Tipo da programação', :selected => 'Dividir valor previsto por 12'
      expect(page).to have_field 'Valor', :with => '800,00'
    end
  end

  it 'should show selected function on subfunction modal' do
    Subfunction.make!(:geral)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Subfunção'

      fill_modal 'Função', :with => 'Administração', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição'

      expect(page).to_not have_disabled_field 'Subfunção'

      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição' do
        expect(page).to have_field 'filter_function', :with => '04 - Administração'
      end
    end
  end

  it 'should not have the subfunction disabled when editing budget_allocation with subfunction' do
    BudgetAllocation.make!(:alocacao)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to_not have_disabled_field 'Subfunção'
    end
  end

  it 'should disable and empty the subfunction when the function is removed' do
    BudgetAllocation.make!(:alocacao)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_modal 'Função', :with => 'Administração', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição'

      clear_modal 'Função'

      expect(page).to have_disabled_field 'Subfunção'
      expect(page).to have_field 'Função', :with => ''
    end
  end

  it 'should empty the subfunction when the function are changed' do
    Subfunction.make!(:geral)
    Function.make!(:execucao)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      fill_modal 'Função', :with => 'Administração', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição'

      fill_modal 'Função', :with => 'Execução', :field => 'Descrição'

      expect(page).to have_field 'Subfunção', :with => ''
    end
  end

  scenario 'destroy an existent budget_allocation' do
    BudgetAllocation.make!(:alocacao_extra)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    within_records do
      page.find('a').click
    end

    click_link "Apagar"

    expect(page).to have_notice 'Dotação Orçamentaria apagada com sucesso.'

    expect(page).to_not have_content 'Alocação extra'
  end

  scenario 'should filter by budget structure' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'

    click_button 'Pesquisar'

    expect(page).to have_content 'Manutenção e Reparo'
    expect(page).to_not have_content 'Alocação'
  end

  scenario 'should filter by descriptor' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'

    click_button 'Pesquisar'

    expect(page).to_not have_content 'Manutenção e Reparo'
    expect(page).to have_content 'Alocação'
  end

  scenario 'should filter by subfunction' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Subfunção', :with => 'Supervisor', :field => 'Descrição'

    click_button 'Pesquisar'

    expect(page).to have_content 'Manutenção e Reparo'
    expect(page).to_not have_content 'Alocação'
  end

  scenario 'should filter by government program' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Programa do governo', :with => 'Educação', :field => 'Descrição'

    click_button 'Pesquisar'

    expect(page).to have_content 'Manutenção e Reparo'
    expect(page).to_not have_content 'Alocação'
  end

  scenario 'should filter by government action' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Ação do governo', :with => 'Ação Nacional', :field => 'Descrição'

    click_button 'Pesquisar'

    expect(page).to have_content 'Manutenção e Reparo'
    expect(page).to_not have_content 'Alocação'
  end

  scenario 'should filter by expense nature' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Natureza da despesa', :with => 'Compra de Material', :field => 'Descrição'

    click_button 'Pesquisar'

    expect(page).to have_content 'Manutenção e Reparo'
    expect(page).to_not have_content 'Alocação'
  end

  scenario 'should filter by function' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Outros > Contabilidade > Orçamento > Dotação Orçamentaria > Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Função', :with => 'Execução', :field => 'Descrição'

    click_button 'Pesquisar'

    expect(page).to have_content 'Manutenção e Reparo'
    expect(page).to_not have_content 'Alocação'
  end
end
