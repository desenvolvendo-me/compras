#encoding: utf-8
require 'spec_helper'

feature TradingItemClosing do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['tradings']
    sign_in
  end

  scenario "closing an item at index page" do
    TradingConfiguration.make!(:pregao)
    item = TradingItem.make!(:item_pregao_presencial)
    trading = Trading.make!(:pregao_presencial,
      :items => [
        item,
        TradingItem.make!(:segundo_item_pregao_presencial)])

    bidder1 = trading.bidders.first
    bidder2 = trading.bidders.second
    bidder3 = trading.bidders.last

    TradingItemBid.create!(
      :round => 0,
      :trading_item_id => item.id,
      :bidder_id => bidder1.id,
      :amount => 120.0,
      :stage => TradingItemBidStage::PROPOSALS,
      :status => TradingItemBidStatus::WITH_PROPOSAL)

    TradingItemBid.create!(
      :round => 0,
      :trading_item_id => item.id,
      :bidder_id => bidder2.id,
      :amount => 119.0,
      :stage => TradingItemBidStage::PROPOSALS,
      :status => TradingItemBidStatus::WITH_PROPOSAL)

    TradingItemBid.create!(
      :round => 0,
      :trading_item_id => item.id,
      :bidder_id => bidder3.id,
      :amount => 121.0,
      :stage => TradingItemBidStage::PROPOSALS,
      :status => TradingItemBidStatus::WITH_PROPOSAL)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    within 'table.records tbody tr:nth-child(1)' do
      click_link 'Encerramento do item'
    end

    expect(page).to have_disabled_field 'Item do pregão', :with => '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Licitante com a melhor proposta', :with => ""

    select 'Fracassado', :from => 'Situação *'

    fill_in 'Motivo', :with => 'Os licitantes fracassaram'

    click_button 'Salvar'

    expect(page).to have_notice 'Encerramento do Item do Pregão criado com sucesso'

    within 'table.records tbody tr:nth-child(1)' do
       click_link 'Encerramento do item'
    end

    expect(page).to have_title 'Encerramento do Item do Pregão 1/2012'
    expect(page).to have_disabled_field 'Item do pregão', :with => '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Motivo', :with => 'Os licitantes fracassaram'
    expect(page).to have_disabled_field 'Situação'
    expect(page).to have_select 'Situação', :selected => 'Fracassado'

    expect(page).to_not have_link 'Apagar'
    expect(page).to_not have_button 'Salvar'

    click_link 'Voltar'

    expect(page).to have_title 'Itens do Pregão Presencial 1/2012'
  end

  scenario "closing the last item or trading" do
    TradingConfiguration.make!(:pregao)
    item = TradingItem.make!(:item_pregao_presencial)
    trading = Trading.make!(:pregao_presencial,
      :items => [
        item
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

    expect(page).to have_title 'Criar Encerramento do Pregão Presencial'

    expect(page).to have_disabled_field 'Pregão', :with => '1/2012'
  end

  scenario "closing an item with status winner without a bidder" do
    TradingConfiguration.make!(:pregao)
    item = TradingItem.make!(:item_pregao_presencial)
    trading = Trading.make!(:pregao_presencial,
      :items => [
        item,
        TradingItem.make!(:segundo_item_pregao_presencial)])

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    within 'table.records tbody tr:nth-child(1)' do
      click_link 'Encerramento do item'
    end

    expect(page).to have_disabled_field 'Licitante com a melhor proposta', :with => ""

    select 'Vencedor', :from => 'Situação'

    click_button 'Salvar'

    expect(page).to_not have_notice 'Encerramento do Item do Pregão criado com sucesso'

    expect(page).to have_content 'não tem um licitante vencedor'
  end

  scenario 'negotiation of the winner not benefited' do
    TradingConfiguration.make!(:pregao)
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Fazer oferta'

    expect(page).to have_title "Criar Proposta"

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_notice "Proposta criada com sucesso"

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_notice "Proposta criada com sucesso"

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_notice "Proposta criada com sucesso"

    expect(page).to have_title 'Propostas'

    click_link 'Registrar lances'

    choose 'Sem proposta'

    click_button 'Salvar'

    expect(page).to have_notice 'Oferta criada com sucesso'

    fill_in 'Valor da proposta', :with => '90,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Oferta criada com sucesso'

    choose 'Sem proposta'

    click_button 'Salvar'

    expect(page).to have_notice 'Oferta criada com sucesso'

    expect(page).to have_title 'Classificação das Ofertas'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content 'Sim'
        expect(page).to have_content '100,00'
        expect(page).to have_content '11,11'
        expect(page).to_not have_link 'Negociar'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Não'
        expect(page).to have_content '100,00'
        expect(page).to have_content '11,11'
        expect(page).to_not have_link 'Negociar'
      end

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Não'
        expect(page).to have_content '90,00'
        expect(page).to have_content '0,00'
        expect(page).to have_link 'Inabilitar'

        click_link 'Negociar'
      end
    end

    expect(page).to have_title 'Negociação'
    expect(page).to have_field 'Licitante', :with => 'Wenderson Malheiros'

    fill_in 'Valor da proposta', :with => '80,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Negociação criada com sucesso'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Não'
        expect(page).to have_content '80,00'
        expect(page).to have_content '0,00'
        expect(page).to have_link 'Refazer neg.'
        expect(page).to_not have_link 'Inabilitar'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Não'
        expect(page).to have_content '100,00'
        expect(page).to have_content '25,00'
        expect(page).to_not have_link 'Negociar'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content 'Sim'
        expect(page).to have_content '100,00'
        expect(page).to have_content '25,00'
        expect(page).to_not have_link 'Negociar'
      end
    end

    click_link 'Encerramento do item'

    expect(page).to have_title 'Criar Encerramento do Item do Pregão'
    expect(page).to have_disabled_field 'Licitante com a melhor proposta', :with => 'Wenderson Malheiros'
    select 'Vencedor', :from => 'Situação'

    click_button 'Salvar'

    expect(page).to have_notice 'Encerramento do Item do Pregão criado com sucesso'
  end
end
