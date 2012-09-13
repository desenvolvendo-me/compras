# encoding: utf-8
require 'spec_helper'

feature "AccountPlans" do
  background do
    sign_in
  end

  scenario 'create a new account_plan' do
    AccountPlanConfiguration.make!(:plano1)

    navigate 'Contabilidade > Comum > Plano de Contas > Planos de Contas'

    click_link 'Criar Plano de Conta'

    within_tab 'Principal' do
      fill_modal 'Configuração do plano de contas', :with => '2012', :field => 'Ano de exercício'
      fill_in 'Conta contábil', :with => '9.99'
      fill_in 'Título', :with => 'Bancos conta movimento'
      fill_in 'Função', :with => 'Registra a movimentação'
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

    click_button 'Salvar'

    expect(page).to have_notice 'Plano de Conta editado com sucesso.'

    click_link 'Bancos contas próprias'

    within_tab 'Principal' do
      expect(page).to have_field 'Configuração do plano de contas', :with => 'Segundo plano de MG'
      expect(page).to have_field 'Conta contábil', :with => '99.99'
      expect(page).to have_field 'Título', :with => 'Bancos contas próprias'
      expect(page).to have_field 'Função', :with => 'Registra movimentações de conta própria'
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
