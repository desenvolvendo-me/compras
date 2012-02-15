# encoding: utf-8
require 'spec_helper'

feature "AdministractiveActTypeClassifications" do
  background do
    sign_in
  end

  scenario 'create a new administractive_act_type_classification' do
    click_link 'Contabilidade'

    click_link 'Classificações de Tipo de Ato Administrativo'

    click_link 'Criar Classificação de Tipos de Ato Administrativo'

    fill_in 'Descrição', :with => 'description'

    click_button 'Criar Classificação de Tipos de Ato Administrativo'

    page.should have_notice 'Classificação de Tipos de Ato Administrativo criado com sucesso.'

    click_link 'description'

    page.should have_field 'Descrição', :with => 'description'
  end

  scenario 'validates uniqueness of description' do
    AdministractiveActTypeClassification.make!(:primeiro_tipo)

    click_link 'Contabilidade'

    click_link 'Classificações de Tipo de Ato Administrativo'

    click_link 'Criar Classificação de Tipos de Ato Administrativo'

    fill_in 'Descrição', :with => 'Tipo 01'

    click_button 'Criar Classificação de Tipos de Ato Administrativo'

    page.should_not have_notice 'Classificação Tipos de Ato Administrativo criado com sucesso.'

    page.should have_content 'já está em uso'
  end

  scenario 'update an existent administractive_act_type_classification' do
    AdministractiveActTypeClassification.make!(:primeiro_tipo)

    click_link 'Contabilidade'

    click_link 'Classificações de Tipo de Ato Administrativo'

    click_link 'Tipo 01'

    fill_in 'Descrição', :with => 'Segundo Tipo'

    click_button 'Atualizar Classificação de Tipos de Ato Administrativo'

    page.should have_notice 'Classificação de Tipos de Ato Administrativo editado com sucesso.'

    click_link 'Segundo Tipo'

    page.should have_field 'Descrição', :with => 'Segundo Tipo'
  end

  scenario 'destroy an existent administractive_act_type_classification' do
    AdministractiveActTypeClassification.make!(:primeiro_tipo)

    click_link 'Contabilidade'

    click_link 'Classificações de Tipo de Ato Administrativo'

    click_link 'Tipo 01'

    click_link 'Apagar Tipo 01', :confirm => true

    page.should have_notice 'Classificação de Tipos de Ato Administrativo apagado com sucesso.'

    page.should_not have_content 'description'
  end
end
