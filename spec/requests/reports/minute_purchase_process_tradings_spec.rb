#encoding: utf-8
require 'spec_helper'

feature 'Report::MinutePurchaseProcessTradings' do
  background do
    sign_in
  end

  scenario 'viewing the list in alphabetical order' do
    make_dependencies!

    navigate 'Relatórios > minute_purchase_process_tradings > minute_purchase_process_trading'

    click_on 'Gerar Relatório de minute_purchase_process_tradings'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_content 'Other'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'One'
      end
    end
  end

  scenario 'viewing the list in numerical order' do
    make_dependencies!

    navigate 'Relatórios > minute_purchase_process_tradings > minute_purchase_process_trading'

    select 'Numérica', :from => 'Tipo de ordenação'

    click_on 'Gerar Relatório de minute_purchase_process_tradings'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_content 'One'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Other'
      end
    end
  end

  def make_dependencies!
    MinutePurchaseProcessTradingSearcher.make!(:one)
    MinutePurchaseProcessTradingSearcher.make!(:other)
  end
end
