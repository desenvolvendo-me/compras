# encoding: utf-8
require 'spec_helper'

feature "TradingItemBids" do
  background do
    sign_in
  end

  scenario "Placing an offer to an item" do
    Trading.make!(:pregao_presencial)

    navigate "Pregão Presencial > Pregões Presencial"

    click_link "1/2012"

    within_tab "Itens" do
      click_link "Itens/Ofertas"
    end

    click_link "Fazer oferta"

    expect(page).to have_content "Criar Oferta"

    fill_in "Número da rodada", :with => "1"

    within_modal "Licitante" do
      click_button "Pesquisar"
      click_record "Gabriel Sobrinho"
    end

    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_content "Oferta criada com sucesso"
  end
end
