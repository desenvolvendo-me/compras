# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessLots" do
  background do
    sign_in
  end

  scenario 'accessing the lots and return to licitation process edit page' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    lot = licitation_process.licitation_process_lots.first

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    page.should have_link lot.to_s

    click_link 'Voltar ao processo licitatório'

    page.should have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario 'creating a new lot' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'observacoes teste'
    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    page.should have_content 'Lote de itens criado com sucesso.'

    within_records do
      click_link licitation_process.licitation_process_lots.last.to_s
    end

    page.should have_field 'Observações', :with => 'observacoes teste'
    page.should have_content '01.01.00001 - Antivirus'
    page.should have_content '10,00'
  end

  scenario 'updating an existing lot' do
    pending "validation for itens/administrative_process prevents the creation of a lot on blueprints"
  end

  scenario 'deleting a lot' do
    pending "validation for itens/administrative_process prevents the creation of a lot on blueprints"
  end

  scenario 'only items from administrative process that are not included by any lot must be available' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_canetas)
    AdministrativeProcessBudgetAllocationItem.make!(:item_arame_farpado)

    click_link 'Processos'

    click_link 'Processos Administrativos'

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
      page.should_not have_content 'Arame farpado'

      page.should have_content 'Antivirus'
      page.should have_content 'Arame comum'
    end

    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    page.should have_content 'Lote de itens criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_content 'Antivirus'

    fill_modal 'Itens', :with => '', :field => 'Material' do
      click_button 'Pesquisar'

      # item 'Arame farpado' is not part of the administrative process and should not appear
      page.should_not have_content 'Arame farpado'

      # item 'Arame comum' is available and should appear
      page.should have_content 'Arame comum'

      # item 'Antivirus' was taken and should not appear
      page.should_not have_content 'Antivirus'
    end

    # removing 'Antivirus' item
    click_button 'Remover'

    fill_modal 'Itens', :with => '02.02.00002 - Arame comum', :field => 'Material'

    click_button 'Salvar'

    page.should have_content 'Lote de itens editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_content 'Arame comum'

    fill_modal 'Itens', :with => '', :field => 'Material' do
      click_button 'Pesquisar'

      # item 'Arame farpado' is not part of the administrative process and should not appear
      page.should_not have_content 'Arame farpado'

      # item 'Arame comum' was taken available and should not appear
      page.should_not have_content 'Arame comum'

      # item 'Antivirus' is available now and should appear
      page.should have_content 'Antivirus'
    end
  end

  scenario "index shoud have title Lotes de itens do Processo Licitatório 1/2013" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    page.should have_content "Lotes de itens do Processo Licitatório 1/2013"
  end

  scenario "edit shoud have title Editar Lotes de itens do Processo Licitatório 1/2013" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'Lote especial'

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should have_content "Editar Lote 1 do Processo Licitatório 1/2013"
  end

  scenario "new shoud have title Criar Lotes de itens no Processo Licitatório 1/2013" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    page.should have_content "Criar Lote de itens no Processo Licitatório 1/2013"
  end
end
