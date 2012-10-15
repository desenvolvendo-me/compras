#encoding: utf-8
require 'spec_helper'

feature 'PledgeLiquidationAnnuls' do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'annuling a pledge_liquidation' do
    pledge = Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    navigate 'Outros > Contabilidade > Execução > Empenho > Liquidações de Empenho'

    click_link pledge_liquidation.to_s

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'

      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Data', :with => '10/06/2012'
    fill_in 'Justificativa', :with => 'Não mais necessário'

    click_button 'Salvar'

    expect(page).to have_content 'Anulação de Recurso criado com sucesso.'

    expect(page).to have_select 'Status', :selected => 'Anulada'

    expect(page).to have_field 'Empenho', :with => pledge.to_s
    expect(page).to have_disabled_field 'Data de emissão'
    expect(page).to have_field 'Data de emissão', :with => I18n.l(Date.current)

    expect(page).to have_field 'Valor a ser liquidado', :with => '1,00'
    expect(page).to have_field 'Data *', :with => I18n.l(Date.tomorrow)
    expect(page).to have_disabled_field 'Objeto do empenho'
    expect(page).to have_field 'Objeto do empenho', :with => 'Para empenho 2012'

    expect(page).to_not have_button 'Salvar'

    click_link 'Anulação'

    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data', :with => '10/06/2012'

    expect(page).to have_disabled_field 'Justificativa'
    expect(page).to have_field 'Justificativa', :with => 'Não mais necessário'

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end
end
