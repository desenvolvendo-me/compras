# encoding: utf-8
require 'spec_helper'

feature "PledgeLiquidationCancellations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_liquidation_cancellation' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)
    PledgeLiquidation.make!(:liquidacao_para_dois_vencimentos)
    PledgeParcelMovimentation.make!(:liquidacao_para_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
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

    within '#parcel_1' do
      page.should have_content '1'
      page.should have_content I18n.l(Date.current + 1.day)
      find('.value').should have_content 'R$ 100,00'
      find('.liquidations_value').should have_content 'R$ 90,00'
      find('.canceled_liquidations_value').should have_content 'R$ 90,00'
      find('.balance').should have_content 'R$ 100,00'
    end

    within '#parcel_2' do
      page.should have_content '2'
      page.should have_content I18n.l(Date.current + 2.day)
      find('.value').should have_content 'R$ 100,00'
      find('.liquidations_value').should have_content 'R$ 0,00'
      find('.canceled_liquidations_value').should have_content 'R$ 0,00'
      find('.balance').should have_content 'R$ 100,00'
    end

    page.find('#pledge_value').should have_content 'R$ 200,00'
    page.find('#pledge_liquidations_sum').should have_content 'R$ 90,00'
    page.find('#pledge_liquidation_cancellations_sum').should have_content 'R$ 90,00'
    page.find('#pledge_balance').should have_content 'R$ 200,00'

    page.should have_field 'Valor liquidado a ser anulado', :with => '90,00'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'when fill/clear pledge should fill/clear delegateds fields' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)
    PledgeLiquidation.make!(:liquidacao_para_dois_vencimentos)
    PledgeParcelMovimentation.make!(:liquidacao_para_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

    within '#parcel_1' do
      page.should have_content '1'
      page.should have_content I18n.l(Date.current + 1.day)
      find('.value').should have_content 'R$ 100,00'
      find('.liquidations_value').should have_content 'R$ 90,00'
      find('.canceled_liquidations_value').should have_content 'R$ 0,00'
      find('.balance').should have_content 'R$ 10,00'
    end

    within '#parcel_2' do
      page.should have_content '2'
      page.should have_content I18n.l(Date.current + 2.day)
      find('.value').should have_content 'R$ 100,00'
      find('.liquidations_value').should have_content 'R$ 0,00'
      find('.canceled_liquidations_value').should have_content 'R$ 0,00'
      find('.balance').should have_content 'R$ 100,00'
    end

    page.find('#pledge_value').should have_content 'R$ 200,00'
    page.find('#pledge_liquidations_sum').should have_content 'R$ 90,00'
    page.find('#pledge_liquidation_cancellations_sum').should have_content 'R$ 0,00'
    page.find('#pledge_balance').should have_content 'R$ 110,00'

    clear_modal 'Empenho'
    page.should have_field 'Empenho', :with => ''
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''

    within '#pledge_parcels' do
      page.should_not have_content I18n.l(Date.current + 1.day)
      page.should_not have_content 'R$ 100,00'
    end
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    pledge = Pledge.make!(:empenho)
    PledgeLiquidation.make!(:liquidacao_total)
    PledgeParcelMovimentation.make!(:liquidacao_total)
    pledge_liquidation_cancellation = PledgeLiquidationCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link pledge_liquidation_cancellation.to_s

    should_not have_button 'Criar Anulação de Liquidação de Empenho'

    page.should have_disabled_field 'Empenho'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Valor liquidado a ser anulado'
    page.should have_field 'Valor liquidado a ser anulado', :with => '1,00'
    page.should have_disabled_field 'Data *'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Motivo *'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'should not have a button to destroy an existent pledge' do
    PledgeLiquidation.make!(:liquidacao_total)
    PledgeParcelMovimentation.make!(:liquidacao_total)
    pledge_liquidation_cancellation = PledgeLiquidationCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link pledge_liquidation_cancellation.to_s

    page.should_not have_link "Apagar"
  end
end
