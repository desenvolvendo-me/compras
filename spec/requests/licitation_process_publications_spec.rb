# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessPublications" do
  background do
    sign_in
  end

  scenario 'index should have link to back to licitation_process and create a new publication' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Publicações'

    page.should have_link 'Voltar ao processo licitatório'
    page.should have_link 'Criar Publicação'
    page.should have_content "Publicações do Processo Licitatório #{licitation_process}"
  end

  scenario 'create a new publication' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Publicações'

    click_link 'Criar Publicação'

    page.should have_content "Criar Publicação para o Processo Licitatório #{licitation_process}"

    fill_in "Nome do veículo de comunicação", :with => 'Jornal'
    fill_in "Data da publicação", :with => '20/04/2012'
    select "Edital", :from => "Publicação do(a)"
    select "Internet", :from => "Tipo de circulação do veículo de comunicação"

    click_button 'Salvar'

    page.should have_notice 'Publicação criado com sucesso'

    within_records do
      click_link 'Jornal'
    end

    page.should have_field 'Nome do veículo de comunicação', :with => 'Jornal'
    page.should have_field 'Data da publicação', :with => '20/04/2012'
    page.should have_select 'Publicação do(a)', :selected => 'Edital'
  end

  scenario 'update an existing publication' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Publicações'

    within_records do
      click_link 'Publicacao'
    end

    page.should have_content "Editar Publicação Publicacao do Processo Licitatório #{licitation_process}"

    fill_in "Nome do veículo de comunicação", :with => 'Jornal'
    fill_in "Data da publicação", :with => '20/04/2012'
    select "Edital", :from => "Publicação do(a)"
    select "Internet", :from => "Tipo de circulação do veículo de comunicação"

    click_button 'Salvar'

    page.should have_notice 'Publicação editado com sucesso'

    within_records do
      click_link 'Jornal'
    end

    page.should have_field 'Nome do veículo de comunicação', :with => 'Jornal'
    page.should have_field 'Data da publicação', :with => '20/04/2012'
    page.should have_select 'Publicação do(a)', :selected => 'Edital'
  end

  scenario 'destroy a publication' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Publicações'

    within_records do
      click_link 'Publicacao'
    end

    click_link 'Apagar'

    page.should have_notice 'Publicação apagado com sucesso'

    page.should_not have_link 'Publicacao'
  end
end
