# encoding: utf-8
require 'spec_helper'

feature "MaterialsClasses" do
  background do
    sign_in
  end

  scenario 'create a new materials_class' do
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo de materiais', :with => '01', :field => 'Grupo'
    fill_in 'Nome', :with => 'Materiais de Escritório'
    fill_in 'Descrição', :with => 'materiais para escritório'

    click_button 'Criar Classe de Materiais'

    page.should have_notice 'Classe de Materiais criado com sucesso.'

    click_link 'Materiais de Escritório'

    page.should have_field 'Grupo de materiais', :with => '01'
    page.should have_field 'Nome', :with => 'Materiais de Escritório'
    page.should have_field 'Descrição', :with => 'materiais para escritório'
  end

  scenario 'update an existent materials_class' do
    make_dependencies!

    MaterialsClass.make!(:hortifrutigranjeiros)
    MaterialsGroup.make!(:limpeza)

    click_link 'Cadastros Diversos'

    click_link 'Classes de Materiais'

    click_link 'Hortifrutigranjeiros'

    fill_modal 'Grupo de materiais', :with => '02', :field => 'Grupo'
    fill_in 'Nome', :with => 'Novo nome'
    fill_in 'Descrição', :with => 'descricao'

    click_button 'Atualizar Classe de Materiais'

    page.should have_notice 'Classe de Materiais editado com sucesso.'

    click_link 'Novo nome'

    page.should have_field 'Grupo de materiais', :with => '02'
    page.should have_field 'Nome', :with => 'Novo nome'
    page.should have_field 'Descrição', :with => 'descricao'
  end

  scenario 'destroy an existent materials_class' do
    MaterialsClass.make!(:hortifrutigranjeiros)
    click_link 'Cadastros Diversos'

    click_link 'Classes de Materiais'

    click_link 'Hortifrutigranjeiros'

    click_link 'Apagar Hortifrutigranjeiros', :confirm => true

    page.should have_notice 'Classe de Materiais apagado com sucesso.'

    page.should_not have_content '01'
    page.should_not have_content 'Hortifrutigranjeiros'
    page.should_not have_content 'detalhamento de classe do material'
  end

  scenario 'should validate uniqueness of name' do
    make_dependencies!
    MaterialsClass.make!(:hortifrutigranjeiros)

    click_link 'Cadastros Diversos'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo de materiais', :with => '01', :field => 'Grupo'
    fill_in 'Nome', :with => 'Hortifrutigranjeiros'

    click_button 'Criar Classe de Materiais'

    page.should have_content 'já está em uso'
  end

  def make_dependencies!
    MaterialsGroup.make!(:first)
  end
end
