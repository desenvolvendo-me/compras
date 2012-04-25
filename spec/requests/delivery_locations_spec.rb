# encoding: utf-8
require 'spec_helper'

feature "DeliveryLocations" do
  background do
    sign_in
  end

  scenario 'create a new delivery_location' do
    Address.make!(:general)

    click_link 'Solicitações'

    click_link 'Locais de Entrega'

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

    page.should have_field "Cidade", :with => 'Curitiba'

    fill_mask 'CEP', :with => '88900-000'

    page.should have_field "Estado", :with => 'Parana'

    click_button 'Salvar'

    page.should have_notice 'Local de Entrega criado com sucesso.'

    click_link 'Secretaria da Educação'

    page.should have_field 'Descrição', :with => 'Secretaria da Educação'
    page.should have_field 'Logradouro', :with => 'Girassol'
    page.should have_field 'Número', :with => '13'
    page.should have_field 'Bloco', :with => '20'
    page.should have_field 'Sala/Apartamento', :with => '202'
    page.should have_field 'Complemento', :with => 'Perto da prefeitura'
    page.should have_field 'Bairro', :with => 'São Francisco'
    page.should have_field 'Condomínio', :with => 'Parque das Flores'
    page.should have_field 'Loteamento', :with => 'Solar da Serra'
    page.should have_field "Cidade", :with => 'Curitiba'
    page.should have_field 'CEP', :with => '88900-000'
    page.should have_field "Estado", :with => 'Parana'
  end

  scenario 'update an existent delivery_location' do
    Address.make!(:general)
    DeliveryLocation.make!(:education)

    click_link 'Solicitações'

    click_link 'Locais de Entrega'

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

    page.should have_field "Cidade", :with => 'Curitiba'

    fill_mask 'CEP', :with => '88900-000'

    page.should have_field "Estado", :with => 'Parana'

    click_button 'Salvar'

    page.should have_notice 'Local de Entrega editado com sucesso.'

    click_link 'Secretaria da Saúde'

    page.should have_field 'Descrição', :with => 'Secretaria da Saúde'
    page.should have_field 'Logradouro', :with => 'Girassol'
    page.should have_field 'Número', :with => '13'
    page.should have_field 'Bloco', :with => '20'
    page.should have_field 'Sala/Apartamento', :with => '202'
    page.should have_field 'Complemento', :with => 'Perto da prefeitura'
    page.should have_field 'Bairro', :with => 'São Francisco'
    page.should have_field 'Condomínio', :with => 'Parque das Flores'
    page.should have_field 'Loteamento', :with => 'Solar da Serra'
    page.should have_field "Cidade", :with => 'Curitiba'
    page.should have_field 'CEP', :with => '88900-000'
    page.should have_field "Estado", :with => 'Parana'
  end

  scenario 'destroy an existent delivery_location' do
    DeliveryLocation.make!(:education)

    click_link 'Solicitações'

    click_link 'Locais de Entrega'

    click_link 'Secretaria da Educação'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Local de Entrega apagado com sucesso.'

    page.should_not have_content 'Secretaria da Educação'
  end

  scenario 'create a new delivery_location' do
    DeliveryLocation.make!(:health)

    click_link 'Solicitações'

    click_link 'Locais de Entrega'

    click_link 'Criar Local de Entrega'

    fill_in 'Descrição', :with => 'Secretaria da Saúde'
    fill_modal 'Logradouro', :with => 'Girassol'
    fill_in 'Número', :with => '13'
    fill_in 'Bloco', :with => '20'
    fill_in 'Sala/Apartamento', :with => '202'
    fill_in 'Complemento', :with => 'Perto da prefeitura'
    fill_modal 'Bairro', :with => 'São Francisco'
    fill_modal 'Condomínio', :with => 'Parque das Flores'
    fill_modal 'Loteamento', :with => 'Solar da Serra'
    fill_mask 'CEP', :with => '88900-000'

    click_button 'Salvar'

    page.should have_content "já está em uso"
  end
end
