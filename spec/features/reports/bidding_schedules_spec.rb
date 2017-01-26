#encoding: utf-8
require 'spec_helper'

feature 'Report::BiddingSchedules' do
  scenario 'viewing the all licitation process filter by date of trial' do
    make_dependencies!

    navigate 'Relatórios > Agendas de Licitações'

    fill_in 'Data do julgamento inicial', with: '01/07/2013'
    fill_in 'Data do julgamento final', with: I18n.l(Date.current)

    click_button 'Gerar Relatório de agendas de licitação'

    within_records do
      expect(page).to_not have_content '10/06/2013'
      expect(page).to_not have_content '01/01/2013'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '10/07/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '2/2013'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '20,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '10/08/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '3/2013'
        expect(page).to have_content 'Concorrência'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '20,00'
      end
    end
  end

  scenario 'viewing the list filter by object_type' do
    make_dependencies!

    navigate 'Relatórios > Agendas de Licitações'

    select 'Compras e serviços', from: 'Tipo de objeto'
    fill_in 'Data do julgamento inicial', with: '01/01/2011'
    fill_in 'Data do julgamento final', with: I18n.l(Date.current)

    click_button 'Gerar Relatório de agendas de licitação'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '10/07/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '2/2013'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '20,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '10/08/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '3/2013'
        expect(page).to have_content 'Concorrência'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '20,00'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '01/01/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '4/2013'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '30,00'
      end
    end
  end

  scenario 'viewing the list filter by object_type and modality' do
    make_dependencies!

    navigate 'Relatórios > Agendas de Licitações'

    select 'Compras e serviços', from: 'Tipo de objeto'
    select 'Convite', from: 'Modalidade'
    fill_in 'Data do julgamento inicial', with: '01/01/2011'
    fill_in 'Data do julgamento final', with: I18n.l(Date.current)

    click_button 'Gerar Relatório de agendas de licitação'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '10/07/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '2/2013'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '20,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '01/01/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '4/2013'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '30,00'
      end
    end
  end

  scenario 'viewing the all licitation process filter by date of trial' do
    make_dependencies!

    navigate 'Relatórios > Agendas de Licitações'

    fill_modal 'Comissão de licitação', with: 'Comissão para pregão presencial', field: 'Descrição e finalidade da comissão'
    fill_in 'Data do julgamento inicial', with: '01/07/2012'
    fill_in 'Data do julgamento final', with: I18n.l(Date.current)

    click_button 'Gerar Relatório de agendas de licitação'

    within_records do
      expect(page).to_not have_content '10/06/2013'
      expect(page).to_not have_content '10/07/2013'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '10/08/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '3/2013'
        expect(page).to have_content 'Concorrência'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '20,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '01/01/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '4/2013'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '30,00'
      end
    end
  end

  scenario 'print report filter by date of trial' do
    make_dependencies!

    navigate 'Relatórios > Agendas de Licitações'

    select 'Compras e serviços', from: 'Tipo de objeto'
    select 'Convite', from: 'Modalidade'
    fill_modal 'Comissão de licitação', with: 'Comissão para pregão presencial', field: 'Descrição e finalidade da comissão'
    fill_in 'Data do julgamento inicial', with: '01/07/2012'
    fill_in 'Data do julgamento final', with: I18n.l(Date.current)

    click_button 'Gerar Relatório de agendas de licitação'

    within_records do
      expect(page).to_not have_content '10/06/2013'
      expect(page).to_not have_content '10/07/2013'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '01/01/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '4/2013'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '30,00'
      end
    end

    click_link 'Imprimir'

    expect(page).to have_content 'Relatório de agendas de licitação'

    within '.filters' do
      expect(page).to have_content 'Filtros'
      expect(page).to have_content 'Tipo de objeto: Compras e serviços'
      expect(page).to have_content 'Modalidade: Convite'
      expect(page).to have_content 'Comissão de licitação: Comissão para pregão presencial'
      expect(page).to have_content "Período: 01/07/2012 até #{I18n.l Date.current}"
    end

    within_records do
      expect(page).to_not have_content '10/06/2013'
      expect(page).to_not have_content '10/07/2013'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '01/01/2013'
        expect(page).to have_content '14:00'
        expect(page).to have_content '4/2013'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Licitação para compra de carteiras'
        expect(page).to have_content '30,00'
      end
    end
  end

  def make_dependencies!
    Timecop.travel(Date.new(2013,01,01))

    licitation_commission = LicitationCommission.make!(:comissao)
    licitation_commission_pregao = LicitationCommission.make!(:comissao_pregao_presencial)

    creditor_sobrinho  = Creditor.make!(:sobrinho_sa)
    creditor_nohup     = Creditor.make!(:nohup)
    creditor_wenderson = Creditor.make!(:wenderson_sa)

    item_arame = PurchaseProcessItem.make!(:item_arame)

    purchase_process_one = LicitationProcess.make!(:processo_licitatorio, year: 2013, process: 1,
      envelope_delivery_date: "2013-06-10".to_date,
      proposal_envelope_opening_date: "2013-06-10".to_date,
      object_type: PurchaseProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_one, unit_price: 100.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_one, unit_price: 150.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_one, unit_price: 160.00)

    accreditation_sobrinho  = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor, creditor: creditor_sobrinho)
    accreditation_wenderson = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor, creditor: creditor_wenderson)
    accreditation_nohup     = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor, creditor: creditor_nohup)

    PurchaseProcessAccreditation.make!(:general_accreditation, licitation_process: purchase_process_one,
      purchase_process_accreditation_creditors: [accreditation_nohup, accreditation_wenderson, accreditation_sobrinho])

    Bidder.make!(:licitante, creditor: creditor_sobrinho, enabled: true, licitation_process: purchase_process_one)
    Bidder.make!(:licitante, creditor: creditor_nohup, enabled: true, licitation_process: purchase_process_one)
    Bidder.make!(:licitante, creditor: creditor_wenderson, enabled: true, licitation_process: purchase_process_one)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_one,
      licitation_commission: licitation_commission)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_one,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_one,
      creditor: creditor_wenderson, ratification_date: "2013-01-31".to_date, adjudication_date: "2013-01-31".to_date)

    purchase_process_two = LicitationProcess.make!(:processo_licitatorio_fornecedores, year: 2013, process: 2,
      envelope_delivery_date: "2013-07-10".to_date,
      proposal_envelope_opening_date: "2013-07-10".to_date,
      publications: [LicitationProcessPublication.make!(:publicacao, publication_date: Date.current)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_two, unit_price: 200.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_two, unit_price: 50.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_two, unit_price: 160.00)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_two,
      licitation_commission: licitation_commission)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_two,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_two,
      creditor: creditor_sobrinho, ratification_date: "2013-02-28".to_date, adjudication_date: "2013-02-28".to_date)

    purchase_process_three = LicitationProcess.make!(:processo_licitatorio_computador, bidders: [],
      envelope_delivery_date: "2013-08-10".to_date,
      proposal_envelope_opening_date: "2013-08-10".to_date, process: 3)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_three, unit_price: 200.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_three, unit_price: 50.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_three, unit_price: 160.00)

    Bidder.make!(:licitante, creditor: creditor_sobrinho, enabled: true, licitation_process: purchase_process_three)
    Bidder.make!(:licitante, creditor: creditor_nohup, enabled: true, licitation_process: purchase_process_three)
    Bidder.make!(:licitante, creditor: creditor_wenderson, enabled: true, licitation_process: purchase_process_three)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_three,
      licitation_commission: licitation_commission_pregao)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_three,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_three,
      creditor: creditor_nohup, ratification_date: "2013-03-30".to_date, adjudication_date: "2013-03-30".to_date)

    purchase_process_four = LicitationProcess.make!(:processo_licitatorio_canetas, process: 4, bidders: [])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_four, unit_price: 200.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_four, unit_price: 50.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_four, unit_price: 160.00)

    accreditation_sobrinho  = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor, creditor: creditor_sobrinho)
    accreditation_wenderson = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor, creditor: creditor_wenderson)
    accreditation_nohup     = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor, creditor: creditor_nohup)

    PurchaseProcessAccreditation.make!(:general_accreditation, licitation_process: purchase_process_one,
      purchase_process_accreditation_creditors: [accreditation_nohup, accreditation_wenderson, accreditation_sobrinho])

    Bidder.make!(:licitante, creditor: creditor_sobrinho, enabled: true, licitation_process: purchase_process_four)
    Bidder.make!(:licitante, creditor: creditor_nohup, enabled: true, licitation_process: purchase_process_four)
    Bidder.make!(:licitante, creditor: creditor_wenderson, enabled: true, licitation_process: purchase_process_four)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_four,
      licitation_commission: licitation_commission_pregao)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_four,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_four,
      creditor: creditor_wenderson, ratification_date: "2013-04-30".to_date, adjudication_date: "2013-04-30".to_date)

    Timecop.return

    sign_in
  end
end
