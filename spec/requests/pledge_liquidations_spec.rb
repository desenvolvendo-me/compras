# encoding: utf-8
require 'spec_helper'

feature "PledgeLiquidations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_liquidation' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    navigate_through 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Empenho', :with => pledge.id.to_s, :field => 'Id'
    fill_in 'Valor a ser liquidado', :with => '150,00'
    fill_in 'Data *', :with => I18n.l(Date.tomorrow)
    fill_in 'Objeto do empenho', :with => 'Para empenho 2012'

    click_button 'Salvar'

    page.should have_notice 'Liquidação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

    page.should have_field 'Valor a ser liquidado', :with => '150,00'
    page.should have_field 'Data *', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Objeto do empenho', :with => 'Para empenho 2012'
  end

  scenario 'when fill/clear pledge should fill/clear delegateds fields' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    navigate_through 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Empenho', :with => pledge.id.to_s, :field => 'Id'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_field 'Objeto do empenho', :with => 'Descricao'

    clear_modal 'Empenho'

    page.should have_field 'Empenho', :with => ''
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''
  end

  scenario 'should have all disabled fields when edit existent pledge_liquidation' do
    pledge = Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link pledge_liquidation.to_s

    should_not have_button 'Criar Liquidação de Empenho'

    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

    page.should have_field 'Valor a ser liquidado', :with => '1,00'
    page.should have_field 'Data *', :with => I18n.l(Date.tomorrow)
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => 'Para empenho 2012'
  end

  scenario 'should not have a button to destroy an existent pledge_liquidation' do
    Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Liquidações de Empenhos'

    click_link pledge_liquidation.to_s

    page.should_not have_link 'Apagar'
  end
end
