# encoding: utf-8
require 'spec_helper'

feature "AdministrativeProcesses" do
  background do
    sign_in
  end

  scenario 'create a new administrative_process' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:global_com_menor_preco)
    Employee.make!(:sobrinho)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Status do processo administrativo'
      page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'

      fill_mask 'Ano', :with => '2012'
      fill_mask 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão presencial', :from => 'Modalidade'
      fill_modal 'Forma de julgamento', :with => 'Forma Global com Menor Preço', :field => 'Descrição'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Administrativo criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'
      page.should have_field 'Process', :with => '1'
      page.should have_disabled_field 'Ano'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data do processo', :with => '07/03/2012'
      page.should have_field 'Número do protocolo', :with => '00099/2012'
      page.should have_select 'Tipo de objeto', :selected => 'Compras e serviços'
      page.should have_select 'Modalidade', :selected => 'Pregão presencial'
      page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentárias' do
      page.should have_field 'Dotação orçamentária', :with => budget_allocation.to_s
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '20,00'

      page.should have_field 'Valor total', :with => '20,00'
    end
  end

  scenario 'should have all fields disabled on edit when status is different from waiting' do
    AdministrativeProcess.make!(:compra_liberada)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'
      page.should have_disabled_field 'Ano'
      page.should have_disabled_field 'Data do processo'
      page.should have_disabled_field 'Número do protocolo'
      page.should have_disabled_field 'Tipo de objeto'
      page.should have_disabled_field 'Modalidade'
      page.should have_disabled_field 'Forma de julgamento'
      page.should have_disabled_field 'Objeto do processo licitatório'
      page.should have_disabled_field 'Responsável'
      page.should have_disabled_field 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      page.should have_disabled_field 'Dotação orçamentária'
      page.should have_disabled_field 'Saldo da dotação'
      page.should have_disabled_field 'Valor previsto'

      page.should_not have_button 'Adicionar Dotação'
      page.should_not have_button 'Remover Dotação'
    end
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    BudgetAllocation.make!(:alocacao)
    administrative_process = AdministrativeProcess.make!(:compra_liberada)
    SignatureConfiguration.make!(:processo_administrativo)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Imprimir'

    page.should have_content administrative_process.to_s
    page.should have_content "00088/2012"
    page.should have_content "07/03/2012"
    page.should have_content "Excelentíssimo Sr. Márcio Lacerda"
    page.should have_content "Convite para compras e serviços de engenharia"
    page.should have_content "Compras e serviços"
    page.should have_content "Forma Global com Menor Preço"
    page.should have_content "Licitação para compra de carteiras"
    page.should have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
    page.should have_content 'Gabriel Sobrinho'
    page.should have_content 'Gerente'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content 'Supervisor'
  end

  scenario 'value calculation on budget allocations' do
    click_link 'Processos'

    click_link 'Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Dotações orçamentárias' do
      click_button 'Adicionar Dotação'

      fill_in 'Valor previsto', :with => '20,00'

      page.should have_field 'Valor total', :with => '20,00'

      click_button 'Adicionar Dotação'

      within 'div.administrative-process-budget-allocation:first' do
        fill_in 'Valor previsto', :with => '30,00'
      end

      page.should have_field 'Valor total', :with => '50,00'

      within 'div.administrative-process-budget-allocation:last' do
        click_button 'Remover Dotação'
      end

      page.should have_field 'Valor total', :with => '30,00'
    end
  end

  scenario 'asserting that duplicated budget allocations cannot be saved' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:global_com_menor_preco)
    Employee.make!(:sobrinho)
    budget_allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Status do processo administrativo'
      page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'

      fill_in 'Ano', :with => '2012'
      fill_mask 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão presencial', :from => 'Modalidade'
      fill_modal 'Forma de julgamento', :with => 'Forma Global com Menor Preço', :field => 'Descrição'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar Dotação'

      within 'div.administrative-process-budget-allocation:first' do
        fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
        fill_in 'Valor previsto', :with => '30,00'
      end
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentárias' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'update an existing administrative process' do
    AdministrativeProcess.make!(:compra_aguardando)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Status do processo administrativo'
      page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'

      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão presencial', :from => 'Modalidade'
      fill_modal 'Forma de julgamento', :with => 'Forma Global com Menor Preço', :field => 'Descrição'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras 2'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '30,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Administrativo editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'
      page.should have_field 'Process', :with => '1'
      page.should have_disabled_field 'Ano'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data do processo', :with => '07/03/2012'
      page.should have_field 'Número do protocolo', :with => '00099/2012'
      page.should have_select 'Tipo de objeto', :selected => 'Compras e serviços'
      page.should have_select 'Modalidade', :selected => 'Pregão presencial'
      page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras 2'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentárias' do
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '30,00'
    end
  end

  scenario 'should not have print button if status different from released' do
    AdministrativeProcess.make!(:compra_aguardando)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should_not have_select 'Status do processo administrativo', :selected => 'Liberado'
    page.should_not have_link 'Imprimir'
  end

  scenario 'should have print button if status equals released' do
     AdministrativeProcess.make!(:compra_liberada)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should have_select 'Status do processo administrativo', :selected => 'Liberado'
    page.should have_link 'Imprimir'
  end

  scenario "should have a release button when editing an administrative process with status waiting" do
    AdministrativeProcess.make!(:compra_aguardando)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'
    page.should have_button 'Liberar'
  end

  scenario "should not have a release button when editing an administrative process without status waiting" do
    AdministrativeProcess.make!(:compra_liberada)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should_not have_select 'Status do processo administrativo', :selected => 'Aguardando'
    page.should_not have_button 'Liberar'
  end

  scenario "releasing an administrative process" do
    AdministrativeProcess.make!(:compra_aguardando)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_button 'Liberar'

    page.should have_notice 'Processo Administrativo liberado com sucesso'
  end

  scenario "should have a annul button when editing an administrative process with status waiting" do
    AdministrativeProcess.make!(:compra_aguardando)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should have_select 'Status do processo administrativo', :selected => 'Aguardando'
    page.should have_button 'Anular'
  end

  scenario "should not have an annul button when editing an administrative process without status waiting" do
    AdministrativeProcess.make!(:compra_liberada)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should_not have_select 'Status do processo administrativo', :selected => 'Aguardando'
    page.should_not have_button 'Anular'
  end

  scenario "annuling an administrative process" do
    AdministrativeProcess.make!(:compra_aguardando)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_button 'Anular'

    page.should have_notice 'Processo Administrativo anulado com sucesso'
  end

  scenario "show new licitation process link" do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should have_link 'Novo processo licitatório'
  end

  scenario "show edit licitation process link" do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should have_link 'Editar processo licitatório'
  end

  scenario "should not have new licitation process link if not released" do
    AdministrativeProcess.make!(:compra_aguardando)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    page.should_not have_link 'Novo processo licitatório'
    page.should_not have_link 'Editar processo licitatório'
  end

  scenario "should not have a release and annull button at new" do
    click_link 'Processos'

    click_link 'Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    page.should_not have_button 'Anular'
    page.should_not have_button 'Liberar'
  end
end
