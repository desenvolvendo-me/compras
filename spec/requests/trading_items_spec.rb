#encoding: utf-8
require 'spec_helper'

feature TradingItem do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['tradings']
    sign_in
  end

  scenario "listing trading items" do
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    expect(page).to have_content "Itens do Pregão Presencial 1/2012"
    expect(page).to have_link "Antivirus"

    click_link "Voltar ao pregão presencial"

    expect(page).to have_content 'Editar 1/2012'
  end

  scenario "listing trading items with one item started" do
    TradingConfiguration.make!(:pregao)
    item = TradingItem.make!(:item_pregao_presencial)
    trading = Trading.make!(:pregao_presencial,
      :trading_items => [
        item,
        TradingItem.make!(:segundo_item_pregao_presencial)
      ])

    TradingItemBid.create!(
      :round => 0,
      :trading_item_id => item.id,
      :bidder_id => trading.bidders.first.id,
      :amount => 120.0,
      :stage => TradingItemBidStage::PROPOSALS,
      :status => TradingItemBidStatus::WITH_PROPOSAL)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    within 'table.records tbody tr:nth-child(1)' do
      expect(page).to_not have_disabled_element 'Encerramento do item',
                                            :reason => 'O item não foi iniciado'
    end

    within 'table.records tbody tr:nth-child(2)' do
      expect(page).to have_disabled_element 'Fazer oferta',
                                            :reason => 'Encerre o item (01.01.00001 - Antivirus) antes de iniciar outro'
    end
  end

  scenario 'should not have Apagar button' do
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Antivirus'

    expect(page).to_not have_link 'Apagar'
  end

  scenario 'go back link on form_button' do
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Antivirus'

    click_link 'Voltar'

    expect(page).to have_content 'Itens do Pregão Presencial 1/2012'
    expect(page).to have_link "Antivirus"
  end

  scenario 'edit and existing item' do
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Antivirus'

    fill_in 'Redução mínima admissível entre os lances em %', :with => '9,90'

    fill_in 'Descrição detalhada', :with => 'Descrição do antivírus'

    expect(page).to have_readonly_field 'Redução mínima admissível entre os lances em valor'

    fill_in 'Redução mínima admissível entre os lances em %', :with => '0,00'

    fill_in 'Redução mínima admissível entre os lances em valor', :with => '8,80'

    expect(page).to have_readonly_field 'Redução mínima admissível entre os lances em %'

    click_button 'Salvar'

    expect(page).to have_notice 'Item do Pregão Presencial editado com sucesso.'

    expect(page).to have_content 'Itens do Pregão Presencial 1/2012'

    click_link 'Antivirus'

    expect(page).to have_field 'Descrição detalhada', :with => 'Descrição do antivírus'

    expect(page).to have_field 'Redução mínima admissível entre os lances em valor', :with => '8,80'

    expect(page).to have_readonly_field 'Redução mínima admissível entre os lances em %'
  end

  scenario 'show all bidders at proposal_report' do
    TradingConfiguration.make!(:pregao)
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"
    click_button "Salvar e ir para Itens/Ofertas"
    click_link "Fazer oferta"

    # Proposal stage
    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    fill_in "Valor da proposta", :with => "200,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    choose 'Sem proposta'

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '100,00'
        expect(page).to have_content '0,00'
        expect(page).to have_content 'Selecionado'
        expect(page).to have_link 'Corrigir proposta'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Não selecionado'
        expect(page).to have_link 'Corrigir proposta'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content '0,00'
        expect(page).to have_content '0,00'
        expect(page).to have_content 'Sem proposta'
        expect(page).to have_link 'Corrigir proposta'
      end
    end
  end

  scenario 'not allow to go to the round of bids without proposal valid' do
    TradingConfiguration.make!(:pregao)
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"
    click_button "Salvar e ir para Itens/Ofertas"
    click_link "Fazer oferta"

    # Proposal stage
    choose 'Sem proposta'

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    choose 'Sem proposta'

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    choose 'Sem proposta'

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'
    expect(page).to have_disabled_element 'Registrar lances', :reason => 'Não é permitido registrar ofertas enquanto não houver licitante com proposta'
  end

  scenario 'show bidders disqualified at proposal_report' do
    TradingConfiguration.make!(:pregao)
    trading = Trading.make!(:pregao_presencial)

    bidder = trading.bidders.second

    BidderDisqualification.create!(:bidder_id => bidder.id, :reason => "Inabilitado")

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"
    click_button "Salvar e ir para Itens/Ofertas"
    click_link "Fazer oferta"

    # Proposal stage
    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'
    expect(page).to have_content 'Propostas'
    expect(page.current_url).to match(/#title/)

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '100,00'
        expect(page).to have_content '0,00'
        expect(page).to have_content 'Selecionado'
        expect(page).to have_link 'Corrigir proposta'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content '100,00'
        expect(page).to have_content '0,00'
        expect(page).to have_content 'Selecionado'
        expect(page).to have_link 'Corrigir proposta'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '0,00'
        expect(page).to have_content 'Inabilitado'
        expect(page).to_not have_link 'Corrigir proposta'
      end
    end
  end

  scenario "closing an item at index page" do
    TradingConfiguration.make!(:pregao)
    item = TradingItem.make!(:item_pregao_presencial)
    trading = Trading.make!(:pregao_presencial,
      :trading_items => [
        item,
        TradingItem.make!(:segundo_item_pregao_presencial)
      ])

    TradingItemBid.create!(
      :round => 0,
      :trading_item_id => item.id,
      :bidder_id => trading.bidders.first.id,
      :amount => 120.0,
      :stage => TradingItemBidStage::PROPOSALS,
      :status => TradingItemBidStatus::WITH_PROPOSAL)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    within 'table.records tbody tr:nth-child(1)' do
      click_link 'Encerramento do item'
    end

    select 'Fracassado', :from => 'Situação *'

    fill_in 'Motivo', :with => 'Os licitantes fracassaram'

    click_button 'Salvar'

    expect(page).to have_notice 'Encerramento do Item do Pregão criado com sucesso'

    within 'table.records tbody tr:nth-child(1)' do
      expect(page).to have_link 'Encerramento do item'
    end
  end
end
