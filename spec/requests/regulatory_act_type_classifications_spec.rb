# encoding: utf-8
require 'spec_helper'

feature "RegulatoryActTypeClassifications" do
  background do
    sign_in
  end

  scenario 'create a new regulatory_act_type_classification, update and destroy an existing' do
    navigate 'Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    click_link 'Criar Classificação de Tipos de Ato Regulamentador'

    fill_in 'Descrição', :with => 'Descrição'

    click_button 'Salvar'

    expect(page).to have_notice 'Classificação de Tipos de Ato Regulamentador criada com sucesso.'

    click_link 'Descrição'

    expect(page).to have_field 'Descrição', :with => 'Descrição'

    fill_in 'Descrição', :with => 'Segundo Tipo'

    click_button 'Salvar'

    expect(page).to have_notice 'Classificação de Tipos de Ato Regulamentador editada com sucesso.'

    click_link 'Segundo Tipo'

    expect(page).to have_field 'Descrição', :with => 'Segundo Tipo'

    click_link 'Apagar'

    expect(page).to have_notice 'Classificação de Tipos de Ato Regulamentador apagada com sucesso.'

    expect(page).to_not have_content 'Segundo Tipo'
  end

  scenario 'index with columns at the index' do
    RegulatoryActTypeClassification.make!(:primeiro_tipo)

    navigate 'Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    within_records do
      expect(page).to have_content 'Descrição'

      within 'tbody tr' do
        expect(page).to have_content 'Tipo 01'
      end
    end
  end
end
