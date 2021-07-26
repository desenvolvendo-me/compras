require 'spec_helper'

feature "LicitationProcessRatifications", vcr: { cassette_name: :licitation_process_ratifications } do
  background do
    sign_in
  end

  scenario 'creating and updating a ratification to licitation process by item' do
    licitation = LicitationProcess.make!(:processo_licitatorio_computador,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      bidders:[Bidder.make!(:licitante_sobrinho, enabled: true)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, ranking: 1)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation, ranking: 1)

    FactoryGirl.create(:process_responsible, licitation_process: licitation,
      stage_process: StageProcess.make(:emissao_edital))

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_field 'Processo de compra', disabled: true

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

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Concorrência 1', disabled: true
    expect(page).to have_field 'Participante vencedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Sequência', :with => '1', disabled: true

    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '2,99'
    expect(page).to have_content '4,99'
    expect(page).to have_content '9,98'

    expect(page).to have_checked_field bidder_checkbok_html_name(0)

    expect(page).to have_field 'Processo de compra', disabled: true

    fill_in 'Data de homologação', :with => "#{I18n.l(Date.tomorrow)}"
    fill_in 'Data de adjudicação', :with => "#{I18n.l(Date.tomorrow)}"

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra editada com sucesso.'

    within_records do
      click_link '2/2013 - Concorrência 1'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Concorrência 1', disabled: true
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

  scenario 'creating a ratification from a licitation process by lot' do
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

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_nohup,
      licitation_process: purchase_process, lot: 1010, unit_price: 100.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_nohup,
      licitation_process: purchase_process, lot: 50, unit_price: 270.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_ibm,
      licitation_process: purchase_process, lot: 1010, unit_price: 180.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_ibm, creditor: creditor_ibm,
      licitation_process: purchase_process, lot: 50, unit_price: 200.00)

    item_antivirus = RealignmentPriceItem.create!(
      purchase_process_item_id: antivirus.id,
      price: 50.0)

    realignment_1010 = RealignmentPrice.new(
      creditor_id: creditor_nohup.id,
      purchase_process_id: purchase_process.id,
      lot: 1010)

    realignment_1010.items << item_antivirus
    realignment_1010.save!

    item_arame = RealignmentPriceItem.create!(
      purchase_process_item_id: arame.id,
      price: 150.0)

    item_arame_farpado = RealignmentPriceItem.create!(
      purchase_process_item_id: arame_farpado.id,
      price: 25.0)

    realignment_50 = RealignmentPrice.new(
      creditor_id: creditor_ibm.id,
      purchase_process_id: purchase_process.id,
      lot: 50)

    realignment_50.items << item_arame_farpado
    realignment_50.items << item_arame
    realignment_50.save!

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process,
      stage_process: StageProcess.make(:emissao_edital))

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_field 'Processo de compra', disabled: true

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Nohup'
    end

    within_records do
      expect(page).to have_css('tbody tr', count: 1)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '01.01.00001'
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '50,00'
        expect(page).to have_content '100,00'
      end
    end

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'IBM'
    end

    within_records do
      expect(page).to have_css('tbody tr', count: 2)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '02.02.00001'
        expect(page).to have_content 'Arame farpado'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '25,00'
        expect(page).to have_content '50,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002'
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '150,00'
        expect(page).to have_content '150,00'
      end
    end

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    within_records do
      click_link '1'
    end

    expect(page).to have_field 'Sequência', :with => '1', disabled: true
    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Convite 1', disabled: true
    expect(page).to have_field 'Participante vencedor', :with => 'IBM'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '02.02.00001'
        expect(page).to have_content 'Arame farpado'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '25,00'
        expect(page).to have_content '50,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002'
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '150,00'
        expect(page).to have_content '150,00'
      end
    end

    expect(page).to have_checked_field bidder_checkbok_html_name(0)

    expect(page).to have_field 'Processo de compra', disabled: true

    fill_in 'Data de homologação', :with => "#{I18n.l(Date.tomorrow)}"
    fill_in 'Data de adjudicação', :with => "#{I18n.l(Date.tomorrow)}"
  end

  scenario 'creating a ratification from a licitation process global' do
    creditor_ibm   = Creditor.make!(:ibm)
    creditor_nohup = Creditor.make!(:nohup)

    arame         = PurchaseProcessItem.make!(:item_arame, lot: 50)
    arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado, lot: 50)

    purchase_process = LicitationProcess.make!(:valor_maximo_ultrapassado,
      judgment_form: JudgmentForm.make!(:global_com_menor_preco),
      publications: [LicitationProcessPublication.make!(:publicacao)],
      items: [arame, arame_farpado],
      bidders: [Bidder.make!(:licitante_com_proposta_3, creditor: creditor_nohup,
                              licitation_process: purchase_process, enabled: true),
                Bidder.make!(:licitante_com_proposta_7, creditor: creditor_ibm,
                              licitation_process: purchase_process, enabled: true)])

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process)

    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_nohup,
      licitation_process: purchase_process, unit_price: 300.00)

    PurchaseProcessCreditorProposal.make!(:proposta_global_ibm, creditor: creditor_ibm,
      licitation_process: purchase_process, unit_price: 200.00)

    item_arame = RealignmentPriceItem.create!(
      purchase_process_item_id: arame.id,
      price: 150.0)

    item_arame_farpado = RealignmentPriceItem.create!(
      purchase_process_item_id: arame_farpado.id,
      price: 25.0)

    realignment_50 = RealignmentPrice.new(
      creditor_id: creditor_ibm.id,
      purchase_process_id: purchase_process.id,
      lot: 50)

    realignment_50.items << item_arame_farpado
    realignment_50.items << item_arame
    realignment_50.save!

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process,
      stage_process: StageProcess.make(:emissao_edital))

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_field 'Processo de compra', disabled: true

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'IBM'
    end

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '02.02.00001'
        expect(page).to have_content 'Arame farpado'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '25,00'
        expect(page).to have_content '50,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002'
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '150,00'
        expect(page).to have_content '150,00'
      end
    end

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    within_records do
      click_link '1'
    end

    expect(page).to have_field 'Sequência', :with => '1', disabled: true
    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Convite 1', disabled: true
    expect(page).to have_field 'Participante vencedor', :with => 'IBM'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '02.02.00001'
        expect(page).to have_content 'Arame farpado'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '25,00'
        expect(page).to have_content '50,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002'
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '150,00'
        expect(page).to have_content '150,00'
      end
    end

    expect(page).to have_checked_field bidder_checkbok_html_name(0)

    expect(page).to have_field 'Processo de compra', disabled: true

    fill_in 'Data de homologação', :with => "#{I18n.l(Date.tomorrow)}"
    fill_in 'Data de adjudicação', :with => "#{I18n.l(Date.tomorrow)}"
  end

  scenario 'creating and updating ratification for trading by item' do
    creditor_sobrinho = Creditor.make!(:sobrinho_sa)
    creditor_nohup    = Creditor.make!(:nohup)

    item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado)
    item_arame         = PurchaseProcessItem.make!(:item_arame)
    item               = PurchaseProcessItem.make!(:item)

    licitation = LicitationProcess.make!(:pregao_presencial,
      bidders: [],
      items: [item_arame_farpado, item_arame, item])

    accreditation_sobrinho = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor,
      creditor: creditor_sobrinho)

    accreditation_nohup = PurchaseProcessAccreditationCreditor.make(:wenderson_creditor,
      creditor: creditor_nohup)

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: licitation,
      purchase_process_accreditation_creditors: [accreditation_sobrinho, accreditation_nohup])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation, creditor: creditor_sobrinho,
        item: item_arame_farpado, unit_price: 3.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation, creditor: creditor_sobrinho,
        item: item_arame, unit_price: 15.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation, creditor: creditor_sobrinho,
        item: item, unit_price: 2.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation, creditor: creditor_nohup,
        item: item_arame_farpado, unit_price: 9.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation, creditor: creditor_nohup,
        item: item_arame, unit_price: 5.00)

     PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation, creditor: creditor_nohup,
        item: item, unit_price: 15.00)

    trading = PurchaseProcessTrading.create!(purchase_process_id: licitation.id)

    trading_item_arame_farpado = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: item_arame_farpado.id)

    trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: item_arame.id)

    trading_item = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: item.id)

    accreditation_sobrinho = accreditation.purchase_process_accreditation_creditors.first
    accreditation_nohup    = accreditation.purchase_process_accreditation_creditors.last

    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame_farpado.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

    trading_item_arame_farpado.close!
    trading_item_arame.close!
    trading_item.update_column :status, PurchaseProcessTradingItemStatus::FAILED

    Bidder.make!(:licitante, creditor: creditor_sobrinho, enabled: true,
      licitation_process: licitation)
    Bidder.make!(:licitante, creditor: creditor_nohup, enabled: true,
      licitation_process: licitation)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation)

    FactoryGirl.create(:process_responsible, licitation_process: licitation,
      stage_process: StageProcess.make(:emissao_edital))

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_field 'Processo de compra', disabled: true

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'

      within_records do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Nohup'
      end

      click_link 'Voltar'
    end

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    expect(page).to have_content '02.02.00001'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content 'UN'
    expect(page).to have_content '2'
    expect(page).to have_content '3,00'
    expect(page).to have_content '6,00'

    expect(page).to_not have_content '01.01.00001'
    expect(page).to_not have_content 'Antivirus'

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

     within_modal 'Participante vencedor' do
      click_button 'Pesquisar'

      within_records do
        expect(page).to_not have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Nohup'
      end

      click_link 'Voltar'
    end

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Nohup'
    end

    expect(page).to have_content '02.02.00002'
    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'UN'
    expect(page).to have_content '1'
    expect(page).to have_content '5,00'
    expect(page).to have_content '5,00'

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'

      within_records do
        expect(page).to_not have_content 'Gabriel Sobrinho'
        expect(page).to_not have_content 'Nohup'
      end
    end
  end

  scenario 'creating and updating ratification for trading by lot' do
    creditor_sobrinho = Creditor.make!(:sobrinho_sa)
    creditor_nohup    = Creditor.make!(:nohup)

    item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado, lot: 50)
    item_arame         = PurchaseProcessItem.make!(:item_arame, lot: 50)
    item               = PurchaseProcessItem.make!(:item, lot: 1010)

    licitation = LicitationProcess.make!(:pregao_presencial,
      bidders: [],
      judgment_form: JudgmentForm.make!(:por_lote_com_melhor_tecnica),
      items: [item_arame_farpado, item_arame, item])

    accreditation_sobrinho = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor,
      creditor: creditor_sobrinho)

    accreditation_nohup = PurchaseProcessAccreditationCreditor.make(:wenderson_creditor,
      creditor: creditor_nohup)

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: licitation,
      purchase_process_accreditation_creditors: [accreditation_sobrinho, accreditation_nohup])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation, creditor: creditor_sobrinho,
        lot: 50, unit_price: 200.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation, creditor: creditor_sobrinho,
        lot: 1010, unit_price: 500.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation, creditor: creditor_nohup,
        lot: 50, unit_price: 500.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation, creditor: creditor_nohup,
        lot: 1010, unit_price: 100.00)

    trading = PurchaseProcessTrading.create!(purchase_process_id: licitation.id)

    trading_item_50 = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      lot: 50)

    trading_item_1010 = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      lot: 1010)

    accreditation_sobrinho = accreditation.purchase_process_accreditation_creditors.first
    accreditation_nohup    = accreditation.purchase_process_accreditation_creditors.last

    PurchaseProcessTradingItemBid.create!(item_id: trading_item_50.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

    PurchaseProcessTradingItemBid.create!(item_id: trading_item_1010.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 0, round: 1, number: 1, status: TradingItemBidStatus::DECLINED)

    trading_item_50.close!
    trading_item_1010.close!

    Bidder.make!(:licitante, creditor: creditor_sobrinho, enabled: true,
      licitation_process: licitation)
    Bidder.make!(:licitante, creditor: creditor_nohup, enabled: true,
      licitation_process: licitation)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation)

    FactoryGirl.create(:process_responsible, licitation_process: licitation,
      stage_process: StageProcess.make(:emissao_edital))

    realignment_item = RealignmentPriceItem.create!(
      purchase_process_item_id: item.id,
      price: 50.0)

    realignment_1010 = RealignmentPrice.new(
      creditor_id: creditor_nohup.id,
      purchase_process_id: licitation.id,
      lot: 1010)

    realignment_1010.items << realignment_item
    realignment_1010.save!

    realignment_item_arame = RealignmentPriceItem.create!(
      purchase_process_item_id: item_arame.id,
      price: 150.0)

    realignment_item_arame_farpado = RealignmentPriceItem.create!(
      purchase_process_item_id: item_arame_farpado.id,
      price: 25.0)

    realignment_50 = RealignmentPrice.new(
      creditor_id: creditor_sobrinho.id,
      purchase_process_id: licitation.id,
      lot: 50)

    realignment_50.items << realignment_item_arame_farpado
    realignment_50.items << realignment_item_arame
    realignment_50.save!

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_field 'Processo de compra', disabled: true

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'

      within_records do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Nohup'
      end

      click_link 'Voltar'
    end

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Nohup'
    end

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '01.01.00001'
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '50,00'
        expect(page).to have_content '100,00'
      end
    end

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '02.02.00001'
        expect(page).to have_content 'Arame farpado'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '25,00'
        expect(page).to have_content '50,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002'
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '150,00'
        expect(page).to have_content '150,00'
      end
    end

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    within_records do
      click_link '1/2012 - Pregão 1'
    end

    expect(page).to have_field 'Sequência', :with => '1', disabled: true
    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Pregão 1', disabled: true
    expect(page).to have_field 'Participante vencedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '02.02.00001'
        expect(page).to have_content 'Arame farpado'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '25,00'
        expect(page).to have_content '50,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '02.02.00002'
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '150,00'
        expect(page).to have_content '150,00'
      end
    end
  end

  scenario 'creating and updating a ratification to direct purchase' do
    sobrinho_creditor = Creditor.make!(:sobrinho_sa)
    wenderson_creditor = Creditor.make!(:wenderson_sa)
    licitation = LicitationProcess.make!(:compra_direta,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      items: [
        PurchaseProcessItem.make!(:item_arame_farpado, creditor: sobrinho_creditor),
        PurchaseProcessItem.make!(:item_arame, creditor: sobrinho_creditor),
        PurchaseProcessItem.make!(:item_arame_farpado, creditor: wenderson_creditor),
        PurchaseProcessItem.make!(:item_arame, creditor: wenderson_creditor),
      ])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, ranking: 1)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation, ranking: 1)
    Bidder.make!(:licitante_sobrinho, licitation_process: licitation, creditor: sobrinho_creditor, enabled: true)
    Bidder.make!(:licitante_sobrinho, licitation_process: licitation, creditor: wenderson_creditor, enabled: true)

    FactoryGirl.create(:process_responsible, licitation_process: licitation,
      stage_process: StageProcess.make(:emissao_edital))

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_field 'Processo de compra', disabled: true

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
      click_link '2/2013 - Dispensa justificadas 1'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Dispensa justificadas 1', disabled: true
    expect(page).to have_field 'Participante vencedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data de homologação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data de adjudicação', :with => I18n.l(Date.current)
    expect(page).to have_field 'Sequência', :with => '1', disabled: true

    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content '1'
    expect(page).to have_content '2'
    expect(page).to have_content '10,00'
    expect(page).to have_content '30,00'
    expect(page).to have_content '60,00'

    expect(page).to have_checked_field bidder_checkbok_html_name(0)

    expect(page).to have_field 'Processo de compra', disabled: true

    fill_in 'Data de homologação', :with => "#{I18n.l(Date.tomorrow)}"
    fill_in 'Data de adjudicação', :with => "#{I18n.l(Date.tomorrow)}"

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra editada com sucesso.'

    within_records do
      click_link '2/2013 - Dispensa justificadas 1'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Dispensa justificadas 1', disabled: true
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

    click_link 'Voltar'

    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_field 'Processo de compra', disabled: true

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Wenderson'
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
  end

  scenario 'cleaning items' do
    licitation = LicitationProcess.make!(:processo_licitatorio_computador,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      bidders:[Bidder.make!(:licitante_sobrinho, enabled: true)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, ranking: 1)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation, ranking: 1)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'

    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_field 'Processo de compra', with: '2/2013 - Concorrência 1', disabled: true

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

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'

    within_records do
      click_link '2/2013 - Concorrência 1'
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
    expect(page).to have_content '1 - 3.1.90.00.00 - Aplicações Diretas'
    expect(page).to have_content 'Supervisor'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Gerente'
    expect(page).to have_content 'Gabriel Sobrinho'
  end

  scenario "Bidder's modal should not have button new", intermittent: true do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

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

  scenario 'cant create a ratification if dont have any process_responsibles' do
    licitation = LicitationProcess.make!(:processo_licitatorio_computador,
      judgment_form: JudgmentForm.make!(:por_item_com_menor_preco),
      bidders:[Bidder.make!(:licitante_sobrinho, enabled: true)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, ranking: 1)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation, ranking: 1)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Adjudicação/Homologação'
    click_link 'Criar Homologação e Adjudicação de Processo de Compra'

    expect(page).to have_disabled_element 'Salvar', reason: 'Primeiro crie responsáveis do processo'
    expect(page).to have_link "Criar Responsáveis do processo"

    expect(page).to have_selector "a#process_responsible_link[target='_blank']"
    visit edit_process_responsible_path(licitation.id)

    expect(page).to have_title "Editar responsável do Processo de Compras"
  end

  scenario 'should create a two ratification to licitation_process' do
    creditor_sobrinho  = Creditor.make!(:sobrinho_sa)
    creditor_nohup     = Creditor.make!(:nohup)

    item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado)
    item_arame         = PurchaseProcessItem.make!(:item_arame)

    licitation = LicitationProcess.make!(:pregao_presencial,
      bidders: [],
      items: [item_arame_farpado, item_arame])

    accreditation_sobrinho = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor,
      creditor: creditor_sobrinho)

    accreditation_nohup = PurchaseProcessAccreditationCreditor.make(:wenderson_creditor,
      creditor: creditor_nohup)

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: licitation,
      purchase_process_accreditation_creditors: [accreditation_sobrinho, accreditation_nohup])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation, creditor: creditor_sobrinho,
        item: item_arame_farpado, unit_price: 3.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation, creditor: creditor_sobrinho,
        item: item_arame, unit_price: 15.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation, creditor: creditor_nohup,
        item: item_arame_farpado, unit_price: 9.00)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation, creditor: creditor_nohup,
        item: item_arame, unit_price: 5.00)

    trading = PurchaseProcessTrading.create!(purchase_process_id: licitation.id)

    trading_item_arame_farpado = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: item_arame_farpado.id)

    trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: item_arame.id)

    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame_farpado.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 2.80, round: 1, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame_farpado.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 2.79, round: 1, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame_farpado.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 2.77, round: 2, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame_farpado.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 2.76, round: 2, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame_farpado.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 0, round: 3, number: 1, status: TradingItemBidStatus::DECLINED)

    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 4.98, round: 1, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 4.97, round: 1, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 4.95, round: 2, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 4.94, round: 2, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 0.00, round: 3, number: 1, status: TradingItemBidStatus::DECLINED)

    trading_item_arame_farpado.close!
    trading_item_arame.close!

    Bidder.make!(:licitante, creditor: creditor_sobrinho, enabled: true,
      licitation_process: licitation)
    Bidder.make!(:licitante, creditor: creditor_nohup, enabled: true,
      licitation_process: licitation)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation)

    FactoryGirl.create(:process_responsible, licitation_process: licitation,
      stage_process: StageProcess.make(:emissao_edital))

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    click_link 'Adjudicação/Homologação'

    click_link 'Criar Homologação e Adjudicação'

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Nohup'
    end

    expect(page).to have_content '02.02.00002'
    expect(page).to have_content 'Arame comum'
    expect(page).to have_content 'UN'
    expect(page).to have_content '1'
    expect(page).to have_content '5,00'
    expect(page).to have_content '5,00'

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    within_records do
      expect(page).to have_content 'Nohup'
    end

    click_link 'Criar Homologação e Adjudicação'

    within_modal 'Participante vencedor' do
      click_button 'Pesquisar'
      click_record 'Sobrinho'
    end

    expect(page).to have_content '02.02.00001'
    expect(page).to have_content 'Arame farpado'
    expect(page).to have_content 'UN'
    expect(page).to have_content '2'
    expect(page).to have_content '3,00'
    expect(page).to have_content '6,00'

    check 'checkAll'

    click_button 'Salvar'

    expect(page).to have_notice 'Homologação e Adjudicação de Processo de Compra criada com sucesso.'

    within_records do
      expect(page).to have_content 'Nohup'
      expect(page).to have_content 'Sobrinho'
    end
  end

  def bidder_checkbok_html_name(number)
    "licitation_process_ratification[licitation_process_ratification_items_attributes][#{number}][ratificated]"
  end
end
