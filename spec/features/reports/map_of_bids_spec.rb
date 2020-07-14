require 'spec_helper'

feature 'Report::MapOfBids', vcr: { cassette_name: :map_of_bids } do
  background do
    sign_in
  end

  scenario 'should map of bids' do
    make_dependencies!

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    click_link 'Mapa de lances'

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
        expect(page).to have_content 'Nohup'
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

      within '.nohup' do
        expect(page).to have_content 'Nohup'
        expect(page).to have_content 'R$ 4,99'
        expect(page).to have_content 'R$ 4,99'
      end
    end

    within '.bids' do
      within 'tbody' do
        within 'tr:nth-child(1)' do
          expect(page).to have_content 'Arame comum'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '1'
          expect(page).to have_content '4,98'
        end

        within 'tr:nth-child(2)' do
          expect(page).to have_content 'Arame comum'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '1'
          expect(page).to have_content '4,97'
        end

        within 'tr:nth-child(3)' do
          expect(page).to have_content 'Arame comum'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '2'
          expect(page).to have_content '4,96'
        end

        within 'tr:nth-child(4)' do
          expect(page).to have_content 'Arame comum'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '2'
          expect(page).to have_content '4,95'
        end

        within 'tr:nth-child(5)' do
          expect(page).to have_content 'Arame comum'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '3'
          expect(page).to have_content '0,00'
        end

        within 'tr:nth-child(6)' do
          expect(page).to have_content 'Antivirus'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '1'
          expect(page).to have_content '2,80'
        end

        within 'tr:nth-child(7)' do
          expect(page).to have_content 'Antivirus'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '1'
          expect(page).to have_content '2,79'
        end

        within 'tr:nth-child(8)' do
          expect(page).to have_content 'Antivirus'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '2'
          expect(page).to have_content '2,78'
        end

        within 'tr:nth-child(9)' do
          expect(page).to have_content 'Antivirus'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '2'
          expect(page).to have_content '2,77'
        end

        within 'tr:nth-child(10)' do
          expect(page).to have_content 'Antivirus'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '3'
          expect(page).to have_content '0,00'
        end
      end
    end

    within '.negotiations' do
      within 'tbody' do
        within 'tr:nth-child(1)' do
          expect(page).to have_content 'Antivirus'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '2,50'
        end

        within 'tr:nth-child(2)' do
          expect(page).to have_content 'Arame comum'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '4,50'
        end
      end
    end
  end

  scenario 'should display map of bids and proposals by lot' do
    make_dependencies_bids_by_lot!

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    click_link 'Mapa de lances'

    within 'table.items_1' do
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

    within 'table.proposals_1' do
      within 'tr.winner' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'R$ 2,99'
      end

      within 'tr.lost' do
        expect(page).to have_content 'Nohup'
        expect(page).to have_content 'R$ 4,99'
      end
    end

    within 'table.items_2' do
      within 'tbody' do
        within 'tr:nth-child(1)' do
          expect(page).to have_content 'Arame farpado'
          expect(page).to have_content '2'
          expect(page).to have_content 'R$ 30,00'
          expect(page).to have_content 'R$ 60,00'
        end
      end
    end

    within 'table.proposals_2' do
      within 'tr.draw:nth-last-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'R$ 4,99'
      end

      within 'tr.draw:nth-child(1)' do
        expect(page).to have_content 'Nohup'
        expect(page).to have_content 'R$ 4,99'
      end
    end

    within '.bids' do
      within 'tbody' do
        within 'tr:nth-child(1)' do
          expect(page).to have_content '1'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '1'
          expect(page).to have_content '2,80'
        end

        within 'tr:nth-child(2)' do
          expect(page).to have_content '1'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '1'
          expect(page).to have_content '2,79'
        end

        within 'tr:nth-child(3)' do
          expect(page).to have_content '1'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '2'
          expect(page).to have_content '2,78'
        end

        within 'tr:nth-child(4)' do
          expect(page).to have_content '1'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '2'
          expect(page).to have_content '2,77'
        end

        within 'tr:nth-child(5)' do
          expect(page).to have_content '1'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '3'
          expect(page).to have_content '0,00'
        end

        within 'tr:nth-child(6)' do
          expect(page).to have_content '2'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '1'
          expect(page).to have_content '4,98'
        end

        within 'tr:nth-child(7)' do
          expect(page).to have_content '2'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '1'
          expect(page).to have_content '4,97'
        end

        within 'tr:nth-child(8)' do
          expect(page).to have_content '2'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '2'
          expect(page).to have_content '4,96'
        end

        within 'tr:nth-child(9)' do
          expect(page).to have_content '2'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '2'
          expect(page).to have_content '4,95'
        end

        within 'tr:nth-child(10)' do
          expect(page).to have_content '2'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '3'
          expect(page).to have_content '0,00'
        end
      end
    end

    within '.negotiations' do
      within 'tbody' do
        within 'tr:nth-child(1)' do
          expect(page).to have_content '1'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content '2,50'
        end

        within 'tr:nth-child(2)' do
          expect(page).to have_content '2'
          expect(page).to have_content 'Nohup'
          expect(page).to have_content '4,50'
        end
      end
    end
  end

  def make_dependencies!
    creditor_sobrinho = Creditor.make!(:sobrinho)
    creditor_nohup = Creditor.make!(:nohup)

    item = PurchaseProcessItem.make!(:item)
    item_arame = PurchaseProcessItem.make!(:item_arame)

    accreditation_sobrinho = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor,
      creditor: creditor_sobrinho)

    accreditation_nohup = PurchaseProcessAccreditationCreditor.make(:wenderson_creditor,
      creditor: creditor_nohup)

    purchase_process = LicitationProcess.make!(:pregao_presencial,
      items: [item, item_arame])

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: purchase_process,
      purchase_process_accreditation_creditors: [accreditation_sobrinho, accreditation_nohup])


    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      creditor: creditor_nohup,
      item: item)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: purchase_process,
      creditor: creditor_sobrinho,
      item: item)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      creditor: creditor_nohup,
      item: item_arame)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: purchase_process,
      creditor: creditor_sobrinho,
      item: item_arame,
      unit_price: 4.99)

    trading = PurchaseProcessTrading.create!(purchase_process_id: purchase_process.id)

    trading_item = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: item.id)

    trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: item_arame.id)

    accreditation_sobrinho = accreditation.purchase_process_accreditation_creditors.first
    accreditation_nohup    = accreditation.purchase_process_accreditation_creditors.last

    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 2.80, round: 1, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 2.79, round: 1, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 2.78, round: 2, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 2.77, round: 2, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 0, round: 3, number: 1, status: TradingItemBidStatus::DECLINED)


    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 4.98, round: 1, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 4.97, round: 1, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 4.96, round: 2, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 4.95, round: 2, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 0.00, round: 3, number: 1, status: TradingItemBidStatus::DECLINED)

    trading_item.close!
    trading_item_arame.close!

    PurchaseProcessTradingItemNegotiation.create!(purchase_process_trading_item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id, amount: 2.50)
    PurchaseProcessTradingItemNegotiation.create!(purchase_process_trading_item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id, amount: 4.50)
  end

  def make_dependencies_bids_by_lot!
    creditor_sobrinho = Creditor.make!(:sobrinho)
    creditor_nohup = Creditor.make!(:nohup)

    item = PurchaseProcessItem.make!(:item, lot: 1)
    item_arame = PurchaseProcessItem.make!(:item_arame, lot: 1)
    item_arame_farpado = PurchaseProcessItem.make!(:item_arame_farpado, lot: 2)

    accreditation_sobrinho = PurchaseProcessAccreditationCreditor.make(:sobrinho_creditor,
      creditor: creditor_sobrinho)

    accreditation_nohup = PurchaseProcessAccreditationCreditor.make(:wenderson_creditor,
      creditor: creditor_nohup)

    purchase_process = LicitationProcess.make!(:pregao_presencial,
      items: [item, item_arame, item_arame_farpado], judgment_form: JudgmentForm.make!(:por_lote_com_menor_preco))

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: purchase_process,
      purchase_process_accreditation_creditors: [accreditation_sobrinho, accreditation_nohup])

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      creditor: creditor_nohup,
      item: nil,
      lot: 1)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: purchase_process,
      creditor: creditor_sobrinho,
      item: nil,
      lot: 1)

    PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
      licitation_process: purchase_process,
      creditor: creditor_nohup,
      item: nil,
      lot: 2)

    PurchaseProcessCreditorProposal.make!(:proposta_arame,
      licitation_process: purchase_process,
      creditor: creditor_sobrinho,
      item: nil,
      lot: 2,
      unit_price: 4.99)

    trading = PurchaseProcessTrading.create!(purchase_process_id: purchase_process.id)

    trading_item = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: nil, lot: 1)

    trading_item_arame = PurchaseProcessTradingItem.create!(trading_id: trading.id,
      item_id: nil, lot: 2)

    accreditation_sobrinho = accreditation.purchase_process_accreditation_creditors.first
    accreditation_nohup    = accreditation.purchase_process_accreditation_creditors.last

    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 2.80, round: 1, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 2.79, round: 1, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 2.78, round: 2, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 2.77, round: 2, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 0, round: 3, number: 1, status: TradingItemBidStatus::DECLINED)

    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 4.98, round: 1, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 4.97, round: 1, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 4.96, round: 2, number: 1, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id,
      amount: 4.95, round: 2, number: 2, status: TradingItemBidStatus::WITH_PROPOSAL)
    PurchaseProcessTradingItemBid.create!(item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id,
      amount: 0.00, round: 3, number: 1, status: TradingItemBidStatus::DECLINED)

    trading_item.close!
    trading_item_arame.close!

    PurchaseProcessTradingItemNegotiation.create!(purchase_process_trading_item_id: trading_item.id,
      purchase_process_accreditation_creditor_id: accreditation_sobrinho.id, amount: 2.50)
    PurchaseProcessTradingItemNegotiation.create!(purchase_process_trading_item_id: trading_item_arame.id,
      purchase_process_accreditation_creditor_id: accreditation_nohup.id, amount: 4.50)
  end
end
