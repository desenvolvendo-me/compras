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

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      page.should have_disabled_field 'Código'

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

    page.should have_notice 'Dotação Orçamentaria criado com sucesso.'

    within_records do
      click_link '1 - Alocação'
    end

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2012 - Detran'
      page.should have_disabled_field 'Código'
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      page.should have_field 'Função', :with => '04 - Administração'
      page.should have_field 'Subfunção', :with => '01 - Administração Geral'
      page.should have_field 'Programa do governo', :with => 'Habitação'
      page.should have_field 'Ação do governo', :with => 'Ação Governamental'
      page.should have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'
      page.should have_field 'Recurso', :with => 'Reforma e Ampliação'
      page.should have_field 'Descrição', :with => 'Alocação'
      page.should have_field 'Objetivo', :with => 'Manutenção da Unidade Administrativa'
      page.should have_select 'Tipo de dívida', :selected => 'Nenhuma'
      page.should have_field 'Tipo de dotação', :with => 'Dotação Administrativa'
      page.should have_checked_field 'Refinanciamento'
      page.should_not have_checked_field 'Saúde'
      page.should_not have_checked_field 'Recurso alienação'
      page.should_not have_checked_field 'Educação'
      page.should_not have_checked_field 'Previdência'
      page.should_not have_checked_field 'Pessoal'
      page.should have_field 'Data', :with => '17/02/2012'
    end

    within_tab 'Programação' do
      page.should have_select 'Tipo da programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'create a new budget_allocation with 1 as code when is other year' do
    Descriptor.make!(:detran_2012)
    BudgetAllocation.make!(:reparo_2011)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      page.should have_disabled_field 'Código'

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

    page.should have_notice 'Dotação Orçamentaria criado com sucesso.'

    within_records do
      click_link '1 - Alocação para o ano de 2012'
    end

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2012 - Detran'
      page.should have_disabled_field 'Código'
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      page.should have_field 'Função', :with => '05 - Execução'
      page.should have_field 'Subfunção', :with => '02 - Supervisor'
      page.should have_field 'Programa do governo', :with => 'Educação'
      page.should have_field 'Ação do governo', :with => 'Ação Nacional'
      page.should have_field 'Natureza da despesa', :with => '3.0.10.01.11 - Compra de Material'
      page.should have_field 'Recurso', :with => 'Reforma e Ampliação'
      page.should have_field 'Descrição', :with => 'Alocação para o ano de 2012'
      page.should have_field 'Objetivo', :with => 'Manutenção da Unidade Administrativa do ano de 2012'
      page.should have_select 'Tipo de dívida', :selected => 'Nenhuma'
      page.should have_field 'Tipo de dotação', :with => 'Dotação Administrativa'
      page.should have_checked_field 'Refinanciamento'
      page.should_not have_checked_field 'Saúde'
      page.should_not have_checked_field 'Recurso alienação'
      page.should_not have_checked_field 'Educação'
      page.should_not have_checked_field 'Previdência'
      page.should_not have_checked_field 'Pessoal'
      page.should have_field 'Data', :with => '17/02/2012'
    end

    within_tab 'Programação' do
      page.should have_select 'Tipo da programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'should apply month value based on kind and value' do
    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Programação' do
      page.should have_disabled_field 'Valor'

      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
      page.should have_field 'Valor', :with => ''
      page.should have_disabled_field 'Valor'
      page.should have_content '0,00'

      select 'Dividir valor previsto por 12', :from => 'Tipo'
      fill_in 'Valor', :with => '222,22'
      page.should have_content '18,51'
      page.should have_content '18,61'
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

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2013', :field => 'Exercício'
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

    page.should have_notice 'Dotação Orçamentaria editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2013 - Secretaria de Educação'
      page.should have_field 'Estrutura orçamentaria', :with => '1.2 - Secretaria de Desenvolvimento'
      page.should have_field 'Função', :with => '04 - Administração'
      page.should have_field 'Subfunção', :with => '02 - Gerente Geral'
      page.should have_field 'Programa do governo', :with => 'Educação'
      page.should have_field 'Ação do governo', :with => 'Ação Nacional'
      page.should have_field 'Natureza da despesa', :with => '3.0.10.01.11 - Compra de Material'
      page.should have_field 'Recurso', :with => 'Construção'
      page.should have_field 'Descrição', :with => 'Novo nome'
      page.should have_field 'Objetivo', :with => 'Construção da Unidade Administrativa'
      page.should have_select 'Tipo de dívida', :selected => 'Contrato'
      page.should have_field 'Tipo de dotação', :with => 'Dotação Presidencial'
      page.should_not have_checked_field 'Refinanciamento'
      page.should have_checked_field 'Saúde'
      page.should_not have_checked_field 'Recurso alienação'
      page.should_not have_checked_field 'Educação'
      page.should_not have_checked_field 'Previdência'
      page.should_not have_checked_field 'Pessoal'
      page.should have_field 'Data', :with => '01/02/2012'
    end

    within_tab 'Programação' do
      page.should have_select 'Tipo da programação', :selected => 'Dividir valor previsto por 12'
      page.should have_field 'Valor', :with => '800,00'
    end
  end

  it 'should show selected function on subfunction modal' do
    Subfunction.make!(:geral)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      page.should have_disabled_field 'Subfunção'

      fill_modal 'Função', :with => 'Administração', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição'

      page.should_not have_disabled_field 'Subfunção'

      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição' do
        page.should have_field 'filter_function', :with => '04 - Administração'
      end
    end
  end

  it 'should not have the subfunction disabled when editing budget_allocation with subfunction' do
    BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should_not have_disabled_field 'Subfunção'
    end
  end

  it 'should disable and empty the subfunction when the function is removed' do
    BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_modal 'Função', :with => 'Administração', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição'

      clear_modal 'Função'

      page.should have_disabled_field 'Subfunção'
      page.should have_field 'Função', :with => ''
    end
  end

  it 'should empty the subfunction when the function are changed' do
    Subfunction.make!(:geral)
    Function.make!(:execucao)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      fill_modal 'Função', :with => 'Administração', :field => 'Descrição'
      fill_modal 'Subfunção', :with => 'Administração Geral', :field => 'Descrição'

      fill_modal 'Função', :with => 'Execução', :field => 'Descrição'

      page.should have_field 'Subfunção', :with => ''
    end
  end

  scenario 'destroy an existent budget_allocation' do
    BudgetAllocation.make!(:alocacao_extra)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    within_records do
      page.find('a').click
    end

    click_link "Apagar", :confirm => true

    page.should have_notice 'Dotação Orçamentaria apagado com sucesso.'

    page.should_not have_content 'Alocação extra'
  end

  scenario 'validates uniqueness of name' do
    BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Criar Dotação Orçamentaria'

    within_tab 'Principal' do
      fill_in 'Descrição', :with => 'Alocação'
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'should filter by budget structure' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'

    click_button 'Pesquisar'

    page.should have_content 'Manutenção e Reparo'
    page.should_not have_content 'Alocação'
  end

  scenario 'should filter by descriptor' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'
    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'

    click_button 'Pesquisar'

    page.should_not have_content 'Manutenção e Reparo'
    page.should have_content 'Alocação'
  end

  scenario 'should filter by subfunction' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Subfunção', :with => 'Supervisor', :field => 'Descrição'

    click_button 'Pesquisar'

    page.should have_content 'Manutenção e Reparo'
    page.should_not have_content 'Alocação'
  end

  scenario 'should filter by government program' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Programa do governo', :with => 'Educação', :field => 'Descrição'

    click_button 'Pesquisar'

    page.should have_content 'Manutenção e Reparo'
    page.should_not have_content 'Alocação'
  end

  scenario 'should filter by government action' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Ação do governo', :with => 'Ação Nacional', :field => 'Descrição'

    click_button 'Pesquisar'

    page.should have_content 'Manutenção e Reparo'
    page.should_not have_content 'Alocação'
  end

  scenario 'should filter by expense nature' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Natureza da despesa', :with => 'Compra de Material', :field => 'Descrição'

    click_button 'Pesquisar'

    page.should have_content 'Manutenção e Reparo'
    page.should_not have_content 'Alocação'
  end

  scenario 'should filter by function' do
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentarias'

    click_link 'Filtrar Dotações Orçamentarias'

    fill_modal 'Função', :with => 'Execução', :field => 'Descrição'

    click_button 'Pesquisar'

    page.should have_content 'Manutenção e Reparo'
    page.should_not have_content 'Alocação'
  end
end
