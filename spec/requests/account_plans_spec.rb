# encoding: utf-8
require 'spec_helper'

feature "AccountPlans" do
  background do
    sign_in
  end

  scenario 'create a new account_plan' do
    AccountPlanConfiguration.make!(:plano1)
    CheckingAccountOfFiscalAccount.make!(:disponibilidade_financeira)

    navigate 'Contabilidade > Comum > Plano de Contas > Planos de Contas'

    click_link 'Criar Plano de Conta'

    within_tab 'Principal' do
      fill_modal 'Configuração do plano de contas', :with => '2012', :field => 'Ano de exercício'
      fill_in 'Conta contábil', :with => '9.99'
      fill_in 'Título', :with => 'Bancos conta movimento'
      fill_in 'Função', :with => 'Registra a movimentação'
    end

    within_tab 'Atributos' do
      select 'Crédito', :from => 'Natureza do saldo'
      select 'Patrimonial', :from => 'Natureza da informação'
      select 'Inverte saldo', :from => 'Variação da natureza da informação'
      check 'Escrituração'
      select 'Financeiro', :from => 'Indicador de superávit financeiro'
      select 'Bilateral', :from => 'Tipo de movimentação'
    end

    within_tab 'Atributos TCE' do
      check 'Mês 12'
      check 'Mês 13'
      check 'Mês 14'
      check 'Não encerra'
      check 'Detalhamento obrigatório abertura'
      check 'Detalhamento obrigatório mês 13'
      check 'Detalhamento obrigatório mês 14'

      fill_modal 'Conta corrente', :with => 'Disponibilidade financeira'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Plano de Conta criado com sucesso.'

    click_link 'Bancos conta moviment'

    within_tab 'Principal' do
      expect(page).to have_field 'Configuração do plano de contas', :with => 'Plano1'
      expect(page).to have_field 'Conta contábil', :with => '9.99'
      expect(page).to have_field 'Título', :with => 'Bancos conta movimento'
      expect(page).to have_field 'Função', :with => 'Registra a movimentação'
    end

    within_tab 'Atributos' do
      expect(page).to have_select 'Natureza do saldo', :selected => 'Crédito'
      expect(page).to have_select 'Natureza da informação', :selected => 'Patrimonial'
      expect(page).to have_select 'Variação da natureza da informação', :selected => 'Inverte saldo'
      expect(page).to have_checked_field 'Escrituração'
      expect(page).to have_select 'Indicador de superávit financeiro', :selected => 'Financeiro'
      expect(page).to have_select 'Tipo de movimentação', :selected => 'Bilateral'
    end

    within_tab 'Atributos TCE' do
      expect(page).to have_checked_field 'Mês 12'
      expect(page).to have_checked_field 'Mês 13'
      expect(page).to have_checked_field 'Mês 14'
      expect(page).to have_checked_field 'Não encerra'
      expect(page).to have_checked_field 'Detalhamento obrigatório abertura'
      expect(page).to have_checked_field 'Detalhamento obrigatório mês 13'
      expect(page).to have_checked_field 'Detalhamento obrigatório mês 14'

      expect(page).to have_field 'Conta corrente', :with => 'Disponibilidade financeira'
    end
  end

  scenario 'should have account_checking disabled before fill account_plan_configuration' do
    AccountPlanConfiguration.make!(:plano1)

    navigate 'Contabilidade > Comum > Plano de Contas > Planos de Contas'

    click_link 'Criar Plano de Conta'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Conta contábil'

      fill_modal 'Configuração do plano de contas', :with => '2012', :field => 'Ano de exercício'

      expect(page).to have_field 'Conta contábil'
      expect(page).to_not have_disabled_field 'Conta contábil'
    end
  end

  scenario 'update an existent account_plan' do
    AccountPlan.make!(:bancos)
    AccountPlanConfiguration.make!(:segundo_plano)

    navigate 'Contabilidade > Comum > Plano de Contas > Planos de Contas'

    click_link 'Bancos conta movimento'

    within_tab 'Principal' do
      fill_modal 'Configuração do plano de contas', :with => '2011', :field => 'Ano de exercício'
      fill_in 'Conta contábil', :with => '99.99'
      fill_in 'Título', :with => 'Bancos contas próprias'
      fill_in 'Função', :with => 'Registra movimentações de conta própria'
    end

    within_tab 'Atributos' do
      select 'Mista', :from => 'Natureza do saldo'
      select 'Compensado', :from => 'Natureza da informação'
      select 'Inverte saldo', :from => 'Variação da natureza da informação'
      uncheck 'Escrituração'
      select 'Permanente', :from => 'Indicador de superávit financeiro'
      select 'Unilateral devedora', :from => 'Tipo de movimentação'
    end

    within_tab 'Atributos TCE' do
      check 'Mês 12'
      uncheck 'Detalhamento obrigatório abertura'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Plano de Conta editado com sucesso.'

    click_link 'Bancos contas próprias'

    within_tab 'Principal' do
      expect(page).to have_field 'Configuração do plano de contas', :with => 'Segundo plano de MG'
      expect(page).to have_field 'Conta contábil', :with => '99.99'
      expect(page).to have_field 'Título', :with => 'Bancos contas próprias'
      expect(page).to have_field 'Função', :with => 'Registra movimentações de conta própria'
    end

    within_tab 'Atributos' do
      expect(page).to have_select 'Natureza do saldo', :selected => 'Mista'
      expect(page).to have_select 'Natureza da informação', :selected => 'Compensado'
      expect(page).to have_select 'Variação da natureza da informação', :selected => 'Inverte saldo'
      expect(page).to_not have_checked_field 'Escrituração'
      expect(page).to have_select 'Indicador de superávit financeiro', :selected => 'Permanente'
      expect(page).to have_select 'Tipo de movimentação', :selected => 'Unilateral devedora'
    end

    within_tab 'Atributos TCE' do
      expect(page).to have_checked_field 'Mês 12'
      expect(page).to have_unchecked_field 'Detalhamento obrigatório abertura'
    end
  end

  scenario 'destroy an existent account_plan' do
    AccountPlan.make!(:bancos)

    navigate 'Contabilidade > Comum > Plano de Contas > Planos de Contas'

    click_link 'Bancos conta movimento'

    click_link 'Apagar'

    expect(page).to have_notice 'Plano de Conta apagado com sucesso.'

    expect(page).to_not have_content 'Bancos conta movimento'
  end
end
