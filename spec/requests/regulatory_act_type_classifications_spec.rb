# encoding: utf-8
require 'spec_helper'

feature "RegulatoryActTypeClassifications" do
  background do
    sign_in
  end

  scenario 'create a new regulatory_act_type_classification' do
    navigate 'Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    click_link 'Criar Classificação de Tipos de Ato Regulamentador'

    fill_in 'Descrição', :with => 'description'

    click_button 'Salvar'

    expect(page).to have_notice 'Classificação de Tipos de Ato Regulamentador criada com sucesso.'

    click_link 'description'

    expect(page).to have_field 'Descrição', :with => 'description'
  end

  scenario 'update an existent regulatory_act_type_classification' do
    RegulatoryActTypeClassification.make!(:primeiro_tipo)

    navigate 'Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    click_link 'Tipo 01'

    fill_in 'Descrição', :with => 'Segundo Tipo'

    click_button 'Salvar'

    expect(page).to have_notice 'Classificação de Tipos de Ato Regulamentador editada com sucesso.'

    click_link 'Segundo Tipo'

    expect(page).to have_field 'Descrição', :with => 'Segundo Tipo'
  end

  scenario 'destroy an existent regulatory_act_type_classification' do
    RegulatoryActTypeClassification.make!(:primeiro_tipo)

    navigate 'Comum > Legislação > Ato Regulamentador > Classificações de Tipo de Ato Regulamentador'

    click_link 'Tipo 01'

    click_link 'Apagar'

    expect(page).to have_notice 'Classificação de Tipos de Ato Regulamentador apagada com sucesso.'

    expect(page).to_not have_content 'description'
  end
end
