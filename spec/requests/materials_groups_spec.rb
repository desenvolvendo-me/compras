# encoding: utf-8
require 'spec_helper'

feature "MaterialsGroups" do
  background do
    sign_in
  end

  scenario 'create a new materials_group' do
    navigate_through 'Compras e Licitações > Cadastros Gerais > Grupos de Materiais'

    click_link 'Criar Grupo de Materiais'

    fill_in 'Código', :with => '01'
    fill_in 'Descrição', :with => 'Informática'

    click_button 'Salvar'

    page.should have_notice 'Grupo de Materiais criado com sucesso.'

    click_link 'Informática'

    page.should have_field 'Código', :with => '01'
    page.should have_field 'Descrição', :with => 'Informática'
  end

  scenario 'update an existent materials_group' do
    MaterialsGroup.make!(:informatica)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Grupos de Materiais'

    click_link 'Informática'

    fill_in 'Código', :with => '02'
    fill_in 'Descrição', :with => 'Materiais de escritorio'

    click_button 'Salvar'

    page.should have_notice 'Grupo de Materiais editado com sucesso.'

    click_link 'Materiais de escritorio'

    page.should have_field 'Código', :with => '02'
    page.should have_field 'Descrição', :with => 'Materiais de escritorio'
  end

  scenario 'destroy an existent materials_group' do
    MaterialsGroup.make!(:informatica)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Grupos de Materiais'

    click_link 'Informática'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Grupo de Materiais apagado com sucesso.'

    page.should_not have_content '01'
    page.should_not have_content 'Informática'
  end

  scenario 'should validate uniqueness of group' do
    MaterialsGroup.make!(:informatica)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Grupos de Materiais'

    click_link 'Criar Grupo de Materiais'

    fill_in 'Código', :with => '01'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end

  scenario 'should validate uniqueness of name' do
    MaterialsGroup.make!(:informatica)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Grupos de Materiais'

    click_link 'Criar Grupo de Materiais'

    fill_in 'Descrição', :with => 'Informática'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end
end
