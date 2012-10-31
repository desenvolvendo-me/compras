#encoding: utf-8
require 'spec_helper'

feature TradingItem do
  background do
    sign_in
  end

  scenario "listing trading items" do
    Trading.make!(:pregao_presencial)

    navigate "Pregão Presencial > Pregões Presencial"

    click_link "1/2012"

    within_tab "Itens" do
      click_link "Itens/Ofertas"
    end

    expect(page).to have_content "Itens do Pregão Presencial 1/2012"
    expect(page).to have_link "Antivirus"

    click_link "Voltar ao pregão presencial"

    expect(page).to have_content 'Editar 1/2012'
  end
end
