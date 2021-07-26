require 'spec_helper'

feature "DocumentTypes" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new document_type' do
    navigate 'Cadastro > Tipos de Documento'

    click_link 'Criar Tipo de Documento'

    fill_in 'Validade em dias', :with => '10'
    fill_in 'Descrição', :with => 'Fiscal'
    select 'Certidão negativa de débitos trabalhistas', :from => 'Tipo da habilitação TCE'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Documento criado com sucesso.'

    click_link 'Fiscal'

    expect(page).to have_field 'Validade em dias', :with => '10'
    expect(page).to have_field 'Descrição', :with => 'Fiscal'
    expect(page).to have_select 'Tipo da habilitação TCE', :selected => 'Certidão negativa de débitos trabalhistas'

    fill_in 'Validade em dias', :with => '20'
    fill_in 'Descrição', :with => 'Oficial'
    select 'Certidão de regularidade FGTS', :from => 'Tipo da habilitação TCE'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Documento editado com sucesso.'

    click_link 'Oficial'

    expect(page).to have_field 'Validade em dias', :with => '20'
    expect(page).to have_field 'Descrição', :with => 'Oficial'
    expect(page).to have_select 'Tipo da habilitação TCE', :selected => 'Certidão de regularidade FGTS'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Documento apagado com sucesso.'

    expect(page).to_not have_content '10'
    expect(page).to_not have_content 'Fiscal'
  end

  scenario 'cannot destroy an existent document_type with licitation_process relationship' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Cadastro > Tipos de Documento'

    click_link 'Fiscal'

    expect(page).to have_disabled_element 'Apagar', :reason => 'Este registro não pôde ser apagado pois há outros cadastros que dependem dele'
  end

  scenario 'index with columns at the index' do
    DocumentType.make!(:fiscal)

    navigate 'Cadastro > Tipos de Documento'

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
