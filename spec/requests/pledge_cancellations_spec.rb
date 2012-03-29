# encoding: utf-8
require 'spec_helper'

feature "PledgeCancellations" do
  background do
    Pledge.destroy_all
    PledgeExpiration.destroy_all
    sign_in
  end

  scenario 'create a new pledge_cancellation' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    page.should have_disabled_field 'Data de emissão'
    page.should have_disabled_field 'Valor'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_modal 'Parcela', :with => '1', :field => 'Número'
    fill_in 'Valor anulado', :with => '1,00'
    select 'Parcial', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)
    select 'Normal', :from => 'Natureza da ocorrência'
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Criar Anulação de Empenho'

    page.should have_notice 'Anulação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'

    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => '30/03/2012'
    page.should have_disabled_field 'Valor do vencimento'
    page.should have_field 'Valor do vencimento', :with => '9,99'

    page.should have_field 'Valor anulado', :with => '1,00'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Valor do vencimento', :with => '9,99'
    page.should have_select 'Natureza da ocorrência', :selected => 'Normal'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'when fill pledge and pledge_expiration should fill delegateds fields' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => '30/03/2012'
    page.should have_disabled_field 'Valor do vencimento'
    page.should have_field 'Valor do vencimento', :with => '9,99'
  end

  scenario 'when select total as kind should disabled and fill value_canceled' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    select 'Total', :from => 'Tipo de anulação'

    page.should have_disabled_field 'Valor anulado'
    page.should have_field 'Valor anulado', :with => '9,99'
  end

  scenario 'should fill value_canceled when select pledge_expiration before kind and kind is total' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    select 'Total', :from => 'Tipo de anulação'
    fill_modal 'Parcela', :with => '1', :field => 'Número'

    page.should have_disabled_field 'Valor anulado'
    page.should have_field 'Valor anulado', :with => '9,99'
  end

  scenario 'when select pledge_expiration first fill pledge' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_field 'Vencimento', :with => '30/03/2012'
    page.should have_field 'Valor do vencimento', :with => '9,99'

    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_field 'Valor do empenho', :with => '9,99'
  end

  scenario 'when select pledge first should filter pledge_expiration by pledge_id' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    fill_modal 'Parcela', :with => '1', :field => 'Número' do
      page.should have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => "#{pledge.id}"
    end
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    pledge = Pledge.make!(:empenho)
    PledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    within_records do
      page.find('a').click
    end

    should_not have_button 'Criar Anulação de Empenho'

    page.should have_disabled_field 'Empenho'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_disabled_field 'Parcela'
    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Valor do vencimento'
    page.should have_field 'Valor do vencimento', :with => '9,99'
    page.should have_disabled_field 'Valor anulado'
    page.should have_field 'Valor anulado', :with => '1,00'
    page.should have_disabled_field 'Tipo de anulação'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
    page.should have_disabled_field 'Data *'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Natureza da ocorrência'
    page.should have_select 'Natureza da ocorrência', :selected => 'Normal'
    page.should have_disabled_field 'Motivo'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'should not have a button to destroy an existent pledge' do
    pledge_cancellation = PledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    within_records do
      page.find('a').click
    end

    page.should_not have_link "Apagar #{pledge_cancellation.id}"
  end
end
