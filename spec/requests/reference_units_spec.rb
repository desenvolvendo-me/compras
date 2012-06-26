# encoding: utf-8
require 'spec_helper'

feature "ReferenceUnits" do
  background do
    sign_in
  end

  scenario 'create a new reference_unit' do
    navigate_through 'Compras e Licitações > Cadastros Gerais > Unidades de Referência'

    click_link 'Criar Unidade de Referência'

    fill_in 'Descrição', :with => 'Reais'
    fill_in 'Sigla', :with => 'R$'

    click_button 'Salvar'

    page.should have_notice 'Unidade de Referência criada com sucesso.'

    click_link 'R$'

    page.should have_field 'Descrição', :with => 'Reais'
    page.should have_field 'Sigla', :with => 'R$'
  end

  scenario 'update a reference_unit' do
    ReferenceUnit.make!(:metro)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Unidades de Referência'

    click_link 'M'

    fill_in 'Descrição', :with => 'Centímetro'
    fill_in 'Sigla', :with => 'cm'

    click_button 'Salvar'

    page.should have_notice 'Unidade de Referência editada com sucesso.'

    click_link 'cm'

    page.should have_field 'Descrição', :with => 'Centímetro'
    page.should have_field 'Sigla', :with => 'cm'
  end

  scenario 'destroy an existent reference_unit' do
    ReferenceUnit.make!(:metro)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Unidades de Referência'

    click_link 'M'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Unidade de Referência apagada com sucesso.'

    page.should_not have_content 'Metro'
  end
end
