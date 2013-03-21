# encoding: utf-8
require 'spec_helper'

feature "Streets" do
  background do
    sign_in
  end

  scenario 'create a new street, update and destroy an existing' do
    Neighborhood.make!(:centro)
    StreetType.make!(:rua)
    StreetType.make!(:avenida)

    navigate 'Geral > Parâmetros > Endereços > Logradouros'

    click_link 'Criar Logradouro'

    fill_in 'Nome', :with => 'Cristiano do O'
    fill_modal 'Tipo do logradouro', :with => 'Rua'
    fill_in 'Zona fiscal', :with => '000'
    fill_modal 'Cidade', :with => 'Belo Horizonte'
    fill_modal 'Bairro', :with => 'Centro'

    click_button 'Salvar'

    expect(page).to have_notice 'Logradouro criado com sucesso.'

    click_link 'Cristiano do O'

    expect(page).to have_field 'Nome', :with => 'Cristiano do O'
    expect(page).to have_field 'Tipo do logradouro', :with => 'Rua'
    expect(page).to have_field 'Zona fiscal', :with => '000'
    expect(page).to have_field 'Cidade', :with => 'Belo Horizonte'
    expect(page).to have_content 'Centro'

    fill_in 'Nome', :with => 'Cristiano do OO'
    fill_modal 'Tipo do logradouro', :with => 'Avenida'
    fill_in 'Zona fiscal', :with => '003'

    click_button 'Salvar'

    expect(page).to have_notice 'Logradouro editado com sucesso.'

    click_link 'Cristiano do OO'

    expect(page).to have_field 'Nome', :with => 'Cristiano do OO'
    expect(page).to have_field 'Tipo do logradouro', :with => 'Avenida'
    expect(page).to have_field 'Zona fiscal', :with => '003'
    expect(page).to have_field 'Cidade', :with => 'Belo Horizonte'
    expect(page).to have_content 'Centro'

    click_link 'Apagar'

    expect(page).to have_notice 'Logradouro apagado com sucesso.'

    expect(page).to_not have_content 'Cristiano do OO'
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

  scenario 'index with columns at the index' do
    Street.make!(:girassol)

    navigate 'Geral > Parâmetros > Endereços > Logradouros'

    within_records do
      expect(page).to have_content 'Nome do logradouro'
      expect(page).to have_content 'Tipo do logradouro'
      expect(page).to have_content 'Cidade'

      within 'tbody tr' do
        expect(page).to have_content 'Girassol'
        expect(page).to have_content 'Rua'
        expect(page).to have_content 'Belo Horizonte'
      end
    end
  end
end
