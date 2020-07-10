require 'spec_helper'

feature "PurchaseSolicitations", vcr: { cassette_name: :purchase_solicitations } do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  let(:customer) { create(:customer, domain: 'compras.dev', name: 'Compras Dev') }

  background do
    sign_in
  end

  scenario 'create a new purchase_solicitation' do
    Employee.make!(:sobrinho)
    DeliveryLocation.make!(:education)
    Material.make!(:antivirus, :material_type => MaterialType::ASSET)
    Material.make!(:office, :material_type => MaterialType::ASSET)

    navigate 'Licitações > Solicitações de Compra'

    

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', disabled: true
      expect(page).to have_field 'Liberação', disabled: true
      expect(page).to have_field 'Por', disabled: true
      expect(page).to have_field 'Observações do atendimento', disabled: true
      expect(page).to have_field 'Justificativa para não atendimento', disabled: true
      expect(page).to have_field 'Status de atendimento', disabled: true

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
      fill_with_autocomplete 'Material', :with => 'Antivirus'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN', disabled: true

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '2,22'
      fill_in 'Valor unitário', :with => '0,22'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '0,49', disabled: true

      click_button 'Adicionar'

      fill_with_autocomplete 'Material', :with => 'Office'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN', disabled: true

      fill_in 'Marca/Referência', :with => 'MS Office'
      fill_in 'Quantidade', :with => '0,12'
      fill_in 'Valor unitário', :with => '121,22'

      # asserting calculated unit price of the item
      expect(page).to have_field 'Valor total', :with => '14,55', disabled: true

      expect(page).to have_field 'Valor total dos itens', :with => '15,04', disabled: true

      click_button 'Adicionar'

      within_records do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content 'Norton'
        expect(page).to have_content '2,22'
        expect(page).to have_content '0,22'
        expect(page).to have_content '0,49'
      end

      within_records do
        expect(page).to have_content '01.01.00002 - Office'
        expect(page).to have_content 'UN'
        expect(page).to have_content 'MS Office'
        expect(page).to have_content '0,12'
        expect(page).to have_content '121,22'
        expect(page).to have_content '14,55'
      end
    end

    within_tab 'Dotações orçamentárias' do
      click_button "Adicionar"

      expect(page).to_not have_css '.nested-record'
      fill_with_autocomplete 'Dotação', :with => 'Aplicações Diretas'
      fill_with_autocomplete 'Desdobramento', :with => 'Aposentadorias'

      expect(page).to have_field 'Natureza da despesa', :with => '3.1.90.00.00 - Aplicações Diretas',
        disabled: true
      expect(page).to have_field 'Saldo da dotação',:with => '0,00', disabled: true

      fill_in 'Valor estimado', :with => '100,00'

      click_button "Adicionar"

      within_records do
        expect(page).to have_content '12 - Aplicações Diretas'
        expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
        expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '0,00'
        expect(page).to have_content '100,00'
      end

      # Não pode adicionar 2 dotações iguais
      fill_with_autocomplete 'Dotação', :with => 'Aplicações Diretas'

      click_button "Adicionar"

      within_records do
        expect(page).to have_css '.nested-record', :count => 1
      end

    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '1', disabled: true
      expect(page).to have_field 'Ano', :with => '2012', disabled: true
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2012'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Solicitante', :with => '9 - Secretaria de Educação'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      expect(page).to have_field 'Local para entrega', :with => 'Secretaria da Educação'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Bens'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      expect(page).to have_select 'Status de atendimento', :selected => 'Pendente', disabled: true
    end

    within_tab 'Itens' do

      expect(page).to have_field 'Valor total dos itens', :with => '15,04', disabled: true

      within_records do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content 'Norton'
        expect(page).to have_content '2,22'
        expect(page).to have_content '0,22'
        expect(page).to have_content '0,49'
      end

      within_records do
        expect(page).to have_content '01.01.00002 - Office'
        expect(page).to have_content 'UN'
        expect(page).to have_content 'MS Office'
        expect(page).to have_content '0,12'
        expect(page).to have_content '121,22'
        expect(page).to have_content '14,55'
      end
    end

    within_tab 'Dotações orçamentárias' do
      within_records do
        expect(page).to have_content '12 - 3.1.90.00.00 - Aplicações Diretas'
        expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
        expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '0,00'
        expect(page).to have_content '100,00'
      end
    end
  end

  scenario 'update an existent purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo)
    Employee.make!(:wenderson)
    DeliveryLocation.make!(:health)
    Material.make!(:arame_farpado)

    navigate 'Licitações > Solicitações de Compra'

    

    within_records do
      page.find('a').click
    end

    expect(page).to have_subtitle '1/2012'

    expect(page).to_not have_link 'Apagar'
    expect(page).to have_field 'Ano', disabled: true

    within_tab 'Principal' do
      fill_in 'Data da solicitação', :with => '01/02/2013'
      fill_modal 'Responsável pela solicitação', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_in 'Justificativa da solicitação', :with => 'Novas mesas'
      fill_modal 'Local para entrega', :with => 'Secretaria da Saúde', :field => "Descrição"
      select 'Produtos', :from => 'Tipo de solicitação'
      fill_in 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Itens' do
      fill_with_autocomplete 'Material', :with => 'Arame farpado'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN', disabled: true

      fill_in 'Marca/Referência', :with => 'Ferro SA'
      fill_in 'Quantidade', :with => '200,00'
      fill_in 'Valor unitário', :with => '25,00'

      # asserting calculated unit price of the item
      expect(page).to have_field 'Valor total', :with => '5.000,00', disabled: true

      expect(page).to have_field 'Valor total dos itens', :with => '5.600,00', disabled: true

      click_button 'Adicionar'

      within_records do
        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'UN'
          expect(page).to have_content 'Norton'
          expect(page).to have_content '3,00'
          expect(page).to have_content '200,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content '02.02.00001 - Arame farpado'
          expect(page).to have_content 'UN'
          expect(page).to have_content 'Ferro SA'
          expect(page).to have_content '200,00'
          expect(page).to have_content '25,00'
          expect(page).to have_content '5.000,00'
        end
      end

      expect(page).to have_field 'Valor total dos itens', :with => '5.600,00', disabled: true
    end

    within_tab 'Dotações orçamentárias' do
      within_records do
        click_link "Remover"
      end

      fill_with_autocomplete 'Dotação', :with => 'Aplicações Diretas'
      fill_with_autocomplete 'Desdobramento', :with => 'Reserva'

      click_button "Adicionar"

      within_records do
        expect(page).to have_content '12 - Aplicações Diretas'
        expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
        expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '0,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 1/2012 editada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '1', disabled: true
      expect(page).to have_field 'Ano', :with => '2012', disabled: true
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2013'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Solicitante', :with => '9 - Secretaria de Educação'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas mesas'
      expect(page).to have_field 'Local para entrega', :with => 'Secretaria da Saúde'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Produtos'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas mesas estão quebrando no escritório'
    end

    within_tab 'Itens' do
      within_records do
        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'UN'
          expect(page).to have_content 'Norton'
          expect(page).to have_content '3,00'
          expect(page).to have_content '200,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content '02.02.00001 - Arame farpado'
          expect(page).to have_content 'UN'
          expect(page).to have_content 'Ferro SA'
          expect(page).to have_content '200,00'
          expect(page).to have_content '25,00'
          expect(page).to have_content '5.000,00'
        end
      end

      expect(page).to have_field 'Valor total dos itens', :with => '5.600,00', disabled: true
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_css('.records .record', :count => 1)

      within_records do
        expect(page).to have_content '12 - 3.1.90.00.00 - Aplicações Diretas'
        expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
        expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
        expect(page).to have_content '0,00'
      end
    end
  end

  scenario 'should validate presence of items when editing' do
    PurchaseSolicitation.make!(:reparo)

    navigate 'Licitações > Solicitações de Compra'

    

    within_records do
      page.find('a').click
    end

    within_tab 'Itens' do
      within_records do
        within 'tbody tr:nth-child(1)' do
          click_link 'Remover'
        end
      end
    end

    click_button 'Salvar'

    # expect(page).to_not have_notice 'Solicitação de Compra 1/2012 editada com sucesso.'

    within_tab 'Itens' do
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'calculate total value of items' do
    Material.make!(:antivirus, :material_type => MaterialType::CONSUMPTION)
    Material.make!(:arame_farpado, :material_type => MaterialType::CONSUMPTION)

    navigate 'Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      select 'Produtos', :from => 'Tipo de solicitação'
    end

    within_tab 'Itens' do
      expect(page).to have_field 'Valor total dos itens', disabled: true

      fill_with_autocomplete 'Material', :with => 'Antivirus'
      fill_in 'Quantidade', :with => '3,00'
      fill_in 'Valor unitário', :with => '10,00'

      expect(page).to have_field 'Valor total', :with => '30,00', disabled: true

      click_button 'Adicionar'

      expect(page).to have_field 'Valor total dos itens', :with => '30,00', disabled: true

      fill_with_autocomplete 'Material', :with => 'Arame'
      fill_in 'Quantidade', :with => '5,00'
      fill_in 'Valor unitário', :with => '2,00'

      expect(page).to have_field 'Valor total', :with => '10,00', disabled: true

      click_button 'Adicionar'

      expect(page).to have_field 'Valor total dos itens', :with => '40,00', disabled: true

      within_records do
        within 'tbody tr:nth-child(1)' do
          click_link 'Remover'
        end
      end

      expect(page).to have_field 'Valor total dos itens', :with => '10,00', disabled: true
    end
  end

  scenario 'create a new purchase_solicitation with the same accouting year the code should be increased by 1' do
    PurchaseSolicitation.make!(:reparo)
    Employee.make!(:sobrinho)
    DeliveryLocation.make!(:education)
    Material.make!(:office, :material_type => MaterialType::ASSET)

    navigate 'Licitações > Solicitações de Compra'

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
      fill_with_autocomplete 'Material', :with => 'Office'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,00'
      fill_in 'Valor unitário', :with => '200,00'

      click_button 'Adicionar'
    end

    within_tab 'Dotações orçamentárias' do
      fill_with_autocomplete 'Dotação', :with => 'Aplicações Diretas'

      click_button "Adicionar"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Solicitação de Compra 2/2012 criada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Código', :with => '2', disabled: true
      expect(page).to have_field 'Ano', :with => '2012', disabled: true
      expect(page).to have_field 'Data da solicitação', :with => '01/02/2012'
      expect(page).to have_field 'Responsável pela solicitação', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Solicitante', :with => '9 - Secretaria de Educação'
      expect(page).to have_field 'Justificativa da solicitação', :with => 'Novas cadeiras'
      expect(page).to have_field 'Local para entrega', :with => 'Secretaria da Educação'
      expect(page).to have_select 'Tipo de solicitação', :selected => 'Bens'
      expect(page).to have_field 'Observações gerais', :with => 'Muitas cadeiras estão quebrando no escritório'

      # Testing the pending status applied automatically
      expect(page).to have_select 'Status de atendimento', :selected => 'Pendente', disabled: true
    end

    within_tab 'Itens' do
      within_records do
        expect(page).to have_content '01.01.00002 - Office'
        expect(page).to have_content 'UN'
        expect(page).to have_content 'Norton'
        expect(page).to have_content '3,00'
        expect(page).to have_content '200,00'
        expect(page).to have_content '600,00'
      end
    end

    within_tab 'Dotações orçamentárias' do
      within_records do
        expect(page).to have_content "Aplicações Diretas"
      end
    end
  end

  scenario 'should not show edit button when is not editable' do
    PurchaseSolicitation.make!(:reparo_liberado)

    navigate 'Licitações > Solicitações de Compra'

    

    within_records do
      page.find('a').click
    end

    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'esta solicitação já está em uso ou anulada e não pode ser editada'
  end

  scenario 'should show edit button when is returned' do
    PurchaseSolicitation.make!(:reparo,
                               :service_status => PurchaseSolicitationServiceStatus::RETURNED)

    navigate 'Licitações > Solicitações de Compra'

    

    within_records do
      page.find('a').click
    end

    expect(page).to have_button 'Salvar'
  end

  scenario 'create a new purchase_solicitation with same budget_structure and material' do
    PurchaseSolicitation.make!(:reparo, budget_structure_id: 2,
      purchase_solicitation_budget_allocations: [
        PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria,
          budget_allocation_id: 2)])

    Employee.make!(:sobrinho)
    DeliveryLocation.make!(:education)

    navigate 'Licitações > Solicitações de Compra'

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
      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,00'
      fill_in 'Valor unitário', :with => '200,00'

      click_button 'Adicionar'
    end

    within_tab 'Dotações orçamentárias' do
      fill_with_autocomplete 'Dotação', :with => 'Aplicações Diretas'

      click_button "Adicionar"
    end

    click_button 'Salvar'

    expect(page).to have_no_notice 'Solicitação de Compra 2/2012 criada com sucesso.'

    expect(page).to have_content "já existe uma solicitação de compra pendente para este solicitante (9 - Secretaria de Educação) e material (01.01.00001 - Antivirus)"
  end

  scenario 'update a purchase_solicitation with same budget_structure and material' do
    PurchaseSolicitation.make!(:reparo)
    purchase_solicitation = PurchaseSolicitation.make!(:reparo_2013,
                                                       :service_status => PurchaseSolicitationServiceStatus::PENDING,
                                                       :kind => PurchaseSolicitationKind::PRODUCTS)

    navigate 'Licitações > Solicitações de Compra'

    

    within_records do
      click_link purchase_solicitation.decorator.code_and_year
    end

    within_tab 'Itens' do
      within_records do
        within 'tbody tr:nth-child(1)' do
          click_link 'Remover'
        end
      end

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,00'
      fill_in 'Valor unitário', :with => '200,00'

      click_button 'Adicionar'
    end

    click_button 'Salvar'

    expect(page).to have_no_notice 'Solicitação de Compra 1/2012 criada com sucesso.'

    expect(page).to have_content "já existe uma solicitação de compra pendente para este solicitante (1 - Detran) e material (01.01.00001 - Antivirus)"
  end

  scenario 'provide purchase solicitation search by code and responsible' do
    PurchaseSolicitation.make!(:reparo)

    navigate 'Licitações > Solicitações de Compra'

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

    navigate 'Licitações > Solicitações de Compra'

    

    within_records do
      expect(page).to have_content 'Código/Ano'
      expect(page).to have_content 'Solicitante'
      expect(page).to have_content 'Responsável pela solicitação'
      expect(page).to have_content 'Status de atendimento'

      within 'tbody tr' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Pendente'
      end
    end
  end

  scenario "purchase of services" do
    Timecop.travel(Date.new(2012, 10, 10))
    item = PurchaseSolicitationItem.make!(:item, :material => Material.make!(:manutencao))
    PurchaseSolicitation.make!(:reparo,
                               :items => [item],
                               :kind => PurchaseSolicitationKind::SERVICES)
    Material.make!(:antivirus)
    Material.make!(:office, :material_type => MaterialType::SERVICE)

    navigate 'Licitações > Solicitações de Compra'

    click_link "Criar Solicitação de Compra"

    select "Serviços", :from => "Tipo de solicitação"

    within_tab 'Itens' do
      within_autocomplete "Serviço", :with => "Manutenção de Computadores" do
        expect(page).to have_content 'Manutenção de Computadores'
      end
    end

    within_tab "Dotações orçamentárias" do
      fill_with_autocomplete 'Dotação', :with => 'Aplicações Diretas'

      click_button "Adicionar"
    end

    click_link "Voltar"

    

    within_records do
      click_link "1/2012"
    end

    within_tab "Itens" do
      within_autocomplete "Serviço", :with => "Manutenção de Computadores" do
        expect(page).to have_content 'Manutenção de Computadores'
      end
    end
    Timecop.return
  end

  scenario 'should not allow duplicated materials' do
    Material.make!(:antivirus)

    navigate 'Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Principal' do
      select 'Produtos', :from => 'Tipo de solicitação'
    end

    within_tab 'Itens' do
      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content 'Norton'
        expect(page).to have_content '3,50'
        expect(page).to have_content '200,00'
        expect(page).to have_content '700,00'
      end

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_css('.nested-record', :count => 1)
      end
    end
  end

  scenario 'fill automatically budget structure from budget allocation' do
    pending 'quando rodo o teste sozinho ele passa e se rodo tudo falha' do
      navigate 'Licitações > Solicitações de Compra'

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

  scenario 'testing javascript when select kind is empty' do
    Material.make!(:antivirus, :material_type => MaterialType::ASSET)

    navigate 'Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    within_tab 'Itens' do
      expect(page).to have_disabled_element 'Material', :reason => "Escolha um tipo de solicitação primeiro"
    end

    within_tab 'Principal' do
      select 'Bens', :from => 'Tipo de solicitação'
    end

    within_tab 'Itens' do
      fill_with_autocomplete 'Material', :with => 'Antivirus'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN', disabled: true

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '700,00', disabled: true

      click_button 'Adicionar'

      within_records do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content 'Norton'
        expect(page).to have_content '3,50'
        expect(page).to have_content '200,00'
        expect(page).to have_content '700,00'
      end
    end
  end
end
