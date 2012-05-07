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

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Lotes de itens'

    page.should have_link lot.to_s

    click_link 'Voltar ao processo licitatório'

    page.should have_content "Editar #{licitation_process.to_s}"
  end

  scenario 'creating a new lot' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'observacoes teste'

    click_button 'Salvar'

    page.should have_content 'Lote de itens criado com sucesso.'

    within_records do
      click_link licitation_process.licitation_process_lots.last.to_s
    end

    page.should have_field 'Observações', :with => 'observacoes teste'
  end

  scenario 'updating an existing lot' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Lotes de itens'

    within_records do
      page.find('a').click
    end

    fill_in 'Observações', :with => 'novas observacoes'

    click_button 'Salvar'

    page.should have_content 'Lote de itens editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Observações', :with => 'novas observacoes'
  end

  scenario 'deleting a lot' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    lot = licitation_process.licitation_process_lots.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Lotes de itens'

    page.should have_link lot.to_s

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Lote de itens apagado com sucesso.'

    page.should_not have_link lot.to_s
  end
end
