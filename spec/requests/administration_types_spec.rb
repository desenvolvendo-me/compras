# encoding: utf-8
require 'spec_helper'

feature "AdministrationTypes" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new administration_type' do
    LegalNature.make!(:administracao_publica)
    LegalNature.make!(:executivo_federal)

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

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Administração apagado com sucesso.'

    expect(page).to_not have_content 'Pública'
  end

  scenario 'index with columns at the index' do
    AdministrationType.make!(:publica)

    navigate 'Comum > Tipos de Administração'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Administração'
      expect(page).to have_content 'Tipo do órgão'

      within 'tbody tr' do
        expect(page).to have_content 'Pública'
        expect(page).to have_content 'Direta'
        expect(page).to have_content 'Fundação pública'
      end
    end
  end
end