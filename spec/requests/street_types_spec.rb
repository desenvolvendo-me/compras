# encoding: utf-8
require 'spec_helper'

feature "StreetTypes" do
  background do
    sign_in
  end

  scenario 'create a new street type' do
    navigate 'Cadastros Gerais > Endereços > Tipos de Logradouros'

    click_link 'Criar Tipo de Logradouro'

    fill_in 'Nome', :with => 'Alameda'
    fill_in 'Sigla', :with => 'ALA'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Logradouro criado com sucesso.'

    click_link 'Alameda'

    expect(page).to have_field 'Nome', :with => 'Alameda'
    expect(page).to have_field 'Sigla', :with => 'ALA'
  end

  scenario 'update a street type' do
    StreetType.make!(:rua)

    navigate 'Cadastros Gerais > Endereços > Tipos de Logradouros'

    click_link 'Rua'

    fill_in 'Nome', :with => 'Travessa'

    fill_in 'Sigla', :with => 'TRA'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Logradouro editado com sucesso.'

    click_link 'Travessa'

    expect(page).to have_field 'Nome', :with => 'Travessa'
    expect(page).to have_field 'Sigla', :with => 'TRA'
  end

  scenario 'destroy a street type' do
    StreetType.make!(:rua)

    navigate 'Cadastros Gerais > Endereços > Tipos de Logradouros'

    click_link 'Rua'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Logradouro apagado com sucesso.'

    expect(page).to_not have_content 'Rua'
  end
end
