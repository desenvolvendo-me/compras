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
    DeliveryLocation.make!(:education)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    ExpenseNature.make!(:aposentadorias_rpps)
    Material.make!(:antivirus, :material_type => MaterialType::ASSET)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

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
      fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Itens' do
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      expect(page).to have_disabled_field 'Valor total'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '700,00'
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar"

      expect(page).to_not have_css '.nested-record'

      fill_with_autocomplete 'Dotação', :with => 'Aposentadorias'
      fill_with_autocomplete 'Desdobramento', :with => 'Aposentadorias'

      expect(page).to have_field 'Natureza da despesa',:with => '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
      expect(page).to have_field 'Saldo da dotação',:with => '500,00'

      fill_in 'Valor estimado', :with => '100,00'

      click_button "Adicionar"

      within_records do
        expect(page).to have_content '1 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'
        expect(page).to have_content '500,00'
        expect(page).to have_content '100,00'
      end

      # Não pode adicionar 2 dotações iguais
      fill_with_autocomplete 'Dotação', :with => 'Aposentadorias'

      click_button "Adicionar"

      within_records do
        expect(page).to have_css '.nested-record', :count => 1
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2012'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Solicitante', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      expect(page).to have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Bens'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      expect(page).to have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Itens' do
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca/Referência', :with => 'Norton'
      expect(page).to have_field 'Quantidade', :with => '3,50'
      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_field 'Valor total', :with => '700,00'
    end

    within_tab 'Dotações orçamentárias' do
      within_records do
        expect(page).to have_content '1 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'
        expect(page).to have_content '500,00'
        expect(page).to have_content '100,00'
      end
    end
  end

  scenario 'update an existent purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo)
    BudgetStructure.make!(:secretaria_de_desenvolvimento)
    Employee.make!(:wenderson)
    DeliveryLocation.make!(:health)
    ExpenseNature.make!(:aposentadorias_reserva)
    budget_allocation = BudgetAllocation.make!(:reparo_2011)
    Material.make!(:arame_farpado)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    expect(page).to have_subtitle '1/2012'

    expect(page).to_not have_link 'Apagar'
    expect(page).to have_disabled_field 'Ano'

    within_tab 'Principal' do
      fill_in 'Data da solicitação', :with => '01/02/2013'
      fill_modal 'Responsável pela solicitação', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Solicitante', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
      fill_in 'Justificativa da solicitação', :with => 'Novas mesas'
      fill_modal 'Local para entrega', :with => 'Secretaria da Saúde', :field => "Descrição"
      select 'Produtos', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Itens' do
      click_button 'Remover Item'

      expect(page).to have_field 'Valor total dos itens', :with => '0,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Ferro SA'
      fill_in 'Quantidade', :with => '200,00'
      fill_in 'Valor unitário', :with => '25,00'

      # asserting calculated unit price of the item
      expect(page).to have_field 'Valor total', :with => '5.000,00'
    end

    within_tab 'Dotações orçamentárias' do
      within_records do
        click_link "Remover"
      end

      fill_with_autocomplete 'Dotação', :with => 'Aposentadorias'
      fill_with_autocomplete 'Desdobramento', :with => 'Reserva'

      click_button "Adicionar"

      within_records do
        expect(page).to have_content '1.29 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '3.1.90.01.02 - Aposentadorias Custeadas com Recursos da Reserva Remunerada'
        expect(page).to have_content '3.000,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 1/2012 editada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_disabled_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2013'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Solicitante', :with => '1.29 - Secretaria de Desenvolvimento'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas mesas'
      expect(page).to have_field 'Local para entrega', :with => 'Secretaria da Saúde'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Produtos'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Itens' do
      expect(page).to have_field 'Valor total dos itens', :with => '5.000,00'
      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca/Referência', :with => 'Ferro SA'
      expect(page).to have_field 'Quantidade', :with => '200,00'
      expect(page).to have_field 'Valor unitário', :with => '25,00'
      expect(page).to have_field 'Valor total', :with => '5.000,00'

    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_css('.records .record', :count => 1)

      within_records do
        expect(page).to have_content '1.29 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '3.1.90.01.02 - Aposentadorias Custeadas com Recursos da Reserva Remunerada'
        expect(page).to have_content '3.000,00'
      end
    end
  end

  scenario 'should have at least one budget allocation and one item' do
    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    click_button 'Salvar'

    expect(page).to have_content 'é necessário cadastrar pelo menos uma dotação'

    within_tab 'Itens' do
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'should validate presence of budget allocations and items when editing' do
    PurchaseSolicitation.make!(:reparo)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      within_records do
        click_link 'Remover'
      end
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Solicitação de Compra 1/2012 editada com sucesso.'

    expect(page).to have_content 'é necessário cadastrar pelo menos uma dotação'

    click_link 'Voltar'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Itens' do
      click_button 'Remover Item'
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Solicitação de Compra 1/2012 editada com sucesso.'

    within_tab 'Itens' do
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'calculate total value of items' do
    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Itens' do
      expect(page).to have_disabled_field 'Valor total dos itens'

      click_button 'Adicionar Item'

      within '.item:first' do
        fill_in 'Quantidade', :with => '3,00'
        fill_in 'Valor unitário', :with => '10,00'
        expect(page).to have_field 'Valor total', :with => '30,00'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '30,00'

      click_button 'Adicionar Item'

      within '.item:first' do
        fill_in 'Quantidade', :with => '5,00'
        fill_in 'Valor unitário', :with => '2,00'
        expect(page).to have_field 'Valor total', :with => '10,00'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '40,00'

      click_button 'Adicionar Item'

      within '.item:first' do
        fill_in 'Quantidade', :with => '10,00'
        fill_in 'Valor unitário', :with => '5,50'
        expect(page).to have_field 'Valor total', :with => '55,00'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '95,00'

      # removing an item
      within '.item:last' do
        click_button 'Remover Item'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '65,00'
    end
  end

  scenario 'create a new purchase_solicitation with the same accouting year the code should be increased by 1' do
    PurchaseSolicitation.make!(:reparo)
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:sobrinho)
    DeliveryLocation.make!(:education)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:office, :material_type => MaterialType::ASSET)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Bens', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Itens' do
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Office', :field => 'Descrição'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,00'
      fill_in 'Valor unitário', :with => '200,00'
    end

    within_tab 'Dotações orçamentárias' do
      fill_with_autocomplete 'Dotação', :with => 'Aposentadorias'

      click_button "Adicionar"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 2/2012 criada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '2'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2012'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Solicitante', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      expect(page).to have_field 'Local para entrega', :selected => 'Secretaria da Educação'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Bens'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      expect(page).to have_select 'Status de atendimento', :selected => 'Pendente'
    end

    within_tab 'Itens' do
      expect(page).to have_field 'Material', :with => '01.01.00002 - Office'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca/Referência', :with => 'Norton'
      expect(page).to have_field 'Quantidade', :with => '3,00'
      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_field 'Valor total', :with => '600,00'
    end

    within_tab 'Dotações orçamentárias' do
      within_records do
        expect(page).to have_content budget_allocation.to_s
      end
    end
  end

  scenario 'should not show edit button when is not editable' do
    PurchaseSolicitation.make!(:reparo_liberado)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

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

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    expect(page).to have_button 'Salvar'
  end

  scenario 'create a new purchase_solicitation with same budget_structure and material' do
    purchase_solicitation = PurchaseSolicitation.make!(:reparo)
    Employee.make!(:sobrinho)
    DeliveryLocation.make!(:education)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Produtos', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Itens' do
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'
    end

    within_tab 'Dotações orçamentárias' do
      fill_with_autocomplete 'Dotação', :with => 'Aposentadorias'

      click_button "Adicionar"
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Itens' do
      expect(page).to have_content "já existe uma solicitação de compra pendente para este solicitante e material"
    end
  end

  scenario 'update a purchase_solicitation with same budget_structure and material' do
    PurchaseSolicitation.make!(:reparo)
    purchase_solicitation = PurchaseSolicitation.make!(:reparo_2013,
                                                       :service_status => PurchaseSolicitationServiceStatus::PENDING)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link purchase_solicitation.decorator.code_and_year
    end

    within_tab 'Itens' do
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Itens' do
      expect(page).to have_content "já existe uma solicitação de compra pendente para este solicitante e material"
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

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_content 'Código/Ano'
      expect(page).to have_content 'Solicitante'
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
    item = PurchaseSolicitationItem.make!(:item, :material => Material.make!(:manutencao))
    PurchaseSolicitation.make!(:reparo,
                               :items => [item],
                               :kind => PurchaseSolicitationKind::SERVICES)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Material.make!(:office, :material_type => MaterialType::SERVICE)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Criar Solicitação de Compra"

    select "Serviços", :on => "Tipo de solicitação"

    within_tab 'Itens' do
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

    within_tab "Dotações orçamentárias" do
      fill_with_autocomplete 'Dotação', :with => 'Aposentadorias'

      click_button "Adicionar"
    end

    click_link "Voltar"

    click_link "Limpar Filtro"

    within_records do
      click_link "1/2012"
    end

    within_tab "Itens" do
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

  scenario 'should not allow duplicated materials' do
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:sobrinho)
    DeliveryLocation.make!(:education)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da solicitação', :with => '01/02/2012'
      fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Responsável pela solicitação', :with => '958473', :field => 'Matrícula'
      fill_in 'Justificativa da solicitação', :with => 'Novas cadeiras'
      fill_modal 'Local para entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      select 'Produtos', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'
    end

    within_tab 'Itens' do
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      click_button 'Adicionar Item'

      within '.item:first' do
        fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
        fill_in 'Marca/Referência', :with => 'Norton'
        fill_in 'Quantidade', :with => '2,0'
        fill_in 'Valor unitário', :with => '300,00'
      end
    end

    within_tab 'Dotações orçamentárias' do
      fill_with_autocomplete 'Dotação', :with => 'Aposentadorias'

      click_button "Adicionar"
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Itens' do
      within '.item:last' do
        expect(page).to have_content 'já está em uso'
      end
    end
  end

  scenario 'fill automatically budget structure from budget allocation' do
    pending 'quando rodo o teste sozinho ele passa e se rodo tudo falha' do
      BudgetAllocation.make!(:alocacao)
      BudgetAllocation.make!(:reparo_2011)

      navigate 'Processos de Compra > Solicitações de Compra'

      click_link 'Criar Solicitação de Compra'

      within_tab 'Principal' do
        fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      end

      within_tab 'Dotações orçamentárias' do
        within_autocomplete 'Dotação', :with => 'Compra de Material' do
          expect(page).to_not have_content 'Compra de Material'
        end
      end

      within_tab 'Principal' do
        clear_modal 'Solicitante'
      end

      within_tab 'Dotações orçamentárias' do
        within_autocomplete 'Dotação', :with => 'Compra de Material' do
          expect(page).to have_content 'Compra de Material'
        end
      end
    end
  end
end
