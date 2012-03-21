# encoding: utf-8
require 'spec_helper'

feature "AdditionalCreditOpeningNatures" do
  background do
    sign_in
  end

  scenario 'create a new additional_credit_opening_nature' do
    click_link 'Contabilidade'

    click_link 'Naturezas de Abertura de Créditos Suplementares'

    click_link 'Criar Natureza de Abertura de Créditos Suplementares'

    fill_in 'Descrição', :with => 'Abre crédito suplementar'
    select 'Outros', :from => 'Classificação'

    click_button 'Criar Natureza de Abertura de Créditos Suplementares'

    page.should have_notice 'Natureza de Abertura de Créditos Suplementares criado com sucesso.'

    click_link 'Abre crédito suplementar'

    page.should have_field 'Descrição', :with => 'Abre crédito suplementar'
    page.should have_select 'Classificação', :selected => 'Outros'
  end

  scenario 'update an existent additional_credit_opening_nature' do
    AdditionalCreditOpeningNature.make!(:abre_credito)

    click_link 'Contabilidade'

    click_link 'Naturezas de Abertura de Créditos Suplementares'

    click_link 'Abre crédito suplementar'

    fill_in 'Descrição', :with => 'Abre crédito suplementar - superavit financeiro'
    select 'Remanejamento', :from => 'Classificação'

    click_button 'Atualizar Natureza de Abertura de Créditos Suplementares'

    page.should have_notice 'Natureza de Abertura de Créditos Suplementares editado com sucesso.'

    click_link 'Abre crédito suplementar - superavit financeiro'

    page.should have_field 'Descrição', :with => 'Abre crédito suplementar - superavit financeiro'
    page.should have_select 'Classificação', :selected => 'Remanejamento'
  end

  scenario 'destroy an existent additional_credit_opening_nature' do
    AdditionalCreditOpeningNature.make!(:abre_credito)

    click_link 'Contabilidade'

    click_link 'Naturezas de Abertura de Créditos Suplementares'

    click_link 'Abre crédito suplementar'

    click_link 'Apagar Abre crédito suplementar', :confirm => true

    page.should have_notice 'Natureza de Abertura de Créditos Suplementares apagado com sucesso.'

    page.should_not have_content 'Abre crédito suplementar'
    page.should_not have_content 'Outros'
  end
end
