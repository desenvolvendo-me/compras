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
    LicitationCommission.make!(:comissao_pregao_presencial)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    within_tab "Principal" do
      fill_in "Ano", :with => "2012"
      fill_modal "Processo licitatório", :with => "1", :field => "Processo"
      fill_modal "Órgão/Entidade", :with => "Detran"
      fill_modal "Unidade licitante", :with => "Secretaria de Educação"

      expect(page).to have_disabled_field "Objeto resumido"
      expect(page).to have_field "Objeto resumido", :with => "Descrição resumida do objeto"
    end

    within_tab "Pregoeiro e equipe" do
      fill_modal "Comissão de licitação", :with => "Comissão para pregão presencial", :field => "Descrição"
    end

    click_button "Salvar"

    expect(page).to have_content "Pregão Presencial criado com sucesso"

    click_link "1/2012"

    within_tab "Principal" do
      expect(page).to have_field "Número", :with => "1"
      expect(page).to have_field "Ano", :with => "2012"
      expect(page).to have_field "Processo licitatório", :with => "1/2012"
      expect(page).to have_field "Órgão/Entidade", :with => "Detran"
      expect(page).to have_field "Unidade licitante", :with => "Secretaria de Educação"
      expect(page).to have_field "Objeto resumido", :with => "Descrição resumida do objeto"
    end

    within_tab "Pregoeiro e equipe" do
      expect(page).to have_field "Comissão de licitação", :with => "Comissão para pregão presencial - Tipo: Pregão - Data de Nomeação: 20/03/2012"
      expect(page).to have_content "Pregoeiro"
      expect(page).to have_content "Equipe de Apoio"
    end
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

  scenario "choosing a commission for the trading session" do
    LicitationCommission.make!(:comissao_pregao_presencial)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    within_tab "Pregoeiro e equipe" do
      fill_modal "Comissão de licitação", :with => "Comissão para pregão presencial", :field => "Descrição"

      expect(page).to have_content "Pregoeiro"
      expect(page).to have_content "Equipe de Apoio"
    end
  end

  scenario "only allows a licitation process to be used once" do
    Entity.make!(:detran)
    Entity.make!(:secretaria_de_educacao)
    LicitationProcess.make!(:pregao_presencial)
    LicitationCommission.make!(:comissao_pregao_presencial)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    within_tab "Principal" do
      fill_in "Ano", :with => "2012"
      fill_modal "Processo licitatório", :with => "1", :field => "Processo"
      fill_modal "Órgão/Entidade", :with => "Detran"
      fill_modal "Unidade licitante", :with => "Secretaria de Educação"
      fill_in "Objeto resumido", :with => "Descrição resumida do objeto"
    end

    within_tab "Pregoeiro e equipe" do
      fill_modal "Comissão de licitação", :with => "Comissão para pregão presencial", :field => "Descrição"
    end

    click_button "Salvar"

    expect(page).to have_content "Pregão Presencial criado com sucesso"

    click_link "Criar Pregão Presencial"

    within_modal "Processo licitatório" do
      click_button "Pesquisar"

      within_records do
        expect(page).not_to have_content '1/2012'
      end

      click_link "Voltar"
    end

    click_link "Voltar"

    within_records do
      page.find('a').click
    end

    within_modal "Processo licitatório" do
      click_button "Pesquisar"

      within_records do
        expect(page).to have_content '1/2012'
      end
    end
  end

  scenario "suggesting the current year as the trading's year" do
    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    within_tab "Principal" do
      expect(page).to have_field "Ano", :with => Date.current.year.to_s
    end
  end

  scenario "filtering out licitation commissions with type other than trading" do
    LicitationCommission.make!(:comissao,
                               :expiration_date => Date.tomorrow,
                               :exoneration_date => nil)
    LicitationCommission.make!(:comissao_pregao_presencial)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    within_tab "Pregoeiro e equipe" do
      within_modal "Comissão de licitação" do
        expect(page).to have_disabled_field "Tipo de comissão"

        click_button "Pesquisar"
        expect(page).to have_content "Comissão para pregão presencial"
        expect(page).not_to have_content "descricao da comissao"
      end
    end
  end

  scenario "filtering out expired licitation commissions" do
    LicitationCommission.make!(:comissao_pregao_presencial,
                               :expiration_date => Date.yesterday)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    within_tab "Pregoeiro e equipe" do
      within_modal "Comissão de licitação" do
        click_button "Pesquisar"
        within_records do
          expect(page).not_to have_content "Comissão para pregão presencial"
        end
      end
    end
  end

  scenario "filtering out exonerated licitation commissions" do
    LicitationCommission.make!(:comissao_pregao_presencial,
                               :exoneration_date => Date.today)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    within_tab "Pregoeiro e equipe" do
      within_modal "Comissão de licitação" do
        expect(page).to have_disabled_field "Data da exoneração"

        click_button "Pesquisar"
        within_records do
          expect(page).not_to have_content "Comissão para pregão presencial"
        end
      end
    end
  end

  scenario "displaying items information when the licitation process field is filled" do
    LicitationProcess.make!(:pregao_presencial)

    navigate "Pregão > Pregões Presenciais"

    click_link "Criar Pregão Presencial"

    fill_modal "Processo licitatório", :with => "1", :field => "Processo"

    within_tab "Itens" do
      expect(page).to have_field "Item", :with => "1"
      expect(page).to have_field "Material", :with => "01.01.00001 - Antivirus"
      expect(page).to have_field "Unidade", :with => "UN"
      expect(page).to have_field "Quantidade", :with => "2,00"
      expect(page).to have_field "Valor unitário", :with => "10,00"
      expect(page).to have_field "Descrição detalhada", :with => "Antivirus avast"

      fill_in "Redução mínima admissível entre os lances em %", :with => "15,00"
      expect(page).to have_disabled_field "Redução mínima admissível entre os lances em valor"

      fill_in "Redução mínima admissível entre os lances em %", :with => "0,00"
      fill_in "Redução mínima admissível entre os lances em valor", :with => "1,20"
      expect(page).to have_disabled_field "Redução mínima admissível entre os lances em %"

      fill_in "Descrição detalhada", :with => "descrição modificada antivirus avast"
    end

    click_button "Salvar"

    expect(page).to have_content "Pregão Presencial criado com sucesso"

    click_link "1/2012"

    within_tab "Itens" do
      expect(page).to have_field "Item", :with => "1"
      expect(page).to have_field "Material", :with => "01.01.00001 - Antivirus"
      expect(page).to have_field "Unidade", :with => "UN"
      expect(page).to have_field "Quantidade", :with => "2,00"
      expect(page).to have_field "Valor unitário", :with => "10,00"
      expect(page).to have_disabled_field "Redução mínima admissível entre os lances em %"
      expect(page).to have_field "Redução mínima admissível entre os lances em valor", :with => "1,20"
      expect(page).to have_field "Descrição detalhada", :with => "descrição modificada antivirus avast"
    end
  end

  scenario "adding bidders to the trading" do
    Trading.make!(:pregao_presencial)
    Creditor.make!(:sobrinho)

    navigate "Pregão > Pregões Presenciais"

    click_link '1/2012'

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    fill_modal 'Fornecedor', :with => "Gabriel Sobrinho"

    click_button 'Salvar'

    expect(page).to have_content "Licitante criado com sucesso"

    click_link 'Voltar ao pregão presencial'

    expect(page).to have_content "Editar 1/2012"
  end
end
