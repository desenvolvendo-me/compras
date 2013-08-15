require 'spec_helper'

feature 'Report::MinutePurchaseProcesses' do
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

  context 'with a purchase_process as licitation_process' do
    scenario 'should minute purchase process' do
      creditor_sobrinho = Creditor.make!(:sobrinho)
      creditor_wenderson = Creditor.make!(:wenderson_sa)

      item = PurchaseProcessItem.make!(:item)
      item_arame = PurchaseProcessItem.make!(:item_arame)

      purchase_process = LicitationProcess.make!(:processo_licitatorio,
        bidders: [Bidder.make!(:licitante, creditor: creditor_wenderson), Bidder.make!(:licitante_sobrinho, creditor: creditor_sobrinho)],
        items: [item, item_arame])

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: purchase_process,
        creditor: creditor_wenderson,
        item: item)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: purchase_process,
        creditor: creditor_sobrinho,
        item: item)

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: purchase_process,
        creditor: creditor_wenderson,
        item: item_arame)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: purchase_process,
        creditor: creditor_sobrinho,
        item: item_arame,
        unit_price: 4.99)

      JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process)

      navigate 'Processos de Compra > Processos de Compras'

      click_link 'Limpar Filtro'
      click_link '1/2012'

      click_link 'Imprimir ATA'

      expect(page).to have_content I18n.l(Date.tomorrow)
      expect(page).to have_content '14:00'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content 'Gabriel Sobrinho'
    end
  end

  context 'with a purchase_process as direct_purchase' do
    scenario 'should minute purchase process' do
      creditor_sobrinho = Creditor.make!(:sobrinho)
      creditor_wenderson = Creditor.make!(:wenderson_sa)

      item = PurchaseProcessItem.make!(:item, creditor: creditor_sobrinho)
      item_arame = PurchaseProcessItem.make!(:item_arame, creditor: creditor_wenderson)

      purchase_process = LicitationProcess.make!(:compra_direta,
        bidders: [Bidder.make!(:licitante, creditor: creditor_wenderson), Bidder.make!(:licitante_sobrinho, creditor: creditor_sobrinho)],
        items: [item, item_arame])

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: purchase_process,
        creditor: creditor_wenderson,
        item: item)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: purchase_process,
        creditor: creditor_sobrinho,
        item: item)

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: purchase_process,
        creditor: creditor_wenderson,
        item: item_arame)

      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: purchase_process,
        creditor: creditor_sobrinho,
        item: item_arame,
        unit_price: 4.99)

      JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process)

      navigate 'Processos de Compra > Processos de Compras'

      click_link 'Limpar Filtro'
      click_link '2/2013'

      click_link 'Imprimir ATA'

      expect(page).to have_content I18n.l(Date.current)
      expect(page).to have_content '14:00'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content 'Gabriel Sobrinho'
    end
  end
end
