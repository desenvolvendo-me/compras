# encoding: utf-8
require 'spec_helper'

feature "ReferenceUnits" do
  background do
    sign_in
  end

  scenario 'create a new reference_unit' do
    navigate 'Compras e Licitações > Cadastros Gerais > Unidades de Referência'

    click_link 'Criar Unidade de Referência'

    fill_in 'Descrição', :with => 'Reais'
    fill_in 'Sigla', :with => 'R$'

    click_button 'Salvar'

    expect(page).to have_notice 'Unidade de Referência criada com sucesso.'

    click_link 'R$'

    expect(page).to have_field 'Descrição', :with => 'Reais'
    expect(page).to have_field 'Sigla', :with => 'R$'
  end

  scenario 'update a reference_unit' do
    ReferenceUnit.make!(:metro)

    navigate 'Compras e Licitações > Cadastros Gerais > Unidades de Referência'

    click_link 'M'

    fill_in 'Descrição', :with => 'Centímetro'
    fill_in 'Sigla', :with => 'cm'

    click_button 'Salvar'

    expect(page).to have_notice 'Unidade de Referência editada com sucesso.'

    click_link 'cm'

    expect(page).to have_field 'Descrição', :with => 'Centímetro'
    expect(page).to have_field 'Sigla', :with => 'cm'
  end

  scenario 'destroy an existent reference_unit' do
    ReferenceUnit.make!(:metro)

    navigate 'Compras e Licitações > Cadastros Gerais > Unidades de Referência'

    click_link 'M'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Unidade de Referência apagada com sucesso.'

    expect(page).not_to have_content 'Metro'
  end
end
