# encoding: utf-8
require 'spec_helper'

feature "Creditors" do
  background do
    sign_in
  end

  scenario 'create a new creditor' do
    Entity.make!(:detran)

    click_link 'Contabilidade'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_in 'Nome', :with => 'Nohup LTDA.'
    fill_modal 'Entidade', :with => 'Detran'
    select 'Ativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Nohup LTDA.'

    page.should have_field 'Nome', :with => 'Nohup LTDA.'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent creditor' do
    Entity.make!(:secretaria_de_educacao)
    Creditor.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Credores'

    click_link 'Nohup LTDA.'

    fill_in 'Nome', :with => 'Nobe'
    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Nobe'

    page.should have_field 'Nome', :with => 'Nobe'
    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent creditor' do
    Creditor.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Credores'

    click_link 'Nohup LTDA.'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Credor apagado com sucesso.'

    page.should_not have_field 'Nome', :with => 'Nohup LTDA.'
    page.should_not have_field 'Entidade', :with => 'Detran'
    page.should_not have_select 'Status', :selected => 'Ativo'
  end
end
