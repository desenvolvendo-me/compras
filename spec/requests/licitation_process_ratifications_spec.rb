# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessRatifications" do
  background do
    sign_in
  end

  scenario 'creating and updating a ratification to licitation process' do
    licitation = LicitationProcess.make!(:processo_licitatorio_computador,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      bidders:[Bidder.make!(:licitante_sobrinho, enabled: true)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, ranking: 1)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation, ranking: 1)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_disabled_field 'Processo de compra'

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '2,99'
    expect(page).to have_content '4,99'
    expect(page).to have_content '9,98'

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    within_records do
      click_link '1'
    end

    expect(page).to have_disabled_field 'Processo de compra'
    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Concorrência 1'
    expect(page).to have_field 'Participante vencedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Sequência', :with => '1'

    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '2,99'
    expect(page).to have_content '4,99'
    expect(page).to have_content '9,98'

    expect(page).to have_checked_field bidder_checkbok_html_name(0)

    expect(page).to_not have_link 'Apagar'
    expect(page).to have_disabled_field 'Processo de compra'

    fill_in 'Data de homologação', :with => "#{I18n.l(Date.tomorrow)}"
    fill_in 'Data de adjudicação', :with => "#{I18n.l(Date.tomorrow)}"

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra editada com sucesso.'

    within_records do
      click_link '1 - Processo de Compra 2/2013 - Concorrência 1'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Concorrência 1'
    expect(page).to have_field 'Participante vencedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.tomorrow)
    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '2,99'
    expect(page).to have_content '4,99'
    expect(page).to have_content '9,98'

    expect(page).to have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'creating and updating a ratification to direct purchase' do
    creditor = Creditor.make!(:sobrinho_sa)
    licitation = LicitationProcess.make!(:compra_direta,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      items: [PurchaseProcessItem.make!(:item_arame_farpado, creditor: creditor),
        PurchaseProcessItem.make!(:item_arame, creditor: creditor)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, ranking: 1)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation, ranking: 1)
    Bidder.make!(:licitante_sobrinho, licitation_process: licitation, creditor: creditor, enabled: true)
    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_disabled_field 'Processo de compra'

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '1'
    expect(page).to have_content '10,00'
    expect(page).to have_content '2'
    expect(page).to have_content '30,00'
    expect(page).to have_content '60,00'

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    within_records do
      click_link '1'
    end

    expect(page).to have_disabled_field 'Processo de compra'
    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Concorrência 1'
    expect(page).to have_field 'Participante vencedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Sequência', :with => '1'

    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '1'
    expect(page).to have_content '2'
    expect(page).to have_content '10,00'
    expect(page).to have_content '30,00'
    expect(page).to have_content '60,00'

    expect(page).to have_checked_field bidder_checkbok_html_name(0)

    expect(page).to_not have_link 'Apagar'
    expect(page).to have_disabled_field 'Processo de compra'

    fill_in 'Data de homologação', :with => "#{I18n.l(Date.tomorrow)}"
    fill_in 'Data de adjudicação', :with => "#{I18n.l(Date.tomorrow)}"

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra editada com sucesso.'

    within_records do
      click_link '1 - Processo de Compra 2/2013 - Concorrência 1'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Concorrência 1'
    expect(page).to have_field 'Participante vencedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.tomorrow)
    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '1'
    expect(page).to have_content '2'
    expect(page).to have_content '10,00'
    expect(page).to have_content '30,00'
    expect(page).to have_content '60,00'

    expect(page).to have_checked_field bidder_checkbok_html_name(0)
  end

  scenario 'cleaning items' do
    licitation = LicitationProcess.make!(:processo_licitatorio_computador,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      bidders:[Bidder.make!(:licitante_sobrinho, enabled: true)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, ranking: 1)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation, ranking: 1)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'

    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    fill_modal 'Processo de compra', :with => '2013', :field => 'Ano'

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '2,99'
    expect(page).to have_content '4,99'
    expect(page).to have_content '9,98'

    clear_modal 'Participante vencedor'

    expect(page).to_not have_content 'Arame comum'
    expect(page).to_not have_content 'Arame farpado'
  end

  scenario 'print report' do
    Prefecture.make!(:belo_horizonte)
    licitation = LicitationProcess.make!(:processo_licitatorio_computador)
    LicitationProcessRatification.make!(:processo_licitatorio_computador)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, ranking: 1)
    SignatureConfiguration.make!(:homologacao_e_adjudicao_do_processo_licitatorio)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'

    within_records do
      click_link '1 - Processo de Compra 2/2013 - Concorrência 1'
    end

    click_link 'Imprimir termo'

    expect(page).to have_content '1'
    expect(page).to have_content '2/2013'
    expect(page).to have_content 'Concorrência'
    expect(page).to have_content I18n.l Date.current
    expect(page).to have_content 'Licitação para compra de carteiras'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content '02.02.00001 - Arame farpado'
    expect(page).to have_content '2'
    expect(page).to have_content '-'
    expect(page).to have_content '4,99'
    expect(page).to have_content '9,98'
    expect(page).to have_content '1 - 3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
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
