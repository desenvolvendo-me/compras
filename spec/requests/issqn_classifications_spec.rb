# encoding: utf-8
require 'spec_helper'

feature "IssqnClassifications" do
  background do
    sign_in
  end

  scenario 'create a new issqn_classification' do
    click_link 'Cadastro Econômico'

    click_link 'Enquadramentos ISSQN'

    click_link 'Criar Enquadramento ISSQN'

    fill_in 'Nome', :with => 'NF-e'

    click_button 'Criar Enquadramento ISSQN'

    page.should have_notice 'Enquadramento ISSQN criado com sucesso.'

    click_link 'NF-e'

    page.should have_field 'Nome', :with => 'NF-e'
  end

  scenario 'update an existent issqn_classification' do
    IssqnClassification.make!(:estimativa)

    click_link 'Cadastro Econômico'

    click_link 'Enquadramentos ISSQN'

    click_link 'Estimativa'

    fill_in 'Nome', :with => 'Estipulado'

    click_button 'Atualizar Enquadramento ISSQN'

    page.should have_notice 'Enquadramento ISSQN editado com sucesso.'

    click_link 'Estipulado'

    page.should have_field 'Nome', :with => 'Estipulado'
  end

  scenario 'destroy an existent issqn_classification' do
    IssqnClassification.make!(:estimativa)

    click_link 'Cadastro Econômico'

    click_link 'Enquadramentos ISSQN'

    click_link 'Estimativa'

    click_link 'Apagar Estimativa', :confirm => true

    page.should have_notice 'Enquadramento ISSQN apagado com sucesso.'

    within_records do
      page.should_not have_content 'Estimativa'
    end
  end
end
