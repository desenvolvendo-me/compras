# encoding: utf-8
require 'spec_helper'

feature "TradingItemBids" do
  background do
    sign_in
  end

  scenario "Placing an proposal to an item" do
    Trading.make!(:pregao_presencial)

    navigate "Processos de Compra > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    click_link "Fazer oferta"

    expect(page).to have_content "Criar Proposta"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'

    expect(page).not_to have_field "Número da rodada"
    expect(page).to have_focus_on 'Valor da proposta'

    expect(page).to have_field "Licitante", :with => "Gabriel Sobrinho"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).not_to have_field 'Menor preço'
    expect(page).not_to have_field 'Valor limite'

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_notice "Oferta criada com sucesso"
  end

  scenario "Placing an proposal to an item and showing the proposal report after make all proposals" do
    TradingConfiguration.make!(:pregao)
    Trading.make!(:pregao_presencial)

    navigate "Processos de Compra > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    click_link "Fazer oferta"

    expect(page).to have_content "Criar Proposta"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).not_to have_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Gabriel Sobrinho"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).not_to have_field 'Menor preço'
    expect(page).not_to have_field 'Valor limite'

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_notice "Oferta criada com sucesso"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).not_to have_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Wenderson Malheiros"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).not_to have_field 'Menor preço'
    expect(page).not_to have_field 'Valor limite'

    fill_in "Valor da proposta", :with => "140,00"

    click_button "Salvar"

    expect(page).to have_notice "Oferta criada com sucesso"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).not_to have_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Nohup"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).not_to have_field 'Menor preço'
    expect(page).not_to have_field 'Valor limite'

    fill_in "Valor da proposta", :with => "101,00"

    click_button "Salvar"

    expect(page).to have_content 'Propostas'

    within '.records tbody tr:nth-child(1)' do
      expect(page.find('.bidder-name')).to have_content 'Gabriel Sobrinho'
      expect(page.find('.bidder-amount')).to have_content '100,00'
      expect(page.find('.bidder-percent')).to have_content '0,00'
      expect(page.find('.bidder-position')).to have_content 'Selecionado'
    end

    within '.records tbody tr:nth-child(2)' do
      expect(page.find('.bidder-name')).to have_content 'Nohup'
      expect(page.find('.bidder-amount')).to have_content '101,00'
      expect(page.find('.bidder-percent')).to have_content '1,00'
      expect(page.find('.bidder-position')).to have_content 'Selecionado'
    end

    within '.records tbody tr:nth-child(3)' do
      expect(page.find('.bidder-name')).to have_content 'Wenderson Malheiros'
      expect(page.find('.bidder-amount')).to have_content '140,00'
      expect(page.find('.bidder-percent')).to have_content '40,00'
      expect(page.find('.bidder-position')).to have_content 'Não selecionado'
    end

    click_link 'Registrar lances'

    expect(page).to have_content "Registrar Lance"
    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Nohup"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).to have_disabled_field 'Menor preço'
    expect(page).to have_field 'Menor preço', :with => '100,00'
    expect(page).to have_disabled_field 'Valor limite'
    expect(page).to have_field 'Valor limite', :with => '99,99'

    fill_in "Valor da proposta", :with => "99,00"

    click_button "Salvar"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Gabriel Sobrinho"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).to have_disabled_field 'Menor preço'
    expect(page).to have_field 'Menor preço', :with => '99,00'
    expect(page).to have_disabled_field 'Valor limite'
    expect(page).to have_field 'Valor limite', :with => '98,99'

    fill_in "Valor da proposta", :with => "80,00"

    click_button "Salvar"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).to have_field "Número da rodada", :with => "2"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Nohup"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).to have_disabled_field 'Menor preço'
    expect(page).to have_field 'Menor preço', :with => '80,00'
    expect(page).to have_disabled_field 'Valor limite'
    expect(page).to have_field 'Valor limite', :with => '79,99'

    fill_in "Valor da proposta", :with => "79,00"

    click_button "Salvar"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).to have_field "Número da rodada", :with => "2"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Gabriel Sobrinho"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).to have_disabled_field 'Menor preço'
    expect(page).to have_field 'Menor preço', :with => '79,00'
    expect(page).to have_disabled_field 'Valor limite'
    expect(page).to have_field 'Valor limite', :with => '78,99'

    fill_in "Valor da proposta", :with => "78,00"

    click_button "Salvar"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).to have_field "Número da rodada", :with => "3"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Nohup"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).to have_disabled_field 'Menor preço'
    expect(page).to have_field 'Menor preço', :with => '78,00'
    expect(page).to have_disabled_field 'Valor limite'
    expect(page).to have_field 'Valor limite', :with => '77,99'

    choose 'Declinou'

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    expect(page).to have_content 'Classificação das Ofertas'

    expect(page).to_not have_checked_field 'Apenas beneficiados'

    within '.records tbody tr:nth-child(1)' do
      expect(page.find('.bidder-name')).to have_content 'Gabriel Sobrinho'
      expect(page.find('.bidder-amount')).to have_content '78,00'
      expect(page.find('.bidder-percent')).to have_content '0,00'
      expect(page.find('.bidder-position')).to have_content '1º lugar'
    end

    within '.records tbody tr:nth-child(2)' do
      expect(page.find('.bidder-name')).to have_content 'Nohup'
      expect(page.find('.bidder-amount')).to have_content '79,00'
      expect(page.find('.bidder-percent')).to have_content '1,28'
      expect(page.find('.bidder-position')).to have_content '2º lugar'
    end

    within '.records tbody tr:nth-child(3)' do
      expect(page.find('.bidder-name')).to have_content 'Wenderson Malheiros'
      expect(page.find('.bidder-amount')).to have_content '140,00'
      expect(page.find('.bidder-percent')).to have_content '79,49'
      expect(page.find('.bidder-position')).to have_content '3º lugar'
    end
  end

  scenario "Placing an offer to an item" do
    trading = Trading.make!(:pregao_presencial)

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    click_link "Fazer oferta"

    expect(page).to have_content "Registrar Lance"

    expect(page).to have_checked_field 'Com proposta'
    expect(page).to_not have_checked_field 'Sem proposta'
    expect(page).to_not have_checked_field 'Desclassificado'
    expect(page).to_not have_checked_field 'Declinou'

    expect(page).to have_focus_on 'Valor da proposta'

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Wenderson Malheiros"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Valor da proposta', :with => '0,00'
    expect(page).to have_disabled_field 'Menor preço'
    expect(page).to have_field 'Menor preço', :with => '100,00'
    expect(page).to have_disabled_field 'Valor limite'
    expect(page).to have_field 'Valor limite', :with => '99,99'

    fill_in "Valor da proposta", :with => "99,00"

    click_button "Salvar"

    expect(page).to have_notice "Oferta criada com sucesso"
  end

  scenario 'increment bidder and round when all bidder have proposals for the round' do
    trading = Trading.make!(:pregao_presencial)

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link "1/2012"

    click_button "Salvar e ir para Itens/Ofertas"

    click_link "Fazer oferta"

    expect(page).to have_content "Registrar Lance"

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Wenderson Malheiros"
    expect(page).to have_disabled_field "Licitante"
    expect(page).to have_field 'Menor preço', :with => '100,00'
    expect(page).to have_field 'Valor limite', :with => '99,99'

    fill_in "Valor da proposta", :with => "99,00"

    click_button "Salvar"

    expect(page).to have_content "Oferta criada com sucesso"

    expect(page).to have_content "Registrar Lance"

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Nohup"
    expect(page).to have_disabled_field "Licitante"

    fill_in "Valor da proposta", :with => "90,00"

    expect(page).to have_field 'Menor preço', :with => '99,00'
    expect(page).to have_field 'Valor limite', :with => '98,99'

    click_button "Salvar"

    expect(page).to have_content "Oferta criada com sucesso"

    expect(page).to have_content "Registrar Lance"

    expect(page).to have_field "Número da rodada", :with => "1"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Gabriel Sobrinho"
    expect(page).to have_disabled_field "Licitante"

    fill_in "Valor da proposta", :with => "80,00"

    expect(page).to have_field 'Menor preço', :with => '90,00'
    expect(page).to have_field 'Valor limite', :with => '89,99'

    click_button "Salvar"

    expect(page).to have_content "Oferta criada com sucesso"

    expect(page).to have_content "Registrar Lance"

    expect(page).to have_field "Número da rodada", :with => "2"
    expect(page).to have_disabled_field "Número da rodada"

    expect(page).to have_field "Licitante", :with => "Nohup"
    expect(page).to have_disabled_field "Licitante"

    expect(page).to have_field 'Menor preço', :with => '80,00'
    expect(page).to have_field 'Valor limite', :with => '79,99'
  end

  scenario 'when form is with errors back button should back to the trading_items index' do
    trading = Trading.make!(:pregao_presencial)

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Fazer oferta'

    expect(page).to have_content "Registrar Lance"

    click_button 'Salvar'

    expect(page).to have_content 'deve ser maior que 0'

    click_button 'Salvar'

    expect(page).to have_content 'deve ser maior que 0'

    click_link 'Voltar'

    expect(page).to have_content 'Itens do Pregão Presencial 1/2012'
  end

  scenario 'without proposal' do
    trading = Trading.make!(:pregao_presencial)

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Fazer oferta'

    expect(page).to have_content "Registrar Lance"

    choose 'Sem proposta'

    click_button 'Salvar'

    expect(page).to have_notice 'Oferta criada com sucesso.'
    expect(page).to have_field 'Número da rodada', :with => '1'
  end

  scenario 'enable disclassification_reason when status is disqualified' do
    trading = Trading.make!(:pregao_presencial)

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Fazer oferta'

    expect(page).to have_disabled_field 'Motivo da desclassificação'

    choose 'Desclassificado'

    expect(page).to_not have_disabled_field 'Motivo da desclassificação'

    choose 'Sem proposta'

    expect(page).to have_disabled_field 'Motivo da desclassificação'
  end

  scenario 'disqualify a bib' do
    trading = Trading.make!(:pregao_presencial)

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Fazer oferta'

    choose 'Desclassificado'

    fill_in 'Motivo da desclassificação', :with => 'Não compareceu ao pregão'

    click_button 'Salvar'

    expect(page).to have_notice 'Oferta criada com sucesso'
  end

  scenario 'classification' do
    trading = Trading.make!(:pregao_presencial)

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Fazer oferta'

    fill_in 'Valor da proposta', :with => '99,00'

    click_button 'Salvar'

    expect(page).to have_content 'Oferta criada com sucesso'

    fill_in 'Valor da proposta', :with => '90,00'

    click_button 'Salvar'

    expect(page).to have_content 'Oferta criada com sucesso'

    choose 'Sem proposta'

    click_button 'Salvar'

    expect(page).to have_content 'Oferta criada com sucesso'

    choose 'Sem proposta'

    click_button 'Salvar'

    expect(page).to have_content 'Oferta criada com sucesso'

    expect(page).to have_content 'Classificação das Ofertas'

    expect(page).to_not have_checked_field 'Apenas beneficiados'

    within '.records tbody tr:nth-child(1)' do
      expect(page.find('.bidder-name')).to have_content 'Nohup'
      expect(page.find('.bidder-amount')).to have_content '90,00'
      expect(page.find('.bidder-percent')).to have_content '0,00'
      expect(page.find('.bidder-position')).to have_content '1º lugar'
    end

    within '.records tbody tr:nth-child(2)' do
      expect(page.find('.bidder-name')).to have_content 'Wenderson Malheiros'
      expect(page.find('.bidder-amount')).to have_content '99,00'
      expect(page.find('.bidder-percent')).to have_content '10,00'
      expect(page.find('.bidder-position')).to have_content '2º lugar'
    end

    within '.records tbody tr:nth-child(3)' do
      expect(page.find('.bidder-name')).to have_content 'Gabriel Sobrinho'
      expect(page.find('.bidder-amount')).to have_content '100,00'
      expect(page.find('.bidder-percent')).to have_content '11,11'
      expect(page.find('.bidder-position')).to have_content '3º lugar'
    end
  end

  scenario 'should validates minimum_limit rounded' do
    trading_item = TradingItem.make!(:item_pregao_presencial,
      :minimum_reduction_value => 0, :minimum_reduction_percent => 10.0)

    trading = Trading.make!(:pregao_presencial, :trading_items => [trading_item])

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Fazer oferta'

    fill_in 'Valor da proposta', :with => '89,63'

    click_button 'Salvar'

    expect(page).to have_content 'Oferta criada com sucesso'

    expect(page).to have_field 'Valor limite', :with => '80,67'

    fill_in 'Valor da proposta', :with => '80,67'

    click_button 'Salvar'

    expect(page).to have_content 'Oferta criada com sucesso'
  end

  scenario 'disqualification_reason is required only when status is disqualified' do
    trading_item = TradingItem.make!(:item_pregao_presencial,
      :minimum_reduction_value => 0, :minimum_reduction_percent => 10.0)

    trading = Trading.make!(:pregao_presencial, :trading_items => [trading_item])

    make_stage_of_proposals :trading => trading

    navigate "Processos de Compra > Pregão Presencial"

    click_link '1/2012'

    click_button 'Salvar e ir para Itens/Ofertas'

    click_link 'Fazer oferta'

    expect(page).to_not have_field 'Motivo da desclassificação *'

    choose 'Declinou'

    expect(page).to_not have_field 'Motivo da desclassificação *'

    choose 'Desclassificado'

    expect(page).to have_field 'Motivo da desclassificação'

    choose 'Sem proposta'

    expect(page).to_not have_field 'Motivo da desclassificação *'
  end

  def make_stage_of_proposals(options = {})
    TradingConfiguration.make!(:pregao)
    trading = options.fetch(:trading) { Trading.make!(:pregao_presencial)}
    trading.percentage_limit_to_participate_in_bids = TradingConfiguration.percentage_limit_to_participate_in_bids
    trading.save!
    trading_item = options.fetch(:trading_item) { trading.trading_items.first }
    bidders = options.fetch(:bidders) { trading_item.bidders }

    bidders.each do |bidder|
      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)
    end
  end
end
