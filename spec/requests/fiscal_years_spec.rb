# encoding: utf-8
require 'spec_helper'

feature "FiscalYears" do
  background do
    sign_in
  end

  scenario 'create a new fiscal year' do
    click_link 'Cadastros Diversos'

    click_link 'Exercícios Fiscais'

    click_link 'Criar Exercício Fiscal'

    fill_in 'Ano', :with => '2011'

    click_button 'Salvar'

    page.should have_notice 'Exercício Fiscal criado com sucesso.'

    click_link '2011'

    page.should have_field 'Ano', :with => '2011'
  end

  scenario 'update an existent fiscal year' do
    FiscalYear.make!(:two_thousand_and_eleven)

    click_link 'Cadastros Diversos'

    click_link 'Exercícios Fiscais'

    click_link '2011'

    fill_in 'Ano', :with => '2012'

    click_button 'Salvar'

    page.should have_notice 'Exercício Fiscal editado com sucesso.'

    click_link '2012'

    page.should have_field 'Ano', :with => '2012'
  end

  scenario 'destroy an existent fiscal_year' do
    FiscalYear.make!(:two_thousand_and_eleven)

    click_link 'Cadastros Diversos'

    click_link 'Exercícios Fiscais'

    click_link '2011'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Exercício Fiscal apagado com sucesso.'

    page.should_not have_content '2011'
  end
end
