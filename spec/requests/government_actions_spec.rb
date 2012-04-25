# encoding: utf-8
require 'spec_helper'

feature "GovernmentActions" do
  background do
    sign_in
  end

  scenario 'create a new government_action' do
    Entity.make!(:detran)

    click_link 'Contabilidade'

    click_link 'Ações do Governo'

    click_link 'Criar Ação do Governo'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_in 'Descrição', :with => 'Ação Governamental'
    select 'Ativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Ação do Governo criada com sucesso.'

    click_link 'Ação Governamental'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Descrição', :with => 'Ação Governamental'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent government_action' do
    GovernmentAction.make!(:governamental)
    Entity.make!(:secretaria_de_educacao)

    click_link 'Contabilidade'

    click_link 'Ações do Governo'

    click_link 'Ação Governamental'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Exercício', :with => '2011'
    fill_in 'Descrição', :with => 'Ação Estatal'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Ação do Governo editada com sucesso.'

    click_link 'Ação Estatal'

    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Exercício', :with => '2011'
    page.should have_field 'Descrição', :with => 'Ação Estatal'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent government_action' do
    GovernmentAction.make!(:governamental)

    click_link 'Contabilidade'

    click_link 'Ações do Governo'

    click_link 'Ação Governamental'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Ação do Governo apagada com sucesso.'

    page.should_not have_content 'Ação Governamental'
    page.should_not have_content '2012'
  end
end
