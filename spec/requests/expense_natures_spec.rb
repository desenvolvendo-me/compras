# encoding: utf-8
require 'spec_helper'

feature "ExpenseNatures" do
  background do
    sign_in
  end

  scenario 'create a new expense_nature' do
    Descriptor.make!(:detran_2012)
    RegulatoryAct.make!(:sopa)
    ExpenseCategory.make!(:despesa_corrente)
    ExpenseGroup.make!(:restos_a_pagar)
    ExpenseModality.make!(:transferencias_intragovernamentais)
    ExpenseElement.make!(:aposentadorias)

    navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

    click_link 'Criar Natureza da Despesa'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    fill_modal 'Categoria da despesa', :with => '3', :field => 'Código'
    fill_modal 'Grupo da despesa', :with => '0', :field => 'Código'
    fill_modal 'Modalidade da despesa', :with => '10', :field => 'Código'
    fill_modal 'Elemento da despesa', :with => '1', :field => 'Código'
    fill_in 'Desdobramento da despesa', :with => '12'
    select 'Ambos', :from => 'Tipo'
    fill_in 'Descrição', :with => 'Vencimentos e Salários'
    fill_in 'Súmula', :with => 'Registra o valor das despesas com vencimentos'

    click_button 'Salvar'

    expect(page).to have_notice 'Natureza da Despesa criado com sucesso'

    click_link '3.0.10.01.12 - Vencimentos e Salários'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
    expect(page).to have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
    expect(page).to have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
    expect(page).to have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'
    expect(page).to have_field 'Desdobramento da despesa', :with => '12'
    expect(page).to have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
    expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12'
    expect(page).to have_select 'Tipo', :selected => 'Ambos'
    expect(page).to have_field 'Descrição', :with => 'Vencimentos e Salários'
    expect(page).to have_field 'Súmula', :with => 'Registra o valor das despesas com vencimentos'
  end

  scenario 'should generate mask' do
    ExpenseCategory.make!(:despesa_corrente)
    ExpenseGroup.make!(:restos_a_pagar)
    ExpenseModality.make!(:transferencias_intragovernamentais)
    ExpenseElement.make!(:aposentadorias)

    navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

    click_link 'Criar Natureza da Despesa'

    fill_modal 'Categoria da despesa', :with => '3', :field => 'Código'

    fill_modal 'Grupo da despesa', :with => '0', :field => 'Código'
    expect(page).to have_field 'Natureza da despesa', :with => '3.0.00.00.00'

    fill_modal 'Modalidade da despesa', :with => '10', :field => 'Código'

    fill_modal 'Elemento da despesa', :with => '1', :field => 'Código'
    expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.00'

    fill_in 'Desdobramento da despesa', :with => '12'

    expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12'
  end

  context 'filtering' do
    scenario 'should filter by expense_nature' do
      ExpenseNature.make!(:vencimento_e_salarios)
      ExpenseNature.make!(:compra_de_material)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      fill_in 'Natureza da despesa', :with => '3.0.10.01.12'

      click_button 'Pesquisar'

      expect(page).to have_content '3.0.10.01.12'
      expect(page).to_not have_content '3.0.10.01.11'
    end

    scenario 'should filter by description' do
      ExpenseNature.make!(:vencimento_e_salarios)
      ExpenseNature.make!(:compra_de_material)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      fill_in 'Descrição', :with => 'Vencimentos e Salários'

      click_button 'Pesquisar'

      expect(page).to have_content 'Vencimentos e Salários'
      expect(page).to_not have_content 'Compra de Material'
    end

    scenario 'should filter by descriptor' do
      ExpenseNature.make!(:vencimento_e_salario_2011)
      ExpenseNature.make!(:compra_de_material)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'

      click_button 'Pesquisar'

      expect(page).to have_content 'Vencimentos e Salários'
      expect(page).to_not have_content 'Compra de Material'
    end

    scenario 'should filter by regulatory_act' do
      ExpenseNature.make!(:vencimento_e_salario_2011)
      ExpenseNature.make!(:compra_de_material)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'

      click_button 'Pesquisar'

      expect(page).to have_content 'Vencimentos e Salários'
      expect(page).to_not have_content 'Compra de Material'
    end

    scenario 'should filter by kind' do
      ExpenseNature.make!(:vencimento_e_salario_2011)
      ExpenseNature.make!(:compra_de_material)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      select 'Ambos', :from => 'Tipo'

      click_button 'Pesquisar'

      expect(page).to have_content 'Vencimentos e Salários'
      expect(page).to_not have_content 'Compra de Material'
    end

    scenario 'should filter by expense_category' do
      ExpenseNature.make!(:compra_de_material)
      ExpenseNature.make!(:despesas_correntes)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      fill_modal 'Categoria da despesa', :with => '3', :field => 'Código'

      click_button 'Pesquisar'

      expect(page).to have_content '3.0.10.01.11'
      expect(page).to_not have_content '4.4.20.03.11'
    end

    scenario 'should filter by expense_group' do
      ExpenseNature.make!(:compra_de_material)
      ExpenseNature.make!(:despesas_correntes)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      fill_modal 'Grupo da despesa', :with => '0', :field => 'Código'

      click_button 'Pesquisar'

      expect(page).to have_content '3.0.10.01.11'
      expect(page).to_not have_content '4.4.20.03.11'
    end

    scenario 'should filter by expense_modality' do
      ExpenseNature.make!(:compra_de_material)
      ExpenseNature.make!(:despesas_correntes)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      fill_modal 'Modalidade da despesa', :with => '10', :field => 'Código'

      click_button 'Pesquisar'

      expect(page).to have_content '3.0.10.01.11'
      expect(page).to_not have_content '4.4.20.03.11'
    end

    scenario 'should filter by expense_element' do
      ExpenseNature.make!(:compra_de_material)
      ExpenseNature.make!(:despesas_correntes)

      navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

      click_link 'Filtrar Naturezas das Despesas'

      fill_modal 'Elemento da despesa', :with => '1', :field => 'Código'

      click_button 'Pesquisar'

      expect(page).to have_content '3.0.10.01.11'
      expect(page).to_not have_content '4.4.20.03.11'
    end
  end

  scenario 'update an existent expense_nature' do
    ExpenseNature.make!(:vencimento_e_salarios)
    Descriptor.make!(:secretaria_de_educacao_2011)
    RegulatoryAct.make!(:emenda)
    ExpenseCategory.make!(:despesa_de_capital)
    ExpenseGroup.make!(:investimentos)
    ExpenseModality.make!(:transferencias_a_uniao)
    ExpenseElement.make!(:pensoes)

    navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

    click_link '3.0.10.01.12 - Vencimentos e Salários'

    fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
    fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
    fill_modal 'Grupo da despesa', :with => '4', :field => 'Código'
    fill_modal 'Modalidade da despesa', :with => '20', :field => 'Código'
    fill_modal 'Categoria da despesa', :with => '4', :field => 'Código'
    fill_modal 'Elemento da despesa', :with => '3', :field => 'Código'
    fill_in 'Desdobramento da despesa', :with => '11'
    select 'Analítico', :from => 'Tipo'
    fill_in 'Descrição', :with => 'Vencimentos e Salários e Pagamento'
    fill_in 'Súmula', :with => 'Registra o valor das despesas com vencimentos de salários'

    click_button 'Salvar'

    expect(page).to have_notice 'Natureza da Despesa editado com sucesso.'

    click_link '4.4.20.03.11'

    expect(page).to have_field 'Descritor', :with => '2011 - Secretaria de Educação'
    expect(page).to have_field 'Ato regulamentador', :with => 'Emenda constitucional 4567'
    expect(page).to have_field 'Grupo da despesa', :with => '4 - INVESTIMENTOS'
    expect(page).to have_field 'Modalidade da despesa', :with => '20 - TRANSFERÊNCIAS À UNIÃO'
    expect(page).to have_field 'Elemento da despesa', :with => '3 - PENSÕES'
    expect(page).to have_field 'Desdobramento da despesa', :with => '11'
    expect(page).to have_field 'Categoria da despesa', :with => '4 - DESPESA DE CAPITAL'
    expect(page).to have_field 'Natureza da despesa', :with => '4.4.20.03.11'
    expect(page).to have_select 'Tipo', :selected => 'Analítico'
    expect(page).to have_field 'Descrição', :with => 'Vencimentos e Salários e Pagamento'
    expect(page).to have_field 'Súmula', :with => 'Registra o valor das despesas com vencimentos de salários'
  end

  scenario 'destroy an existent expense_nature' do
    ExpenseNature.make!(:vencimento_e_salarios)

    navigate 'Contabilidade > Orçamento > Dotação Orçamentaria > Naturezas das Despesas'

    click_link '3.0.10.01.12 - Vencimentos e Salários'

    click_link 'Apagar'

    expect(page).to have_notice 'Natureza da Despesa apagado com sucesso.'

    expect(page).to_not have_field '3.0.10.01.12'
  end
end
