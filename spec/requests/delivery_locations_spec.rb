# encoding: utf-8
require 'spec_helper'

feature "DeliveryLocations" do
  background do
    sign_in
  end

  scenario 'create a new delivery_location' do
    Address.make!(:general)

    navigate 'Comum > Locais de Entrega'

    click_link 'Criar Local de Entrega'

    fill_in 'Descrição', :with => 'Secretaria da Educação'
    fill_modal 'Logradouro', :with => 'Girassol'
    fill_in 'Número', :with => '13'
    fill_in 'Bloco', :with => '20'
    fill_in 'Sala/Apartamento', :with => '202'
    fill_in 'Complemento', :with => 'Perto da prefeitura'
    fill_modal 'Bairro', :with => 'São Francisco'
    fill_modal 'Condomínio', :with => 'Parque das Flores'
    fill_modal 'Loteamento', :with => 'Solar da Serra'

    expect(page).to have_field "Cidade", :with => 'Curitiba'
    expect(page).to have_field "Distrito", :with => ''

    fill_in 'CEP', :with => '88900-000'

    expect(page).to have_field "Estado", :with => 'Parana'

    click_button 'Salvar'

    expect(page).to have_notice 'Local de Entrega criado com sucesso.'

    click_link 'Secretaria da Educação'

    expect(page).to have_field 'Descrição', :with => 'Secretaria da Educação'
    expect(page).to have_field 'Logradouro', :with => 'Rua Girassol'
    expect(page).to have_field 'Número', :with => '13'
    expect(page).to have_field 'Bloco', :with => '20'
    expect(page).to have_field 'Sala/Apartamento', :with => '202'
    expect(page).to have_field 'Complemento', :with => 'Perto da prefeitura'
    expect(page).to have_field 'Bairro', :with => 'São Francisco'
    expect(page).to have_field 'Condomínio', :with => 'Parque das Flores'
    expect(page).to have_field 'Loteamento', :with => 'Solar da Serra'
    expect(page).to have_field "Cidade", :with => 'Curitiba'
    expect(page).to have_field 'CEP', :with => '88900-000'
    expect(page).to have_field "Estado", :with => 'Parana'
  end

  scenario 'update an existent delivery_location' do
    Address.make!(:general)
    DeliveryLocation.make!(:education)

    navigate 'Comum > Locais de Entrega'

    click_link 'Secretaria da Educação'

    fill_in 'Descrição', :with => 'Secretaria da Saúde'
    fill_modal 'Logradouro', :with => 'Girassol'
    fill_in 'Número', :with => '13'
    fill_in 'Bloco', :with => '20'
    fill_in 'Sala/Apartamento', :with => '202'
    fill_in 'Complemento', :with => 'Perto da prefeitura'
    fill_modal 'Bairro', :with => 'São Francisco'
    fill_modal 'Condomínio', :with => 'Parque das Flores'
    fill_modal 'Loteamento', :with => 'Solar da Serra'

    expect(page).to have_field "Cidade", :with => 'Curitiba'

    fill_in 'CEP', :with => '88900-000'

    expect(page).to have_field "Estado", :with => 'Parana'

    click_button 'Salvar'

    expect(page).to have_notice 'Local de Entrega editado com sucesso.'

    click_link 'Secretaria da Saúde'

    expect(page).to have_field 'Descrição', :with => 'Secretaria da Saúde'
    expect(page).to have_field 'Logradouro', :with => 'Rua Girassol'
    expect(page).to have_field 'Número', :with => '13'
    expect(page).to have_field 'Bloco', :with => '20'
    expect(page).to have_field 'Sala/Apartamento', :with => '202'
    expect(page).to have_field 'Complemento', :with => 'Perto da prefeitura'
    expect(page).to have_field 'Bairro', :with => 'São Francisco'
    expect(page).to have_field 'Condomínio', :with => 'Parque das Flores'
    expect(page).to have_field 'Loteamento', :with => 'Solar da Serra'
    expect(page).to have_field "Cidade", :with => 'Curitiba'
    expect(page).to have_field 'CEP', :with => '88900-000'
    expect(page).to have_field "Estado", :with => 'Parana'
  end

  scenario 'destroy an existent delivery_location' do
    DeliveryLocation.make!(:education)

    navigate 'Comum > Locais de Entrega'

    click_link 'Secretaria da Educação'

    click_link 'Apagar'

    expect(page).to have_notice 'Local de Entrega apagado com sucesso.'

    expect(page).to_not have_content 'Secretaria da Educação'
  end

  scenario 'index with columns at the index' do
    DeliveryLocation.make!(:education)

    navigate 'Comum > Locais de Entrega'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Logradouro'
      expect(page).to have_content 'Número'

      within 'tbody tr' do
        expect(page).to have_content 'Secretaria da Educação'
        expect(page).to have_content 'Avenida Amazonas'
        expect(page).to have_content '3524'
      end
    end
  end
end
