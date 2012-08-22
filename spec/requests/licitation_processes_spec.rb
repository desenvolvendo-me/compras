# encoding: utf-8
require 'spec_helper'

feature "LicitationProcesses" do
  background do
    sign_in
  end

  scenario 'calc by bidder' do
    licitation_process = LicitationProcess.make!(:apuracao_global)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Venceu'
    end

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Perdeu'
    end
  end

  scenario 'calc by lote' do
    licitation_process = LicitationProcess.make!(:apuracao_por_lote)
    LicitationProcessLot.make!(:lote, :licitation_process => licitation_process,
                               :administrative_process_budget_allocation_items => [licitation_process.items.first])
    LicitationProcessLot.make!(:lote_antivirus, :licitation_process => licitation_process,
                               :administrative_process_budget_allocation_items => [licitation_process.items.second])

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço por lote'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Venceu'
    end

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification-2-0-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Perdeu'
    end
  end

  scenario 'calc by item' do
    licitation_process = LicitationProcess.make!(:apuracao_por_itens)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_button 'Apurar'

    expect(page).to have_content 'Processo Licitatório 1/2012'

    expect(page).to have_content 'Apuração: Menor preço total por item'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Venceu'
    end

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Perdeu'
    end

    click_link 'voltar'

    click_link 'Relatório'

    expect(page).to have_content 'Processo Licitatório 1/2012'
  end

  scenario 'acessing from index cancel should return to index' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Cancelar'

    expect(page).to have_link('1/2012')
  end

  scenario 'create a new licitation_process' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)
    budget_allocation = administrative_process.administrative_process_budget_allocations.first.budget_allocation
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    expect(page).to have_content "Criar Processo Licitatório no Processo Administrativo 1/2012"

    expect(page).not_to have_link 'Publicações'

    expect(page).not_to have_button 'Apurar'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_disabled_field 'Modalidade'
      expect(page).to have_disabled_field 'Tipo de objeto'
      expect(page).to have_disabled_field 'Objeto do processo licitatório'
      expect(page).to have_disabled_field 'Responsável'
      expect(page).to have_disabled_field 'Inciso'
      expect(page).to have_disabled_field 'Data da homologação'
      expect(page).to have_disabled_field 'Data da adjudicação'
      expect(page).to have_disabled_field 'Processo administrativo'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '21/03/2012'
      select 'Global', :from => 'Tipo de empenho'

      # testing delegated fields of administrative process (filled by javascript)
      expect(page).to have_field 'Modalidade', :with => 'Convite para compras e serviços'
      expect(page).to have_field 'Tipo de objeto', :with => 'Compras e serviços'
      expect(page).to have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Inciso', :with => 'Item 1'
      expect(page).to have_field 'Abrev. modalidade', :with => 'CV'

      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '14:00'
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora da abertura', :with => '14:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    within_tab 'Dotações' do
      expect(page).to have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '20,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário máximo', :with => '10,00'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '20,00'
    end

    within_tab 'Configuração da apuração' do
      check 'Desclassificar participantes com problemas da documentação'
      check 'Desclassificar participantes com cotações acima do valor máximo estabelecido no edital'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório criado com sucesso.'

    click_link 'Editar processo licitatório'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_disabled_field 'Ano'

      expect(page).to have_field 'Processo', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data do processo', :with => '21/03/2012'
      expect(page).to have_field 'Processo administrativo', :with => '1/2012'
      expect(page).to have_select 'Tipo de empenho', :selected => 'Global'

      # testing delegated fields of administrative process
      expect(page).to have_field 'Modalidade', :with => 'Convite para compras e serviços'
      expect(page).to have_field 'Tipo de objeto', :with => 'Compras e serviços'
      expect(page).to have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      expect(page).to have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Inciso', :with => 'Item 1'

      expect(page).to have_select 'Tipo da apuração', :selected => 'Menor preço global'
      expect(page).to have_field 'Fonte de recurso', :with => 'Reforma e Ampliação'
      expect(page).to have_field 'Validade da proposta', :with => '5'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'dia/dias'
      expect(page).to have_field 'Índice de reajuste', :with => 'XPTO'
      expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      expect(page).to have_field 'Hora da entrega', :with => '14:00'
      expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      expect(page).to have_field 'Hora da abertura', :with => '14:00'
      expect(page).to have_field 'Prazo de entrega', :with => '1'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'ano/anos'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Valor da caução', :with => '50,00'
      expect(page).to have_select 'Parecer jurídico', :selected => 'Favorável'
      expect(page).to have_field 'Data do parecer', :with => '30/03/2012'
      expect(page).to have_field 'Data do contrato', :with => '31/03/2012'
      expect(page).to have_field 'Validade do contrato (meses)', :with => '5'
      expect(page).to have_field 'Observações gerais', :with => 'observacoes'

      # testing fields of licitation number
      expect(page).to have_field 'Número da licitação', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Abrev. modalidade', :with => 'CV'
    end

    within_tab 'Documentos' do
      expect(page).to have_content 'Fiscal'
      expect(page).to have_content '10'
    end

    within_tab 'Dotações' do
      expect(page).to have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '20,00'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '2'
      expect(page).to have_field 'Valor unitário máximo', :with => '10,00'
      expect(page).to have_field 'Valor total', :with => '20,00'

      expect(page).to have_field 'Item', :with => '1'
    end

    within_tab 'Configuração da apuração' do
      expect(page).to have_checked_field 'Desclassificar participantes com problemas da documentação'
      expect(page).to have_checked_field 'Desclassificar participantes com cotações acima do valor máximo estabelecido no edital'
    end
  end

  scenario 'changing judgment form' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)
    budget_allocation = administrative_process.administrative_process_budget_allocations.first.budget_allocation
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    JudgmentForm.make!(:por_lote_com_melhor_tecnica)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    expect(page).to have_content "Criar Processo Licitatório no Processo Administrativo 1/2012"

    expect(page).not_to have_link 'Publicações'

    within_tab 'Principal' do
      fill_modal 'Forma de julgamento', :with => 'Por Lote com Melhor Técnica', :field => 'Descrição'
      select 'Menor preço por lote', :from => 'Tipo da apuração'

      fill_modal 'Forma de julgamento', :with => 'Forma Global com Menor Preço', :field => 'Descrição'
      select 'Menor preço global', :from => 'Tipo da apuração'
    end
  end

  scenario 'update an existent licitation_process' do
    LicitationProcess.make!(:processo_licitatorio)
    administrative_process = AdministrativeProcess.make!(:compra_de_computadores)
    budget_allocation = administrative_process.administrative_process_budget_allocations.first.budget_allocation
    Capability.make!(:construcao)
    PaymentMethod.make!(:cheque)
    DocumentType.make!(:oficial)
    Material.make!(:arame_farpado)
    Indexer.make!(:selic)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    expect(page).to have_content "Editar Processo Licitatório 1/2012 do Processo Administrativo 1/2012"

    expect(page).to have_link 'Publicações'

    within_tab 'Principal' do
      fill_in 'Data do processo', :with => '21/03/2013'
      select 'Estimativo', :from => 'Tipo de empenho'
      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Construção', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '10'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'SELIC'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora da entrega', :with => '15:00'
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      fill_in 'Hora da abertura', :with => '15:00'
      fill_in 'Prazo de entrega', :with => '3'
      select  'mês/meses', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '60,00'
      select 'Contrário', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2013'
      fill_in 'Data do contrato', :with => '31/03/2013'
      fill_in 'Validade do contrato (meses)', :with => '6'
      fill_in 'Observações gerais', :with => 'novas observacoes'
    end

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    within_tab 'Dotações' do
      click_button 'Remover Item'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor total', :with => '20,00'

      # asserting calculated unit price of the item
      expect(page).to have_field 'Valor unitário máximo', :with => '4,00'
    end

    within_tab 'Configuração da apuração' do
      uncheck 'Desclassificar participantes com problemas da documentação'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório editado com sucesso.'

    click_link 'Editar processo licitatório'

    within_tab 'Principal' do
      expect(page).to have_field 'Data do processo', :with => '21/03/2013'
      expect(page).to have_field 'Processo administrativo', :with => '1/2012'
      expect(page).to have_select 'Tipo de empenho', :selected => 'Estimativo'
      expect(page).to have_select 'Tipo da apuração', :selected => 'Menor preço global'
      expect(page).to have_field 'Fonte de recurso', :with => 'Construção'
      expect(page).to have_field 'Validade da proposta', :with => '10'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'dia/dias'
      expect(page).to have_field 'Índice de reajuste', :with => 'SELIC'
      expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      expect(page).to have_field 'Hora da entrega', :with => '15:00'
      expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      expect(page).to have_field 'Hora da abertura', :with => '15:00'
      expect(page).to have_field 'Prazo de entrega', :with => '3'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'mês/meses'
      expect(page).to have_field 'Forma de pagamento', :with => 'Cheque'
      expect(page).to have_field 'Valor da caução', :with => '60,00'
      expect(page).to have_select 'Parecer jurídico', :selected => 'Contrário'
      expect(page).to have_field 'Data do parecer', :with => '30/03/2013'
      expect(page).to have_field 'Data do contrato', :with => '31/03/2013'
      expect(page).to have_field 'Validade do contrato (meses)', :with => '6'
      expect(page).to have_field 'Observações gerais', :with => 'novas observacoes'
    end

    within_tab 'Documentos' do
      expect(page).not_to have_content 'Fiscal'

      expect(page).to have_content 'Oficial'
    end

    within_tab 'Dotações' do
      expect(page).to have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_field 'Valor previsto', :with => '20,00'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '5'
      expect(page).to have_field 'Valor unitário máximo', :with => '4,00'
      expect(page).to have_field 'Valor total', :with => '20,00'

      expect(page).to have_field 'Item', :with => '1'
    end

    within_tab 'Configuração da apuração' do
      expect(page).to have_unchecked_field 'Desclassificar participantes com problemas da documentação'
      expect(page).to have_checked_field 'Desclassificar participantes com cotações acima do valor máximo estabelecido no edital'
    end
  end

  scenario 'creating another licitation with the same year to test process number and licitation number' do
    last_licitation_process = LicitationProcess.make!(:processo_licitatorio)
    AdministrativeProcess.make!(:compra_com_itens_2)
    Indexer.make!(:xpto)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      click_link '1/2013'
    end

    click_link 'Novo processo licitatório'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'

      fill_in 'Ano', :with => '2013'
      fill_in 'Data do processo', :with => '21/04/2013'
      select 'Global', :from => 'Tipo de empenho'
      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5 dias'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '15:00'
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora da abertura', :with => '15:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório criado com sucesso.'

    click_link "Editar processo licitatório"

    within_tab 'Principal' do
      expect(page).to have_field 'Processo', :with => last_licitation_process.process.succ.to_s
      expect(page).to have_field 'Número da licitação', :with => last_licitation_process.licitation_number.succ.to_s
    end
  end

  scenario 'cannot include the same material twice on a budget allocation' do
    LicitationProcess.make!(:processo_licitatorio)
    Material.make!(:antivirus)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    within_tab 'Dotações orçamentarias' do
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
      fill_in 'Quantidade', :with => 2
      fill_in 'Valor unitário máximo', :with => 1

      click_button 'Adicionar Item'

      within '.item:last' do
        fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
        fill_in 'Quantidade', :with => 3
        fill_in 'Valor unitário máximo', :with => 4
      end
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentarias' do
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'budget allocation with total of items diferent than value should not be saved' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    within_tab 'Dotações' do
      expect(page).to have_field 'Valor previsto', :with => "20,00"
      expect(page).to have_field 'Valor total dos itens', :with => "20,00"

      fill_in 'Valor total', :with => '21,00'

      expect(page).to have_field 'Valor total dos itens', :with => "21,00"
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      expect(page).to have_content 'deve ser menor ou igual ao valor previsto (R$ 20,00)'
    end
  end

  scenario 'calculating total of items via javascript' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    within_tab 'Dotações' do
      click_button 'Adicionar Item'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor unitário máximo', :with => '10,00'

      expect(page).to have_field 'Valor total dos itens', :with => '50,00'

      click_button 'Adicionar Item'

      within '.item:first' do
        fill_in 'Quantidade', :with => '4'
        fill_in 'Valor unitário máximo', :with => '20,00'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '130,00'

      within '.item:last' do
        click_button 'Remover Item'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '80,00'
    end
  end

  scenario 'change document types to ensure that the changes are reflected on bidder documents' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    DocumentType.make!(:oficial)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    within_tab 'Documentos' do
      expect(page).to have_field 'Documento', :with => 'Fiscal'
    end

    click_link 'Cancelar'

    click_link 'Voltar ao processo licitatório'

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Licitatório editado com sucesso.'

    click_link 'Editar processo licitatório'

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    within_tab 'Documentos' do
      expect(page).not_to have_field 'Documento', :with => 'Fiscal'
      expect(page).to have_field 'Documento', :with => 'Oficial'
    end
  end

  scenario "count link should not be available when envelope opening date is not the current date" do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    expect(page).not_to have_link 'Apurar'
  end

  scenario 'cannot show update and nested buttons when the publication is (extension, edital, edital_rectification)' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_publicacao_cancelada)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    expect(page).not_to have_button 'Salvar'

    within_tab 'Documentos' do
      expect(page).not_to have_button 'Remover'
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).not_to have_button 'Adicionar Item'
      expect(page).not_to have_button 'Remover Item'
    end
  end

  scenario "should not have link to lots when creating a new licitation process" do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    expect(page).not_to have_link 'Lotes de itens'
  end

  scenario "should brings some filled fields when creating a new licitatoin process" do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    within_tab 'Principal' do
      expect(page).to have_field 'Ano', :with => "#{Date.current.year}"
      expect(page).to have_field 'Data do processo', :with => "#{I18n.l(Date.current)}"
      expect(page).to have_field 'Processo administrativo', :with => "1/2012"
      expect(page).to have_field 'Abrev. modalidade', :with => "CV"
    end
  end

  scenario "cancelar button should redirect to the respective administrative_process" do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Cancelar'

    within_tab 'Principal' do
      expect(page).to have_field 'Processo', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data do processo', :with => '07/03/2012'
      expect(page).to have_field 'Número do protocolo', :with => '00088/2012'
    end
  end

  scenario 'budget allocation with quantity empty and total item value should have 0 as unit value' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    within_tab 'Dotações' do
      click_button 'Remover Item'
      click_button 'Adicionar Item'

      fill_in 'Valor total', :with => '20,00'

      expect(page).to have_field 'Valor unitário máximo', :with => '0,00'
    end
  end

  scenario 'create a new licitation_process with envelope opening date today' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)
    budget_allocation = administrative_process.administrative_process_budget_allocations.first.budget_allocation
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    within_tab 'Principal' do
      select 'Global', :from => 'Tipo de empenho'

      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => I18n.l(Date.current, :format => 'time')
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da abertura', :with => I18n.l(Date.current, :format => 'time')
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    click_button 'Salvar'

    expect(page).not_to have_content 'Routing Error No route matches'
  end

  scenario 'should filter by process' do
    LicitationProcess.make!(:processo_licitatorio)
    LicitationProcess.make!(:processo_licitatorio_computador, :process => 2)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Licitatórios'

    within_records do
      expect(page).to have_css 'a', :count => 2
    end

    click_link 'Filtrar Processos Licitatórios'

    fill_in 'Processo', :with => 1

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_css 'a', :count => 1
    end
  end
end
