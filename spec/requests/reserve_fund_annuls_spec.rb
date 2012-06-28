#encoding: utf-8
require 'spec_helper'

feature 'ReserveFundAnnuls' do
  background do
    sign_in
  end

  scenario 'creating a reserve fund annul' do
    reserve_fund = ReserveFund.make!(:detran_2012)
    Employee.make!(:sobrinho)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link reserve_fund.to_s

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Descrição', :with => 'Não necessário'

    click_button 'Salvar'

    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Anulado'

    click_link 'Anulação'

    page.should have_content "Anulação da Reserva de Dotação #{reserve_fund}"
    page.should have_disabled_field 'Responsável'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => I18n.l(Date.current)

    page.should_not have_link 'Apagar'
    page.should_not have_button 'Salvar'
  end
end
