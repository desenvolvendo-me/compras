# encoding: utf-8
require 'spec_helper'

feature "StreetTypes" do
  background do
    sign_in
  end

  scenario 'create a new street type' do
    click_link 'Cadastros Diversos'

    click_link 'Tipos de Logradouros'

    click_link 'Criar Tipo de Logradouro'

    fill_in 'Nome', :with => 'Alameda'
    fill_in 'Sigla', :with => 'ALA'

    click_button 'Salvar'

    page.should have_notice 'Tipo de Logradouro criado com sucesso.'

    click_link 'Alameda'

    page.should have_field 'Nome', :with => 'Alameda'
    page.should have_field 'Sigla', :with => 'ALA'
  end

  scenario 'update a street type' do
    StreetType.make!(:rua)

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Logradouros'

    click_link 'Rua'

    fill_in 'Nome', :with => 'Travessa'

    fill_in 'Sigla', :with => 'TRA'

    click_button 'Salvar'

    page.should have_notice 'Tipo de Logradouro editado com sucesso.'

    click_link 'Travessa'

    page.should have_field 'Nome', :with => 'Travessa'
    page.should have_field 'Sigla', :with => 'TRA'
  end

  scenario 'destroy a street type' do
    StreetType.make!(:rua)

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Logradouros'

    click_link 'Rua'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Tipo de Logradouro apagado com sucesso.'

    page.should_not have_content 'Rua'
  end
end
