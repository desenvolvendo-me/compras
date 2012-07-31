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
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:sobrinho)
    ExpenseNature.make!(:vencimento_e_salarios)
    DeliveryLocation.make!(:education)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      page.should have_disabled_field 'Código'
      page.should have_disabled_field 'Liberação'
      page.should have_disabled_field 'Por'
      page.should have_disabled_field 'Observações do atendimento'
      page.should have_disabled_field 'Justificativa para não atendimento'
      page.should have_disabled_field 'Status de atendimento'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Estrutura orçamentaria solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentarias' do
      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      end

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      page.should have_disabled_field 'Valor total'

      # asserting calculated total price of the item
      page.should have_field 'Valor total', :with => '700,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Solicitação de Compra criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da solicitação', :with => '01/02/2012'
      page.should have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho', :field => 'Matrícula'
      page.should have_field 'Estrutura orçamentaria solicitante', :with => '1 - Secretaria de Educação'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      page.should have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      page.should have_select 'Tipo de solicitação', :selected => 'Bens'
      page.should have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      page.should have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Dotações orçamentarias' do
      page.should have_field "Dotação", :with => budget_allocation.to_s
      page.should have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'

      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Unidade', :with => 'UN'
      page.should have_field 'Marca/Referência', :with => 'Norton'
      page.should have_field 'Quantidade', :with => '3,50'
      page.should have_field 'Valor unitário', :with => '200,00'
      page.should have_field 'Valor total', :with => '700,00'

      page.should have_field 'Item', :with => '1'
    end
  end

  scenario 'update an existent purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo)
    BudgetStructure.make!(:secretaria_de_desenvolvimento)
    Employee.make!(:wenderson)
    ExpenseNature.make!(:compra_de_material)
    DeliveryLocation.make!(:health)
    budget_allocation = BudgetAllocation.make!(:alocacao_extra)
    Material.make!(:arame_farpado)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    page.should_not have_link 'Apagar'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2013'
      fill_in 'Data da solicitação', :with => '01/02/2013'
      fill_modal 'Responsável pela solicitação', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Estrutura orçamentaria solicitante', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
      fill_in 'Justificativa da solicitação', :with => 'Novas mesas'
      fill_modal 'Local para entrega', :with => 'Secretaria da Saúde', :field => "Descrição"
      select 'Serviços', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentarias' do
      click_button "Remover Dotação"

      click_button "Adicionar Dotação"

      within_modal 'Dotação' do
        fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
        click_button 'Pesquisar'
        click_record '2011 - Detran'
      end

      fill_modal 'Natureza da despesa', :with => 'Compra de Material', :field => 'Descrição'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Ferro SA'
      fill_in 'Quantidade', :with => '200,00'
      fill_in 'Valor unitário', :with => '25,00'

      # asserting calculated unit price of the item
      page.should have_field 'Valor total', :with => '5.000,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Solicitação de Compra editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Ano', :with => '2013'
      page.should have_field 'Data da solicitação', :with => '01/02/2013'
      page.should have_field 'Responsável pela solicitação', :with => 'Wenderson Malheiros', :field => 'Matrícula'
      page.should have_field 'Estrutura orçamentaria solicitante', :with => '1.2 - Secretaria de Desenvolvimento'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas mesas'
      page.should have_field 'Local para entrega', :with => 'Secretaria da Saúde'
      page.should have_select 'Tipo de solicitação', :selected => 'Serviços'
      page.should have_field 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentarias' do
      page.should have_field "Dotação", :with => budget_allocation.to_s
      page.should have_field 'Natureza da despesa', :with => '3.0.10.01.11 - Compra de Material'

      page.should have_field 'Material', :with => '02.02.00001 - Arame farpado'
      page.should have_field 'Unidade', :with => 'UN'
      page.should have_field 'Marca/Referência', :with => 'Ferro SA'
      page.should have_field 'Quantidade', :with => '200,00'
      page.should have_field 'Valor unitário', :with => '25,00'
      page.should have_field 'Valor total', :with => '5.000,00'

      page.should have_field 'Item', :with => '1'
    end
  end

  scenario 'trying to create a new purchase_solicitation with duplicated budget_allocations to ensure the error' do
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:sobrinho)
    ExpenseNature.make!(:vencimento_e_salarios)
    DeliveryLocation.make!(:education)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Estrutura orçamentaria solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentarias' do
      click_button "Adicionar Dotação"

      fill_modal 'Dotação', :with => '1', :field => 'Código'
      fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'

      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:first' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      end
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentarias' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'should have at least one budget allocation with one item' do
    navigate_through 'Compras e Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    click_button 'Salvar'

    within_tab 'Dotações orçamentarias' do
      page.should have_content 'é necessário cadastrar pelo menos uma dotação'

      click_button 'Adicionar Dotação'
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentarias' do
      page.should have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'should validate presence of budget allocations and items when editing' do
    PurchaseSolicitation.make!(:reparo)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentarias' do
      page.should have_field 'Item'

      click_button 'Remover Item'
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentarias' do
      page.should_not have_field 'Item'
      page.should have_content 'é necessário cadastrar pelo menos um item'

      page.should have_field 'Dotação'

      click_button 'Remover Dotação'
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentarias' do
      page.should_not have_field 'Dotação'
      page.should have_content 'é necessário cadastrar pelo menos uma dotação'
    end
  end

  scenario 'calculate total value of items' do
    navigate_through 'Compras e Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dotações orçamentarias' do
      page.should have_disabled_field 'Valor total dos itens'

      click_button 'Adicionar Dotação'

      within '.purchase-solicitation-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:last' do
          fill_in 'Quantidade', :with => '3,00'
          fill_in 'Valor unitário', :with => '10,00'
          page.should have_field 'Valor total', :with => '30,00'
        end

        click_button 'Adicionar Item'

        within '.item:last' do
          fill_in 'Quantidade', :with => '5,00'
          fill_in 'Valor unitário', :with => '2,00'
          page.should have_field 'Valor total', :with => '10,00'
        end
      end

      click_button 'Adicionar Dotação'

      within '.purchase-solicitation-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:last' do
          fill_in 'Quantidade', :with => '10,00'
          fill_in 'Valor unitário', :with => '5,50'
          page.should have_field 'Valor total', :with => '55,00'
        end
      end

      page.should have_field 'Valor total dos itens', :with => '95,00'

      # removing an item

      within '.purchase-solicitation-budget-allocation:last' do
        within '.item:last' do
          click_button 'Remover Item'
        end
      end

      page.should have_field 'Valor total dos itens', :with => '85,00'

      # removing an entire budget allocation

      within '.purchase-solicitation-budget-allocation:first' do
        click_button 'Remover Dotação'
      end

      page.should have_field 'Valor total dos itens', :with => '30,00'
    end
  end

  scenario 'create a new purchase_solicitation with the same accouting year the code should be increased by 1' do
    PurchaseSolicitation.make!(:reparo)
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:sobrinho)
    ExpenseNature.make!(:vencimento_e_salarios)
    DeliveryLocation.make!(:education)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Estrutura orçamentaria solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentarias' do
      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      end

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,00'
      fill_in 'Valor unitário', :with => '200,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Solicitação de Compra criada com sucesso.'

    within_records do
      click_link '2/2012'
    end

    within_tab 'Principal' do
      page.should have_field 'Código', :with => '2'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da solicitação', :with => '01/02/2012'
      page.should have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho', :field => 'Matrícula'
      page.should have_field 'Estrutura orçamentaria solicitante', :with => '1 - Secretaria de Educação'
      page.should have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      page.should have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      page.should have_select 'Tipo de solicitação', :selected => 'Bens'
      page.should have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      page.should have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Dotações orçamentarias' do
      page.should have_field "Dotação", :with => budget_allocation.to_s
      page.should have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'

      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Unidade', :with => 'UN'
      page.should have_field 'Marca/Referência', :with => 'Norton'
      page.should have_field 'Quantidade', :with => '3,00'
      page.should have_field 'Valor unitário', :with => '200,00'
      page.should have_field 'Valor total', :with => '600,00'

      page.should have_field 'Item', :with => '1'
    end
  end

  scenario 'should not show edit button when is not editable' do
    PurchaseSolicitation.make!(:reparo,
                               :service_status => PurchaseSolicitationServiceStatus::LIBERATED)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Salvar'
  end

  scenario 'should show edit button when is returned' do
    PurchaseSolicitation.make!(:reparo,
                               :service_status => PurchaseSolicitationServiceStatus::RETURNED)

    navigate_through 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    page.should have_button 'Salvar'
  end
end
