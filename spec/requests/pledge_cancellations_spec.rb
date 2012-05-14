# encoding: utf-8
require 'spec_helper'

feature "PledgeCancellations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_cancellation' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Ano', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_in 'Valor a ser anulado', :with => '150,00'
    select 'Parcial', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)
    select 'Normal', :from => 'Natureza da ocorrência'
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Salvar'

    page.should have_notice 'Anulação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Ano', :with => '2012'

    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '200,00'

    within '#parcel_1' do
      page.should have_content '1'
      page.should have_content I18n.l(Date.current + 1.day)
      find('.value').should have_content 'R$ 100,00'
      find('.canceled_value').should have_content 'R$ 100,00'
      find('.balance').should have_content 'R$ 0,00'
    end

    within '#parcel_2' do
      page.should have_content '2'
      page.should have_content I18n.l(Date.current + 2.day)
      find('.value').should have_content 'R$ 100,00'
      find('.canceled_value').should have_content 'R$ 50,00'
      find('.balance').should have_content 'R$ 50,00'
    end

    page.should have_field 'Valor a ser anulado', :with => '150,00'
    page.should have_select 'Tipo de anulação', :selected => 'Parcial'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_select 'Natureza da ocorrência', :selected => 'Normal'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'when fill/clear pledge should fill/clear delegateds fields' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'

    within '#parcel_1' do
      page.should have_content '1'
      page.should have_content I18n.l(Date.current + 1.day)
      find('.value').should have_content 'R$ 9,99'
      find('.canceled_value').should have_content 'R$ 0,00'
      find('.balance').should have_content 'R$ 9,99'
    end

    clear_modal 'Empenho'
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => ''

    within '#pledge_parcels' do
      page.should_not have_content '1'
      page.should_not have_content I18n.l(Date.current + 1.day)
      page.should_not have_content 'R$ 9,99'
      page.should_not have_content 'R$ 0,00'
      page.should_not have_content 'R$ 9,99'
    end
  end

  scenario 'when select total as kind should fill value with balance' do
    Pledge.make!(:empenho)
    PledgeCancellation.make!(:empenho_2012)
    PledgeParcelMovimentation.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    select 'Total', :from => 'Tipo de anulação'

    page.should have_disabled_field 'Valor a ser anulado'
    page.should have_field 'Valor a ser anulado', :with => '8,99'
  end

  scenario 'should fill value when select pledge before kind and kind is total' do
    Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    select 'Total', :from => 'Tipo de anulação'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    page.should have_disabled_field 'Valor a ser anulado'
    page.should have_field 'Valor a ser anulado', :with => '200,00'
  end

  scenario 'should store value when kind is total' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Ano', :with => '2012'
    fill_in 'Valor a ser anulado', :with => '1,00'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    select 'Total', :from => 'Tipo de anulação'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)
    select 'Normal', :from => 'Natureza da ocorrência'
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Valor a ser anulado', :with => '9,99'
    page.should have_select 'Tipo de anulação', :selected => 'Total'
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
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_disabled_field 'Valor a ser anulado'
    page.should have_field 'Valor a ser anulado', :with => '1,00'
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
    PledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Empenho'

    within_records do
      page.find('a').click
    end

    page.should_not have_link "Apagar"
  end
end
