# encoding: utf-8
require 'spec_helper'

feature "AdministrationTypes" do
  background do
    sign_in
  end

  scenario 'create a new administration_type' do
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Administração'

    click_link 'Criar Tipo de Administração'

    fill_in 'Nome', :with => 'Pública'
    select 'Direta', :from => 'Administração'
    select 'Autarquia', :from => 'Tipo do órgão'
    fill_modal 'Natureza jurídica', :with => 'Administração Pública', :field => 'Nome'

    click_button 'Criar Tipo de Administração'

    page.should have_notice 'Tipo de Administração criado com sucesso.'

    click_link 'Pública'

    page.should have_field 'Nome', :with => 'Pública'
    page.should have_select 'Administração', :with => 'Direta'
    page.should have_select 'Tipo do órgão', :with => 'Autarquia'
    page.should have_field 'Natureza jurídica', :with => 'Administração Pública'
  end

  scenario 'update an existent administration_type' do
    make_dependencies!

    AdministrationType.make!(:publica)
    LegalNature.make!(:executivo_federal)

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Administração'

    click_link 'Pública'

    fill_in 'Nome', :with => 'Privada'
    select 'Indireta', :from => 'Administração'
    select 'Fundo especial', :from => 'Tipo do órgão'
    fill_modal 'Natureza jurídica', :with => 'Orgão Público do Poder Executivo Federal', :field => 'Nome'

    click_button 'Atualizar Tipo de Administração'

    page.should have_notice 'Tipo de Administração editado com sucesso.'

    click_link 'Privada'

    page.should have_field 'Nome', :with => 'Privada'
    page.should have_select 'Administração', :with => 'Indireta'
    page.should have_select 'Tipo do órgão', :with => 'Fundo especial'
    page.should have_field 'Natureza jurídica', :with => 'Orgão Público do Poder Executivo Federal'
  end

  scenario 'destroy an existent administration_type' do
    AdministrationType.make!(:publica)
    click_link 'Cadastros Diversos'

    click_link 'Tipos de Administração'

    click_link 'Pública'

    click_link 'Apagar Pública', :confirm => true

    page.should have_notice 'Tipo de Administração apagado com sucesso.'

    page.should_not have_content 'Pública'
  end

  scenario 'validates uniqueness of name' do
    AdministrationType.make!(:publica)

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Administração'

    click_link 'Criar Tipo de Administração'

    fill_in 'Nome', :with => 'Pública'

    click_button 'Criar Tipo de Administração'

    page.should have_content 'já está em uso'
  end

  def make_dependencies!
    LegalNature.make!(:administracao_publica)
  end
end
