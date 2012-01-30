# encoding: utf-8
require 'spec_helper'

feature "MaterialsGroups" do
  background do
    sign_in
  end

  scenario 'create a new materials_group' do
    click_link 'Cadastros Diversos'

    click_link 'Grupos de Materiais'

    click_link 'Criar Grupo de Materiais'

    fill_in 'Grupo', :with => '01'
    fill_in 'Nome', :with => 'Generos alimenticios'

    click_button 'Criar Grupo de Materiais'

    page.should have_notice 'Grupo de Materiais criado com sucesso.'

    click_link '01'

    page.should have_field 'Grupo', :with => '01'
    page.should have_field 'Nome', :with => 'Generos alimenticios'
  end

  scenario 'update an existent materials_group' do
    MaterialsGroup.make!(:alimenticios)

    click_link 'Cadastros Diversos'

    click_link 'Grupos de Materiais'

    click_link '01'

    fill_in 'Grupo', :with => '02'
    fill_in 'Nome', :with => 'Materiais de escritorio'

    click_button 'Atualizar Grupo de Materiais'

    page.should have_notice 'Grupo de Materiais editado com sucesso.'

    click_link '02'

    page.should have_field 'Grupo', :with => '02'
    page.should have_field 'Nome', :with => 'Materiais de escritorio'
  end

  scenario 'destroy an existent materials_group' do
    MaterialsGroup.make!(:alimenticios)
    click_link 'Cadastros Diversos'

    click_link 'Grupos de Materiais'

    click_link '01'

    click_link 'Apagar 01', :confirm => true

    page.should have_notice 'Grupo de Materiais apagado com sucesso.'

    page.should_not have_content '01'
    page.should_not have_content 'Generos alimenticios'
  end

  scenario 'should validate uniqueness of group' do
    MaterialsGroup.make!(:alimenticios)
    click_link 'Cadastros Diversos'

    click_link 'Grupos de Materiais'

    click_link 'Criar Grupo de Materiais'

    fill_in 'Grupo', :with => '01'

    click_button 'Criar Grupo de Materiais'

    page.should have_content 'já está em uso'
  end

  scenario 'should validate uniqueness of name' do
    MaterialsGroup.make!(:alimenticios)
    click_link 'Cadastros Diversos'

    click_link 'Grupos de Materiais'

    click_link 'Criar Grupo de Materiais'

    fill_in 'Nome', :with => 'Generos alimenticios'

    click_button 'Criar Grupo de Materiais'

    page.should have_content 'já está em uso'
  end
end
