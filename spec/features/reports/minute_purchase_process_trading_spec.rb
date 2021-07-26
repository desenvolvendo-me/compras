require 'spec_helper'

feature 'Report::MinutePurchaseProcessTradings', vcr: { cassette_name: :minute_purchase_process_tradings } do
  background do
    sign_in
  end

  scenario 'should minute purchase process' do
    make_dependencies!

    navigate 'Licitações > Processos de Compras'


    click_link '1/2012'

    click_link 'Imprimir ATA'

    expect(page).to have_content I18n.l(Date.current)
    expect(page).to have_content '00:00'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Gabriel Sobrinho'
  end


  def make_dependencies!
    creditor_sobrinho = Creditor.make!(:sobrinho)
    creditor_wenderson = Creditor.make!(:wenderson_sa)

    item = PurchaseProcessItem.make!(:item)
    item_arame = PurchaseProcessItem.make!(:item_arame)

    purchase_process = LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
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
  end
end
