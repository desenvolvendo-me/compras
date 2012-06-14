# encoding: utf-8
require 'spec_helper'

feature "ReserveFunds" do
  background do
    sign_in
  end

  scenario 'create a new reserve_fund' do
    Entity.make!(:detran)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    ReserveAllocationType.make!(:licitation)
    LicitationModality.make!(:publica)
    Provider.make!(:wenderson_sa)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Entidade', :with => 'Detran'
    fill_mask 'Exercício', :with => '2012'

    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Reservado'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'
    fill_mask 'Data', :with => '22/02/2012'
    fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

    page.should have_field 'Valor reservado', :with => '10,50'

    fill_in 'Valor *', :with => '10,00'
    fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
    fill_in 'Número da licitação', :with => '001/2012'
    fill_in 'Número do processo', :with => '002/2013'
    fill_modal 'Favorecido', :with => '456789', :field => 'CRC'
    fill_in 'Motivo', :with => 'Motivo para reserva de dotação'

    click_button 'Salvar'

    page.should have_notice 'Reserva de Dotação criado com sucesso.'

    click_link '2012'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field  'Tipo', :with => 'Licitação'
    page.should have_field 'Data', :with => '22/02/2012'
    page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2012 - Alocação"
    page.should have_field 'Valor reservado', :with => '20,50'
    page.should have_field 'Valor *', :with => '10,00'
    page.should have_field 'Modalidade', :with => 'Pública'
    page.should have_field 'Número da licitação', :with => '001/2012'
    page.should have_field 'Número do processo', :with => '002/2013'
    page.should have_field 'Favorecido', :with => 'Wenderson Malheiros'
    page.should have_field 'Motivo', :with => 'Motivo para reserva de dotação'
  end

  scenario 'should have all fields disabled when editing an existent reserve fund' do
    ReserveFund.make!(:detran_2012)
    budget_allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link '2012'

    should_not have_button 'Salvar'

    page.should have_disabled_field 'Entidade'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_disabled_field 'Exercício'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_disabled_field 'Tipo'
    page.should have_field 'Tipo', :with => 'Licitação'
    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => '21/02/2012'
    page.should have_disabled_field 'Dotação orçamentária'
    page.should have_field 'Dotação orçamentária', :with => budget_allocation.to_s
    page.should have_disabled_field 'Valor *'
    page.should have_field 'Valor *', :with => '10,50'
    page.should have_disabled_field 'Modalidade'
    page.should have_field 'Modalidade', :with => 'Pública'
    page.should have_disabled_field 'Número da licitação'
    page.should have_field 'Número da licitação', :with => '001/2012'
    page.should have_disabled_field 'Número do processo'
    page.should have_field 'Número do processo', :with => '002/2013'
    page.should have_disabled_field 'Favorecido'
    page.should have_field 'Favorecido', :with => 'Wenderson Malheiros'
    page.should have_disabled_field 'Motivo'
    page.should have_field 'Motivo', :with => 'Motivo para a reserva de dotação'
  end

  scenario 'should not have link to destroy an existent reserve_fund' do
    ReserveFund.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link '2012'

    page.should_not have_link 'Apagar'
  end

  scenario 'getting and cleaning budget_allocation amount via javascript' do
    budget_allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    page.should have_disabled_field 'Saldo orçamentário'

    fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

    page.should have_disabled_field 'Saldo orçamentário'
    page.should have_field 'Saldo orçamentário', :with => '500,00'

    clear_modal 'Dotação orçamentária'

    page.should have_disabled_field 'Saldo orçamentário'
    page.should have_field 'Saldo orçamentário', :with => ''
  end

  scenario 'show modal info of budget allocation' do
    BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

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

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Número da licitação'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'

    page.should_not have_disabled_field 'Modalidade'
    page.should_not have_disabled_field 'Número da licitação'

    clear_modal 'Tipo'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Número da licitação'

    fill_modal 'Tipo', :with => 'Comum', :field => 'Descrição'

    page.should have_disabled_field 'Modalidade'
    page.should have_disabled_field 'Número da licitação'
  end

  scenario 'should clean licitation modality and licitation number/year when changing type to diferent of licitation' do
    ReserveAllocationType.make!(:licitation)
    ReserveAllocationType.make!(:comum)
    LicitationModality.make!(:publica)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'
    fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
    fill_in 'Número da licitação', :with => '001/2012'

    page.should have_field 'Modalidade', :with => 'Pública'
    page.should have_field 'Número da licitação', :with => '001/2012'

    fill_modal 'Tipo', :with => 'Comum', :field => 'Descrição'

    page.should have_disabled_field 'Modalidade'
    page.should have_field 'Número da licitação', :with => ''
    page.should have_disabled_field 'Modalidade'
    page.should have_field 'Número da licitação', :with => ''
  end
end
