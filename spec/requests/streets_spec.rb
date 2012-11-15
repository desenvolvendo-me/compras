# encoding: utf-8
require 'spec_helper'

feature "Streets" do
  background do
    sign_in
  end

  scenario 'create a new street' do
    Neighborhood.make!(:centro)
    StreetType.make!(:rua)

    navigate 'Geral > Parâmetros > Endereços > Logradouros'

    click_link 'Criar Logradouro'

    fill_in 'Nome', :with => 'Cristiano do O'

    fill_modal 'Tipo do logradouro', :with => 'Rua'

    fill_in 'Zona fiscal', :with => '000'

    fill_modal 'Cidade', :with => 'Belo Horizonte'

    fill_modal 'Bairro', :with => 'Centro'
    expect(page).to have_content "Bairro"

    click_button 'Salvar'

    expect(page).to have_notice 'Logradouro criado com sucesso.'

    click_link 'Cristiano do O'

    expect(page).to have_field 'Nome', :with => 'Cristiano do O'
    expect(page).to have_field 'Tipo do logradouro', :with => 'Rua'
    expect(page).to have_field 'Zona fiscal', :with => '000'
    expect(page).to have_field 'Cidade', :with => 'Belo Horizonte'
    expect(page).to have_content 'Centro'
  end

  scenario 'update a street' do
    StreetType.make!(:avenida)
    Street.make!(:girassol)

    navigate 'Geral > Parâmetros > Endereços > Logradouros'

    click_link 'Girassol'

    fill_in 'Nome', :with => 'Francisco de Assis'

    fill_modal 'Tipo do logradouro', :with => 'Avenida'

    fill_in 'Zona fiscal', :with => '003'

    fill_modal 'Bairro', :with => 'São Francisco'

    click_button 'Salvar'

    expect(page).to have_notice 'Logradouro editado com sucesso.'

    click_link 'Francisco de Assis'

    expect(page).to have_field 'Nome', :with => 'Francisco de Assis'
    expect(page).to have_field 'Tipo do logradouro', :with => 'Avenida'
    expect(page).to have_field 'Zona fiscal', :with => '003'
    expect(page).to have_content 'São Francisco'
  end

  scenario 'destroy a street' do
    Street.make!(:girassol)

    navigate 'Geral > Parâmetros > Endereços > Logradouros'

    click_link 'Girassol'

    click_link 'Apagar'

    expect(page).to have_notice 'Logradouro apagado com sucesso.'

    expect(page).to_not have_content 'Girassol'
  end

  scenario 'should not allow more than one time neighborhood' do
    Neighborhood.make!(:centro)

    navigate 'Geral > Parâmetros > Endereços > Logradouros'

    click_link 'Criar Logradouro'

    fill_modal 'Bairro', :with => 'Centro'
    fill_modal 'Bairro', :with => 'Centro'

    expect(page).to have_content 'Centro'

    expect(page).to have_css 'tr.record', :count => 1
  end
end
