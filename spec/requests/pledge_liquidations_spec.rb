# encoding: utf-8
require 'spec_helper'

feature "PledgeLiquidations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_liquidation' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Entidade', :field => 'Nome', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_in 'Valor a ser liquidado', :with => '150,00'
    select 'Parcial', :from => 'Tipo de liquidação'
    fill_in 'Data *', :with => I18n.l(Date.tomorrow)

    click_button 'Salvar'

    page.should have_notice 'Liquidação de Empenho criado com sucesso.'

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
      page.should have_content I18n.l(Date.tomorrow)
      find('.value').should have_content 'R$ 100,00'
      find('.liquidations_value').should have_content 'R$ 100,00'
      find('.balance').should have_content 'R$ 0,00'
    end

    within '#parcel_2' do
      page.should have_content '2'
      page.should have_content I18n.l(Date.current + 2.day)
      find('.value').should have_content 'R$ 100,00'
      find('.liquidations_value').should have_content 'R$ 50,00'
      find('.balance').should have_content 'R$ 50,00'
    end

    page.should have_field 'Valor a ser liquidado', :with => '150,00'
    page.should have_select 'Tipo de liquidação', :selected => 'Parcial'
    page.should have_field 'Data *', :with => I18n.l(Date.tomorrow)
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => 'Descricao'
  end

  scenario 'when fill/clear pledge should fill/clear delegateds fields' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '200,00'
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => 'Descricao'

    within '#parcel_1' do
      page.should have_content '1'
      page.should have_content I18n.l(Date.tomorrow)
      find('.value').should have_content 'R$ 100,00'
      find('.liquidations_value').should have_content 'R$ 0,00'
      find('.balance').should have_content 'R$ 100,00'
    end

    within '#parcel_2' do
      page.should have_content '2'
      page.should have_content I18n.l(Date.current + 2.day)
      find('.value').should have_content 'R$ 100,00'
      find('.liquidations_value').should have_content 'R$ 0,00'
      find('.balance').should have_content 'R$ 100,00'
    end

    clear_modal 'Empenho'

    page.should have_field 'Empenho', :with => ''
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => ''
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => ''
  end

  scenario 'when kind is total should disable and fill value with balance' do
    Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    select 'Total', :from => 'Tipo de liquidação'

    page.should have_disabled_field 'Valor a ser liquidado'
    page.should have_field 'Valor a ser liquidado', :with => '200,00'
  end

  scenario 'should fill value when select pledge_parcel before kind and kind is total' do
    Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    select 'Total', :from => 'Tipo de liquidação'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    page.should have_disabled_field 'Valor a ser liquidado'
    page.should have_field 'Valor a ser liquidado', :with => '200,00'
  end

  scenario 'create a new pledge_liquidation with value when kind is total' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Entidade', :field => 'Nome', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    select 'Total', :from => 'Tipo de liquidação'
    fill_in 'Data *', :with => I18n.l(Date.tomorrow)

    click_button 'Salvar'

    page.should have_notice 'Liquidação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Valor a ser liquidado', :with => '9,99'
    page.should have_select 'Tipo de liquidação', :selected => 'Total'
    page.should have_field 'Data *', :with => I18n.l(Date.tomorrow)
  end

  scenario 'when submit form with same field missing and kind is total should have value disabled field' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    select 'Total', :from => 'Tipo de liquidação'
    fill_in 'Data *', :with => I18n.l(Date.yesterday)

    click_button 'Salvar'

    page.should_not have_notice 'Liquidação de Empenho criado com sucesso.'

    page.should have_disabled_field 'Valor a ser liquidado'
    page.should have_field 'Valor a ser liquidado', :with => '9,99'
    page.should have_select 'Tipo de liquidação', :selected => 'Total'
  end

  scenario 'should have all disabled fields when edit existent pledge_liquidation' do
    pledge = Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link pledge_liquidation.to_s

    should_not have_button 'Criar Liquidação de Empenho'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_disabled_field 'Entidade'
    page.should have_disabled_field 'Exercício'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'

    page.should have_field 'Valor a ser liquidado', :with => '1,00'
    page.should have_select 'Tipo de liquidação', :selected => 'Parcial'
    page.should have_field 'Data *', :with => I18n.l(Date.tomorrow)
  end

  scenario 'should not have a button to destroy an existent pledge_liquidation' do
    Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link pledge_liquidation.to_s

    page.should_not have_link 'Apagar'
  end
end
