# encoding: utf-8
require 'spec_helper'

feature "FiscalYears" do
  background do
    sign_in
  end

  scenario 'create a new fiscal year' do
    navigate 'Outros > Exercícios Fiscais'

    click_link 'Criar Exercício Fiscal'

    fill_in 'Ano', :with => '2011'

    click_button 'Salvar'

    expect(page).to have_notice 'Exercício Fiscal criado com sucesso.'

    click_link '2011'

    expect(page).to have_field 'Ano', :with => '2011'
  end

  scenario 'update an existent fiscal year' do
    FiscalYear.make!(:two_thousand_and_eleven)

    navigate 'Outros > Exercícios Fiscais'

    click_link '2011'

    fill_in 'Ano', :with => '2012'

    click_button 'Salvar'

    expect(page).to have_notice 'Exercício Fiscal editado com sucesso.'

    click_link '2012'

    expect(page).to have_field 'Ano', :with => '2012'
  end

  scenario 'destroy an existent fiscal_year' do
    FiscalYear.make!(:two_thousand_and_eleven)

    navigate 'Outros > Exercícios Fiscais'

    click_link '2011'

    click_link 'Apagar'

    expect(page).to have_notice 'Exercício Fiscal apagado com sucesso.'

    expect(page).to_not have_content '2011'
  end
end
