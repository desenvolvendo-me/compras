#encoding: utf-8
require 'spec_helper'

feature BidderDisqualification do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['tradings']
    sign_in
  end

  scenario 'Disqualify a bidder at classification' do
    TradingConfiguration.make!(:pregao)

    make_trading_item_at_classification

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"
    click_button "Salvar e ir para Itens/Ofertas"
    click_link "Fazer oferta"

    expect(page).to have_content 'Classificação'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Não'
        expect(page).to have_content '95,00'
        expect(page).to have_content '0,00'

        click_link 'Inabilitar'
      end
    end

    expect(page).to have_content 'Criar Inabilitação de Licitante'
    expect(page).to have_disabled_field 'Licitante', :with => 'Wenderson Malheiros'
    expect(page).to have_disabled_field 'Data', :with => "#{I18n.l(Date.current)}"

    expect(page).to_not have_link 'Apagar'

    fill_in 'Motivo', :with => 'Documentação irregular'

    click_button 'Salvar'

    expect(page).to have_notice 'Inabilitação de Licitante criada com sucesso'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Não'
        expect(page).to have_content '96,00'
        expect(page).to have_content '0,00'
        expect(page).to have_link 'Inabilitar'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Não'
        expect(page).to have_link 'Inabilitação'
      end
    end
  end

  scenario 'Edit a existing disqualification' do
    TradingConfiguration.make!(:pregao)

    make_trading_item_at_classification

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"
    click_button "Salvar e ir para Itens/Ofertas"
    click_link "Fazer oferta"

    expect(page).to have_content 'Classificação'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Não'
        expect(page).to have_content '95,00'
        expect(page).to have_content '0,00'

        click_link 'Inabilitar'
      end
    end

    fill_in 'Motivo', :with => 'Documentação irregular'

    click_button 'Salvar'

    expect(page).to have_notice 'Inabilitação de Licitante criada com sucesso'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(3)' do
        click_link 'Inabilitação'
      end
    end

    expect(page).to have_content 'Editar Wenderson Malheiros'
    expect(page).to have_disabled_field 'Licitante', :with => 'Wenderson Malheiros'
    expect(page).to have_disabled_field 'Data', :with => "#{I18n.l(Date.current)}"
    expect(page).to have_field 'Motivo', :with => "Documentação irregular"

    fill_in 'Motivo', :with => 'Documentação irregular do licitante'

    click_button 'Salvar'

    expect(page).to have_notice 'Inabilitação de Licitante editada com sucesso'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(3)' do
        click_link 'Inabilitação'
      end
    end

    expect(page).to have_content 'Editar Wenderson Malheiros'
    expect(page).to have_disabled_field 'Licitante', :with => 'Wenderson Malheiros'
    expect(page).to have_disabled_field 'Data', :with => "#{I18n.l(Date.current)}"
    expect(page).to have_field 'Motivo', :with => "Documentação irregular do licitante"
  end

  scenario 'Destroy a existing disqualification' do
    TradingConfiguration.make!(:pregao)

    make_trading_item_at_classification

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"
    click_button "Salvar e ir para Itens/Ofertas"
    click_link "Fazer oferta"

    expect(page).to have_content 'Classificação'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Não'
        expect(page).to have_content '95,00'
        expect(page).to have_content '0,00'

        click_link 'Inabilitar'
      end
    end

    fill_in 'Motivo', :with => 'Documentação irregular'

    click_button 'Salvar'

    expect(page).to have_notice 'Inabilitação de Licitante criada com sucesso'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Não'
        expect(page).to have_content '96,00'
        expect(page).to have_content '0,00'
        expect(page).to have_link 'Inabilitar'
      end

      within 'tbody tr:nth-child(3)' do
        click_link 'Inabilitação'
      end
    end

    expect(page).to have_content 'Editar Wenderson Malheiros'

    click_link 'Apagar'

    expect(page).to have_notice 'Inabilitação de Licitante apagada com sucesso'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Não'
        expect(page).to have_content '95,00'
        expect(page).to have_content '0,00'
        expect(page).to have_link 'Inabilitar'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Não'
        expect(page).to have_content '96,00'
        expect(page).to have_content '1,05'
        expect(page).to_not have_link 'Inabilitar'
      end
    end
  end

  def make_trading_item_at_classification
    trading = Trading.make!(:pregao_presencial)
    trading_item = trading.items.first
    bidder1 = trading.bidders.first
    bidder2 = trading.bidders.second
    bidder3 = trading.bidders.last

    # Stage of Proposals
    TradingItemBid.create!(
      :round => 0,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder1.id,
      :amount => 100.0,
      :stage => TradingItemBidStage::PROPOSALS,
      :status => TradingItemBidStatus::WITH_PROPOSAL
    )

    TradingItemBid.create!(
      :round => 0,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder2.id,
      :amount => 100.0,
      :stage => TradingItemBidStage::PROPOSALS,
      :status => TradingItemBidStatus::WITH_PROPOSAL
    )

    TradingItemBid.create!(
      :round => 0,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder3.id,
      :amount => 100.0,
      :stage => TradingItemBidStage::PROPOSALS,
      :status => TradingItemBidStatus::WITH_PROPOSAL
    )

    # Stage of Round of Bids
    TradingItemBid.create!(
      :round => 1,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder1.id,
      :amount => 98.0,
      :stage => TradingItemBidStage::ROUND_OF_BIDS,
      :status => TradingItemBidStatus::WITH_PROPOSAL
    )

    TradingItemBid.create!(
      :round => 1,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder2.id,
      :amount => 97.0,
      :stage => TradingItemBidStage::ROUND_OF_BIDS,
      :status => TradingItemBidStatus::WITH_PROPOSAL
    )

    TradingItemBid.create!(
      :round => 1,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder3.id,
      :amount => 96.0,
      :stage => TradingItemBidStage::ROUND_OF_BIDS,
      :status => TradingItemBidStatus::WITH_PROPOSAL
    )

    TradingItemBid.create!(
      :round => 2,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder1.id,
      :stage => TradingItemBidStage::ROUND_OF_BIDS,
      :status => TradingItemBidStatus::WITHOUT_PROPOSAL
    )

    TradingItemBid.create!(
      :round => 2,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder2.id,
      :amount => 95.0,
      :stage => TradingItemBidStage::ROUND_OF_BIDS,
      :status => TradingItemBidStatus::WITH_PROPOSAL
    )

    TradingItemBid.create!(
      :round => 2,
      :trading_item_id => trading_item.id,
      :bidder_id => bidder3.id,
      :stage => TradingItemBidStage::ROUND_OF_BIDS,
      :status => TradingItemBidStatus::WITHOUT_PROPOSAL
    )
  end
end
