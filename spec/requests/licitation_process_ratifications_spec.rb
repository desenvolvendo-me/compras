# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessRatifications" do
  background do
    sign_in
  end

  scenario 'creating a new ratification' do
    LicitationProcess.make!(:processo_licitatorio_computador,
                            :judgment_form => JudgmentForm.make!(:por_item_com_menor_preco))
    BidderProposal.make!(:proposta_licitante_1, :bidder => Bidder.make!(:licitante))

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_button 'Apurar'
    click_link 'voltar'
    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_disabled_field 'Processo de compra'

    within_modal 'Participante vencedor' do
      expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
      expect(page).to have_disabled_field 'Processo de compra'

      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    expect(page).to have_content 'Antivirus'
    expect(page).to have_content '10,00'

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    within_records do
      click_link '1'
    end

    expect(page).to have_disabled_field 'Processo de compra'
    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Participante vencedor', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Sequência', :with => '1'

    expect(page).to have_content 'Antivirus'
    expect(page).to have_content '10,00'

    expect(page).to have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'updating a ratification' do
    LicitationProcessRatification.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'

    within_records do
      click_link '1 - Processo de Compra 2/2013 - Convite 1'
    end

    expect(page).to_not have_link 'Apagar'
    expect(page).to have_disabled_field 'Processo de compra'

    fill_in 'Data de homologação', :with => "#{I18n.l(Date.tomorrow)}"
    fill_in 'Data de adjudicação', :with => "#{I18n.l(Date.tomorrow)}"

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra editada com sucesso.'

    within_records do
      click_link '1 - Processo de Compra 2/2013 - Convite 1'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Participante vencedor', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.tomorrow)
    expect(page).to have_content 'Antivirus'
    expect(page).to have_content '10,00'

    expect(page).to_not have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'cleaning items' do
    LicitationProcess.make!(:processo_licitatorio_computador,
                            :judgment_form => JudgmentForm.make!(:por_item_com_menor_preco))
    BidderProposal.make!(:proposta_licitante_1, :bidder => Bidder.make!(:licitante))

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_button 'Apurar'
    click_link 'voltar'

    click_link 'Adjudicação/Homologação'

    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    fill_modal 'Processo de compra', :with => '2013', :field => 'Ano'

    within_modal 'Participante vencedor' do
      expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
      expect(page).to have_disabled_field 'Processo de compra'

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
    BidderProposal.make!(:proposta_licitante_1, :bidder => Bidder.make!(:licitante))
    SignatureConfiguration.make!(:homologacao_e_adjudicao_do_processo_licitatorio)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'

    within_records do
      click_link '1 - Processo de Compra 2/2013 - Convite 1'
    end

    click_link 'Imprimir termo'

    expect(page).to have_content '1'
    expect(page).to have_content '2/2013'
    expect(page).to have_content 'Convite'
    expect(page).to have_content I18n.l Date.current
    expect(page).to have_content 'Licitação para compra de carteiras'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content '01.01.00001 - Antivirus'
    expect(page).to have_content '10'
    expect(page).to have_content '-'
    expect(page).to have_content '10,00'
    expect(page).to have_content '20,00'
    expect(page).to have_content '1 - Vencimentos e Salários'
    expect(page).to have_content 'Supervisor'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Gerente'
    expect(page).to have_content 'Gabriel Sobrinho'
  end

  scenario "Bidder's modal should not have button new", intermittent: true do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'

    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    fill_modal 'Processo de compra', :with => '2012', :field => 'Ano'

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'

      expect(page).to_not have_link 'Novo'
    end
  end

  def bidder_checkbok_html_name(number)
    "licitation_process_ratification[licitation_process_ratification_items_attributes][#{number}][ratificated]"
  end
end
