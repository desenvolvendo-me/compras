require 'spec_helper'

feature 'PurchaseProcessCreditorDisqualifications', vcr: { cassette_name: :purchase_process_creditor_disqualifications } do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    Prefecture.make!(:belo_horizonte)

    sign_in
  end

  scenario 'create and update a creditor disqualification of items' do
    licitation = LicitationProcess.make!(:pregao_presencial,
        purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation)

    navigate 'Licitações > Processos de Compras'

    

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
      expect(page).to have_content 'Desclassificada?'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
        expect(page).to have_content 'Desclassificar propostas'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
        expect(page).to have_content 'Nenhuma proposta cadastrada'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Desclassificar propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Data de desclassificação', with: I18n.l(Date.current)
    expect(page).to have_field 'Motivo', with: ''
    expect(page).to have_field 'Toda proposta'
    expect(page).to have_field 'Itens da proposta'
    expect(page).to have_field 'Valor total da proposta', with: '12,97', disabled: true

    within_records do
      expect(page).to have_content 'Lote'
      expect(page).to have_content 'Item'
      expect(page).to have_content 'Material'
      expect(page).to have_content 'Unidade'
      expect(page).to have_content 'Quantidade'
      expect(page).to have_content 'Valor unitário'
      expect(page).to have_content 'Valor total'
      expect(page).to have_content 'Selecionar'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2050'
        expect(page).to have_content '1'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '4,99'
        expect(page).to have_content '9,98'
      end

      within 'tbody tr:nth-last-child(1)' do
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
      within 'tbody tr:nth-child(1)' do
        check 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Desclassificação de Proposta de Credor criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Parcialmente'
        click_link 'Desclassificar propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Motivo', with: 'Motivo para desclassificação'
    expect(page).to have_checked_field 'Itens da proposta'
    expect(page).to have_field 'Valor total da proposta', with: '12,97', disabled: true

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to_not have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    choose 'Toda proposta'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Desclassificação de Proposta de Credor editada com sucesso'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Totalmente'
        click_link 'Desclassificar propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Motivo', with: 'Motivo para desclassificação'
    expect(page).to have_checked_field 'Toda proposta'
    expect(page).to have_field 'Valor total da proposta', with: '12,97', disabled: true

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_link 'Voltar'

    expect(page).to have_content 'Proposta Comercial Processo 1/2012 - Pregão 1'
  end

  scenario 'create and update a creditor disqualification of lots' do
    licitation = LicitationProcess.make!(:pregao_presencial,
      judgment_form: JudgmentForm.make!(:por_lote_com_menor_preco),
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame, lot: 1025)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation, item: nil, lot: 2050)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation, item: nil, lot: 1025)

    navigate 'Licitações > Processos de Compras'

    

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
      expect(page).to have_content 'Desclassificada?'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
        expect(page).to have_content 'Desclassificar propostas'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
        expect(page).to have_content 'Nenhuma proposta cadastrada'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Desclassificar propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Data de desclassificação', with: I18n.l(Date.current)
    expect(page).to have_field 'Motivo', with: ''
    expect(page).to have_field 'Toda proposta'
    expect(page).to have_field 'Lotes da proposta'
    expect(page).to have_field 'Valor total da proposta', with: '7,98', disabled: true

    within_records do
      expect(page).to have_content 'Lote'
      expect(page).to have_content 'Valor total'
      expect(page).to have_content 'Selecionar'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2050'
        expect(page).to have_content '4,99'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content '1025'
        expect(page).to have_content '2,99'
      end
    end

    fill_in 'Motivo', with: 'Motivo para desclassificação'

    choose 'Lotes da proposta'

    within_records do
      within 'tbody tr:nth-child(1)' do
        check 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Desclassificação de Proposta de Credor criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Parcialmente'
        click_link 'Desclassificar propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Motivo', with: 'Motivo para desclassificação'
    expect(page).to have_checked_field 'Lotes da proposta'
    expect(page).to have_field 'Valor total da proposta', with: '7,98', disabled: true

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to_not have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    choose 'Toda proposta'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Desclassificação de Proposta de Credor editada com sucesso'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Totalmente'
        click_link 'Desclassificar propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Motivo', with: 'Motivo para desclassificação'
    expect(page).to have_checked_field 'Toda proposta'
    expect(page).to have_field 'Valor total da proposta', with: '7,98', disabled: true
  end

  scenario 'create and update a global creditor disqualification' do
    licitation = LicitationProcess.make!(:pregao_presencial,
      judgment_form: JudgmentForm.make!(:global_com_menor_preco),
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame, lot: 1025)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation,
      item: nil, lot: nil, unit_price: 1100.00)

    navigate 'Licitações > Processos de Compras'

    

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
      expect(page).to have_content 'Desclassificada?'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
        expect(page).to have_content 'Desclassificar propostas'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
        expect(page).to have_content 'Nenhuma proposta cadastrada'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Desclassificar propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Data de desclassificação', with: I18n.l(Date.current)
    expect(page).to have_field 'Motivo', with: ''
    expect(page).to have_field 'Valor total da proposta', with: '1.100,00', disabled: true
    expect(page).to_not have_field 'Toda proposta'

    fill_in 'Motivo', with: 'Motivo para desclassificação'

    within_records do
      expect(page).to have_content 'Valor total'
      expect(page).to have_content 'Selecionar'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1.100,00'
        check 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Desclassificação de Proposta de Credor criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Totalmente'
        click_link 'Desclassificar propostas'
      end
    end

    expect(page).to have_content 'Desclassificar fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Motivo', with: 'Motivo para desclassificação'
    expect(page).to_not have_checked_field 'Toda proposta'
    expect(page).to have_field 'Valor total da proposta', with: '1.100,00', disabled: true

    click_button 'Salvar'

    expect(page).to have_content 'Desclassificação de Proposta de Credor editada com sucesso'
  end

  scenario 'checking all itens change the disqualification kind' do
    licitation = LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      items: [ PurchaseProcessItem.make!(:item_arame_farpado),
               PurchaseProcessItem.make!(:item_arame)])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, licitation_process: licitation)
    PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation)

    navigate 'Licitações > Processos de Compras'

    

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
      expect(page).to have_content 'Desclassificada?'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
        expect(page).to have_content 'Desclassificar propostas'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
        expect(page).to have_content 'Nenhuma proposta cadastrada'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Desclassificar propostas'
      end
    end

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to_not have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to_not have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    choose 'Toda proposta'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_checked_field 'purchase_process_creditor_disqualification[proposal_item_ids][]'
        uncheck 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    expect(page).to have_checked_field 'Itens da proposta'

    within_records do
      within 'tbody tr:nth-last-child(1)' do
        check 'purchase_process_creditor_disqualification[proposal_item_ids][]'
      end
    end

    expect(page).to have_checked_field 'Toda proposta'
  end
end
