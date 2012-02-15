# encoding: utf-8
require 'spec_helper'

feature "LegalTextNatures" do
  background do
    sign_in
  end

  scenario 'create a new legal_texts_nature' do
    click_link 'Contabilidade'

    click_link 'Naturezas de Textos Jurídicos'

    click_link 'Criar Natureza de Textos Jurídicos'

    fill_in 'Descrição', :with => 'Natureza Cívica'

    click_button 'Criar Natureza de Textos Jurídicos'

    page.should have_notice 'Natureza de Textos Jurídicos criada com sucesso.'

    click_link 'Natureza Cívica'

    page.should have_field 'Descrição', :with => 'Natureza Cívica'
  end

  scenario 'update an existent legal_texts_nature' do
    LegalTextNature.make!(:civica)

    click_link 'Contabilidade'

    click_link 'Naturezas de Textos Jurídicos'

    click_link 'Natureza Cívica'

    fill_in 'Descrição', :with => 'Natureza Jurídica'

    click_button 'Atualizar Natureza de Textos Jurídicos'

    page.should have_notice 'Natureza de Textos Jurídicos editada com sucesso.'

    click_link 'Natureza Jurídica'

    page.should have_field 'Descrição', :with => 'Natureza Jurídica'
  end

  scenario 'destroy an existent legal_texts_nature' do
    LegalTextNature.make!(:civica)
    click_link 'Contabilidade'

    click_link 'Naturezas de Textos Jurídicos'

    click_link 'Natureza Cívica'

    click_link 'Apagar Natureza Cívica', :confirm => true

    page.should have_notice 'Natureza de Textos Jurídicos apagada com sucesso.'

    page.should_not have_content 'Natureza Cívica'
  end

  scenario 'validate uniqueness of name' do
    LegalTextNature.make!(:civica)

    click_link 'Contabilidade'

    click_link 'Naturezas de Textos Jurídicos'

    click_link 'Criar Natureza de Textos Jurídicos'

    fill_in 'Descrição', :with => 'Natureza Cívica'

    click_button 'Criar Natureza de Textos Jurídicos'

    page.should have_content 'já está em uso'
  end
end
