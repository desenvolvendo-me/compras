# encoding: utf-8
require 'spec_helper'

feature "BidOpenings" do
  background do
    sign_in
  end

  scenario 'create a new bid_opening' do
    organogram = Organogram.make!(:secretaria_de_educacao)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    JudgmentForm.make!(:global_com_menor_preco)
    Employee.make!(:sobrinho)

    click_link 'Processos Administrativos'

    click_link 'Aberturas de Licitação'

    click_link 'Criar Abertura de Licitação'

    page.should have_disabled_field 'Status do processo administrativo'
    page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'

    fill_in 'Ano', :with => '2012'
    fill_in 'Data do processo', :with => '07/03/2012'
    fill_in 'Número do protocolo', :with => '00099/2012'
    fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
    fill_in 'Valor estimado', :with => '500,50'
    fill_modal 'Dotação utilizada', :with => '2012', :field => 'Exercício'
    select 'Compras e serviços', :from => 'Tipo de objeto'
    select 'Pregão presencial', :from => 'Modalidade'
    fill_modal 'Forma de julgamento', :with => 'Forma Global com Menor Preço', :field => 'Descrição'
    fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    select 'Aguardando', :from => 'Status do processo administrativo'

    click_button 'Criar Abertura de Licitação'

    page.should have_notice 'Abertura de Licitação criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_disabled_field 'Processo'
    page.should have_field 'Process', :with => '1'
    page.should have_disabled_field 'Ano'
    page.should have_field 'Ano', :with => '2012'
    page.should have_field 'Data do processo', :with => '07/03/2012'
    page.should have_field 'Número do protocolo', :with => '00099/2012'
    page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
    page.should have_field 'Valor estimado', :with => '500,50'
    page.should have_field 'Dotação utilizada', :with => "#{budget_allocation.id}/2012"
    page.should have_select 'Tipo de objeto', :selected => 'Compras e serviços'
    page.should have_select 'Modalidade', :selected => 'Pregão presencial'
    page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
    page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'
    page.should have_disabled_field 'Data de liberação'
  end

  scenario 'should have all fields disabled when editing an existent bid_opening' do
    BidOpening.make!(:compra_de_cadeiras)

    click_link 'Processos Administrativos'

    click_link 'Aberturas de Licitação'

    within_records do
      page.find('a').click
    end

    page.should have_disabled_field 'Processo'
    page.should have_disabled_field 'Ano'
    page.should have_disabled_field 'Data do processo'
    page.should have_disabled_field 'Número do protocolo'
    page.should have_disabled_field 'Unidade orçamentária'
    page.should have_disabled_field 'Valor estimado'
    page.should have_disabled_field 'Dotação utilizada'
    page.should have_disabled_field 'Tipo de objeto'
    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Forma de julgamento'
    page.should have_disabled_field 'Objeto do processo licitatório'
    page.should have_disabled_field 'Responsável'
    page.should have_disabled_field 'Status do processo administrativo'
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    bid_opening = BidOpening.make!(:compra_de_cadeiras)

    click_link 'Processos Administrativos'

    click_link 'Aberturas de Licitação'

    within_records do
      page.find('a').click
    end

    click_link 'Imprimir'

    page.should have_content "Número: #{bid_opening}"
    page.should have_content "Protocolo número: 00099/2012"
    page.should have_content "Data da solicitação: 07/03/2012"
    page.should have_content "Excelentíssimo Sr. Márcio Lacerda"
    page.should have_content "Unidade orçamentária: 02.00 - Secretaria de Educação"
    page.should have_content "Valor estimado: 500,00"
    page.should have_content "Dotação utilizada: #{budget_allocation}"
    page.should have_content "Modalidade: Pregão presencial"
    page.should have_content "Tipo de objeto: Compras e serviços"
    page.should have_content "Forma de julgamento: Forma Global com Menor Preço"
    page.should have_content "Descrição do objeto: Licitação para compra de carteiras"
    page.should have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
  end
end
