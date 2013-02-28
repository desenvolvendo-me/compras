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

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_disabled_field 'Liberação'
      expect(page).to have_disabled_field 'Por'
      expect(page).to have_disabled_field 'Observações do atendimento'
      expect(page).to have_disabled_field 'Justificativa para não atendimento'
      expect(page).to have_disabled_field 'Status de atendimento'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Estrutura orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      end

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      expect(page).to have_disabled_field 'Valor total'
      expect(page).to have_disabled_field 'Status'
      expect(page).to have_select 'Status', :selected => 'Pendente'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '700,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2012'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Estrutura orçamentária solicitante', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      expect(page).to have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Bens'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      expect(page).to have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field "Dotação", :with => budget_allocation.to_s
      expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca/Referência', :with => 'Norton'
      expect(page).to have_field 'Quantidade', :with => '3,50'
      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_field 'Valor total', :with => '700,00'
      expect(page).to have_select 'Status', :selected => 'Pendente'
      expect(page).to have_disabled_field 'Status'

      expect(page).to have_field 'Item', :with => '1'
    end
  end

  scenario 'update an existent purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo)
    BudgetStructure.make!(:secretaria_de_desenvolvimento)
    Employee.make!(:wenderson)
    ExpenseNature.make!(:compra_de_material)
    DeliveryLocation.make!(:health)
    budget_allocation = BudgetAllocation.make!(:reparo_2011)
    Material.make!(:arame_farpado)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      page.find('a').click
    end

    expect(page).to have_subtitle '1/2012'

    expect(page).to_not have_link 'Apagar'
    expect(page).to have_disabled_field 'Ano'

    within_tab 'Principal' do
      fill_in 'Data da solicitação', :with => '01/02/2013'
      fill_modal 'Responsável pela solicitação', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Estrutura orçamentária solicitante', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
      fill_in 'Justificativa da solicitação', :with => 'Novas mesas'
      fill_modal 'Local para entrega', :with => 'Secretaria da Saúde', :field => "Descrição"
      select 'Produtos', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Remover Dotação"

      click_button "Adicionar Dotação"

      within_modal 'Dotação' do
        click_button 'Pesquisar'
        click_record '2011 - Secretaria de Educação'
      end

      fill_modal 'Natureza da despesa', :with => 'Compra de Material', :field => 'Descrição'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Ferro SA'
      fill_in 'Quantidade', :with => '200,00'
      fill_in 'Valor unitário', :with => '25,00'
      expect(page).to have_disabled_field 'Status'
      expect(page).to have_select 'Status', :selected => 'Pendente'

      # asserting calculated unit price of the item
      expect(page).to have_field 'Valor total', :with => '5.000,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 1/2012 editada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_disabled_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2013'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Estrutura orçamentária solicitante', :with => '1.29 - Secretaria de Desenvolvimento'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas mesas'
      expect(page).to have_field 'Local para entrega', :with => 'Secretaria da Saúde'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Produtos'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field "Dotação", :with => budget_allocation.to_s
      expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.11 - Compra de Material'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca/Referência', :with => 'Ferro SA'
      expect(page).to have_field 'Quantidade', :with => '200,00'
      expect(page).to have_field 'Valor unitário', :with => '25,00'
      expect(page).to have_field 'Valor total', :with => '5.000,00'
      expect(page).to have_select 'Status', :selected => 'Pendente'
      expect(page).to have_disabled_field 'Status'

      expect(page).to have_field 'Item', :with => '1'
    end
  end

  scenario 'should have at least one budget allocation with one item' do
    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    click_button 'Salvar'

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_content 'é necessário cadastrar pelo menos uma dotação'

      click_button 'Adicionar Dotação'
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'should validate presence of budget allocations and items when editing' do
    PurchaseSolicitation.make!(:reparo)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Item'

      click_button 'Remover Item'
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_field 'Item'
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'

      expect(page).to have_field 'Dotação'

      click_button 'Remover Dotação'
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_field 'Dotação'
      expect(page).to have_content 'é necessário cadastrar pelo menos uma dotação'
    end
  end

  scenario 'calculate total value of items' do
    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_disabled_field 'Valor total dos itens'

      click_button 'Adicionar Dotação'

      within '.purchase-solicitation-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:last' do
          fill_in 'Quantidade', :with => '3,00'
          fill_in 'Valor unitário', :with => '10,00'
          expect(page).to have_field 'Valor total', :with => '30,00'
        end

        click_button 'Adicionar Item'

        within '.item:last' do
          fill_in 'Quantidade', :with => '5,00'
          fill_in 'Valor unitário', :with => '2,00'
          expect(page).to have_field 'Valor total', :with => '10,00'
        end
      end

      click_button 'Adicionar Dotação'

      within '.purchase-solicitation-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:last' do
          fill_in 'Quantidade', :with => '10,00'
          fill_in 'Valor unitário', :with => '5,50'
          expect(page).to have_field 'Valor total', :with => '55,00'
        end
      end

      expect(page).to have_field 'Valor total dos itens', :with => '95,00'

      # removing an item

      within '.purchase-solicitation-budget-allocation:last' do
        within '.item:last' do
          click_button 'Remover Item'
        end
      end

      expect(page).to have_field 'Valor total dos itens', :with => '85,00'

      # removing an entire budget allocation

      within '.purchase-solicitation-budget-allocation:first' do
        click_button 'Remover Dotação'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '30,00'
    end
  end

  scenario 'create a new purchase_solicitation with the same accouting year the code should be increased by 1' do
    PurchaseSolicitation.make!(:reparo)
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:sobrinho)
    ExpenseNature.make!(:vencimento_e_salarios)
    DeliveryLocation.make!(:education)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:office)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Estrutura orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      end

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Office', :field => 'Descrição'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,00'
      fill_in 'Valor unitário', :with => '200,00'
      expect(page).to have_disabled_field 'Status'
      expect(page).to have_select 'Status', :selected => 'Pendente'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 2/2012 criada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '2'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2012'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Estrutura orçamentária solicitante', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      expect(page).to have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Bens'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      expect(page).to have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field "Dotação", :with => budget_allocation.to_s
      expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'

      expect(page).to have_field 'Material', :with => '01.01.00002 - Office'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca/Referência', :with => 'Norton'
      expect(page).to have_field 'Quantidade', :with => '3,00'
      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_field 'Valor total', :with => '600,00'
      expect(page).to have_select 'Status', :selected => 'Pendente'
      expect(page).to have_disabled_field 'Status'

      expect(page).to have_field 'Item', :with => '1'
    end
  end

  scenario 'should not show edit button when is not editable' do
    PurchaseSolicitation.make!(:reparo_liberado)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      page.find('a').click
    end

    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'esta solicitação já está em uso ou anulada e não pode ser editada'
  end

  scenario 'should show edit button when is returned' do
    PurchaseSolicitation.make!(:reparo,
                               :service_status => PurchaseSolicitationServiceStatus::RETURNED)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      page.find('a').click
    end

    expect(page).to have_button 'Salvar'
  end

  scenario 'create a new purchase_solicitation with same budget_structure and material' do
    purchase_solicitation = PurchaseSolicitation.make!(:reparo)
    Employee.make!(:sobrinho)
    ExpenseNature.make!(:vencimento_e_salarios)
    DeliveryLocation.make!(:education)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Estrutura orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      end

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_content "já existe uma solicitação de compra pendente com esta estrutura orçamentária solicitante e material"
    end
  end

  scenario 'update a purchase_solicitation with same budget_structure and material' do
    PurchaseSolicitation.make!(:reparo)
    purchase_solicitation = PurchaseSolicitation.make!(:reparo_2013,
                                                       :service_status => PurchaseSolicitationServiceStatus::PENDING)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      click_link purchase_solicitation.decorator.code_and_year
    end

    within_tab 'Dotações orçamentárias' do
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_content "já existe uma solicitação de compra pendente com esta estrutura orçamentária solicitante e material"
    end
  end

  scenario 'provide purchase solicitation search by code and responsible' do
    PurchaseSolicitation.make!(:reparo)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Filtrar Solicitações de Compra'

    fill_in 'Código', :with => '1'

    clear_modal "Ano"

    click_button 'Pesquisar'

    expect(page).to have_content '1/2012'

    click_link 'Filtrar Solicitações de Compra'

    within_modal 'Responsável' do
      fill_modal 'Pessoa', :field => 'Nome', :with => 'Gabriel Sobrinho'
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    click_button 'Pesquisar'

    expect(page).to have_content 'Gabriel Sobrinho'
  end

  scenario 'index with columns at the index' do
    PurchaseSolicitation.make!(:reparo)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      expect(page).to have_content 'Código/Ano'
      expect(page).to have_content 'Estrutura orçamentária solicitante'
      expect(page).to have_content 'Responsável pela solicitação'
      expect(page).to have_content 'Status de atendimento'

      within 'tbody tr' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '1 - Secretaria de Educação'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Pendente'
      end
    end
  end

  scenario "purchase of services" do
    PurchaseSolicitation.make!(:reparo,
                               :kind => PurchaseSolicitationKind::SERVICES)
    ExpenseNature.make!(:vencimento_e_salarios)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Material.make!(:manutencao)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Criar Solicitação de Compra"

    select "Serviços", :on => "Tipo de solicitação"

    within_tab "Dotações orçamentárias" do
      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      end

      click_button 'Adicionar Item'

      within_modal "Serviço" do
        click_button "Pesquisar"

        within_records do
          expect(page).to have_content "Manutenção de Computadores"
          expect(page).not_to have_content "Antivirus"
        end

        click_link "Voltar"
      end
    end

    click_link "Voltar"

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      click_link "1/2012"
    end

    within_tab "Dotações orçamentárias" do
      clear_modal "Serviço"

      within_modal "Serviço" do
        click_button "Pesquisar"

        within_records do
          expect(page).to have_content "Manutenção de Computadores"
          expect(page).not_to have_content "Antivirus"
        end
      end
    end
  end

  scenario "verify status of purchase solicitations items, first partially
            attended and after attended" do

    PurchaseSolicitation.make!(:reparo_office,
                               :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
                               :purchase_solicitation_liberations => [PurchaseSolicitationLiberation.make(:reparo)],
                               :purchase_solicitation_budget_allocations => [
                                 PurchaseSolicitationBudgetAllocation.make(:alocacao_primaria_office_2_itens_liberados)])

    #### Create a purchase solicitation item group with one material only
    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    fill_in 'Descrição', :with => 'Agrupamento de arame farpado'

    expect(page).to have_disabled_field "Situação"

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'
    fill_modal 'Solicitações de compra', :with => '2012', :field => 'Ano'

    click_button 'Salvar'

    expect(page).to have_notice 'Agrupamento de Item de Solicitação de Compra criado com sucesso.'

    ### Create a direct purchase with item group
    LegalReference.make!(:referencia)
    Creditor.make!(:wenderson_sa)
    BudgetStructure.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    ModalityLimit.make!(:modalidade_de_compra_ponte, :without_bidding => "40000,00")
    PriceRegistration.make!(:registro_de_precos)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de arame farpado'
      end

      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'

      fill_modal 'Estrutura orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_modal 'Registro de preços', :with => 'Aquisição de combustíveis', :field => 'Objeto'
      fill_in 'Observações gerais', :with => 'obs'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 criada com sucesso.'

    ### Create a supply authorization of direct purchase with item group
    navigate 'Processos de Compra > Compra Direta'

    click_link "Filtrar Compras Diretas"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      page.find('a').click
    end

    click_button 'Gerar autorização de fornecimento'

    click_link 'voltar'

    ### Verify status, should be partially attended
    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end

    within_tab 'Dotações orçamentárias' do
      within 'div.item' do
        expect(page).to have_select 'Status', :selected => 'Pendente'
      end

      within 'div.item:last' do
        expect(page).to have_select 'Status', :selected => 'Atendido'
      end
    end

    #### Create a purchase solicitation item group with last material liberated
    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    fill_in 'Descrição', :with => 'Agrupamento de office'

    expect(page).to have_disabled_field "Situação"

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Office', :field => 'Descrição'
    fill_modal 'Solicitações de compra', :with => '2012', :field => 'Ano'

    click_button 'Salvar'

    expect(page).to have_notice 'Agrupamento de Item de Solicitação de Compra criado com sucesso.'

    ### Create a direct purchase with item group
    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de office'
      end

      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'

      fill_modal 'Estrutura orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_modal 'Registro de preços', :with => 'Aquisição de combustíveis', :field => 'Objeto'
      fill_in 'Observações gerais', :with => 'obs'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 2/2012 criada com sucesso.'

    ### Create a supply authorization of direct purchase with item group
    navigate 'Processos de Compra > Compra Direta'

    click_link "Filtrar Compras Diretas"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      click_link '2/2012'
    end

    click_button 'Gerar autorização de fornecimento'

    click_link 'voltar'

    ### Verify status, should be attended
    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Filtrar Solicitações de Compra"

    clear_modal "Ano"

    click_button "Pesquisar"

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Atendida'
    end

    within_tab 'Dotações orçamentárias' do
      within 'div.item' do
        expect(page).to have_select 'Status', :selected => 'Atendido'
      end

      within 'div.item:last' do
        expect(page).to have_select 'Status', :selected => 'Atendido'
      end
    end
  end

  scenario 'should not allow duplicated materials' do
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:sobrinho)
    ExpenseNature.make!(:vencimento_e_salarios)
    DeliveryLocation.make!(:education)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Estrutura orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:last' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_modal 'Natureza da despesa', :with => 'Vencimentos e Salários', :field => 'Descrição'
      end

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      click_button 'Adicionar Item'

      within '#allocations .item:last' do
        fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
        fill_in 'Marca/Referência', :with => 'Norton'
        fill_in 'Quantidade', :with => '2,0'
        fill_in 'Valor unitário', :with => '300,00'
      end
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Dotações orçamentárias' do
      within '#allocations .item:last' do
        expect(page).to have_content 'já está em uso'
      end
    end
  end

  scenario 'fill automatically budget structure from budget allocation' do
    BudgetStructure.make!(:secretaria_de_educacao)
    budget_allocation = BudgetAllocation.make!(:alocacao)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_modal 'Estrutura orçamentária solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar Dotação"

      within '.purchase-solicitation-budget-allocation:last' do
        within_modal 'Dotação' do
          expect(page).to have_disabled_field 'Estrutura orçamentária', :with => '1 - Secretaria de Educação'

          click_link 'Voltar'
        end
      end
    end

    within_tab 'Principal' do
      clear_modal 'Estrutura orçamentária solicitante'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:last' do
        within_modal 'Dotação' do
          expect(page).to have_field 'Estrutura orçamentária', :with => ''
        end
      end
    end
  end
end
