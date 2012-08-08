# encoding: utf-8
require 'spec_helper'

feature "LegalTextNatures" do
  background do
    sign_in
  end

  scenario 'create a new legal_texts_nature' do
    navigate 'Contabilidade > Comum > Legislação > Naturezas de Textos Jurídicos'

    click_link 'Criar Natureza de Textos Jurídicos'

    fill_in 'Descrição', :with => 'Natureza Cívica'

    click_button 'Salvar'

    expect(page).to have_notice 'Natureza de Textos Jurídicos criada com sucesso.'

    click_link 'Natureza Cívica'

    expect(page).to have_field 'Descrição', :with => 'Natureza Cívica'
  end

  scenario 'update an existent legal_texts_nature' do
    LegalTextNature.make!(:civica)

    navigate 'Contabilidade > Comum > Legislação > Naturezas de Textos Jurídicos'

    click_link 'Natureza Cívica'

    fill_in 'Descrição', :with => 'Natureza Jurídica'

    click_button 'Salvar'

    expect(page).to have_notice 'Natureza de Textos Jurídicos editada com sucesso.'

    click_link 'Natureza Jurídica'

    expect(page).to have_field 'Descrição', :with => 'Natureza Jurídica'
  end

  scenario 'destroy an existent legal_texts_nature' do
    LegalTextNature.make!(:civica)

    navigate 'Contabilidade > Comum > Legislação > Naturezas de Textos Jurídicos'

    click_link 'Natureza Cívica'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Natureza de Textos Jurídicos apagada com sucesso.'

    expect(page).not_to have_content 'Natureza Cívica'
  end

  scenario 'validate uniqueness of name' do
    LegalTextNature.make!(:civica)

    navigate 'Contabilidade > Comum > Legislação > Naturezas de Textos Jurídicos'

    click_link 'Criar Natureza de Textos Jurídicos'

    fill_in 'Descrição', :with => 'Natureza Cívica'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
