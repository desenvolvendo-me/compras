# encoding: utf-8
require 'spec_helper'

feature "PurchaseSolicitationItemGroups" do
  background do
    sign_in
  end

  scenario 'create a new purchase_solicitation_item_group' do
    PurchaseSolicitation.make!(:reparo_liberado)

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    fill_in 'Descrição', :with => 'Agrupamento de antivirus'

    expect(page).to have_disabled_field "Situação"

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
    fill_modal 'Solicitações de compra', :with => '2012', :field => 'Ano'

    click_button 'Salvar'

    expect(page).to have_notice 'Agrupamento de Item de Solicitação de Compra criado com sucesso.'

    click_link 'Agrupamento de antivirus'

    expect(page).to have_select "Situação", :selected => "Pendente"
    expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'

    within '.records' do
      expect(page).to have_content '1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
      expect(page).to have_content '3'
    end

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_select 'Status', :selected => 'Agrupado'
      expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de antivirus'
    end

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    click_button 'Remover'

    click_button 'Salvar'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_select 'Status', :selected => 'Pendente'
      expect(page).to have_field 'Agrupamento', :with => ''
    end

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    fill_modal 'Solicitações de compra', :with => '2012', :field => 'Ano'

    click_button 'Salvar'

    expect(page).to have_notice 'Agrupamento de Item de Solicitação de Compra editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_select 'Status', :selected => 'Agrupado'
      expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de antivirus'
    end
  end

  scenario 'update an existent purchase_solicitation_item_group' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Agrupamento de reparo 2013'

    expect(page).to_not have_link 'Apagar'

    expect(page).to have_disabled_field "Situação"
    expect(page).to have_select "Situação", :selected => "Pendente"

    click_button 'Remover Material'

    click_button 'Salvar'

    expect(page).to have_notice 'Agrupamento de Item de Solicitação de Compra editado com sucesso.'

    click_link 'Agrupamento de reparo 2013'

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'
    fill_modal 'Solicitações de compra', :with => '2013', :field => 'Ano'

    click_button 'Salvar'

    expect(page).to have_notice 'Agrupamento de Item de Solicitação de Compra editado com sucesso.'

    click_link 'Agrupamento de reparo 2013'

    expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'

    within '.records' do
      expect(page).to have_content '1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
      expect(page).to have_content '99'
    end
  end

  scenario 'validating modal of purchase solicitation' do
    pending 'is not possible to simulate the event focus of a modal on nested.'
    PurchaseSolicitation.make!(:reparo)
    PurchaseSolicitation.make!(:reparo_2013)

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

    page.execute_script 'purchaseSolicitationModalUrl();'

    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      expect(page).to have_content '2012'
      expect(page).to have_css 'table.records tbody tr', :count => 2

      fill_in 'Ano', :with => '2012'

      click_button 'Pesquisar'
      click_record '2012'
    end

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a purchase solicitation cannot be seletected twice
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      expect(page).to have_content '2013'
      expect(page).to have_css 'table.records tbody tr', :count => 1

      fill_in 'Ano', :with => '2013'

      click_button 'Pesquisar'
      click_record '2013'
    end

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a purchase solicitation cannot be seletected twice
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      expect(page).to_not have_css 'table.records tbody tr'

      click_link 'Voltar'
    end

    click_button 'Salvar'
    click_link '1'

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a purchase solicitation cannot be seletected twice
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      expect(page).to_not have_css 'table.records tbody tr'

      click_link 'Voltar'
    end

    within 'table.records' do
      click_button 'Remover'
    end

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a purchase solicitation removed can be seletected again
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      expect(page).to have_content '2012'
      expect(page).to have_css 'table.records tbody tr', :count => 1

      fill_in 'Ano', :with => '2012'

      click_button 'Pesquisar'
      click_record '2012'
    end

    within 'table.records' do
      click_button 'Remover'
      click_button 'Remover'
    end

    page.execute_script 'purchaseSolicitationModalUrl();'

    # asserting that a removing all purchase solicitation, all can be seletect again
    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      expect(page).to have_css 'table.records tbody tr', :count => 2
    end
  end

  scenario 'filter by material' do
    PurchaseSolicitationItemGroup.make!(:reparo_arame_farpado)
    PurchaseSolicitationItemGroup.make!(:antivirus_desenvolvimento)

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      expect(page).to have_css('a', :count => 2)
    end

    click_link 'Filtrar Agrupamentos de Itens de Solicitações de Compra'

    fill_modal 'Material', :field => 'Descrição', :with => 'Antivirus'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_css('a', :count => 1)
    end
  end

  scenario 'filter by purchase_solicitation' do
    PurchaseSolicitationItemGroup.make!(:reparo_arame_farpado)
    PurchaseSolicitationItemGroup.make!(:antivirus_desenvolvimento)

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      expect(page).to have_css('a', :count => 2)
    end

    click_link 'Filtrar Agrupamentos de Itens de Solicitações de Compra'

    fill_modal 'Solicitação de compra', :field => 'Ano', :with => '2012'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_css('a', :count => 1)
    end
  end

  scenario 'disable fields and hiden buttons when not editable' do
    PurchaseSolicitationItemGroup.make!(
      :antivirus,
      :licitation_process => LicitationProcess.make!(:processo_licitatorio)
    )

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Agrupamento de antivirus'

    expect(page).to have_disabled_field 'Material'
    expect(page).to have_disabled_field 'Solicitações de compra'

    expect(page).to have_disabled_element 'Adicionar Material',
                    :reason => 'este agrupamento já está em uso e não pode ser editado'
    expect(page).to have_disabled_element 'Remover Material',
                    :reason => 'este agrupamento já está em uso e não pode ser editado'
    expect(page).to have_disabled_element 'Remover',
                    :reason => 'este agrupamento já está em uso e não pode ser editado'
    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'este agrupamento já está em uso e não pode ser editado'
  end

  scenario 'a purchase solicitation with a status other than "Liberated" may not compose a group' do
    item_1 = PurchaseSolicitationBudgetAllocationItem.make(:item, :quantity => 10)
    item_2 = PurchaseSolicitationBudgetAllocationItem.make(:item, :quantity => 20)

    allocation_1 = PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria,
                                                            :items => [item_1])
    allocation_2 = PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_2013,
                                                            :items => [item_2])
    PurchaseSolicitation.make!(:reparo_liberado,
                               :purchase_solicitation_budget_allocations => [allocation_1])
    PurchaseSolicitation.make!(:reparo_desenvolvimento,
                               :service_status => PurchaseSolicitationServiceStatus::PENDING,
                               :purchase_solicitation_budget_allocations => [allocation_2])

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    fill_in 'Descrição', :with => 'Agrupamento de antivirus'

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

    within_modal 'Solicitações de compra' do
      click_button 'Pesquisar'

      within '.records' do
        expect(page).to have_content 'Secretaria de Educação'
        expect(page).to_not have_content 'Secretaria de Desenvolvimento'
      end
    end
  end

  scenario 'only purchase solicitations with pending items may compose a group' do
    item = PurchaseSolicitationBudgetAllocationItem.make(:item,
                                                         :status => 'grouped')
    grouped_allocation = PurchaseSolicitationBudgetAllocation.make(:alocacao_primaria,
                                                                   :items => [item])
    PurchaseSolicitation.make!(:reparo_liberado,
                               :purchase_solicitation_budget_allocations => [grouped_allocation])

    ungrouped_allocation = PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria)
    PurchaseSolicitation.make!(:reparo_2013,
                               :budget_structure => BudgetStructure.make!(:secretaria_de_desenvolvimento),
                               :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
                               :purchase_solicitation_liberations => [PurchaseSolicitationLiberation.make(:reparo)],
                               :purchase_solicitation_budget_allocations => [ungrouped_allocation])

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    fill_in 'Descrição', :with => 'Agrupamento de antivirus'

    click_button 'Adicionar Material'

    fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

    within_modal 'Solicitações de compra' do
      click_button 'Pesquisar'

      within '.records' do
        expect(page).to_not have_content '2012'
        expect(page).to have_content '2013'
      end
    end
  end

  scenario 'index with columns at the index' do
    PurchaseSolicitationItemGroup.make!(:reparo_arame_farpado)
    PurchaseSolicitationItemGroup.make!(:antivirus_desenvolvimento)

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Situação'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Agrupamento de antivirus desenvolvimento'
        expect(page).to have_content 'Pendente'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Agrupamento de arame farpado'
        expect(page).to have_content 'Pendente'
      end
    end
  end
end
