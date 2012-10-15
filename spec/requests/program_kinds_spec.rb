# encoding: utf-8
require 'spec_helper'

feature "ProgramKinds" do
  background do
    sign_in
  end

  scenario 'create a new program_kind' do
    navigate 'Cadastros Gerais > Tipos de Programas'

    click_link 'Criar Tipo de Programa'

    fill_in 'Especificação', :with => 'Gestão de Políticas Públicas'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Programa criado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Especificação', :with => 'Gestão de Políticas Públicas'
  end

  scenario 'update an existing program_kind' do
    ProgramKind.make!(:apoio_administrativo)

    navigate 'Cadastros Gerais > Tipos de Programas'

    within_records do
      page.find('a').click
    end

    fill_in 'Especificação', :with => 'Gestão de Políticas Públicas'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Programa editado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Especificação', :with => 'Gestão de Políticas Públicas'
  end

  scenario 'destroy and existing program_kind' do
    ProgramKind.make!(:apoio_administrativo)

    navigate 'Cadastros Gerais > Tipos de Programas'

    click_link 'Apoio Administrativo'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Programa apagado com sucesso.'

    expect(page).to_not have_link 'Apoio Administrativo'
  end
end
