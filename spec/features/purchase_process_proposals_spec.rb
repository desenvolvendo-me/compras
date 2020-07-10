require 'spec_helper'

feature 'PurchaseProcessProposals', vcr: { cassette_name: :purchase_process_proposals } do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    Prefecture.make!(:belo_horizonte)
    sign_in
  end

  scenario 'create and update item proposals' do
    LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      judgment_form: JudgmentForm.make!(:por_item_com_melhor_tecnica))

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_disabled_element 'Lances', reason: 'deve ter ao menos uma proposta'

    click_link 'Propostas'

    expect(page).to have_content 'Proposta Comercial Processo 1/2012 - Pregão 1'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Cadastrar propostas'
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'
    expect(page).to have_content 'Fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Valor total da proposta', with: '0,00', disabled: true
    expect(page).to have_field 'Lote', with: '2050', disabled: true
    expect(page).to have_field 'Item', with: '1', disabled: true
    expect(page).to have_field 'Material', with: '01.01.00001 - Antivirus', disabled: true
    expect(page).to have_field 'Unidade', with: 'UN', disabled: true
    expect(page).to have_field 'Quantidade', with: '2', disabled: true
    expect(page).to have_field 'Preço total', with: '0,00', disabled: true

    fill_in 'Prazo de entrega', with: '10/05/2013'
    fill_in 'Preço unitário', with: '50,20'

    expect(page).to have_field 'Valor total da proposta', with: '100,40', disabled: true
    expect(page).to have_field 'Preço total', with: '100,40', disabled: true

    click_button 'Salvar'

    expect(page).to have_field 'Marca', with: ''
    expect(page).to have_content 'não pode ficar em branco'

    fill_in 'Marca', with: 'Tabajara'
    fill_in 'Preço unitário', with: '0,00'

    click_button 'Salvar'

    expect(page).to have_field 'Preço unitário', with: '0,00'
    expect(page).to have_content 'deve ser maior que 0'

    fill_in 'Marca', with: ''

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'

    within_records do
      within 'tbody tr:nth-child(1)' do
        click_link 'Editar propostas'
      end
    end

    fill_in 'Prazo de entrega', with: '10/05/2013'
    fill_in 'Preço unitário', with: '50,20'
    fill_in 'Marca', with: 'Tabajara'

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Editar propostas'
      end
    end

    expect(page).to have_content 'Editar Proposta Comercial'
    expect(page).to have_content 'Fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_field 'Valor total da proposta', with: '100,40', disabled: true
    expect(page).to have_field 'Lote', with: '2050', disabled: true
    expect(page).to have_field 'Item', with: '1', disabled: true
    expect(page).to have_field 'Material', with: '01.01.00001 - Antivirus', disabled: true
    expect(page).to have_field 'Unidade', with: 'UN', disabled: true
    expect(page).to have_field 'Quantidade', with: '2', disabled: true
    expect(page).to have_field 'Preço total', with: '100,40', disabled: true
    expect(page).to have_field 'Valor total da proposta', with: '100,40', disabled: true

    expect(page).to have_field 'Marca', with: 'Tabajara'
    expect(page).to have_field 'Prazo de entrega', with: '10/05/2013'
    expect(page).to have_field 'Preço unitário', with: '50,20'

    fill_in 'Marca', with: 'Acme'

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'

    click_link "Voltar ao processo de compra"

    expect(page).to_not have_disabled_element 'Lances', reason: 'deve ter ao menos uma proposta'
  end

  scenario 'create and update lot proposals' do
    LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      judgment_form: JudgmentForm.make!(:por_lote_com_melhor_tecnica),
      items: [PurchaseProcessItem.make!(:item), PurchaseProcessItem.make!(:item_arame, lot: 10),
              PurchaseProcessItem.make!(:item_arame_farpado)] )

    first_lot_div = '//*[@id="purchase_process_creditor_proposals"]/div[2]'
    last_lot_div = '//*[@id="purchase_process_creditor_proposals"]/div[4]'

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

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Cadastrar propostas'
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'

    expect(page).to have_field 'Valor total da proposta', with: '0,00', disabled: true

    within :xpath, first_lot_div do
      expect(page).to have_field 'Lote', with: '2050', disabled: true
      expect(page).to have_field 'Preço unitário', with: '0,00'
    end

    within :xpath, last_lot_div do
      expect(page).to have_field 'Lote', with: '10', disabled: true
      expect(page).to have_field 'Preço unitário', with: '0,00'
    end

    within :xpath, first_lot_div do
      fill_in 'Preço unitário', with: '50,20'
    end

    expect(page).to have_field 'Valor total da proposta', with: '50,20', disabled: true

    within :xpath, last_lot_div do
      fill_in 'Preço unitário', with: ''
    end

    click_button 'Salvar'

    within :xpath, last_lot_div do
      expect(page).to have_field 'Preço unitário', with: ''
      expect(page).to have_content 'não pode ficar em branco'
      fill_in 'Preço unitário', with: '100,00'
    end

    expect(page).to have_field 'Valor total da proposta', with: '150,20', disabled: true

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Editar propostas'
      end
    end

    expect(page).to have_content 'Editar Proposta Comercial'

    expect(page).to have_field 'Valor total da proposta', with: '150,20', disabled: true

    within :xpath, first_lot_div do
      expect(page).to have_field 'Lote', with: '2050', disabled: true
      expect(page).to have_field 'Preço unitário', with: '50,20'
    end

    within :xpath, last_lot_div do
      expect(page).to have_field 'Lote', with: '10', disabled: true
      expect(page).to have_field 'Preço unitário', with: '100,00'
      fill_in 'Preço unitário', with: ''
    end

    click_button 'Salvar'

    within :xpath, last_lot_div do
      expect(page).to have_field 'Preço unitário', with: ''
      expect(page).to have_content 'não pode ficar em branco'
      fill_in 'Preço unitário', with: '100,00'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'

    within_records do
      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'

        click_link "Cadastrar propostas"
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'

    expect(page).to have_field 'Valor total da proposta', with: '0,00', disabled: true

    within :xpath, first_lot_div do
      expect(page).to have_field 'Lote', with: '2050', disabled: true
      expect(page).to have_field 'Preço unitário', with: '0,00'
    end

    within :xpath, last_lot_div do
      expect(page).to have_field 'Lote', with: '10', disabled: true
      expect(page).to have_field 'Preço unitário', with: '0,00'
    end
  end

  scenario 'create and update global proposals' do
    LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      judgment_form: JudgmentForm.make!(:global_com_menor_preco),
      items: [PurchaseProcessItem.make!(:item), PurchaseProcessItem.make!(:item_arame, lot: 10),
              PurchaseProcessItem.make!(:item_arame_farpado)])

    global_div = '//*[@id="purchase_process_creditor_proposals"]/div[2]'

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

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Cadastrar propostas'
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'

    within :xpath, global_div do
      expect(page).to have_field 'Valor total da proposta', with: '0,00'
      fill_in 'Valor total da proposta', with: '50,20'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
      end

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:nth-child(1)' do
        click_link 'Editar propostas'
      end
    end

    within :xpath, global_div do
      expect(page).to have_field 'Valor total da proposta', with: '50,20'
    end

    click_link "Voltar"

    within_records do
      within 'tbody tr:nth-last-child(1)' do
        click_link 'Cadastrar propostas'
      end
    end

    within :xpath, global_div do
      expect(page).to have_field 'Valor total da proposta', with: '0,00'
    end
  end

  scenario 'tie brake draw proposals' do
    bidders = [
      Bidder.make!(:licitante_sobrinho, enabled: true, habilitation_date: Date.current),
      Bidder.make!(:licitante, enabled: true, habilitation_date: Date.current),
      Bidder.make!(:me_pregao, enabled: true, habilitation_date: Date.current)
    ]

    LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      bidders: bidders,
      judgment_form: JudgmentForm.make!(:por_item_com_melhor_tecnica))

    first_creditor = '//*[@id="tied_creditor_proposals"]/div[2]/div'
    last_creditor  = '//*[@id="tied_creditor_proposals"]/div[3]/div'

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'

    expect(page).to have_title 'Proposta Comercial Processo 1/2012 - Pregão 1'

    within_records do
      within 'tbody tr:nth-child(1)' do
        click_link 'Cadastrar propostas'
      end
    end

    fill_in 'Preço unitário', with: '50,20'
    fill_in 'Marca', with: 'Chevrolet'
    fill_in 'Prazo de entrega', with: '10/05/2013'

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial editada com sucesso'

    within_records do
      within 'tbody tr:nth-last-child(1)' do
        click_link 'Cadastrar propostas'
      end
    end

    fill_in 'Preço unitário', with: '50,20'
    fill_in 'Marca', with: 'Fiat'
    fill_in 'Prazo de entrega', with: '10/05/2013'

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial editada com sucesso'

    click_link "Desempatar propostas"

    expect(page).to have_title 'Desempate de Propostas'
    expect(page).to have_subtitle '1/2012 - Pregão 1'

    within 'div#tied_creditor_proposals' do
      expect(page).to have_field 'Item/Lote', with: '01.01.00001 - Antivirus', disabled: true

      within :xpath, first_creditor do
        expect(page).to have_field 'Credor', with: 'Gabriel Sobrinho', disabled: true
        expect(page).to have_field 'Preço unitário', with: '50,20', disabled: true
        expect(page).to have_select 'Posição', options: ['1', '2'], selected: '1'
      end

      within :xpath, last_creditor do
        expect(page).to have_field 'Credor', with: 'Wenderson Malheiros', disabled: true
        expect(page).to have_field 'Preço unitário', with: '50,20', disabled: true
        expect(page).to have_select 'Posição', options: ['1', '2'], selected: '1'
      end
    end

    click_button "Salvar"

    expect(page).to have_content 'já está em uso'

    within 'div#tied_creditor_proposals' do
      within 'div.creditor_proposal_rankings' do
        select '2', :from => 'Posição'
      end
    end

    click_button "Salvar"

    expect(page).to have_notice 'Desempate editado com sucesso'

    within_records do
      within 'tbody tr:nth-child(1)' do
        click_link 'Editar propostas'
      end
    end

    fill_in 'Preço unitário', with: '100,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial editada com sucesso'

    expect(page).to_not have_link "Desempatar propostas"
  end
end
