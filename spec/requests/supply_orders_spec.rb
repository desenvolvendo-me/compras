# encoding: utf-8
require 'spec_helper'

feature "SupplyOrder" do
  background do
    sign_in
  end

  scenario 'create a new supply order, update and destroy an existing' do
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
      purchase_process_creditor_proposal: proposal_1)

    ratification_item_2 = LicitationProcessRatificationItem.make!(:item,
      licitation_process_ratification: nil,
      purchase_process_creditor_proposal: proposal_2)

    LicitationProcessRatification.make!(:processo_licitatorio_computador,
      creditor: wenderson,
      licitation_process: licitation_process,
      licitation_process_ratification_items: [ratification_item_1, ratification_item_2])

    first_div_path = '//*[@id="supply_order_items"]/div[1]'
    last_div_path  = '//*[@id="supply_order_items"]/div[2]'

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

    expect(page).to have_disabled_field 'Modalidade', with: '1 - Concorrência'

    fill_in 'Data da autorização', with: I18n.l(Date.new(2013, 12, 13))

    within :xpath, first_div_path do
      expect(page).to have_disabled_field 'Material', with: '02.02.00002 - Arame comum'
      expect(page).to have_disabled_field 'Unidade', with: 'UN'
      expect(page).to have_disabled_field 'Valor', with: '2,99'
      expect(page).to have_disabled_field 'Valor já autorizado', with: '0,00'
      expect(page).to have_disabled_field 'Saldo', with: '2,99'
      expect(page).to have_field 'Valor a autorizar', with: ''
    end

    within :xpath, last_div_path do
      expect(page).to have_disabled_field 'Material', with: '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Unidade', with: 'UN'
      expect(page).to have_disabled_field 'Quantidade', with: '2'
      expect(page).to have_disabled_field 'Qtde já autorizada', with: '0'
      expect(page).to have_disabled_field 'Saldo', with: '2'
      expect(page).to have_field 'Qtde a autorizar', with: ''
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Ordem de Fornecimento criada com sucesso.'

    within :xpath, first_div_path do
      expect(page).to have_content 'não é um número'
      fill_in 'Valor a autorizar', with: '3,99'
    end

    within :xpath, last_div_path do
      expect(page).to have_content 'não é um número'
      fill_in 'Qtde a autorizar', with: '5'
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Ordem de Fornecimento criada com sucesso.'

    within :xpath, first_div_path do
      expect(page).to have_content 'deve ser menor ou igual a 2,99'
      fill_in 'Valor a autorizar', with: '2,99'
    end

    within :xpath, last_div_path do
      expect(page).to have_content 'deve ser menor ou igual a 2'
      fill_in 'Qtde a autorizar', with: '2'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ordem de Fornecimento criada com sucesso.'

    click_link 'Wenderson Malheiros'

    expect(page).to have_field 'Fornecedor', with: 'Wenderson Malheiros'
    expect(page).to have_disabled_field 'Modalidade', with: '1 - Concorrência'
    expect(page).to have_field 'Data da autorização', with: '13/12/2013'

    within :xpath, first_div_path do
      expect(page).to have_disabled_field 'Material', with: '02.02.00002 - Arame comum'
      expect(page).to have_disabled_field 'Unidade', with: 'UN'
      expect(page).to have_disabled_field 'Valor', with: '2,99'
      expect(page).to have_disabled_field 'Valor já autorizado', with: '2,99'
      expect(page).to have_disabled_field 'Saldo', with: '0,00'
      expect(page).to have_field 'Valor a autorizar', with: '2,99'
    end

    within :xpath, last_div_path do
      expect(page).to have_disabled_field 'Material', with: '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Unidade', with: 'UN'
      expect(page).to have_disabled_field 'Quantidade', with: '2'
      expect(page).to have_disabled_field 'Qtde já autorizada', with: '2'
      expect(page).to have_disabled_field 'Saldo', with: '0'
      expect(page).to have_field 'Qtde a autorizar', with: '2'
    end

    fill_in 'Data da autorização', with: I18n.l(Date.new(2013, 12, 15))

    within :xpath, last_div_path do
      fill_in 'Qtde a autorizar', with: '1'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Ordem de Fornecimento editada com sucesso.'

    click_link 'Wenderson Malheiros'

    expect(page).to have_field 'Fornecedor', with: 'Wenderson Malheiros'
    expect(page).to have_field 'Data da autorização', with: '15/12/2013'
    expect(page).to have_disabled_field 'Modalidade', with: '1 - Concorrência'

    within :xpath, first_div_path do
      expect(page).to have_disabled_field 'Material', with: '02.02.00002 - Arame comum'
      expect(page).to have_disabled_field 'Unidade', with: 'UN'
      expect(page).to have_disabled_field 'Valor', with: '2,99'
      expect(page).to have_disabled_field 'Valor já autorizado', with: '2,99'
      expect(page).to have_disabled_field 'Saldo', with: '0,00'
      expect(page).to have_field 'Valor a autorizar', with: '2,99'
    end

    within :xpath, last_div_path do
      expect(page).to have_disabled_field 'Material', with: '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Unidade', with: 'UN'
      expect(page).to have_disabled_field 'Quantidade', with: '2'
      expect(page).to have_disabled_field 'Qtde já autorizada', with: '1'
      expect(page).to have_disabled_field 'Saldo', with: '1'
      expect(page).to have_field 'Qtde a autorizar', with: '1'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Ordem de Fornecimento apagada com sucesso.'

    expect(page).to_not have_link 'Wenderson Malheiros'
  end
end
