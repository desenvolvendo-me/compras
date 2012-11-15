# encoding: utf-8
require 'spec_helper'

feature "AdministrationTypes" do
  background do
    sign_in
  end

  scenario 'create a new administration_type' do
    make_dependencies!

    navigate 'Comum > Tipos de Administração'

    click_link 'Criar Tipo de Administração'

    fill_in 'Descrição', :with => 'Pública'
    select 'Direta', :from => 'Administração'
    select 'Autarquia', :from => 'Tipo do órgão'
    fill_modal 'Natureza jurídica', :with => 'Administração Pública'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Administração criado com sucesso.'

    click_link 'Pública'

    expect(page).to have_field 'Descrição', :with => 'Pública'
    expect(page).to have_select 'Administração', :selected => 'Direta'
    expect(page).to have_select 'Tipo do órgão', :selected => 'Autarquia'
    expect(page).to have_field 'Natureza jurídica', :with => 'Administração Pública'
  end

  scenario 'update an existent administration_type' do
    make_dependencies!

    AdministrationType.make!(:publica)
    LegalNature.make!(:executivo_federal)

    navigate 'Comum > Tipos de Administração'

    click_link 'Pública'

    fill_in 'Descrição', :with => 'Privada'
    select 'Indireta', :from => 'Administração'
    select 'Fundo especial', :from => 'Tipo do órgão'
    fill_modal 'Natureza jurídica', :with => 'Orgão Público do Poder Executivo Federal'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Administração editado com sucesso.'

    click_link 'Privada'

    expect(page).to have_field 'Descrição', :with => 'Privada'
    expect(page).to have_select 'Administração', :selected => 'Indireta'
    expect(page).to have_select 'Tipo do órgão', :selected => 'Fundo especial'
    expect(page).to have_field 'Natureza jurídica', :with => 'Orgão Público do Poder Executivo Federal'
  end

  scenario 'destroy an existent administration_type' do
    AdministrationType.make!(:publica)

    navigate 'Comum > Tipos de Administração'

    click_link 'Pública'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Administração apagado com sucesso.'

    expect(page).to_not have_content 'Pública'
  end

  def make_dependencies!
    LegalNature.make!(:administracao_publica)
  end
end
