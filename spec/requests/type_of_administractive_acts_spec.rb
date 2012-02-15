# encoding: utf-8
require 'spec_helper'

feature "TypeOfAdministractiveActs" do
  background do
    sign_in
  end

  scenario 'create a new type_of_administractive_act' do
    AdministractiveActTypeClassification.make!(:primeiro_tipo)

    click_link 'Contabilidade'

    click_link 'Tipos de Ato Administrativo'

    click_link 'Criar Tipo de Ato Administrativo'

    fill_modal 'Classificação do tipo de ato administrativo', :with => 'Tipo 01', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Lei'

    click_button 'Criar Tipo de Ato Administrativo'

    page.should have_notice 'Tipo de Ato Administrativo criado com sucesso.'

    click_link 'Lei'

    page.should have_field 'Classificação do tipo de ato administrativo', :with => 'Tipo 01'
    page.should have_field 'Descrição', :with => 'Lei'
  end

  scenario 'validates uniqueness of description' do
    TypeOfAdministractiveAct.make!(:lei)

    click_link 'Contabilidade'

    click_link 'Tipos de Ato Administrativo'

    click_link 'Criar Tipo de Ato Administrativo'

    fill_in 'Descrição', :with => 'Lei'

    click_button 'Criar Tipo de Ato Administrativo'

    page.should_not have_notice 'Tipo de Ato Administrativo criado com sucesso.'

    page.should have_content 'já está em uso'
  end

  scenario 'update an existent type_of_administractive_act' do
    TypeOfAdministractiveAct.make!(:lei)
    AdministractiveActTypeClassification.make!(:segundo_tipo)

    click_link 'Contabilidade'

    click_link 'Tipos de Ato Administrativo'

    click_link 'Lei'

    fill_modal 'Classificação do tipo de ato administrativo', :with => 'Tipo 02', :field => 'Descrição'
    fill_in 'Descrição', :with => 'Outra Lei'

    click_button 'Atualizar Tipo de Ato Administrativo'

    page.should have_notice 'Tipo de Ato Administrativo editado com sucesso.'

    click_link 'Outra Lei'

    page.should have_field 'Classificação do tipo de ato administrativo', :with => 'Tipo 02'
    page.should have_field 'Descrição', :with => 'Outra Lei'
  end

  scenario 'destroy an existent type_of_administractive_act' do
    TypeOfAdministractiveAct.make!(:lei)

    click_link 'Contabilidade'

    click_link 'Tipos de Ato Administrativo'

    click_link 'Lei'

    click_link 'Apagar Lei', :confirm => true

    page.should have_notice 'Tipo de Ato Administrativo apagado com sucesso.'

    page.should_not have_content 'Lei'
  end
end
