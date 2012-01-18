# encoding: utf-8
require 'spec_helper'

feature "BranchActivities" do
  background do
    sign_in
  end

  scenario 'create a new branch_activity' do
    BranchClassification.make!(:comercio)
    Cnae.make!(:varejo)

    click_link 'Cadastro Econômico'

    click_link 'Ramos de Atividades'

    click_link 'Criar Ramo de Atividade'

    fill_in 'Nome', :with => 'Instalação de Equipamentos de Som'

    fill_modal 'CNAE', :field => 'Descrição', :with => 'Comércio varejista de mercadorias em geral'
    fill_modal 'Classificação do ramo de atividade', :with => 'Comércio'

    click_button 'Criar Ramo de Atividade'

    page.should have_notice 'Ramo de Atividade criado com sucesso.'

    click_link 'Instalação de Equipamentos de Som'

    page.should have_field 'Nome', :with => 'Instalação de Equipamentos de Som'
    page.should have_field 'CNAE', :with => 'Comércio varejista de mercadorias em geral'
    page.should have_field 'Classificação do ramo de atividade', :with => 'Comércio'
  end

  scenario 'update an existent branch_activity' do
    BranchActivity.make!(:sacolao)

    click_link 'Cadastro Econômico'

    click_link 'Ramos de Atividades'

    click_link 'Comércio de Hortifrutigranjeiros'

    fill_in 'Nome', :with => 'Comercialização de Verduras'

    click_button 'Atualizar Ramo de Atividade'

    page.should have_notice 'Ramo de Atividade editado com sucesso.'

    click_link 'Comercialização de Verduras'

    page.should have_field 'Nome', :with => 'Comercialização de Verduras'
  end

  scenario 'destroy an existent branch_activity' do
    BranchActivity.make!(:venda_de_produtos_importados)

    click_link 'Cadastro Econômico'

    click_link 'Ramos de Atividades'

    click_link 'Venda de Produtos Importados'

    click_link 'Apagar Venda de Produtos Importados', :confirm => true

    page.should have_notice 'Ramo de Atividade apagado com sucesso.'

    page.should_not have_content 'Venda de Produtos Importados'
  end
end
