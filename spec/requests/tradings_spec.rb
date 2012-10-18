# encoding: utf-8
require 'spec_helper'

feature "Tradings" do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario "creating a new trading" do
    Entity.make!(:detran)
    Entity.make!(:secretaria_de_educacao)
    LicitationProcess.make!(:pregao_presencial)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"
    fill_in "Ano", :with => "2012"
    fill_modal "Processo licitatório", :with => "1", :field => "Processo"
    fill_modal "Órgão/Entidade", :with => "Detran"
    fill_modal "Unidade licitante", :with => "Secretaria de Educação"
    fill_in "Objeto resumido", :with => "Descrição resumida do objeto"

    click_button "Salvar"

    expect(page).to have_content "Pregão Presencial criado com sucesso"

    click_link "1/2012"

    expect(page).to have_field "Número", :with => "1"
    expect(page).to have_field "Ano", :with => "2012"
    expect(page).to have_field "Processo licitatório", :with => "1/2012"
    expect(page).to have_field "Órgão/Entidade", :with => "Detran"
    expect(page).to have_field "Unidade licitante", :with => "Secretaria de Educação"
    expect(page).to have_field "Objeto resumido", :with => "Descrição resumida do objeto"
  end

  scenario "filtering out licitation process with modalities other than 'Trading'" do
    LicitationProcess.make!(:pregao_presencial)
    LicitationProcess.make!(:processo_licitatorio)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    within_modal "Processo licitatório" do
      click_button "Pesquisar"

      within_records do
        expect(page).to have_content "1/2012"
        expect(page).not_to have_content "2/2012"
      end
    end
  end
end
