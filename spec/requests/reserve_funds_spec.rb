# encoding: utf-8
require 'spec_helper'

feature "ReserveFunds" do
  background do
    sign_in
  end

  scenario 'create a new reserve_fund' do
    Descriptor.make!(:detran_2012)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    ReserveAllocationType.make!(:licitation)
    LicitationModality.make!(:publica)
    Creditor.make!(:wenderson_sa)
    LicitationProcess.make!(:processo_licitatorio)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'

    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Reservado'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'
    fill_in 'Data', :with => '22/02/2012'
    fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

    page.should have_field 'Valor reservado', :with => '10,50'

    fill_in 'Valor *', :with => '10,00'
    fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
    within_modal 'Favorecido' do
      fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end
    fill_in 'Motivo', :with => 'Motivo para reserva de dotação'

    click_button 'Salvar'

    page.should have_notice 'Reserva de Dotação criado com sucesso.'

    click_link '2012'

    page.should have_field 'Descritor', :with => '2012 - Detran'
    page.should have_field 'Tipo', :with => 'Licitação'
    page.should have_field 'Data', :with => '22/02/2012'
    page.should have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
    page.should have_field 'Valor reservado', :with => '20,50'
    page.should have_field 'Valor *', :with => '10,00'
    page.should have_field 'Modalidade', :with => 'Pública'
    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Processo administrativo', :with => '1/2012'
    page.should have_field 'Favorecido', :with => 'Wenderson Malheiros'
    page.should have_field 'Motivo', :with => 'Motivo para reserva de dotação'
  end

  scenario 'should have all fields disabled when editing an existent reserve fund' do
    ReserveFund.make!(:detran_2012)
    budget_allocation = BudgetAllocation.make!(:alocacao)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link '2012'

    should_not have_button 'Salvar'

    page.should have_disabled_field 'Descritor'
    page.should have_field 'Descritor', :with => '2012 - Detran'
    page.should have_disabled_field 'Tipo'
    page.should have_field 'Tipo', :with => 'Licitação'
    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => '22/02/2012'
    page.should have_disabled_field 'Dotação orçamentaria'
    page.should have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
    page.should have_disabled_field 'Valor *'
    page.should have_field 'Valor *', :with => '10,50'
    page.should have_disabled_field 'Modalidade'
    page.should have_field 'Modalidade', :with => 'Pública'
    page.should have_disabled_field 'Processo licitatório'
    page.should have_disabled_field 'Processo administrativo'
    page.should have_disabled_field 'Favorecido'
    page.should have_field 'Favorecido', :with => 'Wenderson Malheiros'
    page.should have_disabled_field 'Motivo'
    page.should have_field 'Motivo', :with => 'Motivo para a reserva de dotação'
  end

  scenario 'should not have link to destroy an existent reserve_fund' do
    ReserveFund.make!(:detran_2012)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link '2012'

    page.should_not have_link 'Apagar'
  end

  scenario 'getting and cleaning budget_allocation amount via javascript' do
    BudgetAllocation.make!(:alocacao)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    page.should have_disabled_field 'Saldo orçamentário'

    fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

    page.should have_disabled_field 'Saldo orçamentário'
    page.should have_field 'Saldo orçamentário', :with => '500,00'

    clear_modal 'Dotação orçamentaria'

    page.should have_disabled_field 'Saldo orçamentário'
    page.should have_field 'Saldo orçamentário', :with => ''
  end

  scenario 'show modal info of budget allocation' do
    BudgetAllocation.make!(:alocacao)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

    click_link 'reserve_fund_budget_allocation_info_link'

    within '#record' do
      page.should have_content 'Detran'
      page.should have_content '2012'
      page.should have_content 'Alocação'
      page.should have_content '1 - Secretaria de Educação'
      page.should have_content '01 - Administração Geral'
      page.should have_content 'Habitação'
      page.should have_content '500,00'
      page.should have_content 'Ação Governamental'
      page.should have_content '3.0.10.01.12'
      page.should have_content 'Reforma e Ampliação'
      page.should have_content 'Manutenção da Unidade Administrativa'
      page.should have_content 'Nenhuma'
      page.should have_content 'Dotação Administrativa'
    end
  end

  scenario 'enable/disable licitation and licitation modality fields depending on type' do
    ReserveAllocationType.make!(:licitation)
    ReserveAllocationType.make!(:comum)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Processo licitatório'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'

    page.should_not have_disabled_field 'Modalidade'
    page.should_not have_disabled_field 'Processo licitatório'

    clear_modal 'Tipo'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Processo licitatório'

    fill_modal 'Tipo', :with => 'Tipo Comum', :field => 'Descrição'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Processo licitatório'
  end

  scenario 'should clean licitation modality and licitation number/year when changing type to diferent of licitation' do
    ReserveAllocationType.make!(:licitation)
    ReserveAllocationType.make!(:comum)
    LicitationModality.make!(:publica)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'
    fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'

    page.should have_field 'Modalidade', :with => 'Pública'

    fill_modal 'Tipo', :with => 'Tipo Comum', :field => 'Descrição'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Modalidade'
  end

  scenario 'should fill/clear delegate liciation_process fields' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate_through 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Processo administrativo', :with => '1/2012'

    clear_modal 'Processo licitatório'

    page.should have_field 'Processo administrativo', :with => ''
  end
end
