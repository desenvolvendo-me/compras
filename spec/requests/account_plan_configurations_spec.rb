# encoding: utf-8
require 'spec_helper'

feature "AccountPlanConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new account_plan_configuration' do
    make_dependencies!

    navigate 'Contabilidade > Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Criar Configuração de Plano de Contas'

    fill_in 'Ano de exercício', :with => '2012'
    fill_modal 'Estado', :with => 'Minas Gerais'
    fill_in 'Descrição', :with => 'Plano1'

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Plano de Contas criado com sucesso.'

    click_link 'Plano1'

    expect(page).to have_field 'Ano de exercício', :with => '2012'
    expect(page).to have_field 'Estado', :with => 'Minas Gerais'
    expect(page).to have_field 'Descrição', :with => 'Plano1'
  end

  scenario 'update an existent account_plan_configuration' do
    make_dependencies!

    AccountPlanConfiguration.make!(:plano1)

    navigate 'Contabilidade > Comum > Plano de Contas > Configurações de Plano de Contas'

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

    navigate 'Contabilidade > Comum > Plano de Contas > Configurações de Plano de Contas'

    click_link 'Plano1'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Configuração de Plano de Contas apagado com sucesso.'

    expect(page).to_not have_content '2012'
    expect(page).to_not have_content 'Minas Gerais'
    expect(page).to_not have_content 'Plano1'
  end

  def make_dependencies!
    State.make!(:mg)
  end
end
