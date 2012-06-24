# encoding: utf-8
require 'spec_helper'

feature "GovernmentActions" do
  background do
    sign_in
  end

  scenario 'create a new government_action' do
    Descriptor.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Ações do Governo'

    click_link 'Criar Ação do Governo'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Ação Governamental'
    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    page.should have_notice 'Ação do Governo criada com sucesso.'

    click_link 'Ação Governamental'

    page.should have_field 'Descritor', :with => '2012 - Detran'
    page.should have_field 'Descrição', :with => 'Ação Governamental'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent government_action' do
    GovernmentAction.make!(:governamental)
    Descriptor.make!(:secretaria_de_educacao_2011)

    click_link 'Contabilidade'

    click_link 'Ações do Governo'

    click_link 'Ação Governamental'

    fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Ação Estatal'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Ação do Governo editada com sucesso.'

    click_link 'Ação Estatal'

    page.should have_field 'Descritor', :with => '2011 - Secretaria de Educação'
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
