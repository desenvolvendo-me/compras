# encoding: utf-8
require 'spec_helper'

feature "PriceCollectionProposals" do
  background do
    sign_in
  end

  scenario 'should not have a button to create a proposal' do
    click_link 'Processos'

    click_link 'Propostas Para Coleta de Preços'

    page.should_not have_link 'Criar Coleta de Preços'
  end

  scenario 'the proposal should be created automatically when the price collection is created' do
    PriceCollection.make!(:coleta_de_precos)

    click_link 'Processos'

    click_link 'Propostas Para Coleta de Preços'

    page.should have_link '1/2012 - Wenderson Malheiros'
  end

  scenario 'should not have a button to delete a proposal' do
    PriceCollection.make!(:coleta_de_precos)

    click_link 'Processos'

    click_link 'Propostas Para Coleta de Preços'

    click_link '1/2012 - Wenderson Malheiros'

    page.should_not have_link 'Apagar'
  end

  scenario 'editing proposal' do
    PriceCollection.make!(:coleta_de_precos)

    click_link 'Processos'

    click_link 'Propostas Para Coleta de Preços'

    click_link '1/2012 - Wenderson Malheiros'

    fill_in 'Valor unitário', :with => '50,00'

    page.should have_field 'Valor total', :with => '500,00'
    page.should have_field 'Valor total do lote', :with => '500,00'

    click_button 'Salvar'

    page.should have_notice 'Proposta Para Coleta de Preços editada com sucesso.'

    click_link '1/2012 - Wenderson Malheiros'

    page.should have_field 'Valor unitário', :with => '50,00'
    page.should have_field 'Valor total', :with => '500,00'
    page.should have_field 'Valor total do lote', :with => '500,00'
  end
end
