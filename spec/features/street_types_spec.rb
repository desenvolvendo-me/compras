# encoding: utf-8
require 'spec_helper'

feature "StreetTypes" do
  background do
    sign_in
  end

  scenario 'create a new street type, update and destroy an existing' do
    navigate 'Geral > Parâmetros > Endereços > Tipos de Logradouros'

    click_link 'Criar Tipo de Logradouro'

    fill_in 'Nome', :with => 'Alameda'
    fill_in 'Sigla', :with => 'ALA'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Logradouro criado com sucesso.'

    click_link 'Alameda'

    expect(page).to have_field 'Nome', :with => 'Alameda'
    expect(page).to have_field 'Sigla', :with => 'ALA'

    fill_in 'Nome', :with => 'Travessa'
    fill_in 'Sigla', :with => 'TRA'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Logradouro editado com sucesso.'

    click_link 'Travessa'

    expect(page).to have_field 'Nome', :with => 'Travessa'
    expect(page).to have_field 'Sigla', :with => 'TRA'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Logradouro apagado com sucesso.'

    expect(page).to_not have_content 'Travessa'
  end

  scenario 'index with columns at the index' do
    navigate 'Geral > Parâmetros > Endereços > Tipos de Logradouros'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Sigla'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Avenida'
        expect(page).to have_content 'AVE'
      end
    end
  end
end
