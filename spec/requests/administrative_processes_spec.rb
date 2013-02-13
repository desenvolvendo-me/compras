# encoding: utf-8
require 'spec_helper'

feature "AdministrativeProcesses" do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'create a new administrative_process' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    expect(page).to be_on_tab 'Principal'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Status do processo administrativo'
      expect(page).to have_disabled_field 'Modalidade'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from => 'Modalidade'

      select 'Alienação de bens', :from => 'Tipo de objeto'
      expect(page).to have_select 'Modalidade', :selected => ''

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from => 'Modalidade'

      select 'Por Item com Melhor Técnica', :from => 'Forma de julgamento'
      fill_in 'Objeto resumido do processo licitatório', :with => 'Objeto resumido'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '1', :field => 'Código'
      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 criado com sucesso.'

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
      expect(page).to have_select 'Modalidade', :selected => 'Pregão'
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Item com Melhor Técnica'
      expect(page).to have_field 'Objeto resumido do processo licitatório', :with => 'Objeto resumido'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Dotação orçamentária', :with => budget_allocation.to_s
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

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

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

      select 'Pregão', :from => 'Modalidade'
      select 'Por Item com Melhor Técnica', :from => 'Forma de julgamento'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'

      expect(page).to have_disabled_field 'Dotação orçamentária'
      expect(page).to have_disabled_field 'Saldo da dotação'
      expect(page).to have_disabled_field 'Valor previsto'

      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '19.800,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 criado com sucesso.'

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
      expect(page).to have_select 'Modalidade', :with => 'Pregão'
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Item com Melhor Técnica'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'

      expect(page).to have_disabled_field 'Dotação orçamentária'
      expect(page).to have_disabled_field 'Saldo da dotação'
      expect(page).to have_disabled_field 'Valor previsto'

      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '19.800,00'
      expect(page).to have_field 'Valor total', :with => '19.800,00'
    end

    click_link 'Liberar'

    click_button 'Salvar'

    click_link 'Novo processo licitatório'

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '19.800,00'
      expect(page).to have_disabled_field 'Valor previsto'

      expect(page).to have_field 'Valor total dos itens', :with => '19.800,00'
      expect(page).to have_disabled_field 'Valor total dos itens'

      expect(page).to_not have_button 'Adicionar item'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_disabled_field 'Item'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_disabled_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '99'
      expect(page).to have_disabled_field 'Quantidade'

      expect(page).to have_field 'Valor unitário máximo', :with => '200,00'
      expect(page).to have_disabled_field 'Valor unitário máximo'

      expect(page).to have_field 'Valor total', :with => '19.800,00'
      expect(page).to have_disabled_field 'Valor total'

      expect(page).to_not have_button 'Remover item'
    end

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Situação', :selected => 'Em processo de compra'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end
  end

  scenario 'when clear purchase solicitation item group budget allocations should clear too' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to_not have_disabled_field 'Solicitação de compra'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end

      expect(page).to have_disabled_field 'Solicitação de compra'
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '500,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      clear_modal 'Agrupamento de solicitações de compra'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_button 'Adicionar Dotação'

      expect(page).to_not have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to_not have_field 'Saldo da dotação', :with => '500,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Situação', :selected => 'Pendente'
  end

  scenario 'when has budget allocations and select a purchase solicitation item group should clear old budget allocations' do
    BudgetAllocation.make!(:alocacao)
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Dotações orçamentárias' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '1', :field => 'Código'
      fill_in 'Valor previsto', :with => '20,00'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'

      expect(page).to_not have_field 'Dotação orçamentária', :with => ''
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to_not have_field 'Valor previsto', :with => '20,00'

      expect(page).to_not have_field 'Valor total', :with => '20,00'
    end
  end

  scenario 'should have all fields disabled on edit when status is different from waiting' do
    AdministrativeProcess.make!(:compra_liberada)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

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

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_disabled_field 'Dotação orçamentária'
      expect(page).to have_disabled_field 'Saldo da dotação'
      expect(page).to have_disabled_field 'Valor previsto'

      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to_not have_button 'Remover Dotação'
    end
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    BudgetAllocation.make!(:alocacao)
    administrative_process = AdministrativeProcess.make!(:compra_liberada)
    SignatureConfiguration.make!(:processo_administrativo)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Solicitação de abertura de processo licitatório'

    expect(page).to have_content administrative_process.to_s
    expect(page).to have_content "00088/2012"
    expect(page).to have_content "07/03/2012"
    expect(page).to have_content "Excelentíssimo Sr. Márcio Lacerda"
    expect(page).to have_content "Convite"
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
    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Dotações orçamentárias' do
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

  scenario 'update an existing administrative process' do
    JudgmentForm.make!(:por_lote_com_melhor_tecnica)
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Status do processo administrativo'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
      expect(page).to have_select 'Modalidade', :selected => 'Convite'

      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Alienação de bens', :from => 'Tipo de objeto'

      expect(page).to have_select 'Modalidade', :selected => ''

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from =>'Modalidade'
      select 'Por Lote com Melhor Técnica', :from => 'Forma de julgamento'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras 2'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '30,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

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
      expect(page).to have_select 'Modalidade', :selected => 'Pregão'
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Lote com Melhor Técnica'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras 2'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '30,00'
    end
  end

  scenario 'should have disabled print button when status is different from released' do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_select 'Status do processo administrativo', :selected => 'Liberado'
    expect(page).to have_disabled_element 'Solicitação de abertura de processo licitatório',
                    :reason => 'este processo administrativo ainda não foi liberado'
  end

  scenario 'should have print button when status is released' do
     AdministrativeProcess.make!(:compra_liberada)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Liberado'
    expect(page).to have_link 'Solicitação de abertura de processo licitatório'
  end

  scenario 'should have disabled licitation process button when status is not released and is not allowed' do
    AdministrativeProcess.make!(:maior_lance_por_itens).update_attribute :status, AdministrativeProcessStatus::WAITING

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to have_disabled_element 'Novo processo licitatório',
                    :reason => 'o tipo de objeto não permite processo licitatório'
  end

  scenario 'should have disabled licitation process button when status is not released but is allowed' do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_select 'Status do processo administrativo', :selected => 'Liberado'
    expect(page).to have_disabled_element 'Novo processo licitatório',
                    :reason => 'este processo administrativo ainda não foi liberado'
  end

  scenario 'should have disabled licitation process button when status is released but not allowed' do
    AdministrativeProcess.make!(:maior_lance_por_itens)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Liberado'
    expect(page).to have_disabled_element 'Novo processo licitatório',
                    :reason => 'o tipo de objeto não permite processo licitatório'
  end

  scenario 'should have licitation process button when status is released and allowed' do
     AdministrativeProcess.make!(:compra_liberada)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Liberado'
    expect(page).to have_link 'Novo processo licitatório'
  end

  scenario "should have a release button when editing an administrative process with status waiting" do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to have_link 'Liberar'
  end

  scenario "should not have a release button when editing an administrative process without status waiting" do
    AdministrativeProcess.make!(:compra_liberada)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to_not have_link 'Liberar'
  end

  scenario "should have a annul button when editing an administrative process with status waiting" do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to have_button 'Anular'
  end

  scenario "should not have an annul button when editing an administrative process without status waiting" do
    AdministrativeProcess.make!(:compra_liberada)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_select 'Status do processo administrativo', :selected => 'Aguardando'
    expect(page).to_not have_button 'Anular'
  end

  scenario "annuling an administrative process" do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_button 'Anular'

    expect(page).to have_notice 'Processo Administrativo anulado com sucesso'
  end

  scenario "annuling an administrative process with purchase_solicitation_item_group" do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Situação', :selected => 'Em processo de compra'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
    end

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_button 'Anular'

    expect(page).to have_notice 'Processo Administrativo anulado com sucesso'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => ''
    end

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    expect(page).to have_select 'Situação', :selected => 'Anulado'

    click_link 'Anulação'

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_field 'Justificativa', :with => 'Anulado através do processo administrativo 1/2012'
  end

  scenario "show new licitation process link" do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_link 'Novo processo licitatório'
  end

  scenario "show edit licitation process link" do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_link 'Editar processo licitatório'
    expect(page).to have_subtitle '1/2012'
  end

  scenario "should not have a release and annull button at new" do
    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    expect(page).to_not have_button 'Anular'
    expect(page).to_not have_button 'Liberar'
  end

  scenario 'should have disabled licitation_process button if not allow licitation_process' do
    AdministrativeProcess.make!(:maior_lance_por_itens)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    expect(page).to have_disabled_element 'Novo processo licitatório',
                    :reason => 'o tipo de objeto não permite processo licitatório'
  end

  scenario 'should show only purchase_solicitation_item_group not annulled' do
    PurchaseSolicitationItemGroup.make!(:antivirus)

    ResourceAnnul.make!(:anulacao_generica,
                        :annullable => PurchaseSolicitationItemGroup.make!(:reparo_2013))

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

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
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Alienação de bens', :from => 'Tipo de objeto'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Global com Melhor Lance ou Oferta'])
    end
  end

  scenario 'when select concessions_and_permits as object_type should show only best_auction_or_offer' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Concessões e permissões', :from => 'Tipo de objeto'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Global com Melhor Lance ou Oferta'])
    end
  end

  scenario 'when select call_notice as object_type should show only best_technique' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Edital de chamamento/credenciamento', :from => 'Tipo de objeto'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica'])
    end
  end

  scenario 'when select construction_and_engineering_services as object_type should show only lowest_price and best_technique' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Obras e serviços de engenharia', :from => 'Tipo de objeto'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])
    end
  end

  scenario 'when select purchase_and_services as object_type should show only lowest_price and best_technique' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Compras e serviços', :from => 'Tipo de objeto'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica', 'Por Item com Menor Preço'])
    end
  end

  scenario 'when clear object_type should not filter licitation_kind in judgment_form modal' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      select 'Compras e serviços', :from => 'Tipo de objeto'

      select '', :from => 'Tipo de objeto'

      expect(page).to have_select('Forma de julgamento', :options => [])
    end
  end

  scenario 'when clear item group purchase solicitation item should clear budget_allocations' do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      within '.nested-administrative-process-budget-allocation:first' do
        fill_in 'Valor previsto', :with => '10,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      clear_modal 'Agrupamento de solicitações de compra'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Valor total', :with => '0,00'
      expect(page).to_not have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to_not have_field 'Saldo da dotação', :with => '500,00'
    end
  end

  scenario 'when clear item group purchase solicitation item should clear fulfiller' do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end
    end

    within_tab 'Dotações orçamentárias' do
      within '.nested-administrative-process-budget-allocation:first' do
        fill_in 'Valor previsto', :with => '10,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item:first' do
          expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
        end
      end
    end

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      clear_modal 'Agrupamento de solicitações de compra'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item:first' do
          expect(page).to have_field 'Atendido por', :with => ''
        end
      end
    end
  end

  scenario 'assigns a fulfiller to the purchase solicitation budget allocation item when assign a purchase_solicitation_item_group to administrative_process' do
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)
    PurchaseSolicitationItemGroup.make!(:antivirus)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

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

      select 'Pregão', :from => 'Modalidade'
      select 'Por Item com Melhor Técnica', :from => 'Forma de julgamento'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 criado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
    end
  end

  scenario "filtering modalities based on seleted object type" do
    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    select 'Compras e serviços', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência', 'Tomada de Preço', 'Convite', 'Pregão'])

    select 'Alienação de bens', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Leilão'])

    select 'Concessões e permissões', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência'])

    select 'Edital de chamamento/credenciamento', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concurso'])

    select 'Obras e serviços de engenharia', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência', 'Tomada de Preço', 'Convite', 'Concurso', 'Pregão'])
  end

  scenario "changing the purchase_solicitation_item_group should change purchase solicitation items fulfiller" do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    PurchaseSolicitationItemGroup.make!(:office)
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
    end

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de office'
      end
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '50,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => ''
    end

    click_link 'Voltar'

    within_records do
      click_link '2/2012'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
    end
  end

  scenario "changing the purchase_solicitation_item_group should change purchase solicitation and items status" do
    item_group = PurchaseSolicitationItemGroup.make!(:antivirus)
    item_group.purchase_solicitation_items.each do |item|
      item.update_column :purchase_solicitation_item_group_id, item_group.id
    end
    item_group = PurchaseSolicitationItemGroup.make!(:office)
    item_group.purchase_solicitation_items.each do |item|
      item.update_column :purchase_solicitation_item_group_id, item_group.id
    end
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation' do
        within '.item' do
          expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
          expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de antivirus'
          expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
        end
      end
    end

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de office'
      end
    end

    within_tab 'Dotações orçamentárias' do
      fill_in 'Valor previsto', :with => '50,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      #expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item' do
          expect(page).to have_select 'Status', :selected => 'Pendente'
          expect(page).to have_field 'Agrupamento', :with => ''
          expect(page).to have_field 'Atendido por', :with => ''
        end
      end
    end

    click_link 'Voltar'

    within_records do
      click_link '2/2012'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation' do
        within '.item' do
          expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
          #expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de antivirus'
          expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
        end
      end
    end
  end

  scenario 'clear budget allocations when purchase_solicititation is removed' do
    PurchaseSolicitation.make!(:reparo_liberado)
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    expect(page).to be_on_tab 'Principal'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Status do processo administrativo'
      expect(page).to have_disabled_field 'Modalidade'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
      expect(page).to_not have_disabled_field 'Solicitação de compra'
      expect(page).to_not have_disabled_field 'Agrupamento de solicitações de compra'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_disabled_field 'Agrupamento de solicitações de compra'

      select 'Pregão', :from => 'Modalidade'
      select 'Alienação de bens', :from => 'Tipo de objeto'

      expect(page).to have_select 'Modalidade', :selected => ''

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from => 'Modalidade'

      select 'Por Item com Melhor Técnica', :from =>'Forma de julgamento'
      fill_in 'Objeto resumido do processo licitatório', :with => 'Objeto resumido'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'

      fill_in 'Valor previsto', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      clear_modal 'Solicitação de compra'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_button 'Adicionar Dotação'
      expect(page).to_not have_field 'Dotação orçamentária', :with => '1 - Alocação'

      expect(page).to_not have_field 'Saldo da dotação', :with => '500,00'

      expect(page).to have_field 'Valor total', :with => '0,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 editado com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
    end

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation' do
        within '.item' do
          expect(page).to have_select 'Status', :selected => 'Pendente'
          #expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de antivirus'
          expect(page).to have_field 'Atendido por', :with => ''
        end
      end
    end
  end

  scenario 'budget allocations should be fulfilled automatically when fulfill purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado)
    BudgetStructure.make!(:secretaria_de_educacao)
    JudgmentForm.make!(:por_item_com_melhor_tecnica)
    Employee.make!(:sobrinho)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    expect(page).to be_on_tab 'Principal'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Status do processo administrativo'
      expect(page).to have_disabled_field 'Modalidade'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
      expect(page).to_not have_disabled_field 'Solicitação de compra'
      expect(page).to_not have_disabled_field 'Agrupamento de solicitações de compra'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '07/03/2012'
      fill_in 'Número do protocolo', :with => '00099/2012'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_disabled_field 'Agrupamento de solicitações de compra'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

      select 'Pregão', :from => 'Modalidade'
      select 'Alienação de bens', :from => 'Tipo de objeto'

      expect(page).to have_select 'Modalidade', :selected => ''

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from => 'Modalidade'

      select 'Por Item com Melhor Técnica', :from => 'Forma de julgamento'
      fill_in 'Objeto resumido do processo licitatório', :with => 'Objeto resumido'
      fill_in 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      select 'Aguardando', :from => 'Status do processo administrativo'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '600,00'
      expect(page).to have_disabled_field 'Valor previsto'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo 1/2012 criado com sucesso.'

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
      expect(page).to have_field 'Solicitação de compra', :with => '1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
      expect(page).to have_select 'Modalidade', :selected => 'Pregão'
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Item com Melhor Técnica'
      expect(page).to have_field 'Objeto resumido do processo licitatório', :with => 'Objeto resumido'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_select 'Status do processo administrativo', :selected => 'Aguardando'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to_not have_button 'Adicionar Dotação'
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '600,00'
      expect(page).to have_disabled_field 'Valor previsto'
      expect(page).to have_field 'Valor total', :with => '600,00'
    end

    click_link 'Liberar'

    click_button 'Salvar'

    click_link 'Novo processo licitatório'

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Dotação orçamentária', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentária'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to have_field 'Valor previsto', :with => '600,00'
      expect(page).to have_disabled_field 'Valor previsto'

      expect(page).to have_field 'Valor total dos itens', :with => '600,00'
      expect(page).to have_disabled_field 'Valor total dos itens'

      expect(page).to_not have_button 'Adicionar item'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_disabled_field 'Item'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_disabled_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '3'
      expect(page).to have_disabled_field 'Quantidade'

      expect(page).to have_field 'Valor unitário máximo', :with => '200,00'
      expect(page).to have_disabled_field 'Valor unitário máximo'

      expect(page).to have_field 'Valor total', :with => '600,00'
      expect(page).to have_disabled_field 'Valor total'

      expect(page).to_not have_button 'Remover item'
    end

    navigate 'Processos de Compra > Solicitações de Compra'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      within '.item:nth-child(1)' do
        expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
        expect(page).to have_field 'Atendido por', :with => 'Processo administrativo 1/2012'
      end
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Parcialmente atendido'
    end
  end

  scenario 'when clear purchase_solicitation should enable item_group' do
    PurchaseSolicitation.make!(:reparo_liberado)
    PurchaseSolicitationItemGroup.make!(:antivirus)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    expect(page).to be_on_tab 'Principal'

    within_tab 'Principal' do
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_disabled_field 'Agrupamento de solicitações de compra'

      clear_modal 'Solicitação de compra'

      expect(page).to_not have_disabled_field 'Agrupamento de solicitações de compra'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de antivirus'
      end

      expect(page).to have_disabled_field 'Solicitação de compra'
    end
  end

  scenario 'cannot overwrite reponsible when select a purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado)
    PurchaseSolicitationItemGroup.make!(:antivirus)
    Employee.make!(:wenderson)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_tab 'Principal' do
      fill_modal 'Responsável', :field => 'Matrícula', :with => '12903412'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros'

      clear_modal 'Responsável'
      clear_modal 'Solicitação de compra'

      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    end
  end

  scenario 'index with columns at the index' do
    AdministrativeProcess.make!(:compra_aguardando)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      expect(page).to have_content 'Código/Ano'
      expect(page).to have_content 'Data do processo'
      expect(page).to have_content 'Tipo de objeto'
      expect(page).to have_content 'Objeto resumido do processo licitatório'
      expect(page).to have_content 'Status do processo administrativo'

      within 'tbody tr' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '07/03/2012'
        expect(page).to have_content 'Compras e serviços'
        expect(page).to have_content 'Aguardando'
      end
    end
  end

  scenario 'should not return duplicated data of purchase solicitation' do
     purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado,
                                                        :purchase_solicitation_budget_allocations => [
                                                          PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office_2_itens_liberados)])

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      expect(page).to have_css 'table.records tbody tr', :count => 1
    end
  end

  scenario 'should show only item group pending' do
    PurchaseSolicitationItemGroup.make!(:antivirus)
    PurchaseSolicitationItemGroup.make!(:reparo_2013,
      :status => PurchaseSolicitationItemGroupStatus::FULFILLED)
    PurchaseSolicitationItemGroup.make!(:antivirus_desenvolvimento,
      :status => PurchaseSolicitationItemGroupStatus::ANNULLED)

    navigate 'Processo Administrativo/Licitatório > Processos Administrativos'

    click_link 'Criar Processo Administrativo'

    within_modal 'Agrupamento de solicitações de compra' do
      click_button 'Pesquisar'

      expect(page).to have_css 'table.records tbody tr', :count => 1
    end
  end
end
