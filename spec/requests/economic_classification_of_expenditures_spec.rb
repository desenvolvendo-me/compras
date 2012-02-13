# encoding: utf-8
require 'spec_helper'

feature "EconomicClassificationOfExpenditures" do
  background do
    sign_in
  end

  scenario 'create a new economic_classification_of_expenditure' do
    Entity.make!(:detran)
    AdministractiveAct.make!(:sopa)
    StnOrdinance.make!(:geral)

    click_link 'Cadastros Diversos'

    click_link 'Classificações Econômica das Despesas'

    click_link 'Criar Classificação econômica das despesas'

    fill_modal 'Entidade', :with => 'Detran'
    fill_modal 'Portaria STN', :with => 'Portaria Geral', :field => 'Descrição'
    fill_modal 'Ato administrativo', :with => '1234', :field => 'Número'
    fill_in 'Classificação da natureza da despesa', :with => '3.1.90.11.01.00.00.00'
    select 'Ambos', :from => 'Tipo'
    fill_in 'Descrição', :with => 'Vencimentos e Salários'
    fill_in 'Súmula', :with => 'Registra o valor das despesas com vencimentos'

    click_button 'Criar Classificação econômica das despesas'

    page.should have_notice 'Classificação econômica das despesas criado com sucesso.'

    click_link '3.1.90.11.01.00.00.00'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Portaria STN', :with => 'Portaria Geral'
    page.should have_field 'Ato administrativo', :with => '1234'
    page.should have_field 'Classificação da natureza da despesa', :with => '3.1.90.11.01.00.00.00'
    page.should have_select 'Tipo', :with => 'Ambos'
    page.should have_field 'Descrição', :with => 'Vencimentos e Salários'
    page.should have_field 'Súmula', :with => 'Registra o valor das despesas com vencimentos'
  end

  scenario 'update an existent economic_classification_of_expenditure' do
    EconomicClassificationOfExpenditure.make!(:vencimento_e_salarios)
    Entity.make!(:secretaria_de_educacao)
    AdministractiveAct.make!(:emenda)
    StnOrdinance.make!(:interministerial)

    click_link 'Cadastros Diversos'

    click_link 'Classificações Econômica das Despesas'

    click_link '3.1.90.11.01.00.00.00'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_modal 'Portaria STN', :with => 'Portaria Interministerial', :field => 'Descrição'
    fill_modal 'Ato administrativo', :with => '4567', :field => 'Número'
    fill_in 'Classificação da natureza da despesa', :with => '1.2.34.56.78.90.12.34'
    select 'Analítico', :from => 'Tipo'
    fill_in 'Descrição', :with => 'Vencimentos e Salários e Pagamento'
    fill_in 'Súmula', :with => 'Registra o valor das despesas com vencimentos de salários'

    click_button 'Atualizar Classificação econômica das despesas'

    page.should have_notice 'Classificação econômica das despesas editado com sucesso.'

    click_link '1.2.34.56.78.90.12.34'

    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Portaria STN', :with => 'Portaria Interministerial'
    page.should have_field 'Ato administrativo', :with => '4567'
    page.should have_field 'Classificação da natureza da despesa', :with => '1.2.34.56.78.90.12.34'
    page.should have_select 'Tipo', :with => 'Analítico'
    page.should have_field 'Descrição', :with => 'Vencimentos e Salários e Pagamento'
    page.should have_field 'Súmula', :with => 'Registra o valor das despesas com vencimentos de salários'
  end

  scenario 'destroy an existent economic_classification_of_expenditure' do
    EconomicClassificationOfExpenditure.make!(:vencimento_e_salarios)

    click_link 'Cadastros Diversos'

    click_link 'Classificações Econômica das Despesas'

    click_link '3.1.90.11.01.00.00.00'

    click_link 'Apagar 3.1.90.11.01.00.00.00', :confirm => true

    page.should have_notice 'Classificação econômica das despesas apagado com sucesso.'

    page.should_not have_field 'Detran'
    page.should_not have_field '1234'
    page.should_not have_field '3.1.90.11.01.00.00.00'
    page.should_not have_field 'Ambos'
    page.should_not have_field 'Vencimentos e Salários'
    page.should_not have_field 'Registra o valor das despesas com vencimentos'
  end
end
