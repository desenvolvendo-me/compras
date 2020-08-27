#encoding: utf-8
require 'spec_helper'

feature 'Report::MapOfPrices' do
  background do
    Prefecture.make!(:belo_horizonte)
    sign_in
  end

  scenario 'map of prices report ordered by unit price' do
     price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes,
      type_of_calculation: PriceCollectionTypeOfCalculation::LOWEST_PRICE_BY_LOT)

    PriceCollectionProposalItem.all.each_with_index do |proposal_item, index|
      proposal_item.unit_price = 1.25 * (index + 1)
      proposal_item.save!
    end

    navigate 'Licitações > Coletas de Preços'



    within_records do
      page.find('a').click
    end

    expect(page).to have_subtitle '1/2012'

    click_link "Mapa de preços"

    expect(page).to have_content "Mapa Comparativo de Preços"
    expect(page).to have_content "Coleta de Preço 1/2012"

    expect(page).to have_content "Lote: 1 - 01.01.00001 - Antivirus - Quantidade: 3"

    within :xpath, '//*[@id="content"]/div/table[1]' do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Valor unitário'
      expect(page).to have_content 'Valor total'

      within :xpath, '//*[@id="content"]/div/table[1]/tbody/tr[1]' do
        expect(page).to have_content '003.149.513-34 - Wenderson Malheiros'
        expect(page).to have_content 'R$ 1,25'
        expect(page).to have_content 'R$ 12,50'
      end

      within :xpath, '//*[@id="content"]/div/table[1]/tbody/tr[2]' do
        expect(page).to have_content '003.151.987-37 - Gabriel Sobrinho'
        expect(page).to have_content 'R$ 3,75'
        expect(page).to have_content 'R$ 37,50'
      end

      within :xpath, '//*[@id="content"]/div/table[1]/tbody/tr[3]' do
        expect(page).to have_content '85.113.468/0001-45 - IBM'
        expect(page).to have_content 'R$ 6,25'
        expect(page).to have_content 'R$ 62,50'
      end

      within :xpath, '//*[@id="content"]/div/table[1]/tfoot/tr' do
        expect(page).to have_content 'Preço médio'
        expect(page).to have_content 'R$ 3,75'
        expect(page).to have_content 'R$ 37,50'
      end
    end

    expect(page).to have_content "Lote: 2 - 02.02.00002 - Arame comum - Quantidade: 3"

    within :xpath, '//*[@id="content"]/div/table[2]' do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Valor unitário'
      expect(page).to have_content 'Valor total'

      within :xpath, '//*[@id="content"]/div/table[2]/tbody/tr[1]' do
        expect(page).to have_content '003.149.513-34 - Wenderson Malheiros'
        expect(page).to have_content 'R$ 2,50'
        expect(page).to have_content 'R$ 500,00'
      end

      within :xpath, '//*[@id="content"]/div/table[2]/tbody/tr[2]' do
        expect(page).to have_content '003.151.987-37 - Gabriel Sobrinho'
        expect(page).to have_content 'R$ 5,00'
        expect(page).to have_content 'R$ 1.000,00'
      end

      within :xpath, '//*[@id="content"]/div/table[2]/tbody/tr[3]' do
        expect(page).to have_content '85.113.468/0001-45 - IBM'
        expect(page).to have_content 'R$ 7,50'
        expect(page).to have_content 'R$ 1.500,00'
      end

      within :xpath, '//*[@id="content"]/div/table[2]/tfoot/tr' do
        expect(page).to have_content 'Preço médio'
        expect(page).to have_content 'R$ 5,00'
        expect(page).to have_content 'R$ 1.000,00'
      end
    end
  end
end
