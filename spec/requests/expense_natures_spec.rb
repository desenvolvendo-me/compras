# encoding: utf-8
require 'spec_helper'

feature "ExpenseNatures" do
  background do
    sign_in
  end

  scenario 'create a new expense_nature' do
    Entity.make!(:detran)
    RegulatoryAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Naturezas de Despesas'

    click_link 'Criar Natureza de Despesa'

    fill_modal 'Entidade', :with => 'Detran'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    fill_in 'Classificação da natureza da despesa', :with => '3.1.90.11.01.00.00.00'
    select 'Ambos', :from => 'Tipo'
    fill_in 'Descrição', :with => 'Vencimentos e Salários'
    fill_in 'Súmula', :with => 'Registra o valor das despesas com vencimentos'

    click_button 'Criar Natureza de Despesa'

    page.should have_notice 'Natureza de Despesa criado com sucesso'

    click_link '3.1.90.11.01.00.00.00'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Ato regulamentador', :with => '1234'
    page.should have_field 'Classificação da natureza da despesa', :with => '3.1.90.11.01.00.00.00'
    page.should have_select 'Tipo', :selected => 'Ambos'
    page.should have_field 'Descrição', :with => 'Vencimentos e Salários'
    page.should have_field 'Súmula', :with => 'Registra o valor das despesas com vencimentos'
  end

  scenario 'update an existent expense_nature' do
    ExpenseNature.make!(:vencimento_e_salarios)
    Entity.make!(:secretaria_de_educacao)
    RegulatoryAct.make!(:emenda)

    click_link 'Contabilidade'

    click_link 'Naturezas de Despesas'

    click_link '3.1.90.11.01.00.00.00'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
    fill_in 'Classificação da natureza da despesa', :with => '1.2.34.56.78.90.12.34'
    select 'Analítico', :from => 'Tipo'
    fill_in 'Descrição', :with => 'Vencimentos e Salários e Pagamento'
    fill_in 'Súmula', :with => 'Registra o valor das despesas com vencimentos de salários'

    click_button 'Atualizar Natureza de Despesa'

    page.should have_notice 'Natureza de Despesa editado com sucesso.'

    click_link '1.2.34.56.78.90.12.34'

    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Ato regulamentador', :with => '4567'
    page.should have_field 'Classificação da natureza da despesa', :with => '1.2.34.56.78.90.12.34'
    page.should have_select 'Tipo', :selected => 'Analítico'
    page.should have_field 'Descrição', :with => 'Vencimentos e Salários e Pagamento'
    page.should have_field 'Súmula', :with => 'Registra o valor das despesas com vencimentos de salários'
  end

  scenario 'destroy an existent expense_nature' do
    ExpenseNature.make!(:vencimento_e_salarios)

    click_link 'Contabilidade'

    click_link 'Naturezas de Despesas'

    click_link '3.1.90.11.01.00.00.00'

    click_link 'Apagar 3.1.90.11.01.00.00.00', :confirm => true

    page.should have_notice 'Natureza de Despesa apagado com sucesso.'

    page.should_not have_field '3.1.90.11.01.00.00.00'
  end
end
