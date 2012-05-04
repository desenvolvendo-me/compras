# encoding: utf-8
require 'spec_helper'

feature "PledgeLiquidations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_liquidation' do
    pledge = Pledge.make!(:empenho)
    entity = pledge.entity

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Entidade', :field => 'Nome', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_modal 'Parcela', :with => '1', :field => 'Número'
    fill_in 'Valor *', :with => '1,00'
    select 'Parcial', :from => 'Tipo de liquidação'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)

    click_button 'Salvar'

    page.should have_notice 'Liquidação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Entidade', :with => "#{entity}"
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
    page.should have_field 'Saldo', :with => '8,99'

    page.should have_field 'Valor *', :with => '1,00'
    page.should have_select 'Tipo de liquidação', :selected => 'Parcial'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => 'Descricao'
  end

  scenario 'when fill pledge and pledge_parcel should fill delegateds fields' do
    pledge = Pledge.make!(:empenho)
    entity = pledge.entity

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Entidade', :field => 'Nome', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => 'Descricao'

    clear_modal 'Empenho'
    
    page.should have_field 'Entidade', :with => "#{entity}"
    page.should have_field 'Exercício', :with => '2012'
    fill_modal 'Parcela', :with => '1', :field => 'Número'
    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Saldo'
    page.should have_field 'Saldo', :with => '9,99'

    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => 'Descricao'
  end

  scenario 'clear pledge and pledge_parcel when clear pledge' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Entidade', :field => 'Nome', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
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
    page.should have_disabled_field 'Objeto do empenho'
    page.should have_field 'Objeto do empenho', :with => ''
  end

  scenario 'when kind is total should disable and fill value' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    select 'Total', :from => 'Tipo de liquidação'

    page.should have_disabled_field 'Valor *'
    page.should have_field 'Valor *', :with => '100,00'
  end

  scenario 'should fill value when select pledge_parcel before kind and kind is total' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    select 'Total', :from => 'Tipo de liquidação'
    fill_modal 'Parcela', :with => '1', :field => 'Número'

    page.should have_disabled_field 'Valor *'
    page.should have_field 'Valor *', :with => '100,00'
  end

  scenario 'when select pledge_parcel first fill pledge' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

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

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    fill_modal 'Parcela', :with => '1', :field => 'Número' do
      page.should have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => "#{pledge.id}"
    end
  end

  scenario 'when select pledge first and clear it should clear filter by pledge on pledge_parcel modal' do
    pledge = Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenho'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    clear_modal 'Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número' do
      page.should_not have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => ''
    end
  end

  context 'should have modal link' do
    scenario 'when already have stored' do
      pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

      click_link 'Contabilidade'

      click_link 'Liquidações de Empenho'

      click_link "#{pledge_liquidation.id}"

      click_link 'Mais informações'

      page.should have_content 'Informações de: 1'
    end

    scenario 'when change pledge_parcel' do
      Pledge.make!(:empenho_com_dois_vencimentos)

      click_link 'Contabilidade'

      click_link 'Liquidações de Empenho'

      click_link 'Criar Liquidação de Empenho'

      fill_modal 'Parcela', :with => '1', :field => 'Número'
      click_link 'Mais informações'
      page.should have_content 'Informações de: 1'

      fill_modal 'Parcela', :with => '2', :field => 'Número'
      click_link 'Mais informações'
      page.should have_content 'Informações de: 2'
    end
  end

  scenario 'create a new pledge_liquidation with value when kind is total' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Entidade', :field => 'Nome', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Parcela', :with => '1', :field => 'Número'
    select 'Total', :from => 'Tipo de liquidação'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)

    click_button 'Salvar'

    page.should have_notice 'Liquidação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Valor *', :with => '9,99'
    page.should have_select 'Tipo de liquidação', :selected => 'Total'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
  end

  scenario 'when submit form with same field missing and kind is total should have value disabled field' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link 'Criar Liquidação de Empenho'

    fill_modal 'Parcela', :with => '1', :field => 'Número'
    select 'Total', :from => 'Tipo de liquidação'
    fill_in 'Data *', :with => I18n.l(Date.current - 1.day)

    click_button 'Salvar'

    page.should_not have_notice 'Liquidação de Empenho criado com sucesso.'

    page.should have_disabled_field 'Valor *'
    page.should have_field 'Valor *', :with => '9,99'
    page.should have_select 'Tipo de liquidação', :selected => 'Total'
  end

  scenario 'should have all disabled fields when edit existent pledge_liquidation' do
    pledge = Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link "#{pledge_liquidation.id}"

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

    page.should have_field 'Parcela', :with => '1'
    page.should have_disabled_field 'Vencimento'
    page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Saldo'
    page.should have_field 'Saldo', :with => '8,99'

    page.should have_field 'Valor *', :with => '1,00'
    page.should have_select 'Tipo de liquidação', :selected => 'Parcial'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
  end

  scenario 'should not have a button to destroy an existent pledge_liquidation' do
    pledge = Pledge.make!(:empenho)
    pledge_liquidation = PledgeLiquidation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Liquidações de Empenhos'

    click_link "#{pledge_liquidation.id}"

    page.should_not have_link 'Apagar'
  end
end
