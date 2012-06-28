# encoding: utf-8
require 'spec_helper'

feature "Streets" do
  background do
    sign_in
  end

  scenario 'create a new street' do
    Neighborhood.make!(:centro)
    StreetType.make!(:rua)

    navigate_through 'Outros > Logradouros'

    click_link 'Criar Logradouro'

    fill_in 'Nome', :with => 'Cristiano do O'

    fill_modal 'Tipo do logradouro', :with => 'Rua'

    fill_in 'Zona fiscal', :with => '000'

    fill_modal 'Bairro', :with => 'Centro'
    page.should have_content "Bairro"

    click_button 'Salvar'

    page.should have_notice 'Logradouro criado com sucesso.'

    click_link 'Cristiano do O'

    page.should have_field 'Nome', :with => 'Cristiano do O'
    page.should have_field 'Tipo do logradouro', :with => 'Rua'
    page.should have_field 'Zona fiscal', :with => '000'
    page.should have_content 'Centro'
  end

  scenario 'update a street' do
    Neighborhood.make!(:portugal)
    StreetType.make!(:avenida)
    Street.make!(:girassol)

    navigate_through 'Outros > Logradouros'

    click_link 'Girassol'

    fill_in 'Nome', :with => 'Francisco de Assis'

    fill_modal 'Tipo do logradouro', :with => 'Avenida'

    fill_in 'Zona fiscal', :with => '003'

    fill_modal 'Bairro', :with => 'Portugal' 

    click_button 'Salvar'

    page.should have_notice 'Logradouro editado com sucesso.'

    click_link 'Francisco de Assis'

    page.should have_field 'Nome', :with => 'Francisco de Assis'
    page.should have_field 'Tipo do logradouro', :with => 'Avenida'
    page.should have_field 'Zona fiscal', :with => '003'
    page.should have_content 'Portugal'
  end

  scenario 'destroy a street' do
    pending 'awaiting a response from the issue https://github.com/jonleighton/poltergeist/issues/88'

    Street.make!(:girassol)

    navigate_through 'Outros > Logradouros'

    click_link 'Girassol'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Logradouro apagado com sucesso.'

    page.should_not have_content 'Girassol'
  end
end
