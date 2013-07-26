# encoding: utf-8
require 'spec_helper'

feature "ReferenceUnits" do
  background do
    sign_in
  end

  scenario 'create a new reference_unit, update and destroy an existing' do
    navigate 'Comum > Cadastrais > Materiais > Unidades de Medida'

    click_link 'Criar Unidade de Medida'

    fill_in 'Descrição', :with => 'Reais'
    fill_in 'Sigla', :with => 'R$'

    click_button 'Salvar'

    expect(page).to have_notice 'Unidade de Medida criada com sucesso.'

    click_link 'Reais'

    expect(page).to have_field 'Descrição', :with => 'Reais'
    expect(page).to have_field 'Sigla', :with => 'R$'

    fill_in 'Descrição', :with => 'Centímetro'
    fill_in 'Sigla', :with => 'cm'

    click_button 'Salvar'

    expect(page).to have_notice 'Unidade de Medida editada com sucesso.'

    click_link 'Centímetro'

    expect(page).to have_field 'Descrição', :with => 'Centímetro'
    expect(page).to have_field 'Sigla', :with => 'cm'

    click_link 'Apagar'

    expect(page).to have_notice 'Unidade de Medida apagada com sucesso.'

    expect(page).to_not have_content 'Centímetro'
  end

  scenario 'index with columns at the index' do
    navigate 'Comum > Cadastrais > Materiais > Unidades de Medida'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Sigla'

      within 'tbody tr' do
        expect(page).to have_content 'Metro'
        expect(page).to have_content 'M'
      end
    end
  end
end
