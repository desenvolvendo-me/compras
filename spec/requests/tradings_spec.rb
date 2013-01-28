# encoding: utf-8
require 'spec_helper'

feature "Tradings" do
  background do
    sign_in
  end

  scenario "creating a new trading" do
    Entity.make!(:detran)
    Entity.make!(:secretaria_de_educacao)
    LicitationProcess.make!(:pregao_presencial)
    LicitationCommission.make!(:comissao_pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

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

    click_link "Apagar"

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

    click_button "Salvar e ir para Itens/Ofertas"

    expect(page).to have_content 'Itens do Pregão Presencial 1/2012'

    within_records do
      expect(page).to have_link '01.01.00001 - Antivirus'
      expect(page).to have_disabled_element "Fazer oferta", :reason => "O item não possui redução mínima cadastrada."
    end

    click_link 'Antivirus'
    fill_in 'Redução mínima admissível entre os lances em %', :with => '9,90'
    click_button 'Salvar'

    click_link "Fazer oferta"
    expect(page).to have_content "Criar Proposta"

    click_link "Voltar"

    click_link "Voltar"

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

  scenario "filtering out non-published licitation process with modalities other than 'Trading'" do
    LicitationProcess.make!(:pregao_presencial)
    LicitationProcess.make!(:processo_licitatorio, :process => 2)
    LicitationProcess.make!(:pregao_presencial,
                            :bidders => [],
                            :process => 120,
                            :administrative_process => AdministrativeProcess.make!(:pregao_presencial, :process => 3),
                            :licitation_process_publications => [])

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "Criar Pregão Presencial"

    within_modal "Processo licitatório" do
      click_button "Pesquisar"

      within_records do
        expect(page).to have_content "1/2012"
        expect(page).not_to have_content "2/2012"
        expect(page).not_to have_content "120/2012"
      end
    end
  end

  scenario "choosing a commission for the trading session" do
    LicitationCommission.make!(:comissao_pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

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

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

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

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

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

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

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

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

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

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

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

  scenario "adding bidders to the trading" do
    Trading.make!(:pregao_presencial, {
      :licitation_process => LicitationProcess.make!(:pregao_presencial, :bidders => [])
    })
    Creditor.make!(:sobrinho)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link '1/2012'

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    fill_modal 'Fornecedor', :with => "Gabriel Sobrinho"

    click_button 'Salvar'

    expect(page).to have_content "Licitante criado com sucesso"

    click_link 'Voltar ao pregão presencial'

    expect(page).to have_content "Editar 1/2012"
  end

  scenario "trading session with negotiation and closing stage" do
    TradingConfiguration.make!(:pregao)
    trading_item = TradingItem.make!(:item_pregao_presencial,
      :minimum_reduction_value => 1.0)
    trading_item2 = TradingItem.make!(:segundo_item_pregao_presencial)
    trading = Trading.make!(:pregao_presencial, :items => [trading_item, trading_item2])
    trading.licitation_process.bidders << Bidder.make!(:licitante_com_proposta_3)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"
    click_button "Salvar e ir para Itens/Ofertas"
    click_link "Fazer oferta"

    # Proposal stage
    fill_in "Valor da proposta", :with => "100,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    fill_in "Valor da proposta", :with => "101,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    fill_in "Valor da proposta", :with => "102,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    fill_in "Valor da proposta", :with => "103,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    click_link "Registrar lances"

    # Bidding stage
    fill_in "Valor da proposta", :with => "98,00"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    fill_in "Valor da proposta", :with => "97,00"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    fill_in "Valor da proposta", :with => "96,00"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    fill_in "Valor da proposta", :with => "95,00"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    expect(page).to have_field "Menor preço", :with => "95,00"
    expect(page).to have_field "Valor limite", :with => "94,00"

    choose "Declinou"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    choose "Declinou"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    fill_in "Valor da proposta", :with => "94,00"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    fill_in "Valor da proposta", :with => "50,00"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    choose "Declinou"

    click_button "Salvar"

    expect(page).to have_content 'Oferta criada com sucesso'

    expect(page).to have_link 'Desfazer última oferta'

    within_records do
      within("tbody tr:nth-child(1)") do
        expect(page).to have_content "Gabriel Sobrinho"
        expect(page).to have_content "1º lugar"
        expect(page).to have_link "Inabilitar"
      end

      within("tbody tr:nth-child(2)") do
        expect(page).to have_content "Wenderson Malheiros"
        expect(page).to have_content "2º lugar"
      end

      within("tbody tr:nth-child(3)") do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "3º lugar"
      end

      within("tbody tr:nth-child(4)") do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "4º lugar"
      end
    end

    click_link "Inabilitar"

    fill_in 'Motivo', :with => 'Problemas com a documentação'

    click_button 'Salvar'

    expect(page).to have_notice 'Inabilitação de Licitante criada com sucesso.'

    within("#preference-right") do
      expect(page).not_to have_content "Wenderson Malheiros"
      expect(page).not_to have_content "Gabriel Sobrinho"

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "97,00"
        expect(page).to have_content "3,19"
        expect(page).to have_content "1º lugar"
        expect(page).to have_content "À negociar"
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "98,00"
        expect(page).to have_content "4,26"
        expect(page).to have_content "2º lugar"
        expect(page).to have_content "À negociar"
      end
    end

    click_link "Iniciar Negociação"

    expect(page.current_url).to match(/#title/)

    expect(page).to have_content 'Negociação'
    expect(page).to have_disabled_field "Etapa"
    expect(page).to have_field "Etapa", :with => "Negociação"
    expect(page).to have_field "Licitante", :with => "Nobe"
    expect(page).to have_field "Menor preço", :with => "94,00"
    expect(page).to have_field "Valor limite", :with => "93,99"

    fill_in "Valor da proposta", :with => "93,99"

    click_button "Salvar"

    expect(page).to have_content 'Negociação criada com sucesso'

    expect(page).to_not have_link 'Desfazer última oferta'
    expect(page).to have_link 'Desfazer última negociação'

    click_link 'Desfazer última negociação'

    expect(page).to have_link 'Desfazer última oferta'
    expect(page).to_not have_link 'Desfazer última negociação'

    click_link "Iniciar Negociação"

    expect(page).to have_content 'Negociação'
    expect(page).to have_disabled_field "Etapa"
    expect(page).to have_field "Etapa", :with => "Negociação"
    expect(page).to have_field "Licitante", :with => "Nobe"
    expect(page).to have_field "Menor preço", :with => "94,00"
    expect(page).to have_field "Valor limite", :with => "93,99"

    fill_in "Valor da proposta", :with => "93,99"

    click_button 'Salvar'

    within_records do
      within("tbody tr:nth-child(1)") do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "1º lugar"
        expect(page).not_to have_link "Inabilitar"
      end

      within("tbody tr:nth-child(2)") do
        expect(page).to have_content "Wenderson Malheiros"
        expect(page).to have_content "2º lugar"
      end

      within("tbody tr:nth-child(3)") do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "3º lugar"
      end

      within("tbody tr:nth-child(4)") do
        expect(page).to have_content "Gabriel Sobrinho"
        expect(page).to have_link "Inabilitação"
      end
    end

    within("#preference-right") do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "93,99"
        expect(page).to have_content "0,00"
        expect(page).to have_content "1º lugar"
        expect(page).to have_content "Com proposta"
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "98,00"
        expect(page).to have_content "4,27"
        expect(page).to have_content "2º lugar"
        expect(page).to have_content "À negociar"
      end
    end

    expect(page).not_to have_link "Iniciar Negociação"
    expect(page).to have_link "Encerramento do item"

    click_link "Encerramento do item"

    click_link 'Voltar'

    expect(page).to have_title 'Itens do Pregão Presencial 1/2012'

    click_link "Fazer oferta"

    expect(page).to have_title 'Classificação das Ofertas'

    click_link "Encerramento do item"

    expect(page).to have_title 'Criar Encerramento do Item do Pregão'

    select 'Vencedor', :from => 'Situação'

    click_button 'Salvar'

    expect(page).to have_notice 'Encerramento do Item do Pregão criado com sucesso'

    within("tbody tr:nth-child(1)") do
      expect(page).to have_disabled_element "Fazer oferta", :reason => "O item já foi encerrado"
    end

    click_link 'Ver histórico'

    expect(page).to have_content "Item: 01.01.00001 - Antivirus"

    within '.table-proposals' do
      within "tbody tr:nth-child(1)" do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "103,00"
        expect(page).to have_content "3,00"
        expect(page).to have_content "Selecionado"
      end

      within "tbody tr:nth-child(2)" do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "102,00"
        expect(page).to have_content "2,00"
        expect(page).to have_content "Selecionado"
      end

      within "tbody tr:nth-child(3)" do
        expect(page).to have_content "Wenderson Malheiros"
        expect(page).to have_content "101,00"
        expect(page).to have_content "1,00"
        expect(page).to have_content "Selecionado"
      end

      within "tbody tr:nth-child(4)" do
        expect(page).to have_content "Gabriel Sobrinho"
        expect(page).to have_content "100,00"
        expect(page).to have_content "0,00"
        expect(page).to have_content "Selecionado"
      end
    end

    within '.round-of-bids table:nth-of-type(1)' do
      within "tr:nth-child(1)" do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "98,00"
        expect(page).to have_content "3,16"
        expect(page).to have_content "Com proposta"
      end

      within "tr:nth-child(2)" do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "97,00"
        expect(page).to have_content "2,11"
        expect(page).to have_content "Com proposta"
      end

      within "tr:nth-child(3)" do
        expect(page).to have_content "Wenderson Malheiros"
        expect(page).to have_content "96,00"
        expect(page).to have_content "1,05"
        expect(page).to have_content "Com proposta"
      end

      within "tr:nth-child(4)" do
        expect(page).to have_content "Gabriel Sobrinho"
        expect(page).to have_content "95,00"
        expect(page).to have_content "0,00"
        expect(page).to have_content "Com proposta"
      end
    end

    within '.round-of-bids table:nth-of-type(2)' do
      within "tr:nth-child(1)" do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "98,00"
        expect(page).to have_content "3,16"
        expect(page).to have_content "Declinou"
      end

      within "tr:nth-child(2)" do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "97,00"
        expect(page).to have_content "2,11"
        expect(page).to have_content "Declinou"
      end

      within "tr:nth-child(3)" do
        expect(page).to have_content "Wenderson Malheiros"
        expect(page).to have_content "94,00"
        expect(page).to have_content "88,00"
        expect(page).to have_content "Com proposta"
      end

      within "tr:nth-child(4)" do
        expect(page).to have_content "Gabriel Sobrinho"
        expect(page).to have_content "50,00"
        expect(page).to have_content "0,00"
        expect(page).to have_content "Com proposta"
      end
    end

    within '.round-of-bids table:nth-of-type(3)' do
      within "tr:nth-child(1)" do
        expect(page).to have_content "Wenderson Malheiros"
        expect(page).to have_content "94,00"
        expect(page).to have_content "88,00"
        expect(page).to have_content "Declinou"
      end
    end

    within '.table-negotiations' do
      within "tbody tr:nth-child(1)" do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "93,99"
        expect(page).to have_content "0,00"
        expect(page).to have_content "Com proposta"
      end
    end

    click_link 'Voltar'

    within("tbody tr:nth-child(2)") do
      click_link "Fazer oferta"
    end

    expect(page).to have_field "Licitante", :with => "Wenderson Malheiros"

    fill_in "Valor da proposta", :with => "500,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    expect(page).to have_field "Licitante", :with => "Nobe"

    fill_in "Valor da proposta", :with => "510,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    expect(page).to have_field "Licitante", :with => "Nohup"

    fill_in "Valor da proposta", :with => "505,00"

    click_button "Salvar"

    expect(page).to have_content 'Proposta criada com sucesso'

    within_records do
      within("tbody tr:nth-child(1)") do
        expect(page).to have_content "Wenderson Malheiros"
        expect(page).to have_content "500,00"
        expect(page).to have_content "0,00"
        expect(page).to have_content "Selecionado"
      end

      within("tbody tr:nth-child(2)") do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "505,00"
        expect(page).to have_content "1,00"
        expect(page).to have_content "Selecionado"
      end

      within("tbody tr:nth-child(3)") do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "510,00"
        expect(page).to have_content "2,00"
        expect(page).to have_content "Selecionado"
      end

      within("tbody tr:nth-child(4)") do
        expect(page).to have_content "Gabriel Sobrinho"
        expect(page).to have_content "0,00"
        expect(page).to have_content "Inabilitado"
      end
    end

    click_link 'Voltar'

    within '.records tr:last' do
      click_link 'Ver histórico'
    end

    expect(page).to have_content "Item: 01.01.00001 - Antivirus"

    within '.table-proposals' do
      within "tbody tr:nth-child(1)" do
        expect(page).to have_content "Nobe"
        expect(page).to have_content "510,00"
        expect(page).to have_content "2,00"
        expect(page).to have_content "Selecionado"
      end

      within "tbody tr:nth-child(2)" do
        expect(page).to have_content "Nohup"
        expect(page).to have_content "505,00"
        expect(page).to have_content "1,00"
        expect(page).to have_content "Selecionado"
      end

      within "tbody tr:nth-child(3)" do
        expect(page).to have_content "Wenderson Malheiros"
        expect(page).to have_content "500,00"
        expect(page).to have_content "0,00"
        expect(page).to have_content "Selecionado"
      end
    end
  end

  scenario 'columns for index with att_header' do
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    within_records do
      within 'thead tr:nth-child(1)' do
        expect(page).to have_content 'Código/Ano'
        expect(page).to have_content 'Data'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Unidade licitante'
        expect(page).to have_content 'Objeto resumido'
      end

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content "#{I18n.l Date.current}"
        expect(page).to have_content 'Descrição resumida do objeto'
      end
    end
  end
end
