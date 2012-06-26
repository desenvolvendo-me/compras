# encoding: utf-8
require 'spec_helper'

feature "ModalityLimits" do
  background do
    sign_in
  end

  scenario 'create a new modality_limit' do
    navigate_through 'Compras e Licitações > Cadastros Gerais > Limites por Modalidade'

    click_link 'Criar Limite por Modalidade'

    fill_in 'Número da portaria', :with => '0001'
    fill_in 'Início da validade', :with => '01/02/2012'
    fill_in 'Data de publicação', :with => '01/02/2012'

    within_fieldset 'Compras e serviços' do
      fill_in 'Dispensa de licitação', :with => '100,00'
      fill_in 'Carta convite', :with => '200,00'
      fill_in 'Tomada de preço', :with => '300,00'
      fill_in 'Concorrência pública', :with => '400,00'
    end

    within_fieldset 'Obras e serviços de engenharia' do
      fill_in 'Dispensa de licitação', :with => '101,00'
      fill_in 'Carta convite', :with => '201,00'
      fill_in 'Tomada de preço', :with => '301,00'
      fill_in 'Concorrência pública', :with => '401,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Limite por Modalidade criado com sucesso.'

    click_link '0001'

    page.should have_field 'Número da portaria', :with => '0001'
    page.should have_field 'Início da validade', :with => '01/02/2012'
    page.should have_field 'Data de publicação', :with => '01/02/2012'

    within_fieldset 'Compras e serviços' do
      page.should have_field 'Dispensa de licitação', :with => '100,00'
      page.should have_field 'Carta convite', :with => '200,00'
      page.should have_field 'Tomada de preço', :with => '300,00'
      page.should have_field 'Concorrência pública', :with => '400,00'
    end

    within_fieldset 'Obras e serviços de engenharia' do
      page.should have_field 'Dispensa de licitação', :with => '101,00'
      page.should have_field 'Carta convite', :with => '201,00'
      page.should have_field 'Tomada de preço', :with => '301,00'
      page.should have_field 'Concorrência pública', :with => '401,00'
    end
  end

  scenario 'update an existent modality_limit' do
    ModalityLimit.make!(:modalidade_de_compra)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Limites por Modalidade'

    click_link '0001'

    fill_in 'Número da portaria', :with => '0003'
    fill_in 'Início da validade', :with => '01/04/2012'
    fill_in 'Data de publicação', :with => '01/03/2012'

    within_fieldset 'Compras e serviços' do
      fill_in 'Dispensa de licitação', :with => '150,00'
      fill_in 'Carta convite', :with => '250,00'
      fill_in 'Tomada de preço', :with => '350,00'
      fill_in 'Concorrência pública', :with => '450,00'
    end

    within_fieldset 'Obras e serviços de engenharia' do
      fill_in 'Dispensa de licitação', :with => '151,00'
      fill_in 'Carta convite', :with => '251,00'
      fill_in 'Tomada de preço', :with => '351,00'
      fill_in 'Concorrência pública', :with => '451,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Limite por Modalidade editado com sucesso.'

    click_link '0003'

    page.should have_field 'Número da portaria', :with => '0003'
    page.should have_field 'Início da validade', :with => '01/04/2012'
    page.should have_field 'Data de publicação', :with => '01/03/2012'

    within_fieldset 'Compras e serviços' do
      page.should have_field 'Dispensa de licitação', :with => '150,00'
      page.should have_field 'Carta convite', :with => '250,00'
      page.should have_field 'Tomada de preço', :with => '350,00'
      page.should have_field 'Concorrência pública', :with => '450,00'
    end

    within_fieldset 'Obras e serviços de engenharia' do
      page.should have_field 'Dispensa de licitação', :with => '151,00'
      page.should have_field 'Carta convite', :with => '251,00'
      page.should have_field 'Tomada de preço', :with => '351,00'
      page.should have_field 'Concorrência pública', :with => '451,00'
    end
  end

  scenario 'destroy an existent modality_limit' do
    ModalityLimit.make!(:modalidade_de_compra)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Limites por Modalidade'

    click_link '0001'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Limite por Modalidade apagado com sucesso.'

    page.should_not have_content '0001'
    page.should_not have_content '01/02/2012'
    page.should_not have_content '02/03/2012'
  end

  scenario 'destroy an existent modality_limit' do
    ModalityLimit.make!(:modalidade_de_compra)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Limites por Modalidade'

    click_link 'Criar Limite por Modalidade'

    fill_in 'Número da portaria', :with => '0001'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end
end
