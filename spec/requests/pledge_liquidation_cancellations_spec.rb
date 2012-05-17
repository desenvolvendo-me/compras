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

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_in 'Valor liquidado a ser anulado', :with => '90,00'
    select 'Parcial', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Salvar'

    page.should have_notice 'Anulação de Liquidação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '200,00'

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

    page.should have_field 'Valor liquidado a ser anulado', :with => '90,00'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
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
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '200,00'

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

    clear_modal 'Empenho'
    page.should have_field 'Empenho', :with => ''
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => ''

    within '#pledge_parcels' do
      page.should_not have_content '1'
      page.should_not have_content I18n.l(Date.current + 1.day)
      page.should_not have_content 'R$ 100,00'
      page.should_not have_content 'R$ 90,00'
      page.should_not have_content 'R$ 0,00'
    end
  end

  scenario 'when select total as kind should disabled and fill value' do
    Pledge.make!(:empenho)
    PledgeParcelMovimentation.make!(:liquidacao_parcial)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    select 'Total', :from => 'Tipo de anulação'

    page.should have_disabled_field 'Valor liquidado a ser anulado'
    page.should have_field 'Valor liquidado a ser anulado', :with => '1,00'
  end

  scenario 'when submit form with same wrong validation and kind is total should have value as disabled field' do
    Pledge.make!(:empenho)
    PledgeParcelMovimentation.make!(:liquidacao_parcial)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    select 'Total', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.yesterday)

    click_button 'Salvar'

    page.should_not have_notice 'Anulação de Liquidação de Empenho criado com sucesso.'

    page.should have_disabled_field 'Valor liquidado a ser anulado'
    page.should have_field 'Valor liquidado a ser anulado', :with => '1,00'
    page.should have_select 'Tipo de anulação', :selected => 'Total'
  end

  scenario 'should fill value when select pledge before kind and kind is total' do
    Pledge.make!(:empenho)
    PledgeParcelMovimentation.make!(:liquidacao_parcial)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    select 'Total', :from => 'Tipo de anulação'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    page.should have_disabled_field 'Valor liquidado a ser anulado'
    page.should have_field 'Valor liquidado a ser anulado', :with => '1,00'
  end

  scenario 'create a new pledge_liquidation_cancellation with total as kind' do
    Pledge.make!(:empenho)
    PledgeParcelMovimentation.make!(:liquidacao_parcial)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    select 'Total', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.current + 2.day)
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Valor liquidado a ser anulado', :with => '1,00'
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
    page.should have_disabled_field 'Tipo de anulação'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
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
