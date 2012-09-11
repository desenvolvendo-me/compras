# encoding: utf-8
require 'spec_helper'

feature "ExtraCreditNatures" do
  background do
    sign_in
  end

  scenario 'create a new extra_credit_nature' do

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Naturezas de Créditos Suplementares'

    click_link 'Criar Natureza de Crédito Suplementar'

    fill_in 'Descrição', :with => 'Abre crédito suplementar'
    select 'Outros', :from => 'Classificação'

    click_button 'Salvar'

    expect(page).to have_notice 'Natureza de Crédito Suplementar criado com sucesso.'

    click_link 'Abre crédito suplementar'

    expect(page).to have_field 'Descrição', :with => 'Abre crédito suplementar'
    expect(page).to have_select 'Classificação', :selected => 'Outros'
  end

  scenario 'update an existent extra_credig_nature' do
    ExtraCreditNature.make!(:abre_credito)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Naturezas de Créditos Suplementares'

    click_link 'Abre crédito suplementar'

    fill_in 'Descrição', :with => 'Abre crédito suplementar - superavit financeiro'
    select 'Remanejamento', :from => 'Classificação'

    click_button 'Salvar'

    expect(page).to have_notice 'Natureza de Crédito Suplementar editado com sucesso.'

    click_link 'Abre crédito suplementar - superavit financeiro'

    expect(page).to have_field 'Descrição', :with => 'Abre crédito suplementar - superavit financeiro'
    expect(page).to have_select 'Classificação', :selected => 'Remanejamento'
  end

  scenario 'destroy an existent extra_credig_nature' do
    ExtraCreditNature.make!(:abre_credito)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Naturezas de Créditos Suplementares'

    click_link 'Abre crédito suplementar'

    click_link 'Apagar'

    expect(page).to have_notice 'Natureza de Crédito Suplementar apagado com sucesso.'

    within_records do
      expect(page).to_not have_content 'Abre crédito suplementar'
      expect(page).to_not have_content 'Outros'
    end
  end
end
