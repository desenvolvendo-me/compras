# encoding: utf-8
require 'spec_helper'

feature "AdministrativeProcesses" do
  background do
    sign_in
  end

  scenario 'create a new administrative_process' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)
    LicitationModality.make!(:pregao_presencial)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    expect(page).to be_on_tab 'Principal'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Status do processo administrativo'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      fill_modal 'Modalidade', :with => 'Pregão presencial', :field => 'Modalidade'
      fill_modal 'Forma de julgamento', :with => 'Por Item com Melhor Técnica', :field => 'Descrição'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentarias' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'
      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_field 'Process', :with => '1'
      expect(page).to have_disabled_field 'Ano'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data do processo', :with => '07/03/2012'
      expect(page).to have_field 'Número do protocolo', :with => '00099/2012'
      expect(page).to have_select 'Tipo de objeto', :selected => 'Compras e serviços'
      expect(page).to have_field 'Modalidade', :with => 'Pregão presencial'
      expect(page).to have_field 'Forma de julgamento', :with => 'Por Item com Melhor Técnica'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '20,00'

      expect(page).to have_field 'Valor total', :with => '20,00'
    end
  end

  scenario 'fill budget allocations from purchase solicitation item group' do
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)
    PurchaseSolicitationItemGroup.make!(:reparo_2013)
    LicitationModality.make!(:pregao_presencial)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end

      fill_modal 'Modalidade', :with => 'Pregão presencial', :field => 'Modalidade'
      fill_modal 'Forma de julgamento', :with => 'Por Item com Melhor Técnica', :field => 'Descrição'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'

      expect(page).to have_disabled_field 'Dotação orçamentaria'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      fill_in 'Valor previsto', :with => '20,00'

      expect(page).to have_field 'Valor total', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_field 'Process', :with => '1'
      expect(page).to have_disabled_field 'Ano'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data do processo', :with => '07/03/2012'
      expect(page).to have_field 'Número do protocolo', :with => '00099/2012'
      expect(page).to have_select 'Tipo de objeto', :selected => 'Compras e serviços'
      expect(page).to have_field 'Modalidade', :with => 'Pregão presencial'
      expect(page).to have_field 'Forma de julgamento', :with => 'Por Item com Melhor Técnica'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'

      expect(page).to have_disabled_field 'Dotação orçamentaria'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      expect(page).to have_field 'Valor previsto', :with => '20,00'

      expect(page).to have_field 'Valor total', :with => '20,00'
    end
  end

  scenario 'when clear purchase solicitation item group budget allocations should clear too' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'

      expect(page).to have_disabled_field 'Dotação orçamentaria'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
    end

    within_tab 'Principal' do
      clear_modal 'Agrupamento de solicitações de compra'
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to have_button 'Adicionar Dotação'

      expect(page).to_not have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to_not have_field 'Saldo da dotação', :with => '500,00'
    end
  end

  scenario 'when has budget allocations and select a purchase solicitation item group should clear old budget allocations' do
    BudgetAllocation.make!(:alocacao)
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Dotações orçamentarias' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'
      fill_in 'Valor previsto', :with => '20,00'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'

      expect(page).to_not have_field 'Dotação orçamentaria', :with => ''
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to_not have_field 'Valor previsto', :with => '20,00'

      expect(page).to_not have_field 'Valor total', :with => '20,00'
    end
  end

  scenario 'should have all fields disabled on edit when status is different from waiting' do
    AdministrativeProcess.make!(:compra_liberada)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_disabled_field 'Ano'
      expect(page).to have_disabled_field 'Data do processo'
      expect(page).to have_disabled_field 'Número do protocolo'
      expect(page).to have_disabled_field 'Tipo de objeto'
      expect(page).to have_disabled_field 'Modalidade'
      expect(page).to have_disabled_field 'Forma de julgamento'
      expect(page).to have_disabled_field 'Objeto do processo licitatório'
      expect(page).to have_disabled_field 'Responsável'
      expect(page).to have_disabled_field 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to have_disabled_field 'Dotação orçamentaria'
      expect(page).to have_disabled_field 'Saldo da dotação'
      expect(page).to have_disabled_field 'Valor previsto'

      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'
    end
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    BudgetAllocation.make!(:alocacao)
    modality = LicitationModality.make!(:privada,
                                        :description => "Convite para compras e serviços")
    administrative_process = AdministrativeProcess.make!(:compra_liberada,
                                                         :licitation_modality => modality)
    SignatureConfiguration.make!(:processo_administrativo)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Solicitação de abertura de processo licitatório'

    expect(page).to have_content administrative_process.to_s
    expect(page).to have_content "00088/2012"
    expect(page).to have_content "07/03/2012"
    expect(page).to have_content "Excelentíssimo Sr. Márcio Lacerda"
    expect(page).to have_content "Convite para compras e serviços"
    expect(page).to have_content "Compras e serviços"
    expect(page).to have_content "Por Item com Melhor Técnica"
    expect(page).to have_content "Licitação para compra de carteiras"
    expect(page).to have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
    expect(page).to have_content 'Gabriel Sobrinho'
    expect(page).to have_content 'Gerente'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Supervisor'
    expect(page).to have_content '1 - Alocação'
  end

  scenario 'value calculation on budget allocations' do
    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Dotações orçamentarias' do
      click_button 'Adicionar Dotação'

      fill_in 'Valor previsto', :with => '20,00'

      expect(page).to have_field 'Valor total', :with => '20,00'

      click_button 'Adicionar Dotação'

      within 'div.nested-administrative-process-budget-allocation:first' do
        fill_in 'Valor previsto', :with => '30,00'
      end

      expect(page).to have_field 'Valor total', :with => '50,00'

      within 'div.nested-administrative-process-budget-allocation:last' do
        click_button 'Remover Dotação'
      end

      expect(page).to have_field 'Valor total', :with => '30,00'
    end
  end

  scenario 'asserting that duplicated budget allocations cannot be saved' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    LicitationModality.make!(:pregao_presencial)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Status do processo administrativo'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      fill_modal 'Modalidade', :with => 'Pregão presencial', :field => 'Modalidade'
      fill_modal 'Forma de julgamento', :with => 'Por Item com Melhor Técnica', :field => 'Descrição'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentarias' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'
      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar Dotação'

      within 'div.nested-administrative-process-budget-allocation:first' do
        fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'
        fill_in 'Valor previsto', :with => '30,00'
      end
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentarias' do
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'update an existing administrative process' do
    JudgmentForm.make!(:por_lote_com_melhor_tecnica)
    AdministrativeProcess.make!(:compra_aguardando)
    LicitationModality.make!(:pregao_presencial)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Status do processo administrativo'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'

      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      fill_modal 'Modalidade', :with => 'Pregão presencial', :field => 'Modalidade'
      fill_modal 'Forma de julgamento', :with => 'Por Lote com Melhor Técnica', :field => 'Descrição'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras 2'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentarias' do
      fill_in 'Valor previsto', :with => '30,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_field 'Process', :with => '1'
      expect(page).to have_disabled_field 'Ano'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data do processo', :with => '07/03/2012'
      expect(page).to have_field 'Número do protocolo', :with => '00099/2012'
      expect(page).to have_select 'Tipo de objeto', :selected => 'Compras e serviços'
      expect(page).to have_field 'Modalidade', :selected => 'Pregão presencial'
      expect(page).to have_field 'Forma de julgamento', :with => 'Por Lote com Melhor Técnica'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras 2'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '30,00'
    end
  end

  scenario 'should not have print button if status different from released' do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_select 'Status do processo administrativo', :selected => 'Liberado'
    expect(page).to_not have_link 'Solicitação de abertura de processo licitatório'
  end

  scenario 'should have print button if status equals released' do
     AdministrativeProcess.make!(:compra_liberada)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Liberado'
    expect(page).to have_link 'Solicitação de abertura de processo licitatório'
  end

  scenario "should have a release button when editing an administrative process with status waiting" do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to have_link 'Liberar'
  end

  scenario "should not have a release button when editing an administrative process without status waiting" do
    AdministrativeProcess.make!(:compra_liberada)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to_not have_link 'Liberar'
  end

  scenario "should have a annul button when editing an administrative process with status waiting" do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to have_button 'Anular'
  end

  scenario "should not have an annul button when editing an administrative process without status waiting" do
    AdministrativeProcess.make!(:compra_liberada)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to_not have_button 'Anular'
  end

  scenario "annuling an administrative process" do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_button 'Anular'

    expect(page).to have_notice 'Processo Administrativo anulado com sucesso'
  end

  scenario "show new licitation process link" do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_link 'Novo processo licitatório'
  end

  scenario "show edit licitation process link" do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_link 'Editar processo licitatório'
  end

  scenario "should not have new licitation process link if not released" do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_link 'Novo processo licitatório'
    expect(page).to_not have_link 'Editar processo licitatório'
  end

  scenario "should not have a release and annull button at new" do
    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    expect(page).to_not have_button 'Anular'
    expect(page).to_not have_button 'Liberar'
  end

  scenario 'should not have licitation_process button if not allow licitation_process' do
    AdministrativeProcess.make!(:maior_lance_por_itens)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_link 'Novo processo licitatório'
  end

  scenario 'should show only purchase_solicitation_item_group not annulled' do
    PurchaseSolicitationItemGroup.make!(:antivirus)

    ResourceAnnul.make!(:anulacao_generica,
                        :annullable => PurchaseSolicitationItemGroup.make!(:reparo_2013))

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        within_records do
          expect(page).to_not have_content 'Agrupamento de reparo 2013'
          expect(page).to have_content 'Agrupamento de antivirus'
        end
      end
    end
  end

  scenario 'when select disposals_of_assets as object_type should show only best_auction_or_offer' do
    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Alienação de bens', :from => 'Tipo de objeto'

      within_modal 'Forma de julgamento' do
        expect(page).to have_select('Tipo de licitação',
                                :selected => 'Melhor lance ou oferta',
                                :options => ['Melhor lance ou oferta'])
      end
    end
  end

  scenario 'when select concessions_and_permits as object_type should show only best_auction_or_offer' do
    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Concessões e permissões', :from => 'Tipo de objeto'

      within_modal 'Forma de julgamento' do
        expect(page).to have_select('Tipo de licitação',
                                :selected => 'Melhor lance ou oferta',
                                :options => ['Melhor lance ou oferta'])
      end
    end
  end

  scenario 'when select call_notice as object_type should show only best_technique' do
    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Edital de chamamento/credenciamento', :from => 'Tipo de objeto'

      within_modal 'Forma de julgamento' do
        expect(page).to have_select('Tipo de licitação',
                                :selected => 'Melhor técnica',
                                :options => ['Melhor técnica'])
      end
    end
  end

  scenario 'when select construction_and_engineering_services as object_type should show only lowest_price and best_technique' do
    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Obras e serviços de engenharia', :from => 'Tipo de objeto'

      within_modal 'Forma de julgamento' do
        expect(page).to have_select('Tipo de licitação',
                                :selected => 'Melhor técnica',
                                :options => ['Melhor técnica', 'Menor preço'])
      end
    end
  end

  scenario 'when select purchase_and_services as object_type should show only lowest_price and best_technique' do
    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Compras e serviços', :from => 'Tipo de objeto'

      within_modal 'Forma de julgamento' do
        expect(page).to have_select('Tipo de licitação',
                                :selected => 'Melhor técnica',
                                :options => ['Melhor técnica', 'Menor preço'])
      end
    end
  end

  scenario 'when clear object_type should not filter licitation_kind in judgment_form modal' do
    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Compras e serviços', :from => 'Tipo de objeto'

      select '', :from => 'Tipo de objeto'

      within_modal 'Forma de julgamento' do
        expect(page).to have_select('Tipo de licitação',
                                :selected => '',
                                :options => [
                                  'Maior desconto sobre o item',
                                  'Maior desconto sobre o lote',
                                  'Melhor lance ou oferta',
                                  'Melhor técnica',
                                  'Menor preço',
                                  'Técnica e preço'
                                ])
      end
    end
  end

  scenario 'assigns a fulfiller to the purchase solicitation budget allocation item when assign a purchase_solicitation_item_group to administrative_process' do
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)
    PurchaseSolicitationItemGroup.make!(:antivirus)
    LicitationModality.make!(:pregao_presencial)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end

      fill_modal 'Modalidade', :with => 'Pregão presencial', :field => 'Modalidade'
      fill_modal 'Forma de julgamento', :with => 'Por Item com Melhor Técnica', :field => 'Descrição'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentarias' do
      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo criado com sucesso.'

    navigate 'Compras e Licitações > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
    end
  end

  scenario "filtering modalities based on seleted object type" do
    LicitationModality.make!(:publica)
    LicitationModality.make!(:privada,
                             :object_type => 'call_notice')

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    select 'Compras e serviços', :on => "Tipo de objeto"

    within_modal 'Modalidade' do

      expect(page).to have_disabled_field "Tipo do objeto"

      click_button 'Pesquisar'
      within_records do
        expect(page).to have_content "Pública"
        expect(page).not_to have_content "Privada"
      end
    end
  end
end
