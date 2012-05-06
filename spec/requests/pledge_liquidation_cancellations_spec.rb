# encoding: utf-8
require 'spec_helper'

feature "PledgeLiquidationCancellations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_liquidation_cancellation' do
    pledge = Pledge.make!(:empenho)
    PledgeLiquidation.make!(:liquidacao_parcial)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_modal 'Parcela', :with => '1', :field => 'Número'
    fill_in 'Valor a ser anulado', :with => '1,00'
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
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'

    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Saldo'
    page.should have_field 'Saldo', :with => '9,99'

    page.should have_field 'Valor a ser anulado', :with => '1,00'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'when fill pledge and pledge_parcel should fill delegateds fields' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Saldo'
    page.should have_field 'Saldo', :with => '9,99'
  end

  scenario 'clear pledge and pledge_parcel when clear pledge' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Saldo', :with => '9,99'

    clear_modal 'Empenho'
    page.should have_field 'Empenho', :with => ''
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => ''

    page.should have_field 'Parcela', :with => ''
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => ''
    page.should have_disabled_field 'Saldo'
    page.should have_field 'Saldo', :with => ''
  end

  scenario 'when select total as kind should disabled and fill value' do
    Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    select 'Total', :from => 'Tipo de anulação'

    page.should have_disabled_field 'Valor a ser anulado'
    page.should have_field 'Valor a ser anulado', :with => '100,00'
  end

  scenario 'when submit form with same wrong validation and kind is total should have value as disabled field' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    select 'Total', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.current - 1.day)

    click_button 'Salvar'

    page.should_not have_notice 'Anulação de Liquidação de Empenho criado com sucesso.'

    page.should have_disabled_field 'Valor a ser anulado'
    page.should have_field 'Valor a ser anulado', :with => '9,99'
    page.should have_select 'Tipo de anulação', :selected => 'Total'
  end

  scenario 'should fill value when select pledge_parcel before kind and kind is total' do
    Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    select 'Total', :from => 'Tipo de anulação'
    fill_modal 'Parcela', :with => '1', :field => 'Número'

    page.should have_disabled_field 'Valor a ser anulado'
    page.should have_field 'Valor a ser anulado', :with => '100,00'
  end

  scenario 'create a new pledge_liquidation_cancellation with total as kind' do
    Pledge.make!(:empenho)
    PledgeLiquidation.make!(:liquidacao_total)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Parcela', :with => '1', :field => 'Número'
    select 'Total', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.current + 2.day)
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Valor a ser anulado', :with => '9,99'
  end

  scenario 'when select pledge_parcel first fill pledge' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Saldo', :with => '9,99'

    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_field 'Valor do empenho', :with => '9,99'
  end

  scenario 'when select pledge first should filter pledge_parcel by pledge_id' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    fill_modal 'Parcela', :with => '1', :field => 'Número' do
      page.should have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => "#{pledge.id}"
    end
  end

  scenario 'when select pledge first and clear it should clear filter by pledge on pledge_parcel modal' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link 'Criar Anulação de Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    clear_modal 'Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número' do
      page.should_not have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => ''
    end
  end

  context 'should have modal link' do
    scenario 'when already have stored' do
      PledgeLiquidation.make!(:liquidacao_parcial)
      pledge_liquidation_cancellation = PledgeLiquidationCancellation.make!(:empenho_2012)

      click_link 'Contabilidade'

      click_link 'Anulações de Liquidações de Empenho'

      click_link pledge_liquidation_cancellation.to_s

      click_link 'Mais informações'

      page.should have_content 'Informações de: 1'
    end

    scenario 'when change pledge_parcel' do
      Pledge.make!(:empenho_com_dois_vencimentos)

      click_link 'Contabilidade'

      click_link 'Anulações de Liquidações de Empenho'

      click_link 'Criar Anulação de Liquidação de Empenho'

      fill_modal 'Parcela', :with => '1', :field => 'Número'
      click_link 'Mais informações'
      page.should have_content 'Informações de: 1'

      fill_modal 'Parcela', :with => '2', :field => 'Número'
      click_link 'Mais informações'
      page.should have_content 'Informações de: 2'
    end
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    pledge = Pledge.make!(:empenho)
    PledgeLiquidation.make!(:liquidacao_parcial)
    pledge_liquidation_cancellation = PledgeLiquidationCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link pledge_liquidation_cancellation.to_s

    should_not have_button 'Criar Anulação de Liquidação de Empenho'

    page.should have_disabled_field 'Empenho'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Parcela'
    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Valor a ser anulado'
    page.should have_field 'Valor a ser anulado', :with => '1,00'
    page.should have_disabled_field 'Tipo de anulação'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
    page.should have_disabled_field 'Data *'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Motivo *'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'should not have a button to destroy an existent pledge' do
    PledgeLiquidation.make!(:liquidacao_parcial)
    pledge_liquidation_cancellation = PledgeLiquidationCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Liquidações de Empenho'

    click_link pledge_liquidation_cancellation.to_s

    page.should_not have_link "Apagar"
  end
end
