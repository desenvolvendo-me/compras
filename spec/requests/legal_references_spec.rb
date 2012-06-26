# encoding: utf-8
require 'spec_helper'

feature "LegalReferences" do
  background do
    sign_in
  end

  scenario 'create a new legal_reference' do
    navigate_through 'Outros > Referências Legais'

    click_link 'Criar Referência Legal'

    fill_in 'Descrição', :with => 'Referencia'
    fill_in 'Lei', :with => '001'
    fill_in 'Artigo', :with => '002'
    fill_in 'Parágrafo', :with => '003'
    fill_in 'Incisos', :with => '004'
    fill_in 'Sinopse', :with => 'resumo'

    click_button 'Salvar'

    page.should have_notice 'Referência Legal criada com sucesso.'

    click_link 'Referencia'

    page.should have_field 'Descrição', :with => 'Referencia'
    page.should have_field 'Lei', :with => '001'
    page.should have_field 'Artigo', :with => '002'
    page.should have_field 'Parágrafo', :with => '003'
    page.should have_field 'Incisos', :with => '004'
    page.should have_field 'Sinopse', :with => 'resumo'
  end

  scenario 'update an existent legal_reference' do
    LegalReference.make!(:referencia)

    navigate_through 'Outros > Referências Legais'

    click_link 'Referencia'

    fill_in 'Descrição', :with => 'Nova Referencia'
    fill_in 'Lei', :with => '101'
    fill_in 'Artigo', :with => '102'
    fill_in 'Parágrafo', :with => '103'
    fill_in 'Incisos', :with => '104'
    fill_in 'Sinopse', :with => 'novo resumo'

    click_button 'Salvar'

    page.should have_notice 'Referência Legal editada com sucesso.'

    click_link 'Nova Referencia'

    page.should have_field 'Descrição', :with => 'Nova Referencia'
    page.should have_field 'Lei', :with => '101'
    page.should have_field 'Artigo', :with => '102'
    page.should have_field 'Parágrafo', :with => '103'
    page.should have_field 'Incisos', :with => '104'
    page.should have_field 'Sinopse', :with => 'novo resumo'
  end

  scenario 'destroy an existent legal_reference' do
    LegalReference.make!(:referencia)

    navigate_through 'Outros > Referências Legais'

    click_link 'Referencia'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Referência Legal apagada com sucesso.'

    page.should_not have_content 'Referencia'
    page.should_not have_content '001'
    page.should_not have_content '002'
    page.should_not have_content '003'
    page.should_not have_content '004'
  end
end
