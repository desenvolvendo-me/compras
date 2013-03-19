# encoding: utf-8
require 'spec_helper'

feature "DocumentTypes" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new document_type' do
    navigate 'Comum > Tipos de Documento'

    click_link 'Criar Tipo de Documento'

    fill_in 'Validade em dias', :with => '10'
    fill_in 'Descrição', :with => 'Fiscal'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Documento criado com sucesso.'

    click_link 'Fiscal'

    expect(page).to have_field 'Validade em dias', :with => '10'
    expect(page).to have_field 'Descrição', :with => 'Fiscal'

    fill_in 'Validade em dias', :with => '20'
    fill_in 'Descrição', :with => 'Oficial'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Documento editado com sucesso.'

    click_link 'Oficial'

    expect(page).to have_field 'Validade em dias', :with => '20'
    expect(page).to have_field 'Descrição', :with => 'Oficial'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Documento apagado com sucesso.'

    expect(page).to_not have_content '10'
    expect(page).to_not have_content 'Fiscal'
  end

  scenario 'cannot destroy an existent document_type with licitation_process relationship' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Comum > Tipos de Documento'

    click_link 'Fiscal'

    click_link 'Apagar'

    expect(page).to_not have_notice 'Tipo de Documento apagado com sucesso.'

    expect(page).to have_alert 'Tipo de Documento não pode ser apagado.'
  end

  scenario 'index with columns at the index' do
    DocumentType.make!(:fiscal)

    navigate 'Comum > Tipos de Documento'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Validade em dias'

      within 'tbody tr' do
        expect(page).to have_content 'Fiscal'
        expect(page).to have_content '10'
      end
    end
  end
end
