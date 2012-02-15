# encoding: utf-8
require 'spec_helper'

feature "MaterialsClasses" do
  background do
    sign_in
  end

  scenario 'create a new materials_class' do
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '01', :field => 'Número do grupo'
    fill_in 'Número da classe', :with => '01'
    fill_in 'Descrição', :with => 'Materiais de Escritório'
    fill_in 'Detalhamento', :with => 'materiais para escritório'

    click_button 'Criar Classe de Materiais'

    page.should have_notice 'Classe de Materiais criado com sucesso.'

    click_link 'Materiais de Escritório'

    page.should have_field 'Grupo', :with => '01 - Generos alimenticios'
    page.should have_field 'Número da classe', :with => '01'
    page.should have_field 'Descrição', :with => 'Materiais de Escritório'
    page.should have_field 'Detalhamento', :with => 'materiais para escritório'
  end

  scenario 'update an existent materials_class' do
    make_dependencies!

    MaterialsClass.make!(:hortifrutigranjeiros)
    MaterialsGroup.make!(:limpeza)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Hortifrutigranjeiros'

    fill_modal 'Grupo', :with => '02', :field => 'Número do grupo'
    fill_in 'Número da classe', :with => '02'
    fill_in 'Descrição', :with => 'Novo nome'
    fill_in 'Detalhamento', :with => 'descricao'

    click_button 'Atualizar Classe de Materiais'

    page.should have_notice 'Classe de Materiais editado com sucesso.'

    click_link 'Novo nome'

    page.should have_field 'Grupo', :with => '02 - Limpeza'
    page.should have_field 'Número da classe', :with => '02'
    page.should have_field 'Descrição', :with => 'Novo nome'
    page.should have_field 'Detalhamento', :with => 'descricao'
  end

  scenario 'destroy an existent materials_class' do
    MaterialsClass.make!(:hortifrutigranjeiros)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Hortifrutigranjeiros'

    click_link 'Apagar 01 - Hortifrutigranjeiros', :confirm => true

    page.should have_notice 'Classe de Materiais apagado com sucesso.'

    page.should_not have_content '01 - Generos alimenticios'
    page.should_not have_content 'Hortifrutigranjeiros'
    page.should_not have_content 'detalhamento de classe do material'
  end

  scenario 'should validate uniqueness of class_number scoped to materials_group' do
    make_dependencies!
    MaterialsClass.make!(:hortifrutigranjeiros)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '01', :field => 'Número do grupo'
    fill_in 'Número da classe', :with => '01'

    click_button 'Criar Classe de Materiais'

    page.should have_content 'já está em uso'
  end

  scenario 'should not validate uniqueness of class_number when not scoped to materials_group' do
    make_dependencies!
    MaterialsClass.make!(:hortifrutigranjeiros)
    MaterialsGroup.make!(:limpeza)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '02', :field => 'Número do grupo'
    fill_in 'Número da classe', :with => '01'

    click_button 'Criar Classe de Materiais'

    page.should_not have_content 'já está em uso'
  end

  scenario 'should validate uniqueness of description scoped to materials_class' do
    make_dependencies!
    MaterialsClass.make!(:hortifrutigranjeiros)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '01', :field => 'Número do grupo'
    fill_in 'Descrição', :with => 'Hortifrutigranjeiros'

    click_button 'Criar Classe de Materiais'

    page.should have_content 'já está em uso'
  end

  scenario 'should not validate uniqueness of description when is not scoped to materials_class' do
    make_dependencies!
    MaterialsClass.make!(:hortifrutigranjeiros)
    MaterialsGroup.make!(:limpeza)

    click_link 'Solicitações'

    click_link 'Classes de Materiais'

    click_link 'Criar Classe de Materiais'

    fill_modal 'Grupo', :with => '02', :field => 'Número do grupo'
    fill_in 'Descrição', :with => 'Hortifrutigranjeiros'

    click_button 'Criar Classe de Materiais'

    page.should_not have_content 'já está em uso'
  end

  def make_dependencies!
    MaterialsGroup.make!(:alimenticios)
  end
end
