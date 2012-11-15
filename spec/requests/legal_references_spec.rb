# encoding: utf-8
require 'spec_helper'

feature "LegalReferences" do
  background do
    sign_in
  end

  scenario 'create a new legal_reference' do
    navigate 'Processo Administrativo/Licitatório > Auxiliar > Referências Legais'

    click_link 'Criar Referência Legal'

    fill_in 'Descrição', :with => 'Referencia'
    fill_in 'Lei', :with => '001'
    fill_in 'Artigo', :with => '002'
    fill_in 'Parágrafo', :with => '003'
    fill_in 'Incisos', :with => '004'
    fill_in 'Sinopse', :with => 'resumo'

    click_button 'Salvar'

    expect(page).to have_notice 'Referência Legal criada com sucesso.'

    click_link 'Referencia'

    expect(page).to have_field 'Descrição', :with => 'Referencia'
    expect(page).to have_field 'Lei', :with => '001'
    expect(page).to have_field 'Artigo', :with => '002'
    expect(page).to have_field 'Parágrafo', :with => '003'
    expect(page).to have_field 'Incisos', :with => '004'
    expect(page).to have_field 'Sinopse', :with => 'resumo'
  end

  scenario 'update an existent legal_reference' do
    LegalReference.make!(:referencia)

    navigate 'Processo Administrativo/Licitatório > Auxiliar > Referências Legais'

    click_link 'Referencia'

    fill_in 'Descrição', :with => 'Nova Referencia'
    fill_in 'Lei', :with => '101'
    fill_in 'Artigo', :with => '102'
    fill_in 'Parágrafo', :with => '103'
    fill_in 'Incisos', :with => '104'
    fill_in 'Sinopse', :with => 'novo resumo'

    click_button 'Salvar'

    expect(page).to have_notice 'Referência Legal editada com sucesso.'

    click_link 'Nova Referencia'

    expect(page).to have_field 'Descrição', :with => 'Nova Referencia'
    expect(page).to have_field 'Lei', :with => '101'
    expect(page).to have_field 'Artigo', :with => '102'
    expect(page).to have_field 'Parágrafo', :with => '103'
    expect(page).to have_field 'Incisos', :with => '104'
    expect(page).to have_field 'Sinopse', :with => 'novo resumo'
  end

  scenario 'destroy an existent legal_reference' do
    LegalReference.make!(:referencia)

    navigate 'Processo Administrativo/Licitatório > Auxiliar > Referências Legais'

    click_link 'Referencia'

    click_link 'Apagar'

    expect(page).to have_notice 'Referência Legal apagada com sucesso.'

    expect(page).to_not have_content 'Referencia'
    expect(page).to_not have_content '001'
    expect(page).to_not have_content '002'
    expect(page).to_not have_content '003'
    expect(page).to_not have_content '004'
  end
end
