# encoding: utf-8
require 'spec_helper'

feature "GovernmentActions" do
  background do
    sign_in
  end

  scenario 'create a new government_action' do
    Descriptor.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Ações do Governo'

    click_link 'Criar Ação do Governo'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Ação Governamental'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    expect(page).to have_notice 'Ação do Governo criada com sucesso.'

    click_link 'Ação Governamental'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Descrição', :with => 'Ação Governamental'
    expect(page).to have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent government_action' do
    GovernmentAction.make!(:governamental)
    Descriptor.make!(:secretaria_de_educacao_2011)

    navigate 'Contabilidade > Orçamento > Ações do Governo'

    click_link 'Ação Governamental'

    fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Ação Estatal'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    expect(page).to have_notice 'Ação do Governo editada com sucesso.'

    click_link 'Ação Estatal'

    expect(page).to have_field 'Descritor', :with => '2011 - Secretaria de Educação'
    expect(page).to have_field 'Descrição', :with => 'Ação Estatal'
    expect(page).to have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent government_action' do
    GovernmentAction.make!(:governamental)

    navigate 'Contabilidade > Orçamento > Ações do Governo'

    click_link 'Ação Governamental'

    click_link 'Apagar'

    expect(page).to have_notice 'Ação do Governo apagada com sucesso.'

    expect(page).to_not have_content 'Ação Governamental'
    expect(page).to_not have_content '2012'
  end
end
