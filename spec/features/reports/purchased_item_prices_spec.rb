# encoding: utf-8
require 'spec_helper'

feature 'Report::PurchasedItemPrices' do
  background do
    sign_in
  end

  scenario 'it generates the report filtering with date only' do
    make_dependencies!

    navigate 'Relatórios > Valores Praticados por Item'

    within '.purchased_item_price_report_start_date' do
      expect(page).to have_field 'Data inicial', with: I18n.l(Date.today.at_beginning_of_month)
    end

    within '.purchased_item_price_report_end_date' do
      expect(page).to have_field 'Data final', with: I18n.l(Date.today.at_end_of_month)
    end

    fill_in 'Data inicial', with: '01/01/2012'
    fill_in 'Data final',   with: '01/01/2014'

    click_button 'Gerar Relatório de valores praticados por itens'

    within 'table.records:nth-child(1)' do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Wenderson Malheiros'
    end

    within 'table.records:nth-child(2)' do
      expect(page).to have_content 'Processo de compra'
      expect(page).to have_content '2/2013 - Concorrência 1'
    end

    within 'table.records:nth-child(3)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'R$ 4,99'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'R$ 2,99'
      end
    end

    click_link 'Imprimir'

    expect(page).to have_content 'Relatório de valores praticados por itens'

    within '.filters' do
      expect(page).to have_content 'Filtros utilizados'
      expect(page).to have_content 'Agrupamento: Fornecedor'
      expect(page).to have_content 'Período: 01/01/2012 até 01/01/2014'
    end

    within '.report-records' do
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content '2/2013 - Concorrência 1'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'R$ 4,99'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'R$ 2,99'
      end
    end
  end

  scenario 'it generates the report grouping by creditor' do
    make_dependencies!

    navigate 'Relatórios > Valores Praticados por Item'

     within '.purchased_item_price_report_start_date' do
      expect(page).to have_field 'Data inicial', with: I18n.l(Date.today.at_beginning_of_month)
    end

    within '.purchased_item_price_report_end_date' do
      expect(page).to have_field 'Data final', with: I18n.l(Date.today.at_end_of_month)
    end

    fill_in 'Data inicial', with: '01/01/2012'
    fill_in 'Data final',   with: '01/01/2014'

    fill_modal 'Processo de compra', with: '2', field: 'Processo'
    fill_modal 'Fornecedor', with: 'Wenderson'
    fill_modal 'Material', with: 'Arame comum', field: 'Descrição'

    select 'Fornecedor', from: 'Agrupamento'
    select 'Processo licitatório', from: 'Tipo de compra'
    select 'Concorrência', from: 'Modalidade'

    click_button 'Gerar Relatório de valores praticados por itens'

    within 'table.records:nth-child(1)' do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Wenderson Malheiros'
    end

    within 'table.records:nth-child(2)' do
      expect(page).to have_content 'Processo de compra'
      expect(page).to have_content '2/2013 - Concorrência 1'
    end

    within 'table.records:nth-child(3)' do
      expect(page).to have_content 'Item'
      expect(page).to have_content 'Valor Unitário'
      expect(page).to have_content '02.02.00002 - Arame comum'
      expect(page).to have_content 'R$ 2,99'
    end

    click_link 'Imprimir'

    expect(page).to have_content 'Relatório de valores praticados por itens'

    within '.filters' do
      expect(page).to have_content 'Filtros utilizados'
      expect(page).to have_content 'Processo de compra: 2/2013 - Concorrência 1'
      expect(page).to have_content 'Fornecedor: Wenderson Malheiros'
      expect(page).to have_content 'Material: 02.02.00002 - Arame comum'
      expect(page).to have_content 'Tipo de compra: Processo licitatório'
      expect(page).to have_content 'Modalidade: Concorrência'
      expect(page).to have_content 'Agrupamento: Fornecedor'
      expect(page).to have_content 'Período: 01/01/2012 até 01/01/2014'
    end

    within '.report-records' do
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content '2/2013 - Concorrência 1'

      within 'table.records' do
        expect(page).to have_content 'Item'
        expect(page).to have_content 'Valor Unitário'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'R$ 2,99'
      end
    end
  end

  scenario 'it generates the report grouping by licitation process' do
    make_dependencies!

    navigate 'Relatórios > Valores Praticados por Item'

    within '.purchased_item_price_report_start_date' do
      expect(page).to have_field 'Data inicial', with: I18n.l(Date.today.at_beginning_of_month)
    end

    within '.purchased_item_price_report_end_date' do
      expect(page).to have_field 'Data final', with: I18n.l(Date.today.at_end_of_month)
    end

    fill_in 'Data inicial', with: '01/01/2012'
    fill_in 'Data final',   with: '01/01/2014'

    fill_modal 'Processo de compra', with: '2', field: 'Processo'
    fill_modal 'Fornecedor', with: 'Wenderson'
    fill_modal 'Material', with: 'Arame comum', field: 'Descrição'

    select 'Processo', from: 'Agrupamento'
    select 'Processo licitatório', from: 'Tipo de compra'
    select 'Concorrência', from: 'Modalidade'

    click_button 'Gerar Relatório de valores praticados por itens'

    within 'table.records:nth-child(1)' do
      expect(page).to have_content 'Processo de compra'
      expect(page).to have_content '2/2013 - Concorrência 1'
    end

    within 'table.records:nth-child(2)' do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Wenderson Malheiros'
    end

    within 'table.records:nth-child(3)' do
      expect(page).to have_content 'Item'
      expect(page).to have_content 'Valor Unitário'
      expect(page).to have_content '02.02.00002 - Arame comum'
      expect(page).to have_content 'R$ 2,99'
    end

    click_link 'Imprimir'

    expect(page).to have_content 'Relatório de valores praticados por itens'

    within '.filters' do
      expect(page).to have_content 'Filtros utilizados'
      expect(page).to have_content 'Processo de compra: 2/2013 - Concorrência 1'
      expect(page).to have_content 'Fornecedor: Wenderson Malheiros'
      expect(page).to have_content 'Material: 02.02.00002 - Arame comum'
      expect(page).to have_content 'Tipo de compra: Processo licitatório'
      expect(page).to have_content 'Modalidade: Concorrência'
      expect(page).to have_content 'Agrupamento: Processo'
      expect(page).to have_content 'Período: 01/01/2012 até 01/01/2014'
    end

    within '.report-records' do
      expect(page).to have_content '2/2013 - Concorrência 1'
      expect(page).to have_content 'Wenderson Malheiros'

      within 'table.records' do
        expect(page).to have_content 'Item'
        expect(page).to have_content 'Valor Unitário'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'R$ 2,99'
      end
    end
  end

  scenario 'it generates the report grouping by material' do
    make_dependencies!

    navigate 'Relatórios > Valores Praticados por Item'

    within '.purchased_item_price_report_start_date' do
      expect(page).to have_field 'Data inicial', with: I18n.l(Date.today.at_beginning_of_month)
    end

    within '.purchased_item_price_report_end_date' do
      expect(page).to have_field 'Data final', with: I18n.l(Date.today.at_end_of_month)
    end

    fill_in 'Data inicial', with: '01/01/2012'
    fill_in 'Data final',   with: '01/01/2014'

    fill_modal 'Processo de compra', with: '2', field: 'Processo'
    fill_modal 'Fornecedor', with: 'Wenderson'
    fill_modal 'Material', with: 'Arame comum', field: 'Descrição'

    select 'Material', from: 'Agrupamento'
    select 'Processo licitatório', from: 'Tipo de compra'
    select 'Concorrência', from: 'Modalidade'

    click_button 'Gerar Relatório de valores praticados por itens'

    within 'table.records:nth-child(1)' do
      expect(page).to have_content 'Item'
      expect(page).to have_content '02.02.00002 - Arame comum'
    end

    within 'table.records:nth-child(2)' do
      expect(page).to have_content 'Processo de compra'
      expect(page).to have_content '2/2013 - Concorrência 1'
    end

    within 'table.records:nth-child(3)' do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Valor Unitário'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content 'R$ 2,99'
    end

    click_link 'Imprimir'

    expect(page).to have_content 'Relatório de valores praticados por itens'

    within '.filters' do
      expect(page).to have_content 'Filtros utilizados'
      expect(page).to have_content 'Processo de compra: 2/2013 - Concorrência 1'
      expect(page).to have_content 'Fornecedor: Wenderson Malheiros'
      expect(page).to have_content 'Material: 02.02.00002 - Arame comum'
      expect(page).to have_content 'Tipo de compra: Processo licitatório'
      expect(page).to have_content 'Modalidade: Concorrência'
      expect(page).to have_content 'Agrupamento: Material'
      expect(page).to have_content 'Período: 01/01/2012 até 01/01/2014'
    end

    within '.report-records' do
      expect(page).to have_content '2/2013 - Concorrência 1'
      expect(page).to have_content 'Wenderson Malheiros'

      within 'table.records' do
        expect(page).to have_content 'Fornecedor'
        expect(page).to have_content 'Valor Unitário'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'R$ 2,99'
      end
    end
  end

  scenario 'it generates the report of direct purchase' do
    creditor_wenderson = Creditor.make!(:wenderson_sa)

    item = PurchaseProcessItem.make!(:item, creditor: creditor_wenderson,
      unit_price: 5.99)
    item_arame = PurchaseProcessItem.make!(:item_arame, creditor: creditor_wenderson,
      unit_price: 9.99)

    purchase_process = LicitationProcess.make!(:compra_direta,
      bidders: [Bidder.make!(:licitante, creditor: creditor_wenderson)],
      items: [item, item_arame])

    ratification_item_1 = LicitationProcessRatificationItem.make!(:item,
      licitation_process_ratification: nil,
      purchase_process_creditor_proposal: nil,
      purchase_process_item: item)

    ratification_item_2 = LicitationProcessRatificationItem.make!(:item,
      licitation_process_ratification: nil,
      purchase_process_creditor_proposal: nil,
      purchase_process_item: item_arame)

    LicitationProcessRatification.make!(:processo_licitatorio_computador,
      adjudication_date: Date.new(2013, 01, 01),
      creditor: creditor_wenderson,
      licitation_process: purchase_process,
      licitation_process_ratification_items: [ratification_item_1, ratification_item_2])

    navigate 'Relatórios > Valores Praticados por Item'

    within '.purchased_item_price_report_start_date' do
      expect(page).to have_field 'Data inicial', with: I18n.l(Date.today.at_beginning_of_month)
    end

    within '.purchased_item_price_report_end_date' do
      expect(page).to have_field 'Data final', with: I18n.l(Date.today.at_end_of_month)
    end

    fill_in 'Data inicial', with: '01/01/2012'
    fill_in 'Data final',   with: '01/01/2014'

    select 'Processo licitatório', from: 'Tipo de compra'

    click_button 'Gerar Relatório de valores praticados por itens'

    expect(page).to_not have_css 'table.records'

    select 'Compra direta', from: 'Tipo de compra'

    click_button 'Gerar Relatório de valores praticados por itens'

    within 'table.records:nth-child(1)' do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Wenderson Malheiros'
    end

    within 'table.records:nth-child(2)' do
      expect(page).to have_content 'Processo de compra'
      expect(page).to have_content '2/2013 - Dispensa justificadas 1'
    end

    within 'table.records:nth-child(3)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'R$ 5,99'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'R$ 9,99'
      end
    end

    click_link 'Imprimir'

    expect(page).to have_content 'Relatório de valores praticados por itens'

    within '.filters' do
      expect(page).to have_content 'Filtros utilizados'
      expect(page).to have_content 'Agrupamento: Fornecedor'
      expect(page).to have_content 'Período: 01/01/2012 até 01/01/2014'
    end

    within '.report-records' do
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content '2/2013 - Dispensa justificadas 1'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'R$ 5,99'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'R$ 9,99'
      end
    end
  end

  def make_dependencies!
    wenderson = Creditor.make!(:wenderson_sa)

    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador,
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    licitation_process.items.first.material.update_attribute(:control_amount, true)

    proposal_1 = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: licitation_process, creditor: wenderson)

    proposal_2 = PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: licitation_process, creditor: wenderson)

    ratification_item_1 = LicitationProcessRatificationItem.make!(:item,
      licitation_process_ratification: nil,
      purchase_process_item: PurchaseProcessItem.make(:item_arame_farpado),
      purchase_process_creditor_proposal: proposal_1)

    ratification_item_2 = LicitationProcessRatificationItem.make!(:item,
      licitation_process_ratification: nil,
      purchase_process_item: PurchaseProcessItem.make(:item_arame),
      purchase_process_creditor_proposal: proposal_2)

    LicitationProcessRatification.make!(:processo_licitatorio_computador,
      adjudication_date: Date.new(2013, 01, 01),
      creditor: wenderson,
      licitation_process: licitation_process,
      licitation_process_ratification_items: [ratification_item_1, ratification_item_2])
  end
end
