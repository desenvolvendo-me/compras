require 'spec_helper'

feature 'Report::PurchaseProcessRatificationsByPeriods' do
  background do
    sign_in
  end

  scenario 'should display all licitation process ratifications' do
    make_dependencies!

    navigate 'Relatórios > Compras Homologadas por Período'

    click_on 'Gerar Relatório de compras homologadas por período'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2012'
        expect(page).to have_content '1'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Concorrência'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '100,00'
        expect(page).to have_content '31/01/2013'
        expect(page).to have_content '31/01/2013'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '1'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '50,00'
        expect(page).to have_content '28/02/2013'
        expect(page).to have_content '28/02/2013'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '2'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Concorrência'
        expect(page).to have_content 'Nohup'
        expect(page).to have_content '160,00'
        expect(page).to have_content '30/03/2013'
        expect(page).to have_content '30/03/2013'
      end

      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '3'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content '30/04/2013'
        expect(page).to have_content '30/04/2013'
      end

      within 'tbody tr:nth-child(5)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '4'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa por limite'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end

      within 'tbody tr:nth-child(6)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '5'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa justificadas'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end

      within 'tbody tr:nth-child(7)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '6'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa justificadas'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end
    end
  end

  scenario 'should display licitation process ratifications by type_of_purchase' do
    make_dependencies!

    navigate 'Relatórios > Compras Homologadas por Período'

    select 'Compra direta', from: 'Tipo de compra'

    click_on 'Gerar Relatório de compras homologadas por período'

    within_records do
      expect(page).to_not have_content 'Processo licitatório'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '4'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa por limite'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '5'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa justificadas'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '6'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa justificadas'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end
    end
  end

  scenario 'should display licitation process ratifications by type_of_removal' do
    make_dependencies!

    navigate 'Relatórios > Compras Homologadas por Período'

    select 'Compra direta', from: 'Tipo de compra'
    select 'Dispensa justificadas', from: 'Tipo do afastamento'

    click_on 'Gerar Relatório de compras homologadas por período'

    within_records do
      expect(page).to_not have_content 'Processo licitatório'
      expect(page).to_not have_content 'Dispensa por limite'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '5'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa justificadas'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '6'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa justificadas'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end
    end
  end

  scenario 'should display licitation process ratifications by modality' do
    make_dependencies!

    navigate 'Relatórios > Compras Homologadas por Período'

    select 'Processo licitatório', from: 'Tipo de compra'
    select 'Convite', from: 'Modalidade'

    click_on 'Gerar Relatório de compras homologadas por período'

    within_records do
      expect(page).to_not have_content 'Compra direta'
      expect(page).to_not have_content 'Concorrência'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '1'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '50,00'
        expect(page).to have_content '28/02/2013'
        expect(page).to have_content '28/02/2013'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '3'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content '30/04/2013'
        expect(page).to have_content '30/04/2013'
      end
    end
  end

  scenario 'should display licitation process ratifications by object_type' do
    make_dependencies!

    navigate 'Relatórios > Compras Homologadas por Período'

    select 'Processo licitatório', from: 'Tipo de compra'
    select 'Compras e serviços'

    click_on 'Gerar Relatório de compras homologadas por período'

    within_records do
      expect(page).to_not have_content 'Compra direta'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '1'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '50,00'
        expect(page).to have_content '28/02/2013'
        expect(page).to have_content '28/02/2013'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '2'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Concorrência'
        expect(page).to have_content 'Nohup'
        expect(page).to have_content '160,00'
        expect(page).to have_content '30/03/2013'
        expect(page).to have_content '30/03/2013'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '3'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content '30/04/2013'
        expect(page).to have_content '30/04/2013'
      end
    end
  end

  scenario 'should display licitation process ratifications by creditor' do
    make_dependencies!

    navigate 'Relatórios > Compras Homologadas por Período'

    fill_modal 'Fornecedor', with: 'Gabriel Sobrinho'

    click_on 'Gerar Relatório de compras homologadas por período'

    within_records do
      expect(page).to_not have_content 'Compra direta'
      expect(page).to_not have_content 'Nohup'
      expect(page).to_not have_content 'Wenderson Malheiros'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '1'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '50,00'
        expect(page).to have_content '28/02/2013'
        expect(page).to have_content '28/02/2013'
      end
    end
  end

  scenario 'should display licitation process ratifications by between_dates' do
    make_dependencies!

    navigate 'Relatórios > Compras Homologadas por Período'

    fill_in 'Data homologação inicial', with: '30/03/2013'
    fill_in 'Data homologação final', with: I18n.l(Date.current)

    click_on 'Gerar Relatório de compras homologadas por período'

    within_records do
      expect(page).to_not have_content '31/01/2013'
      expect(page).to_not have_content '28/02/2013'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '2'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Concorrência'
        expect(page).to have_content 'Nohup'
        expect(page).to have_content '160,00'
        expect(page).to have_content '30/03/2013'
        expect(page).to have_content '30/03/2013'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '3'
        expect(page).to have_content 'Processo licitatório'
        expect(page).to have_content 'Convite'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content '30/04/2013'
        expect(page).to have_content '30/04/2013'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '4'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa por limite'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end

      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '5'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa justificadas'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end

      within 'tbody tr:nth-child(5)' do
        expect(page).to have_content '2013'
        expect(page).to have_content '6'
        expect(page).to have_content 'Compra direta'
        expect(page).to have_content 'Dispensa justificadas'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content '200,00'
        expect(page).to have_content I18n.l Date.current
        expect(page).to have_content I18n.l Date.current
      end
    end
  end

  def make_dependencies!
    creditor_sobrinho  = Creditor.make!(:sobrinho_sa)
    creditor_nohup     = Creditor.make!(:nohup)
    creditor_wenderson = Creditor.make!(:wenderson_sa)

    item_arame = PurchaseProcessItem.make!(:item_arame)

    purchase_process_one = LicitationProcess.make!(:processo_licitatorio,
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

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_one)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_one,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_one,
      creditor: creditor_wenderson, ratification_date: "2013-01-31".to_date, adjudication_date: "2013-01-31".to_date)

    purchase_process_two = LicitationProcess.make!(:processo_licitatorio_fornecedores, year: 2013, process: 1,
      publications: [LicitationProcessPublication.make!(:publicacao, publication_date: Date.current)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_two, unit_price: 200.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_two, unit_price: 50.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_two, unit_price: 160.00)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_two)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_two,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_two,
      creditor: creditor_sobrinho, ratification_date: "2013-02-28".to_date, adjudication_date: "2013-02-28".to_date)

    purchase_process_three = LicitationProcess.make!(:processo_licitatorio_computador, bidders: [])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_three, unit_price: 200.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_three, unit_price: 50.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_three, unit_price: 160.00)

    Bidder.make!(:licitante, creditor: creditor_sobrinho, enabled: true, licitation_process: purchase_process_three)
    Bidder.make!(:licitante, creditor: creditor_nohup, enabled: true, licitation_process: purchase_process_three)
    Bidder.make!(:licitante, creditor: creditor_wenderson, enabled: true, licitation_process: purchase_process_three)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_three)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_three,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_three,
      creditor: creditor_nohup, ratification_date: "2013-03-30".to_date, adjudication_date: "2013-03-30".to_date)

    purchase_process_four = LicitationProcess.make!(:processo_licitatorio_canetas, process: 3, bidders: [])

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

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_four)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_four,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_four,
      creditor: creditor_wenderson, ratification_date: "2013-04-30".to_date, adjudication_date: "2013-04-30".to_date)

    purchase_process_five = LicitationProcess.make!(:compra_direta, process: 4, year: 2013, bidders: [],
      type_of_removal: TypeOfRemoval::REMOVAL_BY_LIMIT)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_five, unit_price: 200.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_five, unit_price: 50.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_five, unit_price: 160.00)

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_five)

    purchase_process_six = LicitationProcess.make!(:compra_direta, process: 5, year: 2013, bidders: [])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_six, unit_price: 200.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_six, unit_price: 50.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_six, unit_price: 160.00)

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_six)

    purchase_process_seven = LicitationProcess.make!(:compra_direta, process: 6, year: 2013, bidders: [])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_wenderson,
      licitation_process: purchase_process_seven, unit_price: 200.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_sobrinho,
      licitation_process: purchase_process_seven, unit_price: 50.00)
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item_arame, creditor: creditor_nohup,
      licitation_process: purchase_process_seven, unit_price: 160.00)

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_seven)
  end
end
