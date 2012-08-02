# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessRatifications" do
  background do
    sign_in
  end

  scenario 'creating a new ratification' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    click_link 'Criar Homologação e Adjudicação de Processo Licitatório'

    page.should have_disabled_field 'Participante vencedor'

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'

    page.should_not have_disabled_field 'Participante vencedor'

    fill_modal 'Participante vencedor', :with => 'Wenderson Malheiros', :field => 'Fornecedor'

    page.should have_content 'Antivirus'
    page.should have_content '10,00'

    check 'checkAll'

    click_button 'Salvar'

    page.should have_content 'Homologação e Adjudicação de Processo Licitatório criado com sucesso.'

    within_records do
      click_link licitation_process.to_s
    end

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Participante vencedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Data de homologação', :with => I18n.l(Date.current)
    page.should have_field 'Data de adjudicação', :with => I18n.l(Date.current)

    page.should have_content 'Antivirus'
    page.should have_content '10,00'

    page.should have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'updating a ratification' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessRatification.make!(:processo_licitatorio_computador)
    LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Homologações e Adjudicações de Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    page.should_not have_link 'Apagar'

    uncheck bidder_checkbok_html_name(0)

    click_button 'Salvar'

    page.should have_content 'Homologação e Adjudicação de Processo Licitatório editado com sucesso.'

    within_records do
      click_link licitation_process.to_s
    end

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Participante vencedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Data de homologação', :with => I18n.l(Date.current)
    page.should have_field 'Data de adjudicação', :with => I18n.l(Date.current)

    page.should have_content 'Antivirus'
    page.should have_content '10,00'

    page.should_not have_checked_field bidder_checkbok_html_name(0)
  end

  def bidder_checkbok_html_name(number)
    "licitation_process_ratification[licitation_process_bidder_proposals_attributes][#{number}][ratificated]"
  end
end
