# encoding: utf-8
require 'spec_helper'

feature "LicitationProcesses" do
  background do
    sign_in
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

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    page.should have_content "Criar Processo Licitatório no Processo Administrativo 1/2012"

    page.should_not have_link 'Publicações'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'
      page.should have_disabled_field 'Modalidade'
      page.should have_disabled_field 'Tipo de objeto'
      page.should have_disabled_field 'Forma de julgamento'
      page.should have_disabled_field 'Objeto do processo licitatório'
      page.should have_disabled_field 'Responsável'
      page.should have_disabled_field 'Inciso'
      page.should have_disabled_field 'Data da homologação'
      page.should have_disabled_field 'Data da adjudicação'
      page.should have_disabled_field 'Processo administrativo'

      fill_mask 'Ano', :with => '2012'
      fill_mask 'Data do processo', :with => '21/03/2012'
      select 'Global', :from => 'Tipo de empenho'

      # testing delegated fields of administrative process (filled by javascript)
      page.should have_field 'Modalidade', :with => 'Convite para compras e serviços de engenharia'
      page.should have_field 'Tipo de objeto', :with => 'Compras e serviços'
      page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Inciso', :with => 'Item 1'
      page.should have_field 'Abrev. modalidade', :with => 'CV'

      fill_in 'Detalhamento do objeto', :with => 'detalhamento'
      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Unidade da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO', :field => 'Nome'
      fill_mask 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_mask 'Hora da entrega', :with => '14:00'
      fill_mask 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_mask 'Hora da abertura', :with => '14:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_mask 'Data do parecer', :with => '30/03/2012'
      fill_mask 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => budget_allocation.to_s
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '20,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'UN'

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário', :with => '10,00'

      # asserting calculated total price of the item
      page.should have_field 'Valor total', :with => '20,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório criado com sucesso.'

    click_link 'Editar processo licitatório'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'
      page.should have_disabled_field 'Ano'

      page.should have_field 'Processo', :with => '1'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data do processo', :with => '21/03/2012'
      page.should have_field 'Processo administrativo', :with => '1/2012'
      page.should have_select 'Tipo de empenho', :selected => 'Global'

      # testing delegated fields of administrative process
      page.should have_field 'Modalidade', :with => 'Convite para compras e serviços de engenharia'
      page.should have_field 'Tipo de objeto', :with => 'Compras e serviços'
      page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Inciso', :with => 'Item 1'

      page.should have_field 'Detalhamento do objeto', :with => 'detalhamento'
      page.should have_select 'Tipo da apuração', :selected => 'Menor preço global'
      page.should have_field 'Fonte de recurso', :with => 'Reforma e Ampliação'
      page.should have_field 'Validade da proposta', :with => '5'
      page.should have_select 'Unidade da validade da proposta', :selected => 'dia/dias'
      page.should have_field 'Índice de reajuste', :with => 'XPTO'
      page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      page.should have_field 'Hora da entrega', :with => '14:00'
      page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Hora da abertura', :with => '14:00'
      page.should have_field 'Prazo de entrega', :with => '1'
      page.should have_select 'Período', :selected => 'ano/anos'
      page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
      page.should have_field 'Valor da caução', :with => '50,00'
      page.should have_select 'Parecer jurídico', :selected => 'Favorável'
      page.should have_field 'Data do parecer', :with => '30/03/2012'
      page.should have_field 'Data do contrato', :with => '31/03/2012'
      page.should have_field 'Validade do contrato (meses)', :with => '5'
      page.should have_field 'Observações gerais', :with => 'observacoes'

      # testing fields of licitation number
      page.should have_field 'Número da licitação', :with => '1'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Abrev. modalidade', :with => 'CV'
    end

    within_tab 'Documentos' do
      page.should have_content 'Fiscal'
      page.should have_content '10'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => budget_allocation.to_s
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '20,00'

      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Unidade', :with => 'UN'
      page.should have_field 'Quantidade', :with => '2'
      page.should have_field 'Valor unitário', :with => '10,00'
      page.should have_field 'Valor total', :with => '20,00'

      page.should have_field 'Item', :with => '1'
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

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    page.should have_content "Editar Processo Licitatório 1/2012 do Processo Administrativo 1/2012"

    page.should have_link 'Publicações'

    within_tab 'Dados gerais' do
      fill_mask 'Data do processo', :with => '21/03/2013'
      select 'Estimativo', :from => 'Tipo de empenho'
      fill_in 'Detalhamento do objeto', :with => 'novo detalhamento'
      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Construção', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '10'
      select 'dia/dias', :from => 'Unidade da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'SELIC', :field => 'Nome'
      fill_mask 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_mask 'Hora da entrega', :with => '15:00'
      fill_mask 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      fill_mask 'Hora da abertura', :with => '15:00'
      fill_in 'Prazo de entrega', :with => '3'
      select  'mês/meses', :from => 'Período'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '60,00'
      select 'Contrário', :from => 'Parecer jurídico'
      fill_mask 'Data do parecer', :with => '30/03/2013'
      fill_mask 'Data do contrato', :with => '31/03/2013'
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
      page.should have_field 'Unidade', :with => 'UN'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor total', :with => '20,00'

      # asserting calculated unit price of the item
      page.should have_field 'Valor unitário', :with => '4,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório editado com sucesso.'

    click_link 'Editar processo licitatório'

    within_tab 'Dados gerais' do
      page.should have_field 'Data do processo', :with => '21/03/2013'
      page.should have_field 'Processo administrativo', :with => '1/2012'
      page.should have_select 'Tipo de empenho', :selected => 'Estimativo'
      page.should have_field 'Detalhamento do objeto', :with => 'novo detalhamento'
      page.should have_select 'Tipo da apuração', :selected => 'Menor preço global'
      page.should have_field 'Fonte de recurso', :with => 'Construção'
      page.should have_field 'Validade da proposta', :with => '10'
      page.should have_select 'Unidade da validade da proposta', :selected => 'dia/dias'
      page.should have_field 'Índice de reajuste', :with => 'SELIC'
      page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Hora da entrega', :with => '15:00'
      page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      page.should have_field 'Hora da abertura', :with => '15:00'
      page.should have_field 'Prazo de entrega', :with => '3'
      page.should have_select 'Período', :selected => 'mês/meses'
      page.should have_field 'Forma de pagamento', :with => 'Cheque'
      page.should have_field 'Valor da caução', :with => '60,00'
      page.should have_select 'Parecer jurídico', :selected => 'Contrário'
      page.should have_field 'Data do parecer', :with => '30/03/2013'
      page.should have_field 'Data do contrato', :with => '31/03/2013'
      page.should have_field 'Validade do contrato (meses)', :with => '6'
      page.should have_field 'Observações gerais', :with => 'novas observacoes'
    end

    within_tab 'Documentos' do
      page.should_not have_content 'Fiscal'

      page.should have_content 'Oficial'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => budget_allocation.to_s
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '20,00'

      page.should have_field 'Material', :with => '02.02.00001 - Arame farpado'
      page.should have_field 'Unidade', :with => 'UN'
      page.should have_field 'Quantidade', :with => '5'
      page.should have_field 'Valor unitário', :with => '4,00'
      page.should have_field 'Valor total', :with => '20,00'

      page.should have_field 'Item', :with => '1'
    end
  end

  scenario 'creating another licitation with the same year to test process number and licitation number' do
    last_licitation_process = LicitationProcess.make!(:processo_licitatorio)
    AdministrativeProcess.make!(:compra_com_itens_2)
    Indexer.make!(:xpto)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      click_link '1/2013'
    end

    click_link 'Novo processo licitatório'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'

      fill_mask 'Ano', :with => '2013'
      fill_mask 'Data do processo', :with => '21/04/2013'
      select 'Global', :from => 'Tipo de empenho'
      fill_in 'Detalhamento do objeto', :with => 'detalhamento'
      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5 dias'
      select 'dia/dias', :from => 'Unidade da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO', :field => 'Nome'
      fill_mask 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_mask 'Hora da entrega', :with => '15:00'
      fill_mask 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_mask 'Hora da abertura', :with => '15:00'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_mask 'Data do parecer', :with => '30/03/2012'
      fill_mask 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório criado com sucesso.'

    click_link "Editar processo licitatório"

    within_tab 'Dados gerais' do
      page.should have_field 'Processo', :with => last_licitation_process.process.succ.to_s
      page.should have_field 'Número da licitação', :with => last_licitation_process.licitation_number.succ.to_s
    end
  end

  scenario 'cannot include the same material twice on a budget allocation' do
    LicitationProcess.make!(:processo_licitatorio)
    Material.make!(:antivirus)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    within_tab 'Dotações orçamentárias' do
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
      fill_in 'Quantidade', :with => 2
      fill_in 'Valor unitário', :with => 1

      click_button 'Adicionar Item'

      within '.item:last' do
        fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
        fill_in 'Quantidade', :with => 3
        fill_in 'Valor unitário', :with => 4
      end
    end

    click_button 'Salvar'

    within_tab 'Dotações orçamentárias' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'budget allocation with total of items diferent than value should not be saved' do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    within_tab 'Dotações' do
      page.should have_field 'Valor previsto', :with => "20,00"
      page.should have_field 'Valor total dos itens', :with => "20,00"

      fill_in 'Valor total', :with => '21,00'

      page.should have_field 'Valor total dos itens', :with => "21,00"
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'deve ser menor ou igual ao valor previsto (R$ 20,00)'
    end
  end

  scenario 'calculating total of items via javascript' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    within_tab 'Dotações' do
      click_button 'Adicionar Item'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor unitário', :with => '10,00'

      page.should have_field 'Valor total dos itens', :with => '50,00'

      click_button 'Adicionar Item'

      within '.item:first' do
        fill_in 'Quantidade', :with => '4'
        fill_in 'Valor unitário', :with => '20,00'
      end

      page.should have_field 'Valor total dos itens', :with => '130,00'

      within '.item:last' do
        click_button 'Remover Item'
      end

      page.should have_field 'Valor total dos itens', :with => '80,00'
    end
  end

  scenario 'change document types to ensure that the changes are reflected on bidder documents' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    DocumentType.make!(:oficial)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    within_tab 'Documentos' do
      page.should have_field 'Documento', :with => 'Fiscal'
    end

    click_link 'Cancelar'

    click_link 'Voltar ao processo licitatório'

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório editado com sucesso.'

    click_link 'Editar processo licitatório'

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    within_tab 'Documentos' do
      page.should_not have_field 'Documento', :with => 'Fiscal'
      page.should have_field 'Documento', :with => 'Oficial'
    end
  end

  scenario "count link should be available when envelope opening date is the current date" do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    within_tab 'Dados gerais' do
      fill_mask 'Data da abertura dos envelopes', :with => "#{I18n.l(Date.current)}"
    end

    click_button 'Salvar'

    click_link 'Editar processo licitatório'

    page.should have_link 'Apurar'
  end

  scenario "count link should not be available when envelope opening date is not the current date" do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    page.should_not have_link 'Apurar'
  end

  scenario 'cannot show update and nested buttons when the publication is (extension, edital, edital_rectification)' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_publicacao_cancelada)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    page.should_not have_button 'Salvar'

    within_tab 'Documentos' do
      page.should_not have_button 'Remover'
    end

    within_tab 'Dotações orçamentárias' do
      page.should_not have_button 'Adicionar Item'
      page.should_not have_button 'Remover Item'
    end
  end

  scenario "should not have link to lots when creating a new licitation process" do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    page.should_not have_link 'Lotes de itens'
  end

  scenario "should show the count report by type_of_calculation being lowest_total_price_by_item" do
    licitation_process = LicitationProcess.make!(:apuracao_por_itens)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Apurar'

    page.should have_content 'Apuração: Menor preço total por item'
    page.should have_content 'Antivirus'
    page.should have_content 'Gabriel Sobrinho'
    page.should have_content '2'
    page.should have_content '9,00'
    page.should have_content '18,00'

    # back to form
    click_link 'Voltar'
    page.should have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario "should show the count report by type_of_calculation being sort_participants_by_item" do
    licitation_process = LicitationProcess.make!(:classificar_por_itens)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Apurar'

    page.should have_content 'Apuração: Classificar participantes por item (pregão presencial)'
    page.should have_content 'Antivirus'
    page.should have_content 'Gabriel Sobrinho'
    page.should have_content '9,00'
    page.should have_content '2'
    page.should have_content '18,00'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content '10,00'
    page.should have_content '2'
    page.should have_content '20,00'

    # back to form
    click_link 'Voltar'
    page.should have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario "should show the count report by type_of_calculation being highest_bidder_by_item" do
    licitation_process = LicitationProcess.make!(:maior_lance_por_itens)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Apurar'

    page.should have_content 'Apuração: Maior lance por item'
    page.should have_content 'Antivirus'
    page.should have_content '2'
    page.should have_content '10,00'
    page.should have_content '20,00'
    page.should have_content 'Wenderson Malheiros '

    # back to form
    click_link 'Voltar'
    page.should have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario "should show the count report by type_of_calculation being lowest_price_by_lot" do
    licitation_process = LicitationProcess.make!(:apuracao_por_lote)
    LicitationProcessLot.make!(:lote_antivirus, :licitation_process_id => licitation_process.id)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Apurar'

    page.should have_content 'Apuração: Menor preço por lote'
    page.should have_content 'Lote 1'
    page.should have_content 'Gabriel Sobrinho'
    page.should have_content '18,00'

    # back to form
    click_link 'Voltar'
    page.should have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario "should show the count report by type_of_calculation being sort_participants_by_lot" do
    licitation_process = LicitationProcess.make!(:classificar_por_lote)
    LicitationProcessLot.make!(:lote_antivirus, :licitation_process_id => licitation_process.id)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Apurar'

    page.should have_content 'Apuração: Classificar participantes por lote (pregão presencial)'
    page.should have_content 'Lote 1'
    page.should have_content 'Gabriel Sobrinho'
    page.should have_content '18,00'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content '20,00'

    # back to form
    click_link 'Voltar'
    page.should have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario "should show the count report by type_of_calculation being highest_bidder_by_lot" do
    licitation_process = LicitationProcess.make!(:maior_lance_por_lote)
    LicitationProcessLot.make!(:lote_antivirus, :licitation_process_id => licitation_process.id)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Apurar'

    page.should have_content 'Apuração: Maior lance por lote'
    page.should have_content 'Lote 1'
    page.should have_content '20,00'
    page.should have_content 'Wenderson Malheiros '

    # back to form
    click_link 'Voltar'
    page.should have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario "should show the count report by type_of_calculation being lowest_global_price" do
    licitation_process = LicitationProcess.make!(:apuracao_global)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Apurar'

    page.should have_content 'Apuração: Menor preço global'
    page.should have_content 'Gabriel Sobrinho'
    page.should have_content '18,00'

    # back to form
    click_link 'Voltar'
    page.should have_content "Editar Processo Licitatório #{licitation_process} do Processo Administrativo #{licitation_process.administrative_process}"
  end

  scenario "should brings some filled fields when creating a new licitatoin process" do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => "#{Date.current.year}"
      page.should have_field 'Data do processo', :with => "#{I18n.l(Date.current)}"
      page.should have_field 'Processo administrativo', :with => "1/2012"
      page.should have_field 'Abrev. modalidade', :with => "CV"
    end
  end

  scenario "cancelar button should redirect to the respective administrative_process" do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Cancelar'

    within_tab 'Dados gerais' do
      page.should have_field 'Processo', :with => '1'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data do processo', :with => '07/03/2012'
      page.should have_field 'Número do protocolo', :with => '00088/2012'
    end
  end

  scenario 'budget allocation with quantity empty and total item value should have 0 as unit value' do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    within_tab 'Dotações' do
      click_button 'Remover Item'
      click_button 'Adicionar Item'

      fill_in 'Valor total', :with => '20,00'

      page.should have_field 'Valor unitário', :with => '0,00'
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

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    within_tab 'Dados gerais' do
      select 'Global', :from => 'Tipo de empenho'

      fill_in 'Detalhamento do objeto', :with => 'detalhamento'
      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Unidade da validade da proposta'
      fill_modal 'Índice de reajuste', :with => 'XPTO', :field => 'Nome'
      fill_mask 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_mask 'Hora da entrega', :with => I18n.l(Date.current, :format => 'time')
      fill_mask 'Data da abertura dos envelopes', :with => I18n.l(Date.current)
      fill_mask 'Hora da abertura', :with => I18n.l(Date.current, :format => 'time')
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_mask 'Data do parecer', :with => '30/03/2012'
      fill_mask 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    click_button 'Salvar'

    page.should_not have_content 'Routing Error No route matches'
  end

  scenario "When administrative_process modality is auction, should filter type_of_calculation" do
    AdministrativeProcess.make!(:maior_lance_por_itens)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Novo processo licitatório'

    page.should have_css '#licitation_process_type_of_calculation option', :count => 3

    page.should have_select 'Tipo da apuração', :options => ['', 'Menor preço global', 'Menor preço por lote']
  end
end
