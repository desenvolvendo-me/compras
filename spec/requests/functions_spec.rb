# encoding: utf-8
require 'spec_helper'

feature "Functions" do
  background do
    sign_in
  end

  scenario 'create a new function' do
    AdministractiveAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Funções'

    click_link 'Criar Função'

    fill_in 'Código', :with => '04'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    fill_in 'Descrição', :with => 'Administração'

    click_button 'Criar Função'

    page.should have_notice 'Função criada com sucesso.'

    click_link '04'

    page.should have_field 'Código', :with => '04'
    page.should have_field 'Descrição', :with => 'Administração'
    page.should have_field 'Ato regulamentador', :with => '1234'
  end

  scenario 'update an existent function' do
    Function.make!(:administracao)
    AdministractiveAct.make!(:emenda)

    click_link 'Contabilidade'

    click_link 'Funções'

    click_link '04'

    fill_in 'Código', :with => '05'
    fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
    fill_in 'Descrição', :with => 'Execução'

    click_button 'Atualizar Função'

    page.should have_notice 'Função editada com sucesso.'

    click_link '05'

    page.should have_field 'Código', :with => '05'
    page.should have_field 'Descrição', :with => 'Execução'
    page.should have_field 'Ato regulamentador', :with => '4567'
  end

  scenario 'destroy an existent function' do
    Function.make!(:administracao)

    click_link 'Contabilidade'

    click_link 'Funções'

    click_link '04'

    click_link 'Apagar 04 - Administração', :confirm => true

    page.should have_notice 'Função apagada com sucesso.'

    page.should_not have_content '04'
    page.should_not have_content '1234'
  end

  scenario 'have error when have duplicated code of same administractive_act' do
    Function.make!(:administracao)

    click_link 'Contabilidade'

    click_link 'Funções'

    click_link 'Criar Função'

    fill_in 'Código', :with => '04'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    click_button 'Criar Função'

    page.should have_content 'já existe para o ato regulamentador informado'
  end

  scenario 'have not error when have duplicated code of other administractive_act' do
    Function.make!(:administracao)
    AdministractiveAct.make!(:emenda)

    click_link 'Contabilidade'

    click_link 'Funções'

    click_link 'Criar Função'

    fill_in 'Código', :with => '04'
    fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'

    click_button 'Criar Função'

    page.should_not have_content 'já existe para o ato regulamentador informado'
  end

  scenario 'should get and clean the vigor date depending on administractive act' do
    AdministractiveAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Funções'

    click_link 'Criar Função'

    page.should have_disabled_field 'Data da vigência do ato'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    page.should have_disabled_field 'Data da vigência do ato'
    page.should have_field 'Data da vigência do ato', :with => '03/01/2012'

    clear_modal 'Ato regulamentador'

    page.should have_disabled_field 'Data da vigência do ato'
    page.should have_field 'Data da vigência do ato', :with => ''
  end
end
