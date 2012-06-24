# encoding: utf-8
require 'spec_helper'

feature "GovernmentPrograms" do
  background do
    sign_in
  end

  scenario 'create a new government_program' do
    Descriptor.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Programas do Governo'

    click_link 'Criar Programa do Governo'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Habitação'
    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    page.should have_notice 'Programa do Governo criado com sucesso.'

    click_link 'Habitação'

    page.should have_field 'Descritor', :with => '2012 - Detran'
    page.should have_field 'Descrição', :with => 'Habitação'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent government_program' do
    GovernmentProgram.make!(:habitacao)
    Descriptor.make!(:secretaria_de_educacao_2013)

    click_link 'Contabilidade'

    click_link 'Programas do Governo'

    click_link 'Habitação'

    fill_modal 'Descritor', :with => '2013', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Educação'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Programa do Governo editado com sucesso.'

    click_link 'Educação'

    page.should have_field 'Descritor', :with => '2013 - Secretaria de Educação'
    page.should have_field 'Descrição', :with => 'Educação'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent government_program' do
    GovernmentProgram.make!(:habitacao)

    click_link 'Contabilidade'

    click_link 'Programas do Governo'

    click_link 'Habitação'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Programa do Governo apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '2012'
    page.should_not have_content 'Habitação'
    page.should_not have_content 'Ativo'
  end
end
