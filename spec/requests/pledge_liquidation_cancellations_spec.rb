# encoding: utf-8
require 'spec_helper'

feature "PledgeLiquidationCancellations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_liquidation_cancellation' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)
    PledgeLiquidation.make!(:liquidacao_para_dois_vencimentos)

    navigate_through 'Contabilidade > Execução > Empenho > Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => pledge.id.to_s, :field => 'Id'
    fill_in 'Valor liquidado a ser anulado', :with => '90,00'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Salvar'

    page.should have_notice 'Anulação de Liquidação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

    page.should have_field 'Valor liquidado a ser anulado', :with => '90,00'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'when fill/clear pledge should fill/clear delegateds fields' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)
    PledgeLiquidation.make!(:liquidacao_para_dois_vencimentos)

    navigate_through 'Contabilidade > Execução > Empenho > Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => pledge.id.to_s, :field => 'Id'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

    clear_modal 'Empenho'
    page.should have_field 'Empenho', :with => ''
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    Pledge.make!(:empenho)
    PledgeLiquidation.make!(:liquidacao_total)
    pledge_liquidation_cancellation = PledgeLiquidationCancellation.make!(:empenho_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Anulações de Liquidações de Empenho'

    click_link pledge_liquidation_cancellation.to_s

    should_not have_button 'Criar Anulação de Liquidação de Empenho'

    page.should have_disabled_field 'Empenho'
    page.should have_field 'Empenho', :with => '1 - Detran/2012'
    page.should have_disabled_field 'Valor liquidado a ser anulado'
    page.should have_field 'Valor liquidado a ser anulado', :with => '1,00'
    page.should have_disabled_field 'Data *'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Motivo *'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'should not have a button to destroy an existent pledge' do
    PledgeLiquidation.make!(:liquidacao_total)
    pledge_liquidation_cancellation = PledgeLiquidationCancellation.make!(:empenho_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Anulações de Liquidações de Empenho'

    click_link pledge_liquidation_cancellation.to_s

    page.should_not have_link "Apagar"
  end
end
