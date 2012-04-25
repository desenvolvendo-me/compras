# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessAppeals" do
  background do
    sign_in
  end

  scenario 'create a new licitation_process_appeal' do
    LicitationProcess.make!(:processo_licitatorio)
    Person.make!(:sobrinho)

    click_link 'Processos'

    click_link 'Interposição de Recursos de Processos Licitatórios'

    click_link 'Criar Interposição de Recurso do Processo Licitatório'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
    fill_in 'Data do recurso', :with => I18n.l(Date.new(2012, 3, 20))
    select 'Edital', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho', :field => 'Nome'
    fill_in 'Motivo fundamentado do recurso', :with => 'Interposição de recurso licitatório'
    fill_in 'Parecer da comissão de licitação', :with => 'Parecer da comissão de licitação'
    select 'Pendente', :from => 'Situação'

    click_button 'Salvar'

    page.should have_notice 'Interposição de Recurso do Processo Licitatório criado com sucesso.'

    click_link LicitationProcessAppeal.last.to_s

    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Data do recurso', :with => I18n.l(Date.new(2012, 3, 20))
    page.should have_select 'Referente ao', :selected => 'Edital'
    page.should have_field 'Autor', :with => 'Gabriel Sobrinho'
    page.should have_field 'Objeto do Processo', :with => 'Descricao'
    page.should have_field 'Motivo fundamentado do recurso', :with => 'Interposição de recurso licitatório'
    page.should have_field 'Parecer da comissão de licitação', :with => 'Parecer da comissão de licitação'
    page.should have_select 'Situação', :selected => 'Pendente'
  end

  scenario 'update an existent licitation_process_appeal' do
    interposicao_processo_licitatorio = LicitationProcessAppeal.make!(:interposicao_processo_licitatorio)
    LicitationProcess.make!(:processo_licitatorio_computador)
    Person.make!(:wenderson)

    click_link 'Processos'

    click_link 'Interposição de Recursos de Processos Licitatórios'

    click_link interposicao_processo_licitatorio.to_s

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'
    fill_in 'Data do recurso', :with => I18n.l(Date.new(2013, 3, 20))
    select 'Revogação', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Wenderson Malheiros', :field => 'Nome'
    fill_in 'Motivo fundamentado do recurso', :with => 'Interposição de recurso licitatório do computador'
    fill_in 'Parecer da comissão de licitação', :with => 'Parecer da comissão de licitação - wenderson'
    select 'Deferido', :from => 'Situação'

    click_button 'Salvar'

    page.should have_notice 'Interposição de Recurso do Processo Licitatório editado com sucesso.'

    click_link interposicao_processo_licitatorio.to_s

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Data do recurso', :with => I18n.l(Date.new(2013, 3, 20))
    page.should have_select 'Referente ao', :selected => 'Revogação'
    page.should have_field 'Autor', :with => 'Wenderson Malheiros'
    page.should have_field 'Objeto do Processo', :with => 'Descricao do computador'
    page.should have_field 'Motivo fundamentado do recurso', :with => 'Interposição de recurso licitatório do computador'
    page.should have_field 'Parecer da comissão de licitação', :with => 'Parecer da comissão de licitação - wenderson'
    page.should have_select 'Situação', :selected => 'Deferido'
  end

  scenario 'destroy an existent licitation_process_appeal' do
    interposicao_processo_licitatorio = LicitationProcessAppeal.make!(:interposicao_processo_licitatorio)

    click_link 'Processos'

    click_link 'Interposição de Recursos de Processos Licitatórios'

    click_link "#{interposicao_processo_licitatorio}"

    click_link "Apagar", :confirm => true

    page.should have_notice 'Interposição de Recurso do Processo Licitatório apagado com sucesso.'

    page.should_not have_content '1/2013'
    page.should_not have_content I18n.l(Date.new(2012, 3, 20))
    page.should_not have_content 'Revogação'
    page.should_not have_content 'Wenderson Malheiros'
    page.should_not have_content "#{interposicao_processo_licitatorio}"
  end
end
