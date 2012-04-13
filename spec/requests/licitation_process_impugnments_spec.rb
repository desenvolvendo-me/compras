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
    select 'Pendente', :from => 'Situação'
    fill_in 'Data do julgamento', :with => I18n.l(Date.current + 4.days)
    fill_in 'Observação', :with => 'Não há observação'

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
    page.should have_field 'Data do julgamento', :with => I18n.l(Date.current + 4.days)
    page.should have_field 'Observação', :with => 'Não há observação'
    page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    page.should have_field 'Hora da entrega', :with => '14:00'
    page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Hora da abertura', :with => '14:00'
  end

  scenario 'update an existent licitation_process_impugnment' do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link licitation_process_impugnment.id.to_s

    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 1.year + 2.days)
    select 'Pregão', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho', :field => 'Nome'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'
    select 'Pendente', :from => 'Situação'
    fill_in 'Data do julgamento', :with => I18n.l(Date.current + 1.year + 4.days)
    fill_in 'Observação', :with => 'Não há observação'

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
    page.should have_select 'Situação', :selected => 'Pendente'
    page.should have_field 'Data do julgamento', :with => I18n.l(Date.current + 1.year + 4.days)
    page.should have_field 'Observação', :with => 'Não há observação'
    page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    page.should have_field 'Hora da entrega', :with => '14:00'
    page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.current + 1.day)
    page.should have_field 'Hora da abertura', :with => '14:00'
  end

  scenario "update licitation process impugnment new dates should update licitation process date" do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      page.should have_field 'Hora da entrega', :with => '14:00'
      page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Hora da abertura', :with => '14:00'
    end

    click_link 'Processos'

    click_link 'Impugnações do Processo Licitatório'

    click_link licitation_process_impugnment.id.to_s

    fill_in 'Nova data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
    fill_in 'Nova hora da entrega', :with => '16:00'
    fill_in 'Nova data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
    fill_in 'Nova hora da abertura', :with => '16:00'

    click_button 'Atualizar Impugnação do Processo Licitatório'

    page.should have_notice 'Impugnação do Processo Licitatório editado com sucesso.'

    click_link licitation_process_impugnment.to_s

    page.should have_field 'Nova data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Nova hora da entrega', :with => '16:00'
    page.should have_field 'Nova data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
    page.should have_field 'Nova hora da abertura', :with => '16:00'

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Hora da entrega', :with => '16:00'
      page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      page.should have_field 'Hora da abertura', :with => '16:00'
    end
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
