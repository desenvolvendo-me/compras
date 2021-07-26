require 'spec_helper'

feature "PriceCollectionProposals" do

  context 'user logged in' do
    let :current_user do
      User.make!(:sobrinho)
    end

    background do
      create_roles ['price_collections', 'price_collection_proposal_annuls']
      sign_in
    end

    scenario 'should not have a button to create a proposal' do
      PriceCollection.make!(:coleta_de_precos)

      navigate 'Licitações > Coletas de Preços'

      

      click_link '1/2012'

      click_link 'Propostas'

      expect(page).to have_content 'Propostas para a Coleta 1/2012'
      expect(page).to_not have_link 'Criar Proposta Para Coleta de Preços'
    end

    scenario 'the proposal should be created automatically when the price collection is created' do
      PriceCollection.make!(:coleta_de_precos)

      navigate 'Licitações > Coletas de Preços'

      

      click_link '1/2012'

      click_link 'Propostas'

      expect(page).to have_link '1/2012'
    end

    scenario 'should not have a button to delete a proposal' do
      PriceCollection.make!(:coleta_de_precos)

      navigate 'Licitações > Coletas de Preços'

      

      click_link '1/2012'

      click_link 'Propostas'

      click_link '1/2012'

      expect(page).to have_content 'Proposta do Fornecedor Wenderson Malheiros para a Coleta de Preço 1/2012'

      expect(page).to_not have_link 'Apagar'
    end

    scenario 'editing proposal' do
      price_collection = PriceCollection.make!(:coleta_de_precos)

      navigate 'Licitações > Coletas de Preços'

      

      click_link '1/2012'

      click_link 'Propostas'

      click_link '1/2012'

      expect(page).to have_field 'Valor total', disabled: true
      expect(page).to have_field 'Valor total do lote', disabled: true
      expect(page).to have_field 'Status', disabled: true

      expect(page).to_not have_disabled_element 'Salvar', :reason => 'somente o fornecedor da proposta tem autorização para editar'
      expect(page).to have_link 'Anular'

      fill_in 'Valor unitário', with: '0,90'
      expect(page).to have_field 'Valor total', with: '9,00', disabled: true

      click_button "Salvar"

      expect(page).to have_notice 'Proposta Para Coleta de Preços editada com sucesso'

      within_records do
        within 'tbody tr:nth-child(3)' do
          click_link '1/2012'
        end
      end

      expect(page).to have_field 'Valor unitário', with: '0,90'
      expect(page).to have_field 'Valor total', with: '9,00', disabled: true
    end

    scenario 'show columns at the index' do
      PriceCollection.make!(:coleta_de_precos)

      navigate 'Licitações > Coletas de Preços'

      

      click_link '1/2012'

      click_link 'Propostas'

      within_records do
        expect(page).to have_content '1/2012'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content "#{I18n.l(Date.current)}"
        expect(page).to have_content 'Ativo'
      end
    end
  end

  context 'creditor editing proposals' do
    let :current_user do
      User.make!(:creditor_with_password)
    end

    background do
      sign_in
    end

    scenario 'I can see only my proposals' do
      PriceCollection.make!(:coleta_de_precos_com_3_propostas)

      navigate 'Compras e Licitações > Coletas de Preço'

      click_link 'Propostas'

      expect(page).to have_content 'Coletas de Preço'
      expect(page).to_not have_content 'Wenderson Malheiros'
      expect(page).to have_content 'Gabriel Sobrinho'
    end

    scenario 'I can see the information about the price collection' do
      PriceCollection.make!(:coleta_de_precos_com_3_propostas)

      navigate 'Compras e Licitações > Coletas de Preço'

      click_link 'Propostas'

      click_link '1/2012'

      expect(page).to have_content 'Proposta do Fornecedor Gabriel Sobrinho para a Coleta de Preço 1/2012'

      expect(page).to have_field 'Coleta de preços', :with => '1/2012', disabled: true

      expect(page).to have_field 'Data de início', :with => I18n.l(Date.current), disabled: true

      expect(page).to have_field 'Prazo de entrega', :with => '1 ano/anos', disabled: true

      expect(page).to have_field 'Fornecedor', :with => 'Gabriel Sobrinho', disabled: true

      expect(page).to have_select 'Status', :selected => 'Ativo', disabled: true

      expect(page).to have_field 'Valor unitário'
      expect(page).to have_field 'Valor total', disabled: true
      expect(page).to have_field 'Valor total do lote', disabled: true

      click_link 'Voltar'

      expect(page).to have_content 'Propostas Para Coletas de Preços'
    end

    scenario 'I can update my own proposals' do
      PriceCollection.make!(:coleta_de_precos_com_3_propostas)

      navigate 'Compras e Licitações > Coletas de Preço'

      click_link 'Propostas'

      click_link '1/2012'

      fill_in 'Valor unitário', :with => '50,00'

      expect(page).to have_field 'Valor total', :with => '500,00', disabled: true
      expect(page).to have_field 'Valor total do lote', :with => '500,00', disabled: true

      expect(page).to_not have_link 'Anular'

      click_button 'Salvar'

      expect(page).to have_notice 'Proposta Para Coleta de Preços editada com sucesso.'

      click_link '1/2012'

      expect(page).to have_field 'Valor unitário', :with => '50,00'
      expect(page).to have_field 'Valor total', :with => '500,00', disabled: true
      expect(page).to have_field 'Valor total do lote', :with => '500,00', disabled: true
      expect(page).to have_field 'Quantidade', :with => '10', disabled: true
    end

    scenario "I can not update other's proposals" do
       collection = PriceCollection.make!(:coleta_de_precos_com_3_propostas)
       proposal = collection.price_collection_proposals.first

       visit "/price_collection_proposals/#{proposal.id}/edit"

       expect(page).to_not have_field "Coleta de Preços", :with => '1/2012'
    end
  end
end
