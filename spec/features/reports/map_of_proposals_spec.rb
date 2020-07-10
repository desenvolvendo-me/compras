require 'spec_helper'

feature 'Report::MapOfProposals', vcr: { cassette_name: :map_of_proposals } do
  background do
    Prefecture.make!(:belo_horizonte)

    sign_in
  end

  scenario 'should map of proposals order by creditor_name' do
    make_dependencies!
    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'
    click_link 'Mapa de Propostas'

    select 'Ordem alfabética', :from => 'Ordem'

    click_button 'Gerar Mapa de Proposta'

    expect(page).to have_content 'Belo Horizonte'
    expect(page).to have_content 'Mapa Comparativo de Preços'
    expect(page).to have_content '1/2012 - Pregão 1'

    within '.antivirus' do
      within 'thead' do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'Quantidade'
        expect(page).to have_content '2'
      end

      within 'tbody' do
        within 'tr.winner' do
          expect(page).to have_content '- Gabriel Sobrinho'
          expect(page).to have_content 'R$ 2,99'
          expect(page).to have_content 'R$ 5,98'
        end

        within 'tr.lost' do
          expect(page).to have_content 'Wenderson Malheiros'
          expect(page).to have_content 'R$ 4,99'
          expect(page).to have_content 'R$ 9,98'
        end

        within 'tr:nth-last-child(1)' do
          expect(page).to have_content 'Valor de referência'
          expect(page).to have_content 'R$ 10,00'
          expect(page).to have_content 'R$ 20,00'
        end
      end
    end

    within '.arame-comum' do
      within 'thead' do
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Quantidade'
        expect(page).to have_content '1'
      end

      within 'tbody' do
        within '.gabriel-sobrinho.draw' do
          expect(page).to have_content '- Gabriel Sobrinho'
          expect(page).to have_content 'R$ 4,99'
          expect(page).to have_content 'R$ 4,99'
        end

        within '.wenderson-malheiros.draw' do
          expect(page).to have_content 'Wenderson Malheiros'
          expect(page).to have_content 'R$ 4,99'
          expect(page).to have_content 'R$ 4,99'
        end

        within 'tr:nth-last-child(1)' do
          expect(page).to have_content 'Valor de referência'
          expect(page).to have_content 'R$ 10,00'
          expect(page).to have_content 'R$ 10,00'
        end
      end
    end
  end

  scenario 'should map of proposals order by unit_price' do
    make_dependencies!
    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'
    click_link 'Mapa de Propostas'

    select 'Valor crescente', :from => 'Ordem'

    click_button 'Gerar Mapa de Proposta'

    expect(page).to have_content 'Belo Horizonte'
    expect(page).to have_content 'Mapa Comparativo de Preços'
    expect(page).to have_content '1/2012 - Pregão 1'

    within '.antivirus' do
      within 'thead' do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'Quantidade'
        expect(page).to have_content '2'
      end

      within 'tr.winner' do
        expect(page).to have_content '- Gabriel Sobrinho'
        expect(page).to have_content 'R$ 2,99'
        expect(page).to have_content 'R$ 5,98'
      end

      within 'tr.lost' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'R$ 4,99'
        expect(page).to have_content 'R$ 9,98'
      end
    end

    within '.arame-comum' do
      within 'thead' do
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Quantidade'
        expect(page).to have_content '1'
      end

      within '.gabriel-sobrinho' do
        expect(page).to have_content '- Gabriel Sobrinho'
        expect(page).to have_content 'R$ 4,99'
        expect(page).to have_content 'R$ 4,99'
      end

      within '.wenderson-malheiros' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'R$ 4,99'
        expect(page).to have_content 'R$ 4,99'
      end
    end
  end

  scenario 'should map of proposals order by unit_price desc' do
    make_dependencies!
    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'
    click_link 'Mapa de Propostas'

    select 'Valor decrescente', :from => 'Ordem'

    click_button 'Gerar Mapa de Proposta'

    expect(page).to have_content 'Belo Horizonte'
    expect(page).to have_content 'Mapa Comparativo de Preços'
    expect(page).to have_content '1/2012 - Pregão 1'

    within '.antivirus' do
      within 'thead' do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'Quantidade'
        expect(page).to have_content '2'
      end

      within 'tr.lost' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'R$ 4,99'
        expect(page).to have_content 'R$ 9,98'
      end

      within 'tr.winner' do
        expect(page).to have_content '- Gabriel Sobrinho'
        expect(page).to have_content 'R$ 2,99'
        expect(page).to have_content 'R$ 5,98'
      end

    end

    within '.arame-comum' do
      within 'thead' do
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Quantidade'
        expect(page).to have_content '1'
      end

      within '.gabriel-sobrinho.draw' do
        expect(page).to have_content '- Gabriel Sobrinho'
        expect(page).to have_content 'R$ 4,99'
        expect(page).to have_content 'R$ 4,99'
      end

      within '.wenderson-malheiros.draw' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'R$ 4,99'
        expect(page).to have_content 'R$ 4,99'
      end
    end
  end

  scenario 'should map of proposals order by creditor_name when judgment form is by lot' do
    creditor_sobrinho = Creditor.make!(:sobrinho)
    creditor_wenderson = Creditor.make!(:wenderson_sa)

    item = PurchaseProcessItem.make!(:item, lot: 1)
    item_arame = PurchaseProcessItem.make!(:item_arame, lot: 1)

    purchase_process = LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      items: [item, item_arame], judgment_form: JudgmentForm.make!(:por_lote_com_menor_preco))

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      creditor: creditor_wenderson,
      lot: 1,
      item: nil)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: purchase_process,
      creditor: creditor_sobrinho,
      lot: 1,
      item: nil)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'
    click_link 'Mapa de Propostas'

    select 'Ordem alfabética', :from => 'Ordem'

    click_button 'Gerar Mapa de Proposta'

    expect(page).to have_content 'Belo Horizonte'
    expect(page).to have_content 'Mapa Comparativo de Preços'
    expect(page).to have_content '1/2012 - Pregão 1'
    expect(page).to have_content 'Lote: 1'

    within 'table.items' do
      within 'tbody' do
        within 'tr:nth-child(1)' do
          expect(page).to have_content 'Antivirus'
          expect(page).to have_content '2'
          expect(page).to have_content 'R$ 10,00'
          expect(page).to have_content 'R$ 20,00'
        end

        within 'tr:nth-child(2)' do
          expect(page).to have_content 'Arame comum'
          expect(page).to have_content '1'
          expect(page).to have_content 'R$ 10,00'
          expect(page).to have_content 'R$ 10,00'
        end
      end
    end

    within 'table.proposals' do
      within 'tr.winner' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'R$ 2,99'
      end

      within 'tr.lost' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'R$ 4,99'
      end
    end
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
  end
end
