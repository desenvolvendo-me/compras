# encoding: utf-8
require 'spec_helper'

feature "PurchaseSolicitations" do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'create a new purchase_solicitation' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    make_dependencies!

    click_link 'Solicitações'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Liberação'
      page.should have_disabled_field 'Por'
      page.should have_disabled_field 'Observações do atendimento'
      page.should have_disabled_field 'Justificativa para não atendimento'
      page.should have_disabled_field 'Status de atendimento'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Unidade orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Classificação econômica da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    click_button 'Criar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da solicitação', :with => '01/02/2012'
      page.should have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho', :field => 'Matrícula'
      page.should have_field 'Unidade orçamentária solicitante', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      page.should have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      page.should have_select 'Tipo de solicitação', :selected => 'Bens'
      page.should have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
      page.should have_field 'Classificação econômica da despesa', :with => '3.1.90.11.01.00.00.00'

      # Testing the pending status applied automatically
      page.should have_select 'Status de atendimento', :selected => 'Pendente'
    end
  end

  scenario 'create a new purchase_solicitation with multiple budget_allocations' do
    make_dependencies!
    budget_allocation = BudgetAllocation.make!(:alocacao)
    budget_allocation_extra = BudgetAllocation.make!(:alocacao_extra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Liberação'
      page.should have_disabled_field 'Por'
      page.should have_disabled_field 'Observações do atendimento'
      page.should have_disabled_field 'Justificativa para não atendimento'
      page.should have_disabled_field 'Status de atendimento'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Unidade orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '2012', :field => 'Exercício'
        fill_modal 'Compl. do el. da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
        fill_in 'Valor previsto', :with => '200,00'
      end

      click_button "Adicionar"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '2011', :field => 'Exercício'
        fill_modal 'Compl. do el. da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
        fill_in 'Valor previsto', :with => '300,00'
      end
    end

    click_button 'Criar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da solicitação', :with => '01/02/2012'
      page.should have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho', :field => 'Matrícula'
      page.should have_field 'Unidade orçamentária solicitante', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      page.should have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      page.should have_select 'Tipo de solicitação', :selected => 'Bens'
      page.should have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      page.should have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        page.should have_field "Dotação", :with => "#{budget_allocation.id}/2012 - Alocação"
        page.should have_field 'Compl. do el. da despesa', :with => '3.1.90.11.01.00.00.00'
        page.should have_field "Valor previsto", :with => '200,00'
      end

      within '.purchase-solicitation-budget-allocation:last' do
        page.should have_field "Dotação", :with => "#{budget_allocation_extra.id}/2011 - Alocação extra"
        page.should have_field 'Compl. do el. da despesa', :with => '3.1.90.11.01.00.00.00'
        page.should have_field "Valor previsto", :with => '300,00'
      end
    end
  end

  scenario 'update an existent purchase_solicitation' do
    make_dependencies!

    PurchaseSolicitation.make!(:reparo)
    Employee.make!(:wenderson)
    DeliveryLocation.make!(:health)
    Material.make!(:antivirus)
    Organogram.make!(:secretaria_de_desenvolvimento)
    ExpenseEconomicClassification.make!(:compra_de_material)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2013'
      fill_in 'Data da solicitação', :with => '01/02/2013'
      fill_modal 'Responsável pela solicitação', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Unidade orçamentária solicitante', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
      fill_in 'Justificativa da solicitação', :with => 'Novas mesas'
      fill_modal 'Classificação econômica da despesa', :with => 'Compra de Material', :field => 'Descrição'
      fill_modal 'Local para entrega', :with => 'Secretaria da Saúde', :field => "Descrição"
      select 'Serviços', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    click_button 'Atualizar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2013'
      page.should have_field 'Data da solicitação', :with => '01/02/2013'
      page.should have_field 'Responsável pela solicitação', :with => 'Wenderson Malheiros', :field => 'Matrícula'
      page.should have_field 'Unidade orçamentária solicitante', :with => '02.00 - Secretaria de Desenvolvimento'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas mesas'
      page.should have_field 'Classificação econômica da despesa', :with => '2.2.22.11.01.00.00.00'
      page.should have_field 'Local para entrega', :with => 'Secretaria da Saúde'
      page.should have_select 'Tipo de solicitação', :selected => 'Serviços'
      page.should have_field 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end
  end

  scenario 'update an existent purchase_solicitation with multiple budget_allocations' do
    make_dependencies!

    PurchaseSolicitation.make!(:conserto)
    Employee.make!(:wenderson)
    budget_allocation_extra = BudgetAllocation.make!(:alocacao_extra)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    DeliveryLocation.make!(:health)
    Material.make!(:antivirus)
    Organogram.make!(:secretaria_de_desenvolvimento)
    ExpenseEconomicClassification.make!(:compra_de_material)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2013'
      fill_in 'Data da solicitação', :with => '01/02/2013'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_modal 'Unidade orçamentária solicitante', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
      fill_in 'Justificativa da solicitação', :with => 'Novas mesas'
      fill_modal 'Classificação econômica da despesa', :with => 'Compra de Material', :field => 'Descrição'
      fill_modal 'Local para entrega', :with => 'Secretaria da Saúde', :field => 'Descrição'
      select 'Serviços', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        fill_modal 'Compl. do el. da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
        fill_in 'Valor previsto ', :with => '1020,00'
      end
    end

    click_button 'Atualizar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2013'
      page.should have_field 'Data da solicitação', :with => '01/02/2013'
      page.should have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho'
      page.should have_field 'Unidade orçamentária solicitante', :with => '02.00 - Secretaria de Desenvolvimento'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas mesas'
      page.should have_field 'Classificação econômica da despesa', :with => '2.2.22.11.01.00.00.00'
      page.should have_field 'Local para entrega', :with => 'Secretaria da Saúde'
      page.should have_select 'Tipo de solicitação', :selected => 'Serviços'
      page.should have_field 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        page.should have_field 'Dotação', :with => "#{budget_allocation.id}/2012 - Alocação"
        page.should have_field 'Compl. do el. da despesa', :with => '3.1.90.11.01.00.00.00'
        page.should have_field 'Valor previsto', :with => '1.020,00'
      end

      within '.purchase-solicitation-budget-allocation:last' do
        page.should have_field 'Dotação', :with => "#{budget_allocation_extra.id}/2011 - Alocação extra"
        page.should have_field 'Compl. do el. da despesa', :with => '2.2.22.11.01.00.00.00'
        page.should have_field 'Valor previsto ', :with => '30,00'
      end
    end
  end

  scenario 'destroy an existent purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Solicitação de Compra apagada com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content '31/01/2012'
    page.should_not have_content 'Wenderson Malheiros'
    page.should_not have_content 'Reparo nas instalações'
    page.should_not have_content 'Bens'
  end

  scenario 'remove budget allocation from an existent purchase_solicitation' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    PurchaseSolicitation.make!(:conserto)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      click_button 'Remover'
    end

    click_button 'Atualizar Solicitação de Compra'

    page.should have_notice 'Solicitação de Compra editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      page.should_not have_content "#{budget_allocation.id}/2012"
    end
  end

  scenario 'trying to create a new purchase_solicitation with duplicated budget_allocations to ensure the error' do
    make_dependencies!
    BudgetAllocation.make!(:alocacao)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Unidade orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar"

      fill_modal 'Dotação', :with => '2012', :field => 'Exercício'
      fill_modal 'Compl. do el. da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      fill_in 'Valor previsto', :with => '200,00'

      click_button "Adicionar"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '2012', :field => 'Exercício'
        fill_modal 'Compl. do el. da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
        fill_in 'Valor previsto', :with => '300,00'
      end
    end

    click_button 'Criar Solicitação de Compra'

    within_tab 'Dotações orçamentárias' do
      page.should have_content 'já está em uso'
    end
  end

  def make_dependencies!
    Employee.make!(:sobrinho)
    DeliveryLocation.make!(:education)
    Material.make!(:arame_farpado)
    Organogram.make!(:secretaria_de_educacao)
    ExpenseEconomicClassification.make!(:vencimento_e_salarios)
  end
end
