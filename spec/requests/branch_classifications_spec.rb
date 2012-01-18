# encoding: utf-8
require 'spec_helper'

feature "BranchClassifications" do
  background do
    sign_in
  end

  scenario 'create a new branch_classification' do
    click_link 'Cadastro Econômico'

    click_link 'Classificações dos Ramos de Atividades'

    click_link 'Criar Classificação do Ramo de Atividade'

    fill_in 'Nome', :with => 'Agropecuária'

    click_button 'Criar Classificação do Ramo de Atividade'

    page.should have_notice 'Classificação do Ramo de Atividade criada com sucesso.'

    click_link 'Agropecuária'

    page.should have_field 'Nome', :with => 'Agropecuária'
  end

  scenario 'update an existent branch_classification' do
    BranchClassification.make!(:comercio)

    click_link 'Cadastro Econômico'

    click_link 'Classificações dos Ramos de Atividades'

    click_link 'Comércio'

    fill_in 'Nome', :with => 'Comercialização'

    click_button 'Atualizar Classificação do Ramo de Atividade'

    page.should have_notice 'Classificação do Ramo de Atividade editada com sucesso.'

    click_link 'Comercialização'

    page.should have_field 'Nome', :with => 'Comercialização'
  end

  scenario 'destroy an existent branch_classification' do
    BranchClassification.make!(:industria)

    click_link 'Cadastro Econômico'

    click_link 'Classificações dos Ramos de Atividades'

    click_link 'Indústria'

    click_link 'Apagar Indústria', :confirm => true

    page.should have_notice 'Classificação do Ramo de Atividade apagada com sucesso.'

    page.should_not have_content 'Indústria'
  end
end
