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

    page.should have_disabled_field 'Participante vencedor'

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'

    page.should_not have_disabled_field 'Participante vencedor'

    within_modal 'Participante vencedor' do
      page.should have_field 'Processo licitatório', :with => licitation_process.to_s
      page.should have_disabled_field 'Processo licitatório'
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    page.should have_content 'Antivirus'
    page.should have_content '10,00'

    check 'checkAll'

    click_button 'Salvar'

    page.should have_content 'Homologação e Adjudicação de Processo Licitatório criado com sucesso.'

    within_records do
      click_link '1'
    end

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Participante vencedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Data de homologação', :with => I18n.l(Date.current)
    page.should have_field 'Data de adjudicação', :with => I18n.l(Date.current)
    page.should have_field 'Sequência', :with => '1'

    page.should have_content 'Antivirus'
    page.should have_content '10,00'

    page.should have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'updating a ratification' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessRatification.make!(:processo_licitatorio_computador)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    page.should_not have_link 'Apagar'

    uncheck bidder_checkbok_html_name(0)

    click_button 'Salvar'

    page.should have_content 'Homologação e Adjudicação de Processo Licitatório editado com sucesso.'

    within_records do
      click_link '1'
    end

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Participante vencedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Data de homologação', :with => I18n.l(Date.current)
    page.should have_field 'Data de adjudicação', :with => I18n.l(Date.current)

    page.should have_content 'Antivirus'
    page.should have_content '10,00'

    page.should_not have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'cleaning items' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    click_link 'Criar Homologação e Adjudicação de Processo Licitatório'

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'

    within_modal 'Participante vencedor' do
      page.should have_field 'Processo licitatório', :with => licitation_process.to_s
      page.should have_disabled_field 'Processo licitatório'
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    clear_modal 'Processo licitatório'

    page.should have_disabled_field 'Participante vencedor'
    page.should have_field 'Participante vencedor', :with => ''

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'

    within_modal 'Participante vencedor' do
      page.should have_field 'Processo licitatório', :with => licitation_process.to_s
      page.should have_disabled_field 'Processo licitatório'
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    page.should have_content 'Antivirus'
    page.should have_content '10,00'

    clear_modal 'Participante vencedor'

    page.should_not have_content 'Antivirus'
  end

  scenario 'print report' do
    Prefecture.make!(:belo_horizonte)
    LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessRatification.make!(:processo_licitatorio_computador)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Imprimir termo'

    page.should have_content '1'
    page.should have_content '1/2013'
    page.should have_content 'CV'
    page.should have_content '07/08/2012'
    page.should have_content 'Licitação para compra de carteiras'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content '01.01.00001 - Antivirus'
    page.should have_content '10'
    page.should have_content '-'
    page.should have_content '10,00'
    page.should have_content '20,00'
    page.should have_content '1 - Alocação Belo Horizonte'
  end

  def bidder_checkbok_html_name(number)
    "licitation_process_ratification[licitation_process_bidder_proposals_attributes][#{number}][ratificated]"
  end
end
