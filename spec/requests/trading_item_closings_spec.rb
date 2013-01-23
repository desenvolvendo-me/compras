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
      :trading_items => [
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
end
