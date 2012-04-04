# encoding: utf-8
require 'spec_helper'

feature "LicitationCommissions" do
  background do
    sign_in
  end

  scenario 'create a new licitation_commission' do
    RegulatoryAct.make!(:sopa)
    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    select 'Especial', :from => 'Tipo de comissão'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    page.should have_field 'Ato regulamentador', :with => '1234'

    page.should have_disabled_field 'Data da publicação do ato'
    page.should have_field 'Data da publicação do ato', :with => '02/01/2012'

    fill_in 'Data da nomeação', :with => '20/03/2012'
    fill_in 'Data da expiração', :with => '22/03/2012'
    fill_in 'Data da exoneração', :with => '25/03/2012'
    fill_in 'Descrição e finalidade da comissão', :with => 'descrição'

    click_button 'Criar Comissão de Licitação'

    page.should have_notice 'Comissão de Licitação criada com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_select 'Tipo de comissão', :selected => 'Especial'
    page.should have_field 'Data da nomeação', :with => '20/03/2012'
    page.should have_field 'Data da expiração', :with => '22/03/2012'
    page.should have_field 'Data da exoneração', :with => '25/03/2012'
    page.should have_field 'Descrição e finalidade da comissão', :with => 'descrição'
  end

  scenario 'update an existent licitation_commission' do
    RegulatoryAct.make!(:medida_provisoria)
    LicitationCommission.make!(:comissao)

    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    within_records do
      page.find('a').click
    end

    select 'Pregão', :from => 'Tipo de comissão'

    fill_modal 'Ato regulamentador', :with => '8901', :field => 'Número'

    page.should have_field 'Ato regulamentador', :with => '8901'

    page.should have_disabled_field 'Data da publicação do ato'
    page.should have_field 'Data da publicação do ato', :with => '02/01/2013'

    fill_in 'Data da nomeação', :with => '20/03/2013'
    fill_in 'Data da expiração', :with => '22/03/2013'
    fill_in 'Data da exoneração', :with => '25/03/2013'
    fill_in 'Descrição e finalidade da comissão', :with => 'nova descrição'

    click_button 'Atualizar Comissão de Licitação'

    page.should have_notice 'Comissão de Licitação editada com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_select 'Tipo de comissão', :selected => 'Pregão'
    page.should have_field 'Data da nomeação', :with => '20/03/2013'
    page.should have_field 'Data da expiração', :with => '22/03/2013'
    page.should have_field 'Data da exoneração', :with => '25/03/2013'
    page.should have_field 'Descrição e finalidade da comissão', :with => 'nova descrição'
  end

  scenario 'destroy an existent licitation_commission' do
    licitation_commission = LicitationCommission.make!(:comissao)
    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Comissão de Licitação apagada com sucesso.'

    page.should_not have_link "#{licitation_commission.id}"
  end
end
