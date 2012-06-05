# encoding: utf-8
require 'spec_helper'

feature "PriceCollectionProposals" do

  context 'admin logged in' do
    background do
      sign_in
    end

    scenario 'should not have a button to create a proposal' do
      PriceCollection.make!(:coleta_de_precos)

      click_link 'Processos'

      click_link 'Coletas de Preços'

      click_link '1/2012'

      click_link 'Propostas'

      page.should_not have_link 'Criar Proposta Para Coleta de Preços'
    end

    scenario 'the proposal should be created automatically when the price collection is created' do
      PriceCollection.make!(:coleta_de_precos)

      click_link 'Processos'

      click_link 'Coletas de Preços'

      click_link '1/2012'

      click_link 'Propostas'

      page.should have_link '1/2012 - Wenderson Malheiros'
    end

    scenario 'should not have a button to delete a proposal' do
      PriceCollection.make!(:coleta_de_precos)

      click_link 'Processos'

      click_link 'Coletas de Preços'

      click_link '1/2012'

      click_link 'Propostas'

      click_link '1/2012 - Wenderson Malheiros'

      page.should_not have_link 'Apagar'
    end

    scenario 'editing proposal' do
      PriceCollection.make!(:coleta_de_precos)

      click_link 'Processos'

      click_link 'Coletas de Preços'

      click_link '1/2012'

      click_link 'Propostas'

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

  describe 'provider editing proposals', :driver => :selenium do
    let :current_user do
      User.make!(:provider_with_password)
    end

    background do
      sign_in
    end

    scenario 'I can see only my proposals' do
      PriceCollection.make!(:coleta_de_precos_com_2_propostas)

      click_link 'Compras e Licitações'

      click_link 'Coletas de Preço'

      click_link 'Propostas'

      page.should_not have_content '1/2012 - Wenderson Malheiros'
      page.should have_content '1/2012 - Gabriel Sobrinho'
    end

    scenario 'I can update my own proposals' do
      PriceCollection.make!(:coleta_de_precos_com_2_propostas)

      click_link 'Compras e Licitações'

      click_link 'Coletas de Preço'

      click_link 'Propostas'

      click_link '1/2012 - Gabriel Sobrinho'

      fill_in 'Valor unitário', :with => '50,00'

      click_button 'Salvar'

      page.should have_notice 'Proposta Para Coleta de Preços editada com sucesso.'
    end

    scenario "I can not update other's proposals" do
       collection = PriceCollection.make!(:coleta_de_precos_com_2_propostas)
       proposal = collection.price_collection_proposals.first

       visit "/price_collection_proposals/#{proposal.id}/edit"

       page.should_not have_field "Coleta de Preços", :with => '1/2012'
    end
  end
end
