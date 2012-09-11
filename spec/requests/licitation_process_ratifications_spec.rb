# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessRatifications" do
  background do
    sign_in
  end

  scenario 'creating a new ratification' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    click_link 'Criar Homologação e Adjudicação de Processo Licitatório'

    expect(page).to have_disabled_field 'Participante vencedor'

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'

    expect(page).to_not have_disabled_field 'Participante vencedor'

    within_modal 'Participante vencedor' do
      expect(page).to have_field 'Processo licitatório', :with => licitation_process.to_s
      expect(page).to have_disabled_field 'Processo licitatório'
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    expect(page).to have_content 'Antivirus'
    expect(page).to have_content '10,00'

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_content 'Homologação e Adjudicação de Processo Licitatório criado com sucesso.'

    within_records do
      click_link '1'
    end

    expect(page).to have_field 'Processo licitatório', :with => '1/2013'
    expect(page).to have_field 'Participante vencedor', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Sequência', :with => '1'

    expect(page).to have_content 'Antivirus'
    expect(page).to have_content '10,00'

    expect(page).to have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'updating a ratification' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    bidder = LicitationProcessBidder.make!(:licitante_sobrinho, :licitation_process => licitation_process)
    LicitationProcessRatification.make!(:processo_licitatorio_computador, :licitation_process => licitation_process)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => bidder)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_link 'Apagar'

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Homologação e Adjudicação de Processo Licitatório editado com sucesso.'

    within_records do
      click_link '1'
    end

    expect(page).to have_field 'Processo licitatório', :with => '1/2013'
    expect(page).to have_field 'Participante vencedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)

    expect(page).to have_content 'Antivirus'
    expect(page).to have_content '10,00'

    expect(page).to_not have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'cleaning items' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    click_link 'Criar Homologação e Adjudicação de Processo Licitatório'

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'

    within_modal 'Participante vencedor' do
      expect(page).to have_field 'Processo licitatório', :with => licitation_process.to_s
      expect(page).to have_disabled_field 'Processo licitatório'
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    clear_modal 'Processo licitatório'

    expect(page).to have_disabled_field 'Participante vencedor'
    expect(page).to have_field 'Participante vencedor', :with => ''

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'

    within_modal 'Participante vencedor' do
      expect(page).to have_field 'Processo licitatório', :with => licitation_process.to_s
      expect(page).to have_disabled_field 'Processo licitatório'
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    expect(page).to have_content 'Antivirus'
    expect(page).to have_content '10,00'

    clear_modal 'Participante vencedor'

    expect(page).to_not have_content 'Antivirus'
  end

  scenario 'print report' do
    Prefecture.make!(:belo_horizonte)
    LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessRatification.make!(:processo_licitatorio_computador)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))
    SignatureConfiguration.make!(:homologacao_e_adjudicao_do_processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Imprimir termo'

    expect(page).to have_content '1'
    expect(page).to have_content '1/2013'
    expect(page).to have_content 'Convite para compras e serviços'
    expect(page).to have_content I18n.l Date.current
    expect(page).to have_content 'Licitação para compra de carteiras'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content '01.01.00001 - Antivirus'
    expect(page).to have_content '10'
    expect(page).to have_content '-'
    expect(page).to have_content '10,00'
    expect(page).to have_content '20,00'
    expect(page).to have_content '1 - Alocação Belo Horizonte'
    expect(page).to have_content 'Supervisor'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Gerente'
    expect(page).to have_content 'Gabriel Sobrinho'
  end

  def bidder_checkbok_html_name(number)
    "licitation_process_ratification[licitation_process_ratification_items_attributes][#{number}][ratificated]"
  end
end
