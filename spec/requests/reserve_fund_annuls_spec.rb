#encoding: utf-8
require 'spec_helper'

feature 'ReserveFundAnnuls' do
  background do
    sign_in
  end

  scenario 'creating a reserve fund annul' do
    reserve_fund = ReserveFund.make!(:detran_2012)
    Employee.make!(:sobrinho)

    navigate 'Outros > Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link reserve_fund.to_s

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Justificativa', :with => 'Não necessário'

    click_button 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criada com sucesso.'

    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Anulado'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Reserva de Dotação #{reserve_fund}"
    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_disabled_field 'Justificativa'
    expect(page).to have_field 'Justificativa', :with => 'Não necessário'

    expect(page).to_not have_link 'Apagar'
    expect(page).to_not have_button 'Salvar'
  end
end
