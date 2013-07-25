# encoding: utf-8
require 'spec_helper'

feature "RealignmentPrices" do
  let :budget_structure do
    BudgetStructure.new(
      id: 1,
      code: '1',
      full_code: '1',
      tce_code: '051',
      description: 'Secretaria de Desenvolvimento',
      acronym: 'SEMUEDU',
      performance_field: 'Desenvolvimento Educacional')
  end

  background do
    BudgetStructure.stub(:find).and_return(budget_structure)
    sign_in

    ExpenseNature.stub(:all)
    ExpenseNature.stub(:find)
    BudgetAllocation.stub(:all)
    BudgetAllocation.stub(:find)
  end

  scenario 'create a new realignment_price by lot' do
    creditor_ibm   = Creditor.make!(:ibm)
    creditor_nohup = Creditor.make!(:nohup)

    antivirus     = PurchaseProcessItem.make(:item, lot: 1010)
    arame         = PurchaseProcessItem.make!(:item_arame, lot: 50)
    arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado, lot: 50)

    purchase_process = LicitationProcess.make!(:valor_maximo_ultrapassado,
      publications: [LicitationProcessPublication.make!(:publicacao)],
      items: [antivirus, arame, arame_farpado],
      bidders: [Bidder.make!(:licitante_com_proposta_3, creditor: creditor_nohup,
                              licitation_process: purchase_process, enabled: true),
                Bidder.make!(:licitante_com_proposta_7, creditor: creditor_ibm,
                              licitation_process: purchase_process, enabled: true)])

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_nohup,
      licitation_process: purchase_process, lot: 1010, unit_price: 100.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_nohup,
      licitation_process: purchase_process, lot: 50, unit_price: 270.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_ibm,
      licitation_process: purchase_process, lot: 1010, unit_price: 180.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_ibm, creditor: creditor_ibm,
      licitation_process: purchase_process, lot: 50, unit_price: 200.00)

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Limpar Filtro'
    click_link '1/2012'

    click_link 'Realinhamento de preço'

    within_records do
      within 'thead tr' do
        expect(page).to have_content 'Fornecedor'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Lote'
      end

      within 'tbody tr:first' do
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'ibm@gmail.com'
        expect(page).to have_content '50'
        expect(page).to have_content 'Criar realinhamento de preço'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Nohup'
        expect(page).to have_content 'wenderson@gmail.com'
        expect(page).to have_content '1010'
        expect(page).to have_content 'Criar realinhamento de preço'
      end

      within 'tbody tr:first' do
        click_link 'Criar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "200,00"
    expect(page).to have_disabled_field "Diferença", with: "200,00"

    within '#items .nested-realignment_price_items:first' do
      expect(page).to have_disabled_field 'Item', with: '02.02.00002 - Arame comum'
      expect(page).to have_disabled_field 'Quantidade', with: '1'

      fill_in 'Marca', with: 'Comum'
      fill_in 'Valor', with: '100,00'
      fill_in 'Data de entrega', with: '21/10/2013'
    end

    within '#items .nested-realignment_price_items:last' do
      expect(page).to have_disabled_field 'Item', with: '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      fill_in 'Marca', with: 'Farpado'
      fill_in 'Valor', with: '50,00'
      fill_in 'Data de entrega', with: '25/10/2013'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Realinhamento de Preço criado com sucesso.'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_content 'IBM'
        expect(page).to have_content '50'
        expect(page).to have_content 'Editar realinhamento de preço'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Nohup'
        expect(page).to have_content '1010'

        click_link 'Criar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "100,00"
    expect(page).to have_disabled_field "Diferença", with: "100,00"

    within '#items .nested-realignment_price_items:first' do
      expect(page).to have_disabled_field 'Item', with: '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      fill_in 'Marca', with: 'Antivirus'
      fill_in 'Valor', with: '50,00'
      fill_in 'Data de entrega', with: '21/10/2013'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Realinhamento de Preço criado com sucesso.'

     within_records do
      within 'tbody tr:first' do
        expect(page).to have_content 'IBM'
        expect(page).to have_content '50'
        expect(page).to have_content 'Editar realinhamento de preço'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Nohup'
        expect(page).to have_content '1010'

        click_link 'Editar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "100,00"
    expect(page).to have_disabled_field "Diferença", with: "0,00"

    within '#items .nested-realignment_price_items:first' do
      expect(page).to have_disabled_field 'Item', with: '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      expect(page).to have_field 'Marca', with: 'Antivirus'
      expect(page).to have_field 'Valor', with: '50,00'
      expect(page).to have_field 'Data de entrega', with: '21/10/2013'

      fill_in 'Data de entrega', with: '25/10/2013'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Realinhamento de Preço editado com sucesso.'

    within_records do
      within 'tbody tr:last' do
        expect(page).to have_content 'Nohup'
        expect(page).to have_content '1010'

        click_link 'Editar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "100,00"
    expect(page).to have_disabled_field "Diferença", with: "0,00"

    within '#items .nested-realignment_price_items:first' do
      expect(page).to have_disabled_field 'Item', with: '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      expect(page).to have_field 'Marca', with: 'Antivirus'
      expect(page).to have_field 'Valor', with: '50,00'
      expect(page).to have_field 'Data de entrega', with: '25/10/2013'
    end
  end

  scenario 'create a new realignment_price global' do
    creditor_nohup = Creditor.make!(:nohup)
    creditor_ibm   = Creditor.make!(:ibm)

    antivirus     = PurchaseProcessItem.make(:item, lot: 1010)
    arame         = PurchaseProcessItem.make!(:item_arame, lot: 50)
    arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado, lot: 50)

    purchase_process = LicitationProcess.make!(:valor_maximo_ultrapassado,
      judgment_form: JudgmentForm.make!(:global_com_menor_preco),
      publications: [LicitationProcessPublication.make!(:publicacao)],
      items: [antivirus, arame, arame_farpado],
      bidders: [Bidder.make!(:licitante_com_proposta_3, creditor: creditor_nohup,
                              licitation_process: purchase_process, enabled: true),
                Bidder.make!(:licitante_com_proposta_7, creditor: creditor_ibm,
                              licitation_process: purchase_process, enabled: true)])

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_nohup,
      licitation_process: purchase_process, unit_price: 300.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_ibm,
      licitation_process: purchase_process, unit_price: 500.00)

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Limpar Filtro'
    click_link '1/2012'

    click_link 'Realinhamento de preço'

    within_records do
      expect(page).to have_css 'tbody tr', count: 1

      within 'thead tr' do
        expect(page).to have_content 'Fornecedor'
        expect(page).to have_content 'Email'
        expect(page).to_not have_content 'Lote'
      end

      within 'tbody tr:first' do
        expect(page).to have_content 'Nohup'
        expect(page).to have_content 'wenderson@gmail.com'
        expect(page).to have_content 'Criar realinhamento de preço'

        click_link 'Criar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "300,00"
    expect(page).to have_disabled_field "Diferença", with: "300,00"

    within '#items .nested-realignment_price_items:nth-child(1)' do
      expect(page).to have_disabled_field 'Item', with: '02.02.00002 - Arame comum'
      expect(page).to have_disabled_field 'Quantidade', with: '1'

      fill_in 'Marca', with: 'Comum'
      fill_in 'Valor', with: '100,00'
      fill_in 'Data de entrega', with: '21/10/2013'
    end

    within '#items .nested-realignment_price_items:nth-child(2)' do
      expect(page).to have_disabled_field 'Item', with: '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      fill_in 'Marca', with: 'Farpado'
      fill_in 'Valor', with: '50,00'
      fill_in 'Data de entrega', with: '25/10/2013'
    end

    within '#items .nested-realignment_price_items:nth-child(3)' do
      expect(page).to have_disabled_field 'Item', with: '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      fill_in 'Marca', with: 'Antivirus'
      fill_in 'Valor', with: '50,00'
      fill_in 'Data de entrega', with: '21/10/2013'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Realinhamento de Preço criado com sucesso.'

    within_records do
      within 'tbody tr:first' do
        click_link 'Editar realinhamento de preço'
      end
    end

    within '#items .nested-realignment_price_items:nth-child(1)' do
      expect(page).to have_disabled_field 'Item', with: '02.02.00002 - Arame comum'
      expect(page).to have_disabled_field 'Quantidade', with: '1'

      expect(page).to have_field 'Marca', with: 'Comum'
      expect(page).to have_field 'Valor', with: '100,00'
      expect(page).to have_field 'Data de entrega', with: '21/10/2013'
    end

    within '#items .nested-realignment_price_items:nth-child(2)' do
      expect(page).to have_disabled_field 'Item', with: '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      expect(page).to have_field 'Marca', with: 'Farpado'
      expect(page).to have_field 'Valor', with: '50,00'
      expect(page).to have_field 'Data de entrega', with: '25/10/2013'
    end

    within '#items .nested-realignment_price_items:nth-child(3)' do
      expect(page).to have_disabled_field 'Item', with: '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      expect(page).to have_field 'Marca', with: 'Antivirus'
      expect(page).to have_field 'Valor', with: '50,00'
      expect(page).to have_field 'Data de entrega', with: '21/10/2013'
    end
  end

  scenario 'create a new realignment_price for trading' do
    ibm_creditor  = Creditor.make!(:ibm)
    nobe_creditor = Creditor.make!(:nobe)

    antivirus     = PurchaseProcessItem.make(:item, lot: 1010)
    arame         = PurchaseProcessItem.make!(:item_arame, lot: 50)
    arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado, lot: 50)

    purchase_process = LicitationProcess.make!(:pregao_presencial,
      judgment_form: JudgmentForm.make!(:por_lote_com_menor_preco),
      publications: [LicitationProcessPublication.make!(:publicacao)],
      items: [antivirus, arame, arame_farpado])

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: purchase_process,
      purchase_process_accreditation_creditors: [])

    nobe = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      creditor: nobe_creditor,
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    ibm = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      creditor: ibm_creditor,
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: nobe.creditor,
      licitation_process: purchase_process, lot: 1010, unit_price: 100.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: nobe.creditor,
      licitation_process: purchase_process, lot: 50, unit_price: 270.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: ibm.creditor,
      licitation_process: purchase_process, lot: 1010, unit_price: 180.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_ibm, creditor:  ibm.creditor,
      licitation_process: purchase_process, lot: 50, unit_price: 200.00)

    trading = PurchaseProcessTrading.create!(
      purchase_process_id: purchase_process.id)

    trading_item_lot_1010 = PurchaseProcessTradingItem.create!(
      trading_id: trading.id,
      lot: 1010)

    trading_item_lot_50 = PurchaseProcessTradingItem.create!(
      trading_id: trading.id,
      lot: 50)

    PurchaseProcessTradingItemBid.create!(
      item_id: trading_item_lot_1010.id,
      round: 1,
      number: 1,
      purchase_process_accreditation_creditor_id: ibm.id,
      status: TradingItemBidStatus::DECLINED)

    PurchaseProcessTradingItemBid.create!(
      item_id: trading_item_lot_50.id,
      round: 1,
      number: 1,
      purchase_process_accreditation_creditor_id: nobe.id,
      status: TradingItemBidStatus::DECLINED)

    trading_item_lot_1010.close!
    trading_item_lot_50.close!

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Limpar Filtro'
    click_link '1/2012'

    click_link 'Realinhamento de preço'

    within_records do
      within 'thead tr' do
        expect(page).to have_content 'Fornecedor'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Lote'
      end

      within 'tbody tr:first' do
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'ibm@gmail.com'
        expect(page).to have_content '50'
        expect(page).to have_content 'Criar realinhamento de preço'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content '1010'
        expect(page).to have_content 'Criar realinhamento de preço'
      end

      within 'tbody tr:first' do
        click_link 'Criar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "200,00"
    expect(page).to have_disabled_field "Diferença", with: "200,00"

    within '#items .nested-realignment_price_items:first' do
      expect(page).to have_disabled_field 'Item', with: '02.02.00002 - Arame comum'
      expect(page).to have_disabled_field 'Quantidade', with: '1'

      fill_in 'Marca', with: 'Comum'
      fill_in 'Valor', with: '100,00'
      fill_in 'Data de entrega', with: '21/10/2013'
    end

    within '#items .nested-realignment_price_items:last' do
      expect(page).to have_disabled_field 'Item', with: '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      fill_in 'Marca', with: 'Farpado'
      fill_in 'Valor', with: '50,00'
      fill_in 'Data de entrega', with: '25/10/2013'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Realinhamento de Preço criado com sucesso.'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_content 'IBM'
        expect(page).to have_content '50'
        expect(page).to have_content 'Editar realinhamento de preço'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content '1010'

        click_link 'Criar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "100,00"
    expect(page).to have_disabled_field "Diferença", with: "100,00"

    within '#items .nested-realignment_price_items:first' do
      expect(page).to have_disabled_field 'Item', with: '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      fill_in 'Marca', with: 'Antivirus'
      fill_in 'Valor', with: '50,00'
      fill_in 'Data de entrega', with: '21/10/2013'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Realinhamento de Preço criado com sucesso.'

     within_records do
      within 'tbody tr:first' do
        expect(page).to have_content 'IBM'
        expect(page).to have_content '50'
        expect(page).to have_content 'Editar realinhamento de preço'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content '1010'

        click_link 'Editar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "100,00"
    expect(page).to have_disabled_field "Diferença", with: "0,00"

    within '#items .nested-realignment_price_items:first' do
      expect(page).to have_disabled_field 'Item', with: '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      expect(page).to have_field 'Marca', with: 'Antivirus'
      expect(page).to have_field 'Valor', with: '50,00'
      expect(page).to have_field 'Data de entrega', with: '21/10/2013'

      fill_in 'Data de entrega', with: '25/10/2013'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Realinhamento de Preço editado com sucesso.'

    within_records do
      within 'tbody tr:last' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content '1010'

        click_link 'Editar realinhamento de preço'
      end
    end

    expect(page).to have_disabled_field "Valor total da proposta/lance", with: "100,00"
    expect(page).to have_disabled_field "Diferença", with: "0,00"

    within '#items .nested-realignment_price_items:first' do
      expect(page).to have_disabled_field 'Item', with: '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      expect(page).to have_field 'Marca', with: 'Antivirus'
      expect(page).to have_field 'Valor', with: '50,00'
      expect(page).to have_field 'Data de entrega', with: '25/10/2013'
    end
  end
end
