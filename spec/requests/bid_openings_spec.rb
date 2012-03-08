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

    fill_in 'Ano', :with => '2012'
    fill_in 'Data do processo', :with => '07/03/2012'
    fill_in 'Número do protocolo', :with => '00099/2012'
    fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
    fill_in 'Valor estimado', :with => '500,50'
    fill_modal 'Dotação utilizada', :with => '2012', :field => 'Exercício'
    select 'Leilão', :from => 'Modalidade'
    select 'Compras e serviços', :from => 'Tipo de objeto'
    fill_modal 'Forma de julgamento', :with => 'Forma Global com Menor Preço', :field => 'Descrição'
    fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    select 'Aguardando', :from => 'Status do processo administrativo'
    fill_in 'Data de liberação', :with => '07/03/2012'

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
    page.should have_select 'Modalidade', :selected => 'Leilão'
    page.should have_select 'Tipo de objeto', :selected => 'Compras e serviços'
    page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
    page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_select 'Status do processo administrativo', :with => 'Aguardando'
    page.should have_field 'Data de liberação', :with => '07/03/2012'
  end

  scenario 'update an existent bid_opening' do
    organogram = Organogram.make!(:secretaria_de_desenvolvimento)
    budget_allocation = BudgetAllocation.make!(:alocacao_extra)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:wenderson)
    BidOpening.make!(:compra_de_cadeiras)

    click_link 'Processos Administrativos'

    click_link 'Aberturas de Licitação'

    within_records do
      page.find('a').click
    end

    fill_in 'Data do processo', :with => '12/12/2011'
    fill_in 'Número do protocolo', :with => '00099/2011'
    fill_modal 'Unidade orçamentária', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
    fill_in 'Valor estimado', :with => '1500,50'
    fill_modal 'Dotação utilizada', :with => '2011', :field => 'Exercício'
    select 'Outras modalidades', :from => 'Modalidade'
    select 'Alienação de bens', :from => 'Tipo de objeto'
    fill_modal 'Forma de julgamento', :with => 'Por Item com Melhor Técnica', :field => 'Descrição'
    fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de cadeiras da Secretaria'
    fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
    select 'Cancelado', :from => 'Status do processo administrativo'
    fill_in 'Data de liberação', :with => '12/12/2011'

    click_button 'Atualizar Abertura de Licitação'

    page.should have_notice 'Abertura de Licitação editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_disabled_field 'Processo'
    page.should have_disabled_field 'Ano'
    page.should have_field 'Data do processo', :with => '12/12/2011'
    page.should have_field 'Número do protocolo', :with => '00099/2011'
    page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Desenvolvimento'
    page.should have_field 'Valor estimado', :with => '1.500,50'
    page.should have_field 'Dotação utilizada', :with => "#{budget_allocation.id}/2011"
    page.should have_select 'Modalidade', :selected => 'Outras modalidades'
    page.should have_select 'Tipo de objeto', :selected => 'Alienação de bens'
    page.should have_field 'Forma de julgamento', :with => 'Por Item com Melhor Técnica'
    page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de cadeiras da Secretaria'
    page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
    page.should have_select 'Status do processo administrativo', :with => 'Cancelado'
    page.should have_field 'Data de liberação', :with => '12/12/2011'
  end

  scenario 'destroy an existent bid_opening' do
    BidOpening.make!(:compra_de_cadeiras)

    click_link 'Processos Administrativos'

    click_link 'Aberturas de Licitação'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar 1/2012', :confirm => true

    page.should have_notice 'Abertura de Licitação apagado com sucesso.'

    page.should_not have_field '2012'
    page.should_not have_field '07/03/2012'
    page.should_not have_field '00099/2012'
    page.should_not have_select 'Leilão'
  end
end
