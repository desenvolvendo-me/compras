#encoding: utf-8
require 'spec_helper'

feature 'Report::MapOfProposals' do
  background do
    Prefecture.make!(:belo_horizonte)
    sign_in
  end

  scenario 'should map of proposals order by creditor_name' do
    make_dependencies!
    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

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

        within 'tr:last' do
          expect(page).to have_content 'Preço Médio'
          expect(page).to have_content 'R$ 3,99'
          expect(page).to have_content 'R$ 7,98'
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

        within 'tr:last' do
          expect(page).to have_content 'Preço Médio'
          expect(page).to have_content 'R$ 4,99'
          expect(page).to have_content 'R$ 4,99'
        end
      end
    end
  end

  scenario 'should map of proposals order by unit_price' do
    make_dependencies!
    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

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
    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

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

  def make_dependencies!
    licitation = LicitationProcess.make!(:pregao_presencial,
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation),
      items: [PurchaseProcessItem.make!(:item), PurchaseProcessItem.make!(:item_arame) ])

    creditor_sobrinho = licitation.creditors.select { |creditor|  creditor.name == 'Gabriel Sobrinho' }.first
    creditor_wenderson = licitation.creditors.select { |creditor|  creditor.name == 'Wenderson Malheiros' }.first

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: licitation,
      creditor: creditor_wenderson,
      item: PurchaseProcessItem.make!(:item))

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: licitation,
      creditor: creditor_sobrinho,
      item: PurchaseProcessItem.make!(:item))

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: licitation,
      creditor: creditor_wenderson,
      item: PurchaseProcessItem.make!(:item_arame))

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: licitation,
      creditor: creditor_sobrinho,
      item: PurchaseProcessItem.make!(:item_arame),
      unit_price: 4.99)
  end
end
