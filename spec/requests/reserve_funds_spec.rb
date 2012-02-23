# encoding: utf-8
require 'spec_helper'

feature "ReserveFunds" do
  background do
    sign_in
  end

  scenario 'create a new reserve_fund' do
    Entity.make!(:detran)
    budget_allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link 'Criar Reserva de Dotação'

    fill_in 'Exercício', :with => '2012'
    fill_modal 'Entidade', :with => 'Detran'
    fill_modal 'Dotação orçamentária', :with => 'Alocação', :field => 'Descrição'
    fill_in 'Valor', :with => '10,00'

    click_button 'Criar Reserva de Dotação'

    page.should have_notice 'Reserva de Dotação criado com sucesso.'

    click_link '2012'

    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2012"
    page.should have_field 'Valor', :with => '10,00'
  end

  scenario 'update an existent reserve_fund' do
    ReserveFund.make!(:detran_2012)
    Entity.make!(:secretaria_de_educacao)
    budget_allocation = BudgetAllocation.make!(:conserto)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link '2012'

    fill_in 'Exercício', :with => '2011'
    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_modal 'Dotação orçamentária', :with => 'Conserto', :field => 'Descrição'
    fill_in 'Valor', :with => '199,00'

    click_button 'Atualizar Reserva de Dotação'

    page.should have_notice 'Reserva de Dotação editado com sucesso.'

    click_link '2011'

    page.should have_field 'Exercício', :with => '2011'
    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2012"
    page.should have_field 'Valor', :with => '199,00'
  end

  scenario 'destroy an existent reserve_fund' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    reserve_fund = ReserveFund.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Reservas de Dotação'

    click_link '2012'

    click_link "Apagar #{reserve_fund.id}/2012", :confirm => true

    page.should have_notice 'Reserva de Dotação apagado com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content 'Detran'
    page.should_not have_content "#{budget_allocation.id}/2012"
    page.should_not have_content '10,00'
  end
end
