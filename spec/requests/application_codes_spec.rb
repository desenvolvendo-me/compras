# encoding: utf-8
require 'spec_helper'

feature "ApplicationCodes" do
  background do
    sign_in
  end

  scenario 'create a new application_code' do
    navigate 'Outros > Contabilidade > Orçamento > Recurso > Códigos de Aplicações'

    click_link 'Criar Código de Aplicação'

    fill_in 'Código', :with => '110'
    fill_in 'Nome', :with => 'Geral'
    fill_in 'Especificação', :with => 'Recursos próprios'
    expect(page).to have_disabled_field 'Fonte'
    expect(page).to have_select 'Fonte', :selected => 'Manual'

    click_button 'Salvar'

    expect(page).to have_notice 'Código de Aplicação criado com sucesso.'

    click_link 'Geral'

    expect(page).to have_field 'Código', :with => '110'
    expect(page).to_not have_checked_field 'Variável'
    expect(page).to have_field 'Nome', :with => 'Geral'
    expect(page).to have_field 'Especificação', :with => 'Recursos próprios'
    expect(page).to have_disabled_field 'Fonte'
    expect(page).to have_select 'Fonte', :selected => 'Manual'
  end

  context 'when validate uniqueness of code' do
    scenario 'should be invalid if with same variable'do
      ApplicationCode.make!(:geral)

      navigate 'Outros > Contabilidade > Orçamento > Recurso > Códigos de Aplicações'

      click_link 'Criar Código de Aplicação'

      fill_in 'Código', :with => '110'

      click_button 'Salvar'

      expect(page).to have_content 'já existe para a variável selecionada'
    end

    scenario 'should be invalid if with other variable'do
      ApplicationCode.make!(:geral)

      navigate 'Outros > Contabilidade > Orçamento > Recurso > Códigos de Aplicações'

      click_link 'Criar Código de Aplicação'
      check 'Variável'

      fill_in 'Código', :with => '110'

      click_button 'Salvar'

      expect(page).to_not have_content 'já está em uso'
    end
  end

  scenario 'update an existent application_code' do
    ApplicationCode.make!(:geral)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Códigos de Aplicações'

    click_link 'Geral'

    fill_in 'Código', :with => '220'
    check 'Variável'
    fill_in 'Nome', :with => 'Genérico'
    fill_in 'Especificação', :with => 'Recursos próprios da entidade'
    expect(page).to have_disabled_field 'Fonte'
    expect(page).to have_select 'Fonte', :selected => 'Manual'

    click_button 'Salvar'

    expect(page).to have_notice 'Código de Aplicação editado com sucesso.'

    click_link 'Genérico'

    expect(page).to have_field 'Código', :with => '220'
    expect(page).to have_checked_field 'Variável'
    expect(page).to have_field 'Nome', :with => 'Genérico'
    expect(page).to have_field 'Especificação', :with => 'Recursos próprios da entidade'
    expect(page).to have_disabled_field 'Fonte'
    expect(page).to have_select 'Fonte', :selected => 'Manual'
  end

  scenario 'destroy an existent application_code' do
    ApplicationCode.make!(:geral)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Códigos de Aplicações'

    click_link 'Geral'

    click_link 'Apagar'

    expect(page).to have_notice 'Código de Aplicação apagado com sucesso.'

    expect(page).to_not have_content 'Geral'
  end
end
