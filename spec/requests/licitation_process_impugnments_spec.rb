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


  scenario 'destroy an existent licitation_process_impugnment' do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)
    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link "#{licitation_process_impugnment.to_s}"
    
    click_link "Apagar #{licitation_process_impugnment.to_s}", :confirm => true

    page.should have_notice 'Impugnação do Processo Licitatório apagado com sucesso.'

    page.should_not have_link "#{licitation_process_impugnment.to_s}"
  end
end
