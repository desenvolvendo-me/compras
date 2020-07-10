require 'spec_helper'

feature "SupplyOrder", vcr: { cassette_name: 'supply_order' } do
  background do
    sign_in
  end

  scenario 'create a new supply order, update and destroy an existing', :reset_ids do
    wenderson = Creditor.make!(:wenderson_sa)

    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador,
      items: [PurchaseProcessItem.make!(:item_arame_farpado)])

    licitation_process.items.first.material.update_attribute(:control_amount, true)

    proposal_1 = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: licitation_process, creditor: wenderson)

    ratification_item_1 = LicitationProcessRatificationItem.make!(:item,
      licitation_process_ratification: nil,
      purchase_process_creditor_proposal: proposal_1)

    LicitationProcessRatification.make!(:processo_licitatorio_computador,
      creditor: wenderson,
      licitation_process: licitation_process,
      licitation_process_ratification_items: [ratification_item_1])


    navigate 'Contratos > Ordem de Fornecimento'

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

    expect(page).to have_field 'Modalidade', with: '1 - Concorrência', disabled: true

    fill_in 'Data da autorização', with: I18n.l(Date.new(2013, 12, 13))

    fill_with_autocomplete 'Empenho', with: '10'

    within 'div .supply_order_item:nth-child(1)' do
      expect(page).to have_field 'Material', with: '02.02.00001 - Arame farpado', disabled: true
      expect(page).to have_field 'Unidade', with: 'UN', disabled: true
      expect(page).to have_field 'Quantidade', with: '10000', disabled: true
      expect(page).to have_field 'Qtde já autorizada', with: '0', disabled: true
      expect(page).to have_field 'Saldo', with: '10000', disabled: true
      expect(page).to have_field 'Qtde a autorizar', with: ''
    end

    click_button 'Salvar'

    expect(page).to have_no_notice 'Ordem de Fornecimento criada com sucesso.'

    within 'div .supply_order_item:nth-child(1)' do
      expect(page).to have_content 'não é um número'

      fill_in 'Qtde a autorizar', with: '10001'
    end

    click_button 'Salvar'

    expect(page).to have_no_notice 'Ordem de Fornecimento criada com sucesso.'

    within 'div .supply_order_item:nth-child(1)' do
      expect(page).to have_content 'deve ser menor ou igual a 10000'
      fill_in 'Qtde a autorizar', with: '9000'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ordem de Fornecimento criada com sucesso.'

    click_link 'Wenderson Malheiros'

    expect(page).to have_field 'Ano', with: '2013'
    expect(page).to have_field 'Processo de compra', with: '2/2013 - Concorrência 1'
    expect(page).to have_field 'Fornecedor', with: 'Wenderson Malheiros'
    expect(page).to have_field 'Modalidade', with: '1 - Concorrência', disabled: true
    expect(page).to have_field 'Data da autorização', with: '13/12/2013'
    expect(page).to have_field 'Empenho', with: '10'

    within 'div .supply_order_item:nth-child(1)' do
      expect(page).to have_field 'Material', with: '02.02.00001 - Arame farpado', disabled: true
      expect(page).to have_field 'Unidade', with: 'UN', disabled: true
      expect(page).to have_field 'Quantidade', with: '10000', disabled: true
      expect(page).to have_field 'Qtde já autorizada', with: '9000', disabled: true
      expect(page).to have_field 'Saldo', with: '1000', disabled: true
      expect(page).to have_field 'Qtde a autorizar', with: '9000'
    end

    fill_in 'Data da autorização', with: I18n.l(Date.new(2013, 12, 15))

    within 'div .supply_order_item:nth-child(1)' do
      fill_in 'Qtde a autorizar', with: '2000'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ordem de Fornecimento editada com sucesso.'

    click_link 'Wenderson Malheiros'

    expect(page).to have_field 'Ano', with: '2013'
    expect(page).to have_field 'Processo de compra', with: '2/2013 - Concorrência 1'
    expect(page).to have_field 'Fornecedor', with: 'Wenderson Malheiros'
    expect(page).to have_field 'Data da autorização', with: '15/12/2013'
    expect(page).to have_field 'Modalidade', with: '1 - Concorrência', disabled: true
    expect(page).to have_field 'Empenho', with: '10'

    within 'div .supply_order_item:nth-child(1)' do
      expect(page).to have_field 'Material', with: '02.02.00001 - Arame farpado', disabled: true
      expect(page).to have_field 'Unidade', with: 'UN', disabled: true
      expect(page).to have_field 'Quantidade', with: '10000', disabled: true
      expect(page).to have_field 'Qtde já autorizada', with: '2000', disabled: true
      expect(page).to have_field 'Saldo', with: '8000', disabled: true
      expect(page).to have_field 'Qtde a autorizar', with: '2000'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Ordem de Fornecimento apagada com sucesso.'

    expect(page).to_not have_link 'Wenderson Malheiros'
  end
end
