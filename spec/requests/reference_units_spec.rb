# encoding: utf-8
require 'spec_helper'

feature "ReferenceUnits" do
  background do
    sign_in
  end

  scenario 'create a new reference_unit' do
    navigate 'Comum > Unidades de Referência'

    click_link 'Criar Unidade de Referência'

    fill_in 'Descrição', :with => 'Reais'
    fill_in 'Sigla', :with => 'R$'

    click_button 'Salvar'

    expect(page).to have_notice 'Unidade de Referência criada com sucesso.'

    click_link 'Reais'

    expect(page).to have_field 'Descrição', :with => 'Reais'
    expect(page).to have_field 'Sigla', :with => 'R$'
  end

  scenario 'update a reference_unit' do
    ReferenceUnit.make!(:metro)

    navigate 'Comum > Unidades de Referência'

    click_link 'Metro'

    fill_in 'Descrição', :with => 'Centímetro'
    fill_in 'Sigla', :with => 'cm'

    click_button 'Salvar'

    expect(page).to have_notice 'Unidade de Referência editada com sucesso.'

    click_link 'Centímetro'

    expect(page).to have_field 'Descrição', :with => 'Centímetro'
    expect(page).to have_field 'Sigla', :with => 'cm'
  end

  scenario 'destroy an existent reference_unit' do
    ReferenceUnit.make!(:metro)

    navigate 'Comum > Unidades de Referência'

    click_link 'Metro'

    click_link 'Apagar'

    expect(page).to have_notice 'Unidade de Referência apagada com sucesso.'

    expect(page).to_not have_content 'Metro'
  end

  scenario 'index with columns at the index' do
    ReferenceUnit.make!(:metro)

    navigate 'Comum > Unidades de Referência'

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
