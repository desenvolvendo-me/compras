# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessImpugnments" do
  background do
    sign_in
  end

  scenario 'create a new licitation_process_impugnment' do
    LicitationProcess.make!(:processo_licitatorio)
    Person.make!(:sobrinho)

    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link 'Criar Impugnação do Processo Licitatório'

    page.should have_select 'Situação', :selected => 'Pendente'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 2.days)
    select 'Pregão', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho', :field => 'Nome'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'

    page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    page.should have_field 'Hora da entrega', :with => '14:00'
    page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Hora da abertura', :with => '14:00'

    click_button 'Criar Impugnação do Processo Licitatório'
    page.should have_notice 'Impugnação do Processo Licitatório criado com sucesso.'
    click_link LicitationProcessImpugnment.last.to_s

    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Data da impugnação', :with => I18n.l(Date.current + 2.days)
    page.should have_select 'Referente ao', :selected => 'Pregão'
    page.should have_field 'Autor', :with => 'Gabriel Sobrinho'
    page.should have_field 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'
    page.should have_select 'Situação', :selected => 'Pendente'
    page.should have_disabled_field 'Data do julgamento', :with => ''
    page.should have_disabled_field 'Observação', :with => ''
    page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    page.should have_field 'Hora da entrega', :with => '14:00'
    page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Hora da abertura', :with => '14:00'
  end

  scenario 'update an existent licitation_process_impugnment' do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link licitation_process_impugnment.to_s

    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 1.year + 2.days)
    select 'Pregão', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho', :field => 'Nome'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'

    page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    page.should have_field 'Hora da entrega', :with => '14:00'
    page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Hora da abertura', :with => '14:00'

    click_button 'Atualizar Impugnação do Processo Licitatório'

    page.should have_notice 'Impugnação do Processo Licitatório editado com sucesso.'

    click_link licitation_process_impugnment.to_s

    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Data da impugnação', :with => I18n.l(Date.current + 1.year + 2.days)
    page.should have_select 'Referente ao', :selected => 'Pregão'
    page.should have_field 'Autor', :with => 'Gabriel Sobrinho'
    page.should have_field 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'
    page.should have_disabled_field 'Data do julgamento', :with => ''
    page.should have_disabled_field 'Observação', :with => ''
    page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    page.should have_field 'Hora da entrega', :with => '14:00'
    page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Hora da abertura', :with => '14:00'
  end

  scenario 'should have fields disabled when situation is not pending' do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras_deferida)

    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link licitation_process_impugnment.to_s

    page.should have_disabled_field 'Processo licitatório'
    page.should have_disabled_field 'Data da impugnação'
    page.should have_disabled_field 'Referente ao'
    page.should have_disabled_field 'Autor'
    page.should have_disabled_field 'Motivo fundamentado da impugnação'
    page.should have_disabled_field 'Data do julgamento'
    page.should have_disabled_field 'Observação'
    page.should have_disabled_field 'Data da entrega dos envelopes'
    page.should have_disabled_field 'Hora da entrega'
    page.should have_disabled_field 'Data da abertura dos envelopes'
    page.should have_disabled_field 'Hora da abertura'

    page.should_not have_button 'Atualizar Impugnação do Processo Licitatório'
    page.should_not have_button 'Cancelar'
  end

  scenario 'destroy an existent licitation_process_impugnment' do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)
    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link "#{licitation_process_impugnment.to_s}"

    page.should_not have_link "Apagar #{licitation_process_impugnment.to_s}"
  end

  scenario 'envelope dates should be filled when licitation process selected' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link 'Criar Impugnação do Processo Licitatório'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

    page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(licitation_process.envelope_delivery_date)
    page.should have_field 'Hora da entrega', :with => licitation_process.presenter.envelope_delivery_time
    page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(licitation_process.envelope_opening_date)
    page.should have_field 'Hora da abertura', :with => licitation_process.presenter.envelope_opening_time
  end

  scenario 'envelope dates should be empty when clear licitaion process' do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link licitation_process_impugnment.to_s

    clear_modal 'Processo licitatório'

    page.should have_field 'Data da entrega dos envelopes', :with => ''
    page.should have_field 'Hora da entrega', :with => ''
    page.should have_field 'Data da abertura dos envelopes', :with => ''
    page.should have_field 'Hora da abertura', :with => ''
  end
end
