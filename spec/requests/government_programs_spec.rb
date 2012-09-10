# encoding: utf-8
require 'spec_helper'

feature "GovernmentPrograms" do
  background do
    sign_in
  end

  scenario 'create a new government_program' do
    Descriptor.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Programas do Governo'

    click_link 'Criar Programa do Governo'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Habitação'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    expect(page).to have_notice 'Programa do Governo criado com sucesso.'

    click_link 'Habitação'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Descrição', :with => 'Habitação'
    expect(page).to have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent government_program' do
    GovernmentProgram.make!(:habitacao)
    Descriptor.make!(:secretaria_de_educacao_2013)

    navigate 'Contabilidade > Orçamento > Programas do Governo'

    click_link 'Habitação'

    fill_modal 'Descritor', :with => '2013', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Educação'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    expect(page).to have_notice 'Programa do Governo editado com sucesso.'

    click_link 'Educação'

    expect(page).to have_field 'Descritor', :with => '2013 - Secretaria de Educação'
    expect(page).to have_field 'Descrição', :with => 'Educação'
    expect(page).to have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent government_program' do
    GovernmentProgram.make!(:habitacao)

    navigate 'Contabilidade > Orçamento > Programas do Governo'

    click_link 'Habitação'

    click_link 'Apagar'

    expect(page).to have_notice 'Programa do Governo apagado com sucesso.'

    expect(page).not_to have_content 'Detran'
    expect(page).not_to have_content '2012'
    expect(page).not_to have_content 'Habitação'
    expect(page).not_to have_content 'Ativo'
  end
end
