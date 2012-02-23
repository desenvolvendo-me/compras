# encoding: utf-8
require 'spec_helper'

feature "MaterialsTypes" do
  background do
    sign_in
  end

  scenario 'create a new material_type' do
    click_link 'Contabilidade'

    click_link 'Tipos de Bens'

    click_link 'Criar Tipo de Bem'

    fill_in 'Descrição', :with => 'Mesa'

    click_button 'Criar Tipo de Bem'

    page.should have_notice 'Tipo de Bem criado com sucesso.'

    click_link 'Mesa'

    page.should have_field 'Descrição', :with => 'Mesa'
  end

  scenario 'update an existent material_type' do
    MaterialsType.make!(:mesa)

    click_link 'Contabilidade'

    click_link 'Tipos de Bens'

    click_link 'Mesa'

    fill_in 'Descrição', :with => 'Apartamento'

    click_button 'Atualizar Tipo de Bem'

    page.should have_notice 'Tipo de Bem editado com sucesso.'

    click_link 'Apartamento'

    page.should have_field 'Descrição', :with => 'Apartamento'
  end

  scenario 'destroy an existent material_type' do
    MaterialsType.make!(:mesa)

    click_link 'Contabilidade'

    click_link 'Tipos de Bens'

    click_link 'Mesa'

    click_link 'Apagar Mesa', :confirm => true

    page.should have_notice 'Tipo de Bem apagado com sucesso.'

    page.should_not have_content 'Mesa'
  end
end
