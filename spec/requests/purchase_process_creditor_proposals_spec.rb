# encoding: utf-8
require 'spec_helper'

feature 'PurchaseProcessCreditorProposals' do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    Prefecture.make!(:belo_horizonte)
    sign_in
  end

  scenario 'create and update item creditor proposals' do
    LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      judgment_form: JudgmentForm.make!(:por_item_com_melhor_tecnica))

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

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:first' do
        click_link 'Cadastrar propostas'
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'
    expect(page).to have_content 'Fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_disabled_field 'Valor total da proposta', with: '0,00'
    expect(page).to have_disabled_field 'Lote', with: '2050'
    expect(page).to have_disabled_field 'Item', with: '1'
    expect(page).to have_disabled_field 'Material', with: '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Unidade', with: 'UN'
    expect(page).to have_disabled_field 'Quantidade', with: '2'
    expect(page).to have_disabled_field 'Preço total', with: '0,00'

    fill_in 'Preço unitário', with: '50,20'

    expect(page).to have_disabled_field 'Valor total da proposta', with: '100,40'
    expect(page).to have_disabled_field 'Preço total', with: '100,40'

    click_button 'Salvar'

    expect(page).to have_field 'Marca', with: ''
    expect(page).to have_content 'não pode ficar em branco'

    fill_in 'Marca', with: 'Tabajara'
    fill_in 'Prazo de entrega', with: '10/05/2013'

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial criada com sucesso'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:first' do
        click_link 'Editar propostas'
      end
    end

    expect(page).to have_content 'Editar Proposta Comercial'
    expect(page).to have_content 'Fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'


    expect(page).to have_disabled_field 'Valor total da proposta', with: '100,40'
    expect(page).to have_disabled_field 'Lote', with: '2050'
    expect(page).to have_disabled_field 'Item', with: '1'
    expect(page).to have_disabled_field 'Material', with: '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Unidade', with: 'UN'
    expect(page).to have_disabled_field 'Quantidade', with: '2'
    expect(page).to have_disabled_field 'Preço total', with: '100,40'
    expect(page).to have_disabled_field 'Valor total da proposta', with: '100,40'

    expect(page).to have_field 'Marca', with: 'Tabajara'
    expect(page).to have_field 'Prazo de entrega', with: '10/05/2013'
    expect(page).to have_field 'Preço unitário', with: '50,20'

    fill_in 'Marca', with: 'Acme'

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'
  end

  scenario 'create and update lot creditor proposals' do
    LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      judgment_form: JudgmentForm.make!(:por_lote_com_melhor_tecnica),
      items: [PurchaseProcessItem.make!(:item), PurchaseProcessItem.make!(:item_arame, lot: 10),
              PurchaseProcessItem.make!(:item_arame_farpado)] )

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

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:first' do
        click_link 'Cadastrar propostas'
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'

    expect(page).to have_disabled_field 'Valor total da proposta', with: '0,00'

    within 'div.lots:first' do
      expect(page).to have_disabled_field 'Lote', with: '2050'
      expect(page).to have_field 'Preço unitário', with: '0,00'
    end

    within 'div.lots:last' do
      expect(page).to have_disabled_field 'Lote', with: '10'
      expect(page).to have_field 'Preço unitário', with: '0,00'
    end

    within 'div.lots:first' do
      fill_in 'Preço unitário', with: '50,20'
    end

    expect(page).to have_disabled_field 'Valor total da proposta', with: '50,20'

    within 'div.lots:last' do
      fill_in 'Preço unitário', with: ''
    end

    click_button 'Salvar'

    within 'div.lots:last' do
      expect(page).to have_field 'Preço unitário', with: ''
      expect(page).to have_content 'não pode ficar em branco'
      fill_in 'Preço unitário', with: '100,00'
    end

    expect(page).to have_disabled_field 'Valor total da proposta', with: '150,20'

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial criada com sucesso'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:first' do
        click_link 'Editar propostas'
      end
    end

    expect(page).to have_content 'Editar Proposta Comercial'

    expect(page).to have_disabled_field 'Valor total da proposta', with: '150,20'

    within 'div.lots:first' do
      expect(page).to have_disabled_field 'Lote', with: '2050'
      expect(page).to have_field 'Preço unitário', with: '50,20'
    end

    within 'div.lots:last' do
      expect(page).to have_disabled_field 'Lote', with: '10'
      expect(page).to have_field 'Preço unitário', with: '100,00'
      fill_in 'Preço unitário', with: ''
    end

    click_button 'Salvar'

    within 'div.lots:last' do
      expect(page).to have_field 'Preço unitário', with: ''
      expect(page).to have_content 'não pode ficar em branco'
      fill_in 'Preço unitário', with: '100,00'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'

    within_records do
      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'

        click_link "Cadastrar propostas"
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'

    expect(page).to have_disabled_field 'Valor total da proposta', with: '0,00'

    within 'div.lots:first' do
      expect(page).to have_disabled_field 'Lote', with: '2050'
      expect(page).to have_field 'Preço unitário', with: '0,00'
    end

    within 'div.lots:last' do
      expect(page).to have_disabled_field 'Lote', with: '10'
      expect(page).to have_field 'Preço unitário', with: '0,00'
    end
  end

  scenario 'create and update global creditor proposals' do
    LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      judgment_form: JudgmentForm.make!(:global_com_menor_preco),
      items: [PurchaseProcessItem.make!(:item), PurchaseProcessItem.make!(:item_arame, lot: 10),
              PurchaseProcessItem.make!(:item_arame_farpado)])

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

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:first' do
        click_link 'Cadastrar propostas'
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'

    within 'div.lots:first' do
      expect(page).to have_field 'Valor total da proposta', with: '0,00'
      fill_in 'Valor total da proposta', with: '50,20'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial criada com sucesso'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar propostas'
      end

      within 'tbody tr:first' do
        click_link 'Editar propostas'
      end
    end

    within 'div.lots:first' do
      expect(page).to have_field 'Valor total da proposta', with: '50,20'
    end

    click_link "Voltar"

    within_records do
      within 'tbody tr:last' do
        click_link 'Cadastrar propostas'
      end
    end

    within 'div.lots:first' do
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

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'

    expect(page).to have_title 'Proposta Comercial Processo 1/2012 - Pregão 1'

    within_records do
      within 'tbody tr:first' do
        click_link 'Cadastrar propostas'
      end
    end

    fill_in 'Preço unitário', with: '50,20'
    fill_in 'Marca', with: 'Chevrolet'
    fill_in 'Prazo de entrega', with: '10/05/2013'

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:last' do
        click_link 'Cadastrar propostas'
      end
    end

    fill_in 'Preço unitário', with: '50,20'
    fill_in 'Marca', with: 'Fiat'
    fill_in 'Prazo de entrega', with: '10/05/2013'

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    click_link "Desempatar propostas"

    expect(page).to have_title 'Desempate de Propostas'
    expect(page).to have_subtitle '1/2012 - Pregão 1'

    within 'div#tied_creditor_proposals' do
      within 'div.creditor_proposal_rankings:first' do
        expect(page).to have_disabled_field 'Credor', with: 'Gabriel Sobrinho'
        expect(page).to have_disabled_field 'Item/Lote', with: '01.01.00001 - Antivirus'
        expect(page).to have_disabled_field 'Preço unitário', with: '50,20'
        expect(page).to have_select 'Posição', options: ['1', '2'], selected: '1'
      end

      within 'div.creditor_proposal_rankings:last' do
        expect(page).to have_disabled_field 'Credor', with: 'Wenderson Malheiros'
        expect(page).to have_disabled_field 'Item/Lote', with: '01.01.00001 - Antivirus'
        expect(page).to have_disabled_field 'Preço unitário', with: '50,20'
        expect(page).to have_select 'Posição', options: ['1', '2'], selected: '1'
      end
    end

    click_button "Salvar"

    expect(page).to have_content 'já está em uso'

    within 'div#tied_creditor_proposals' do
      within 'div.creditor_proposal_rankings:first' do
        select '2', :from => 'Posição'
      end
    end

    click_button "Salvar"

    expect(page).to have_notice 'Desempate editado com sucesso'

    within_records do
      within 'tbody tr:first' do
        click_link 'Editar propostas'
      end
    end

    fill_in 'Preço unitário', with: '100,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial editada com sucesso'

    expect(page).to_not have_link "Desempatar propostas"
  end
end
