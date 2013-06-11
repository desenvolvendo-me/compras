# encoding: utf-8
require 'spec_helper'

feature "SupplyOrder" do
  background do
    sign_in
  end

  scenario 'create a new supply order, update and destroy an existing' do
    item = PurchaseProcessItem.make(:item)
    licitation_process = LicitationProcess.make(:processo_licitatorio_computador,
      items: [item])
    proposal = PurchaseProcessCreditorProposal.make(:proposta_arame,
      licitation_process: licitation_process,
      item: item)
    ratification_item = LicitationProcessRatificationItem.make(:item,
      licitation_process_ratification: nil,
      purchase_process_creditor_proposal: proposal)
    LicitationProcessRatification.make!(:processo_licitatorio_computador,
      licitation_process_ratification_items: [ratification_item])

    navigate 'Instrumentos Contratuais > Ordem de Fornecimento'

    click_link 'Criar Ordem de Fornecimento'

    fill_in 'Ano', with: 2013

    within_modal 'Processo de compra' do
      click_button 'Pesquisar'
      click_record '2013'
    end

    within_modal 'Fornecedor' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    expect(page).to have_disabled_field 'Modalidade', with: '2 - Concorrência'
    expect(page).to have_disabled_field 'Material', with: '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Unidade', with: 'UN'
    expect(page).to have_disabled_field 'Quantidade', with: '2'
    expect(page).to have_disabled_field 'Qtde já autorizada', with: '0'
    expect(page).to have_disabled_field 'Saldo', with: '2'
    expect(page).to have_field 'Qtde a autorizar', with: ''

    fill_in 'Data da autorização', with: I18n.l(Date.new(2013, 12, 13))

    click_button 'Salvar'

    expect(page).to have_notice 'Ordem de Fornecimento criado com sucesso.'

    click_link 'Wenderson Malheiros'

    expect(page).to have_field 'Fornecedor', with: 'Wenderson Malheiros'
    expect(page).to have_field 'Processo de compra', with: '2/2013 - Concorrência 2'
    expect(page).to have_field 'Data da autorização', with: '13/12/2013'

    expect(page).to have_disabled_field 'Modalidade', with: '2 - Concorrência'
    expect(page).to have_disabled_field 'Material', with: '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Unidade', with: 'UN'
    expect(page).to have_disabled_field 'Quantidade', with: '2'
    expect(page).to have_disabled_field 'Qtde já autorizada', with: '0'
    expect(page).to have_disabled_field 'Saldo', with: '2'
    expect(page).to have_field 'Qtde a autorizar', with: ''

    fill_in 'Data da autorização', with: I18n.l(Date.new(2013, 12, 15))
    fill_in 'Qtde a autorizar', with: '1'

    click_button 'Salvar'

    expect(page).to have_notice 'Ordem de Fornecimento editado com sucesso.'

    click_link 'Wenderson Malheiros'

    expect(page).to have_field 'Fornecedor', with: 'Wenderson Malheiros'
    expect(page).to have_field 'Processo de compra', with: '2/2013 - Concorrência 2'
    expect(page).to have_field 'Data da autorização', with: '15/12/2013'

    expect(page).to have_disabled_field 'Modalidade', with: '2 - Concorrência'
    expect(page).to have_disabled_field 'Material', with: '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Unidade', with: 'UN'
    expect(page).to have_disabled_field 'Quantidade', with: '2'
    expect(page).to have_disabled_field 'Qtde já autorizada', with: '1'
    expect(page).to have_disabled_field 'Saldo', with: '1'
    expect(page).to have_field 'Qtde a autorizar', with: '1'

    click_link 'Apagar'

    expect(page).to have_notice 'Ordem de Fornecimento apagado com sucesso.'

    expect(page).to_not have_link 'Wenderson Malheiros'
  end
end
