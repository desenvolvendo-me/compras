# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessLots" do
  background do
    sign_in
  end

  scenario 'accessing the lots and return to licitation process edit page' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    lot = licitation_process.licitation_process_lots.first

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    expect(page).to have_link 'Criar Lote de itens'

    expect(page).to have_link lot.to_s

    click_link 'Voltar ao processo licitatório'

    expect(page).to have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario 'creating a new lot' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'observacoes teste'
    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    expect(page).to have_content 'Lote de itens criado com sucesso.'

    within_records do
      click_link licitation_process.licitation_process_lots.last.to_s
    end

    expect(page).to have_field 'Observações', :with => 'observacoes teste'
    expect(page).to have_content '01.01.00001 - Antivirus'
    expect(page).to have_content '10,00'
  end


  scenario 'should not show link to create a new lot if licitation process is not updatable' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    expect(page).to_not have_link 'Criar Lote de itens'
  end

  scenario 'should not have Salvar neither Apagar buttons when updating a lot if licitation process is not updatable' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_button 'Apagar'
    expect(page).to_not have_button 'Remover'
  end

  scenario 'all fields should be disabled when updating a lot if licitation process is not updatable' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    within_records do
      page.find('a').click
    end

    expect(page).to have_disabled_field 'Observações'
    expect(page).to have_disabled_field 'Itens'
  end

  scenario 'updating an existing lot' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_canetas)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    within_records do
      page.find('a').click
    end

    fill_in 'Observações', :with => 'Arame'
    fill_modal 'Itens', :with => '1', :field => 'Quantidade'

    click_button 'Salvar'

    expect(page).to have_notice 'Lote de itens editado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Observações', :with => 'Arame'
    expect(page).to have_content '01.01.00001 - Antivirus'
    expect(page).to have_content '02.02.00002 - Arame comum'
  end

  scenario 'deleting a lot' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_canetas)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Lote de itens apagado com sucesso'

    within_records do
      expect(page).to_not have_css 'a'
    end
  end

  scenario 'edit an existing lot, search item, remove item and search item again' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_canetas)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    within_records do
      page.find('a').click
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
    licitation_process = LicitationProcess.make!(:processo_licitatorio_canetas_sem_lote)
    AdministrativeProcessBudgetAllocationItem.make!(:item_arame_farpado)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'obs'

    fill_modal 'Itens', :with => '', :field => 'Material' do
      click_button 'Pesquisar'

      # item 'Arame farpado' is not part of the administrative process and should not appear
      expect(page).to_not have_content 'Arame farpado'

      expect(page).to have_content 'Antivirus'
      expect(page).to have_content 'Arame comum'
    end

    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    expect(page).to have_content 'Lote de itens criado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_content 'Antivirus'

    fill_modal 'Itens', :with => '', :field => 'Material' do
      click_button 'Pesquisar'

      # item 'Arame farpado' is not part of the administrative process and should not appear
      expect(page).to_not have_content 'Arame farpado'

      # item 'Arame comum' is available and should appear
      expect(page).to have_content 'Arame comum'

      # item 'Antivirus' was taken and should not appear
      expect(page).to_not have_content 'Antivirus'
    end

    # removing 'Antivirus' item
    click_button 'Remover'

    fill_modal 'Itens', :with => '02.02.00002 - Arame comum', :field => 'Material'

    click_button 'Salvar'

    expect(page).to have_content 'Lote de itens editado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_content 'Arame comum'

    fill_modal 'Itens', :with => '', :field => 'Material' do
      click_button 'Pesquisar'

      # item 'Arame farpado' is not part of the administrative process and should not appear
      expect(page).to_not have_content 'Arame farpado'

      # item 'Arame comum' was taken available and should not appear
      expect(page).to_not have_content 'Arame comum'

      # item 'Antivirus' is available now and should appear
      expect(page).to have_content 'Antivirus'
    end
  end

  scenario "index shoud have title Lotes de itens do Processo Licitatório 1/2013" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    expect(page).to have_content "Lotes de itens do Processo Licitatório 1/2013"
  end

  scenario "edit shoud have title Editar Lotes de itens do Processo Licitatório 1/2013" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    AdministrativeProcessBudgetAllocationItem.make!(:item_arame_farpado)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'Lote especial'

    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    expect(page).to have_content "Editar Lote 1 do Processo Licitatório 1/2013"
  end

  scenario "new shoud have title Criar Lotes de itens no Processo Licitatório 1/2013" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    expect(page).to have_content "Criar Lote de itens no Processo Licitatório 1/2013"
  end
end
