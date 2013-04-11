# encoding: utf-8
require 'spec_helper'

feature 'PurchaseProcessCreditorDisqualifications' do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    Prefecture.make!(:belo_horizonte)
    sign_in
  end

  scenario 'create and update a partial creditor disqualification', js: true do
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado)
    PurchaseProcessCreditorProposal.make!(:proposta_arame)

    LicitationProcess.make!(:pregao_presencial,
      bidders: [Bidder.make!(:licitante_sobrinho),
        Bidder.make!(:licitante)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'

    expect(page).to have_content 'Proposta Comercial Processo 1/2012 - Pregão 1'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'
      expect(page).to have_content 'Desclassificar'

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar Propostas'
        expect(page).to have_content 'Desclassificar Propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar Propostas'
        expect(page).to have_content 'Nenhuma Proposta cadastrada'
      end

      within 'tbody tr:first' do
        click_link 'Desclassificar Propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Data de desclassificação', with: I18n.l(Date.current)
    expect(page).to have_field 'Motivo', with: ''
    expect(page).to have_field 'Toda proposta'
    expect(page).to have_field 'Itens da proposta'
    expect(page).to have_field 'Valor total da proposta', with: '12,97'

    within_records do
      expect(page).to have_content 'Lote'
      expect(page).to have_content 'Item'
      expect(page).to have_content 'Material'
      expect(page).to have_content 'Unidade'
      expect(page).to have_content 'Quantidade'
      expect(page).to have_content 'Valor unitário'
      expect(page).to have_content 'Valor total'
      expect(page).to have_content 'Selecionar'

      within 'tbody tr:first' do
        expect(page).to have_content '2050'
        expect(page).to have_content '1'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '4,99'
        expect(page).to have_content '9,98'
      end

      within 'tbody tr:last' do
        expect(page).to have_content '2050'
        expect(page).to have_content '2'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '2,99'
        expect(page).to have_content '2,99'
      end
    end

    fill_in 'Motivo', with: 'Motivo para desclassificação'

    choose 'Itens da proposta'

    within_records do
      within 'tbody tr:first' do
        check 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Desclassificação de Proposta de Credor criada com sucesso'

    within_records do
      within 'tbody tr:first' do
        click_link 'Desclassificar Propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Motivo', with: 'Motivo para desclassificação'
    expect(page).to have_checked_field 'Itens da proposta'
    expect(page).to have_field 'Valor total da proposta', with: '12,97'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:last' do
        expect(page).to_not have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    choose 'Toda proposta'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:last' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Desclassificação de Proposta de Credor editada com sucesso'

    within_records do
      within 'tbody tr:first' do
        click_link 'Desclassificar Propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Motivo', with: 'Motivo para desclassificação'
    expect(page).to have_checked_field 'Toda proposta'
    expect(page).to have_field 'Valor total da proposta', with: '12,97'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:last' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_link 'Voltar'

    expect(page).to have_content 'Proposta Comercial Processo 1/2012 - Pregão 1'
  end

  scenario 'checking all itens change the disqualification kind', js: true do
    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado)
    PurchaseProcessCreditorProposal.make!(:proposta_arame)

    LicitationProcess.make!(:pregao_presencial,
      bidders: [Bidder.make!(:licitante_sobrinho),
        Bidder.make!(:licitante)],
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'

    expect(page).to have_content 'Proposta Comercial Processo 1/2012 - Pregão 1'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'
      expect(page).to have_content 'Desclassificar'

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar Propostas'
        expect(page).to have_content 'Desclassificar Propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar Propostas'
        expect(page).to have_content 'Nenhuma Proposta cadastrada'
      end

      within 'tbody tr:first' do
        click_link 'Desclassificar Propostas'
      end
    end

    within_records do
      within 'tbody tr:first' do
        expect(page).to_not have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:last' do
        expect(page).to_not have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    choose 'Toda proposta'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:last' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
        uncheck 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    expect(page).to have_checked_field 'Itens da proposta'

    within_records do
      within 'tbody tr:last' do
        check 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    expect(page).to have_checked_field 'Toda proposta'
  end
end
