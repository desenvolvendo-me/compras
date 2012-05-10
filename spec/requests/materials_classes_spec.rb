# encoding: utf-8
require 'spec_helper'

feature "MaterialsClasses" do
  background do
    sign_in
  end

  scenario 'create a new materials_class' do
    MaterialsGroup.make!(:informatica)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '01', :field => 'Código'
    fill_mask 'Código', :with => '01'
    fill_in 'Descrição', :with => 'Materiais de Escritório'
    fill_in 'Detalhamento', :with => 'materiais para escritório'

    click_button 'Salvar'

    page.should have_notice 'Classe de Materiais criado com sucesso.'

    click_link 'Materiais de Escritório'

    page.should have_field 'Grupo', :with => '01 - Informática'
    page.should have_field 'Código', :with => '01'
    page.should have_field 'Descrição', :with => 'Materiais de Escritório'
    page.should have_field 'Detalhamento', :with => 'materiais para escritório'
  end

  scenario 'update an existent materials_class' do
    MaterialsClass.make!(:software)
    MaterialsGroup.make!(:comp_eletricos_eletronicos)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Software'

    fill_modal 'Grupo', :with => '03', :field => 'Código'
    fill_mask 'Código', :with => '02'
    fill_in 'Descrição', :with => 'Lampada'
    fill_in 'Detalhamento', :with => 'descricao'

    click_button 'Salvar'

    page.should have_notice 'Classe de Materiais editado com sucesso.'

    click_link 'Lampada'

    page.should have_field 'Grupo', :with => '03 - Componentes elétricos e eletrônicos'
    page.should have_field 'Código', :with => '02'
    page.should have_field 'Descrição', :with => 'Lampada'
    page.should have_field 'Detalhamento', :with => 'descricao'
  end

  scenario 'destroy an existent materials_class' do
    MaterialsClass.make!(:software)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Software'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Classe de Materiais apagado com sucesso.'

    page.should_not have_content '01 - Informática'
    page.should_not have_content 'Software'
    page.should_not have_content 'Softwares de computador'
  end

  scenario 'should validate uniqueness of class_number scoped to materials_group' do
    MaterialsClass.make!(:software)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '01', :field => 'Código'
    fill_mask 'Código', :with => '01'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end

  scenario 'should not validate uniqueness of class_number when not scoped to materials_group' do
    MaterialsClass.make!(:software)
    MaterialsGroup.make!(:informatica)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '01', :field => 'Código'
    fill_mask 'Código', :with => '02'

    click_button 'Salvar'

    page.should_not have_content 'já está em uso'
  end

  scenario 'should validate uniqueness of description scoped to materials_class' do
    MaterialsGroup.make!(:informatica)
    MaterialsClass.make!(:software)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '01', :field => 'Código'
    fill_in 'Descrição', :with => 'Software'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end

  scenario 'should not validate uniqueness of description when is not scoped to materials_class' do
    MaterialsClass.make!(:software)
    MaterialsGroup.make!(:informatica)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '01', :field => 'Código'
    fill_in 'Descrição', :with => 'Hardware'

    click_button 'Salvar'

    page.should_not have_content 'já está em uso'
  end
end
