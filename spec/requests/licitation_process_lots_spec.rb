# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessLots" do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['licitation_processes', 'administrative_process_budget_allocation_items']
    sign_in
  end

  scenario 'accessing the lots and return to licitation process edit page' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    expect(page).to have_link 'Criar Lote de itens'

    click_link 'Voltar ao processo licitatório'

    expect(page).to have_content "Editar Processo de Compra 2/2013"
  end

  scenario 'creating a new lot' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'observacoes teste'
    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    expect(page).to have_notice 'Lote de itens criado com sucesso.'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_field 'Observações', :with => 'observacoes teste'
    expect(page).to have_content '01.01.00001 - Antivirus'
    expect(page).to have_content '10,00'
  end

  scenario 'should not show link to create a new lot if licitation process is not updatable' do
    LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)

    navigate 'Processos de Compra > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Lotes de itens'

    expect(page).to_not have_link 'Criar Lote de itens'
  end

  scenario 'should disable Salvar and Apagar buttons when updating a lot if licitation process is not updatable' do
    LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)

    navigate 'Processos de Compra > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Lotes de itens'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_disabled_element 'Salvar', :reason => "processo licitatório deste lote não pode ser alterado"
    expect(page).to have_disabled_element 'Apagar', :reason => "processo licitatório deste lote não pode ser alterado"
    expect(page).to_not have_button 'Remover'
  end

  scenario 'all fields should be disabled when updating a lot if licitation process is not updatable' do
    LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)

    navigate 'Processos de Compra > Processos Licitatórios'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Lotes de itens'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_disabled_field 'Observações'
    expect(page).to have_disabled_field 'Itens'
  end

  scenario 'updating an existing lot' do
    LicitationProcess.make!(:processo_licitatorio_canetas)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    within_records do
      click_link 'Lote 1'
    end

    fill_in 'Observações', :with => 'Arame'
    fill_modal 'Itens', :with => '1', :field => 'Quantidade'

    click_button 'Salvar'

    expect(page).to have_notice 'Lote de itens editado com sucesso.'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_field 'Observações', :with => 'Arame'
    expect(page).to have_content '01.01.00001 - Antivirus'
    expect(page).to have_content '02.02.00002 - Arame comum'
  end

  scenario 'deleting a lot' do
    LicitationProcess.make!(:processo_licitatorio_canetas)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    within_records do
      click_link 'Lote 1'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Lote de itens apagado com sucesso'

    within_records do
      expect(page).to_not have_link 'Lote 1'
    end
  end

  scenario 'edit an existing lot, search item, remove item and search item again' do
    LicitationProcess.make!(:processo_licitatorio_canetas)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    within_records do
      click_link 'Lote 1'
    end

    within_modal 'Itens' do
      click_button 'Pesquisar'

      expect(page).to_not have_content '01.01.00001 - Antivirus'
      expect(page).to have_content '02.02.00002 - Arame comum'

      click_record '02.02.00002 - Arame comum'
    end

    within_modal 'Itens' do
      click_button 'Pesquisar'

      expect(page).to_not have_content '01.01.00001 - Antivirus'
      expect(page).to_not have_content '02.02.00002 - Arame comum'
    end
  end

  scenario 'only items from administrative process that are not included by any lot must be available' do
    LicitationProcess.make!(:processo_licitatorio_canetas_sem_lote)
    AdministrativeProcessBudgetAllocationItem.make!(:item_arame_farpado)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'obs'

    within_modal 'Itens' do
      click_button 'Pesquisar'

      within_records do
        # item 'Arame farpado' is not part of the administrative process and should not appear
        expect(page).to_not have_content 'Arame farpado'

        expect(page).to have_content 'Antivirus'
        expect(page).to have_content 'Arame comum'
      end

      click_record '01.01.00001 - Antivirus'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Lote de itens criado com sucesso.'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_content 'Antivirus'

    within_modal 'Itens' do
      click_button 'Pesquisar'

      within_records do
        # item 'Arame farpado' is not part of the administrative process and should not appear
        expect(page).to_not have_content 'Arame farpado'

        # item 'Arame comum' is available and should appear
        expect(page).to have_content 'Arame comum'

        # item 'Antivirus' was taken and should not appear
        expect(page).to_not have_content 'Antivirus'
      end

      click_link 'Voltar'
    end

    # removing 'Antivirus' item
    click_button 'Remover'

    fill_modal 'Itens', :with => '02.02.00002 - Arame comum', :field => 'Material'

    click_button 'Salvar'

    expect(page).to have_notice 'Lote de itens editado com sucesso.'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_content 'Arame comum'

    within_modal 'Itens' do
      click_button 'Pesquisar'

      # item 'Arame farpado' is not part of the administrative process and should not appear
      expect(page).to_not have_content 'Arame farpado'

      # item 'Arame comum' was taken available and should not appear
      expect(page).to_not have_content 'Arame comum'

      # item 'Antivirus' is available now and should appear
      expect(page).to have_content 'Antivirus'
    end
  end

  scenario "index shoud have title Lotes de itens do Processo de Compra 2/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    expect(page).to have_content "Lotes de itens do Processo de Compra 2/2013"
  end

  scenario "edit shoud have title Editar Lotes de itens do Processo de Compra 2/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)
    AdministrativeProcessBudgetAllocationItem.make!(:item_arame_farpado)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'Lote especial'

    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_content "Editar Lote 1 do Processo de Compra 2/2013"
  end

  scenario "new shoud have title Criar Lotes de itens no Processo de Compra 2/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos Licitatórios'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    expect(page).to have_content "Criar Lote de itens no Processo de Compra 2/2013"
  end
end
