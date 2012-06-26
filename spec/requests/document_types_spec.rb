# encoding: utf-8
require 'spec_helper'

feature "DocumentTypes" do
  background do
    sign_in
  end

  scenario 'create a new document_type' do
    navigate_through 'Compras e Licitações > Cadastros Gerais > Tipos de Documento'

    click_link 'Criar Tipo de Documento'

    fill_in 'Validade em dias', :with => '10'
    fill_in 'Descrição', :with => 'Fiscal'

    click_button 'Salvar'

    page.should have_notice 'Tipo de Documento criado com sucesso.'

    click_link 'Fiscal'

    page.should have_field 'Validade em dias', :with => '10'
    page.should have_field 'Descrição', :with => 'Fiscal'
  end

  scenario 'update an existent document_type' do
    DocumentType.make!(:fiscal)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Tipos de Documento'

    click_link 'Fiscal'

    fill_in 'Validade em dias', :with => '20'
    fill_in 'Descrição', :with => 'Oficial'

    click_button 'Salvar'

    page.should have_notice 'Tipo de Documento editado com sucesso.'

    click_link 'Oficial'

    page.should have_field 'Validade em dias', :with => '20'
    page.should have_field 'Descrição', :with => 'Oficial'
  end

  scenario 'cannot destroy an existent document_type with licitation_process relationship' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Tipos de Documento'

    click_link 'Fiscal'

    click_link 'Apagar', :confirm => true

    page.should_not have_notice 'Tipo de Documento apagado com sucesso.'
  end

  scenario 'destroy an existent document_type' do
    DocumentType.make!(:fiscal)
    navigate_through 'Compras e Licitações > Cadastros Gerais > Tipos de Documento'

    click_link 'Fiscal'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Tipo de Documento apagado com sucesso.'

    page.should_not have_content '10'
    page.should_not have_content 'Fiscal'
  end

  scenario 'validate uniqueness of description' do
    DocumentType.make!(:fiscal)

    navigate_through 'Compras e Licitações > Cadastros Gerais > Tipos de Documento'

    click_link 'Criar Tipo de Documento'

    fill_in 'Descrição', :with => 'Fiscal'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end
end
