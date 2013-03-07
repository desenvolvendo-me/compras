# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessAppeals" do
  background do
    sign_in
  end

  scenario 'create a new licitation_process_appeal' do
    LicitationProcess.make!(:processo_licitatorio)
    Person.make!(:sobrinho)

    navigate 'Processos de Compra > Interposição de Recursos de Processos Licitatórios'

    click_link 'Criar Interposição de Recurso do Processo de Compra'

    fill_modal 'Processo de compra', :with => '2012', :field => 'Ano'
    fill_in 'Data do recurso', :with => I18n.l(Date.new(2012, 3, 20))
    select 'Edital', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho'
    fill_in 'Motivo fundamentado do recurso', :with => 'Interposição de recurso licitatório'
    fill_in 'Nova data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    fill_in 'Nova hora da abertura dos envelopes', :with => '15:30'
    fill_in 'Parecer da comissão de licitação', :with => 'Parecer da comissão de licitação'
    select 'Pendente', :from => 'Situação'

    click_button 'Salvar'

    expect(page).to have_notice 'Interposição de Recurso do Processo de Compra criada com sucesso.'

    within_records do
      click_link '1/2012 - 20/03/2012'
    end

    expect(page).to have_field 'Processo de compra', :with => '1/2012'
    expect(page).to have_field 'Data do recurso', :with => I18n.l(Date.new(2012, 3, 20))
    expect(page).to have_select 'Referente ao', :selected => 'Edital'
    expect(page).to have_field 'Autor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Objeto do Processo', :with => 'Licitação para compra de carteiras'
    expect(page).to have_field 'Nova data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Nova hora da abertura dos envelopes', :with => '15:30'
    expect(page).to have_field 'Motivo fundamentado do recurso', :with => 'Interposição de recurso licitatório'
    expect(page).to have_field 'Parecer da comissão de licitação', :with => 'Parecer da comissão de licitação'
    expect(page).to have_select 'Situação', :selected => 'Pendente'
  end

  scenario 'update an existent licitation_process_appeal' do
    LicitationProcessAppeal.make!(:interposicao_processo_licitatorio)
    LicitationProcess.make!(:processo_licitatorio_computador)
    Person.make!(:wenderson)

    navigate 'Processos de Compra > Interposição de Recursos de Processos Licitatórios'

    within_records do
      click_link '1/2012 - 10/04/2012'
    end

    fill_modal 'Processo de compra', :with => '2013', :field => 'Ano'
    fill_in 'Data do recurso', :with => I18n.l(Date.new(2013, 3, 20))
    select 'Revogação', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Wenderson Malheiros'
    fill_in 'Motivo fundamentado do recurso', :with => 'Interposição de recurso licitatório do computador'
    fill_in 'Nova data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 2)
    fill_in 'Nova hora da abertura dos envelopes', :with => '16:00'
    fill_in 'Parecer da comissão de licitação', :with => 'Parecer da comissão de licitação - wenderson'
    select 'Deferido', :from => 'Situação'

    click_button 'Salvar'

    expect(page).to have_notice 'Interposição de Recurso do Processo de Compra editada com sucesso.'

    within_records do
      click_link '2/2013 - 20/03/2013'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013'
    expect(page).to have_field 'Data do recurso', :with => I18n.l(Date.new(2013, 3, 20))
    expect(page).to have_select 'Referente ao', :selected => 'Revogação'
    expect(page).to have_field 'Autor', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Objeto do Processo', :with => 'Licitação para compra de carteiras'
    expect(page).to have_field 'Nova data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 2)
    expect(page).to have_field 'Nova hora da abertura dos envelopes', :with => '16:00'
    expect(page).to have_field 'Motivo fundamentado do recurso', :with => 'Interposição de recurso licitatório do computador'
    expect(page).to have_field 'Parecer da comissão de licitação', :with => 'Parecer da comissão de licitação - wenderson'
    expect(page).to have_select 'Situação', :selected => 'Deferido'
  end

  scenario 'destroy an existent licitation_process_appeal' do
    LicitationProcessAppeal.make!(:interposicao_processo_licitatorio)

    navigate 'Processos de Compra > Interposição de Recursos de Processos Licitatórios'

    within_records do
      click_link '1/2012 - 10/04/2012'
    end

    click_link "Apagar"

    expect(page).to have_notice 'Interposição de Recurso do Processo de Compra apagada com sucesso.'

    within_records do
      expect(page).to_not have_link '1/2012 - 10/04/2012'
    end
  end
end
