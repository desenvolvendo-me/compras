# encoding: utf-8
require 'spec_helper'

feature "AccountPlanConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new account_plan_configuration' do
    make_dependencies!

    navigate 'Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Criar Configuração de Plano de Contas'

    fill_in 'Ano de exercício', :with => '2012'
    fill_modal 'Estado', :with => 'Minas Gerais'
    fill_in 'Descrição', :with => 'Plano1'

    click_button 'Adicionar Estrutura'
    within 'div.nested-account-plan-level:first' do
      fill_in 'Nível', :with => '1'
      fill_in 'Descrição', :with => 'Órgão'
      fill_in 'Dígitos', :with => '2'
      select 'Ponto', :from => 'Separador'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Plano de Contas criado com sucesso.'

    click_link 'Plano1'

    expect(page).to have_field 'Ano de exercício', :with => '2012'
    expect(page).to have_field 'Estado', :with => 'Minas Gerais'
    expect(page).to have_field 'Descrição', :with => 'Plano1'

    within 'div.nested-account-plan-level:first' do
      expect(page).to have_field 'Descrição', :with => 'Órgão'
      expect(page).to have_field 'Dígitos', :with => '2'
      expect(page).to have_select 'Separador', :selected => 'Ponto'
    end
  end

  scenario 'calculate mask with javascript' do
    navigate 'Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Criar Configuração de Plano de Contas'

    click_button 'Adicionar Estrutura'

    fill_in 'Nível', :with => '2'

    fill_in 'Dígitos', :with => '2'

    click_button 'Adicionar Estrutura'
    within 'div.nested-account-plan-level:last' do
      fill_in 'Nível', :with => '1'

      fill_in 'Dígitos', :with => '3'

      select 'Ponto', :from => 'Separador'
    end

    expect(page).to have_field 'Máscara', :with => '999.99'

    within 'div.nested-account-plan-level:last' do
      click_button 'Remover'
    end

    expect(page).to have_field 'Máscara', :with => '99'
  end

  scenario 'update an existent account_plan_configuration' do
    make_dependencies!

    AccountPlanConfiguration.make!(:plano1)

    navigate 'Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Plano1'

    fill_in 'Ano de exercício', :with => '2013'

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Plano de Contas editado com sucesso.'

    click_link 'Plano1'

    expect(page).to have_field 'Ano de exercício', :with => '2013'
    expect(page).to have_field 'Estado', :with => 'Minas Gerais'
    expect(page).to have_field 'Descrição', :with => 'Plano1'
  end

  scenario 'destroy an existent account_plan_configuration' do
    AccountPlanConfiguration.make!(:plano1)

    navigate 'Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Plano1'

    click_link 'Apagar'

    expect(page).to have_notice 'Configuração de Plano de Contas apagado com sucesso.'

    expect(page).to_not have_content '2012'
    expect(page).to_not have_content 'Minas Gerais'
    expect(page).to_not have_content 'Plano1'
  end

  scenario 'when submit a form with errors should return all levels' do
    navigate 'Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Criar Configuração de Plano de Contas'

    click_button 'Adicionar Estrutura'

    within 'div.nested-account-plan-level' do
      fill_in 'Nível', :with => '1'
      fill_in 'Descrição', :with => 'Uso interno'
      fill_in 'Dígitos', :with => '2'
      select 'Ponto', :from => 'Separador'
    end

    click_button 'Adicionar Estrutura'

    within 'div.nested-account-plan-level:nth-child(2)' do
      fill_in 'Nível', :with => '2'
      fill_in 'Descrição', :with => 'Indicador de quantidade'
      fill_in 'Dígitos', :with => '2'
      select 'Barra', :from => 'Separador'
    end

    click_button 'Adicionar Estrutura'

    within 'div.nested-account-plan-level:nth-child(3)' do
      fill_in 'Nível', :with => '3'
      fill_in 'Descrição', :with => 'Uso do fonecedor'
      fill_in 'Dígitos', :with => '2'
    end

    click_button 'Salvar'

    within 'div.nested-account-plan-level:nth-child(1)' do
      expect(page).to have_field 'Nível', :with => '1'
      expect(page).to have_field 'Descrição', :with => 'Uso interno'
      expect(page).to have_field 'Dígitos', :with => '2'
      expect(page).to have_select 'Separador', :selected => 'Ponto'
    end

    within 'div.nested-account-plan-level:nth-child(2)' do
      expect(page).to have_field 'Nível', :with => '2'
      expect(page).to have_field 'Descrição', :with => 'Indicador de quantidade'
      expect(page).to have_field 'Dígitos', :with => '2'
      expect(page).to have_select 'Separador', :selected => 'Barra'
    end

    within 'div.nested-account-plan-level:nth-child(3)' do
      expect(page).to have_field 'Nível', :with => '3'
      expect(page).to have_field 'Descrição', :with => 'Uso do fonecedor'
      expect(page).to have_field 'Dígitos', :with => '2'
    end
  end

  scenario 'when add duplicated level should show error' do
    navigate 'Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Criar Configuração de Plano de Contas'

    click_button 'Adicionar Estrutura'

    within 'div.nested-account-plan-level' do
      fill_in 'Nível', :with => '1'
      fill_in 'Descrição', :with => 'Uso interno'
      fill_in 'Dígitos', :with => '2'
      select 'Ponto', :from => 'Separador'
    end

    click_button 'Adicionar Estrutura'

    within 'div.nested-account-plan-level:nth-child(2)' do
      fill_in 'Nível', :with => '1'
      fill_in 'Descrição', :with => 'Indicador de quantidade'
      fill_in 'Dígitos', :with => '2'
      select 'Barra', :from => 'Separador'
    end

    click_button 'Salvar'

    within 'div.nested-account-plan-level:nth-child(2)' do
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'when add duplicated level should show error using javascript' do
    navigate 'Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Criar Configuração de Plano de Contas'

    click_button 'Adicionar Estrutura'

    within 'div.nested-account-plan-level' do
      fill_in 'Nível', :with => '1'
      fill_in 'Descrição', :with => 'Uso interno'
      fill_in 'Dígitos', :with => '2'
      select 'Ponto', :from => 'Separador'
    end

    click_button 'Adicionar Estrutura'

    within 'div.nested-account-plan-level:nth-child(2)' do
      fill_in 'Nível', :with => '1'
      fill_in 'Descrição', :with => 'Indicador de quantidade'
      fill_in 'Dígitos', :with => '2'
      select 'Barra', :from => 'Separador'

      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'when remove a level should not generate error for duplicated level' do
    AccountPlanConfiguration.make!(:segundo_plano)

    navigate 'Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Segundo plano de MG'

    within 'div.nested-account-plan-level:nth-child(1)' do
      click_button 'Remover'
    end

    click_button 'Adicionar Estrutura'

    within 'div.nested-account-plan-level:nth-child(3)' do
      fill_in 'Nível', :with => '2'
      fill_in 'Descrição', :with => 'Indicador de quantidade'
      fill_in 'Dígitos', :with => '4'
      select 'Barra', :from => 'Separador'

      expect(page).to_not have_content 'já está em uso'
    end
  end

  def make_dependencies!
    State.make!(:mg)
  end
end
