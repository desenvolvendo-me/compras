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

    navigate 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'

    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Reservado'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'
    fill_in 'Data', :with => '22/02/2012'
    fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

    expect(page).to have_field 'Valor reservado', :with => '10,50'

    fill_in 'Valor *', :with => '10,00'
    fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

    fill_modal 'Favorecido', :with => 'Wenderson Malheiros'

    fill_in 'Motivo', :with => 'Motivo para reserva de dotação'

    click_button 'Salvar'

    expect(page).to have_notice 'Reserva de Dotação criado com sucesso.'

    click_link '2012'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Tipo', :with => 'Licitação'
    expect(page).to have_field 'Data', :with => '22/02/2012'
    expect(page).to have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
    expect(page).to have_field 'Valor reservado', :with => '20,50'
    expect(page).to have_field 'Valor *', :with => '10,00'
    expect(page).to have_field 'Modalidade', :with => 'Pública'
    expect(page).to have_field 'Processo licitatório', :with => '1/2012'
    expect(page).to have_field 'Processo administrativo', :with => '1/2012'
    expect(page).to have_field 'Favorecido', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Motivo', :with => 'Motivo para reserva de dotação'
  end

  scenario 'should have all fields disabled when editing an existent reserve fund' do
    ReserveFund.make!(:detran_2012)
    budget_allocation = BudgetAllocation.make!(:alocacao)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link '2012'

    should_not have_button 'Salvar'

    expect(page).to have_disabled_field 'Descritor'
    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_disabled_field 'Tipo'
    expect(page).to have_field 'Tipo', :with => 'Licitação'
    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data', :with => '22/02/2012'
    expect(page).to have_disabled_field 'Dotação orçamentaria'
    expect(page).to have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
    expect(page).to have_disabled_field 'Valor *'
    expect(page).to have_field 'Valor *', :with => '10,50'
    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_field 'Modalidade', :with => 'Pública'
    expect(page).to have_disabled_field 'Processo licitatório'
    expect(page).to have_disabled_field 'Processo administrativo'
    expect(page).to have_disabled_field 'Favorecido'
    expect(page).to have_field 'Favorecido', :with => 'Wenderson Malheiros'
    expect(page).to have_disabled_field 'Motivo'
    expect(page).to have_field 'Motivo', :with => 'Motivo para a reserva de dotação'
  end

  scenario 'should not have link to destroy an existent reserve_fund' do
    ReserveFund.make!(:detran_2012)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link '2012'

    expect(page).to_not have_link 'Apagar'
  end

  scenario 'getting and cleaning budget_allocation amount via javascript' do
    BudgetAllocation.make!(:alocacao)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    expect(page).to have_disabled_field 'Saldo orçamentário'

    fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

    expect(page).to have_disabled_field 'Saldo orçamentário'
    expect(page).to have_field 'Saldo orçamentário', :with => '500,00'

    clear_modal 'Dotação orçamentaria'

    expect(page).to have_disabled_field 'Saldo orçamentário'
    expect(page).to have_field 'Saldo orçamentário', :with => ''
  end

  scenario 'show modal info of budget allocation' do
    BudgetAllocation.make!(:alocacao)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

    click_link 'Mais informações'

    within '#record' do
      expect(page).to have_content 'Detran'
      expect(page).to have_content '2012'
      expect(page).to have_content 'Alocação'
      expect(page).to have_content '1 - Secretaria de Educação'
      expect(page).to have_content '01 - Administração Geral'
      expect(page).to have_content 'Habitação'
      expect(page).to have_content '500,00'
      expect(page).to have_content 'Ação Governamental'
      expect(page).to have_content '3.0.10.01.12'
      expect(page).to have_content 'Reforma e Ampliação'
      expect(page).to have_content 'Manutenção da Unidade Administrativa'
      expect(page).to have_content 'Nenhuma'
      expect(page).to have_content 'Dotação Administrativa'
    end
  end

  scenario 'enable/disable licitation and licitation modality fields depending on type' do
    ReserveAllocationType.make!(:licitation)
    ReserveAllocationType.make!(:comum)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_disabled_field 'Processo licitatório'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'

    expect(page).to_not have_disabled_field 'Modalidade'
    expect(page).to_not have_disabled_field 'Processo licitatório'

    clear_modal 'Tipo'

    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_disabled_field 'Processo licitatório'

    fill_modal 'Tipo', :with => 'Tipo Comum', :field => 'Descrição'

    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_disabled_field 'Processo licitatório'
  end

  scenario 'should clean licitation modality and licitation number/year when changing type to diferent of licitation' do
    ReserveAllocationType.make!(:licitation)
    ReserveAllocationType.make!(:comum)
    LicitationModality.make!(:publica)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Tipo', :with => 'Licitação', :field => 'Descrição'
    fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'

    expect(page).to have_field 'Modalidade', :with => 'Pública'

    fill_modal 'Tipo', :with => 'Tipo Comum', :field => 'Descrição'

    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_disabled_field 'Modalidade'
  end

  scenario 'should fill/clear delegate liciation_process fields' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

    expect(page).to have_field 'Processo licitatório', :with => '1/2012'
    expect(page).to have_field 'Processo administrativo', :with => '1/2012'

    clear_modal 'Processo licitatório'

    expect(page).to have_field 'Processo administrativo', :with => ''
  end
end
