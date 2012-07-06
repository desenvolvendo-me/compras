#encoding: utf-8
require 'spec_helper'

feature 'PledgeLiquidationAnnuls' do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'should not have a annul link when was creating a new solicitation' do
    navigate_through 'Contabilidade > Execução > Empenho > Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    page.should_not have_link 'Anular'
    page.should_not have_link 'Anulação'
  end

  scenario 'annuling a pledge_liquidation' do
    pledge = Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Liquidações de Empenho'

    click_link pledge_liquidation.to_s

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'

      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Data', :with => '10/06/2012'
    fill_in 'Justificativa', :with => 'Não mais necessário'

    click_button 'Salvar'

    page.should have_content 'Anulação de Recurso criado com sucesso.'

    page.should have_select 'Status', :selected => 'Anulada'

    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

    page.should have_field 'Valor a ser liquidado', :with => '1,00'
    page.should have_field 'Data *', :with => I18n.l(Date.tomorrow)
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => 'Para empenho 2012'

    page.should_not have_button 'Salvar'

    click_link 'Anulação'

    page.should have_disabled_field 'Responsável'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'

    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => '10/06/2012'

    page.should have_disabled_field 'Justificativa'
    page.should have_field 'Justificativa', :with => 'Não mais necessário'

    page.should_not have_button 'Salvar'
    page.should_not have_link 'Apagar'
  end
end
