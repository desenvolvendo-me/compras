# encoding: utf-8
require 'spec_helper'

feature "ExtraCreditNatures" do
  background do
    sign_in
  end

  scenario 'create a new extra_credit_nature' do
    click_link 'Contabilidade'

    click_link 'Naturezas de Aberturas de Créditos Suplementares'

    click_link 'Criar Natureza de Abertura de Crédito Suplementar'

    fill_in 'Descrição', :with => 'Abre crédito suplementar'
    select 'Outros', :from => 'Classificação'

    click_button 'Criar Natureza de Abertura de Crédito Suplementar'

    page.should have_notice 'Natureza de Abertura de Crédito Suplementar criado com sucesso.'

    click_link 'Abre crédito suplementar'

    page.should have_field 'Descrição', :with => 'Abre crédito suplementar'
    page.should have_select 'Classificação', :selected => 'Outros'
  end

  scenario 'update an existent extra_credig_nature' do
    ExtraCreditNature.make!(:abre_credito)

    click_link 'Contabilidade'

    click_link 'Naturezas de Aberturas de Créditos Suplementares'

    click_link 'Abre crédito suplementar'

    fill_in 'Descrição', :with => 'Abre crédito suplementar - superavit financeiro'
    select 'Remanejamento', :from => 'Classificação'

    click_button 'Atualizar Natureza de Abertura de Crédito Suplementar'

    page.should have_notice 'Natureza de Abertura de Crédito Suplementar editado com sucesso.'

    click_link 'Abre crédito suplementar - superavit financeiro'

    page.should have_field 'Descrição', :with => 'Abre crédito suplementar - superavit financeiro'
    page.should have_select 'Classificação', :selected => 'Remanejamento'
  end

  scenario 'destroy an existent extra_credig_nature' do
    ExtraCreditNature.make!(:abre_credito)

    click_link 'Contabilidade'

    click_link 'Naturezas de Aberturas de Créditos Suplementares'

    click_link 'Abre crédito suplementar'

    click_link 'Apagar Abre crédito suplementar', :confirm => true

    page.should have_notice 'Natureza de Abertura de Crédito Suplementar apagado com sucesso.'

    page.should_not have_content 'Abre crédito suplementar'
    page.should_not have_content 'Outros'
  end
end
