#encoding: utf-8
require 'spec_helper'

feature 'Report::MinutePurchaseProcesses' do
  background do
    sign_in
  end

  scenario 'viewing the list in alphabetical order' do
    pending
    make_dependencies!

    navigate 'Relatórios > minute_purchase_processes > minute_purchase_process'

    click_on 'Gerar Relatório de minute_purchase_processes'

    within_records do
      within 'tbody tr:first' do
        expect(page).to have_content 'Other'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'One'
      end
    end
  end


  def make_dependencies!

  end
end
