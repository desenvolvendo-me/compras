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
    Period.make!(:um_ano)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'
      page.should have_disabled_field 'Unidade orçamentária'
      page.should have_disabled_field 'Modalidade'
      page.should have_disabled_field 'Tipo de objeto'
      page.should have_disabled_field 'Forma de julgamento'
      page.should have_disabled_field 'Objeto do processo licitatório'
      page.should have_disabled_field 'Responsável'
      page.should have_disabled_field 'Inciso'
      page.should have_disabled_field 'Data da homologação'
      page.should have_disabled_field 'Data da adjudicação'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '21/03/2012'
      fill_modal 'Processo administrativo', :with => '1', :field => 'Processo'
      select 'Global', :from => 'Tipo de empenho'

      # testing delegated fields of administrative process (filled by javascript)
      page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
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
      fill_in 'Validade da proposta', :with => '5 dias'
      fill_in 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '14:00'
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora da abertura', :with => '14:00'
      fill_in 'Índice de reajuste', :with => 'XPTO'
      fill_modal 'Prazo de entrega', :with => '1', :field => 'Quantidade'
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
      page.should have_field 'Dotação orçamentária', :with => budget_allocation.to_s
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '20,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'Unidade'

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário', :with => '10,00'

      # asserting calculated total price of the item
      page.should have_field 'Valor total', :with => '20,00'
    end

    within_tab 'Publicações' do
      click_button "Adicionar Publicação"

      fill_in "Nome do veículo de comunicação", :with => 'Jornal'
      fill_in "Data da publicação", :with => '20/04/2012'
      select "Edital", :from => "Publicação do(a)"
      select "Internet", :from => "Tipo de circulação do veículo de comunicação"
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'
      page.should have_disabled_field 'Ano'

      page.should have_field 'Processo', :with => '1'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data do processo', :with => '21/03/2012'
      page.should have_field 'Processo administrativo', :with => '1/2012'
      page.should have_select 'Tipo de empenho', :selected => 'Global'

      # testing delegated fields of administrative process
      page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Modalidade', :with => 'Convite para compras e serviços de engenharia'
      page.should have_field 'Tipo de objeto', :with => 'Compras e serviços'
      page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Inciso', :with => 'Item 1'

      page.should have_field 'Detalhamento do objeto', :with => 'detalhamento'
      page.should have_select 'Tipo da apuração', :with => 'Menor preço global'
      page.should have_field 'Fonte de recurso', :with => 'Reforma e Ampliação'
      page.should have_field 'Validade da proposta', :with => '5 dias'
      page.should have_field 'Índice de reajuste', :with => 'XPTO'
      page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      page.should have_field 'Hora da entrega', :with => '14:00'
      page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Hora da abertura', :with => '14:00'
      page.should have_field 'Prazo de entrega', :with => '1 ano'
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
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '20,00'

      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Unidade', :with => 'Unidade'
      page.should have_field 'Quantidade', :with => '2'
      page.should have_field 'Valor unitário', :with => '10,00'
      page.should have_field 'Valor total', :with => '20,00'

      page.should have_field 'Item', :with => '1'
    end

    within_tab 'Publicações' do
      page.should have_field 'Nome do veículo de comunicação', :with => 'Jornal'
      page.should have_field 'Data da publicação', :with => '20/04/2012'
      page.should have_select 'Publicação do(a)', :selected => 'Edital'
      page.should have_select 'Tipo de circulação do veículo de comunicação', :selected => 'Internet'
    end
  end

  scenario 'update an existent licitation_process' do
    LicitationProcess.make!(:processo_licitatorio)
    administrative_process = AdministrativeProcess.make!(:compra_de_computadores)
    budget_allocation = administrative_process.administrative_process_budget_allocations.first.budget_allocation
    Capability.make!(:construcao)
    Period.make!(:tres_meses)
    PaymentMethod.make!(:cheque)
    DocumentType.make!(:oficial)
    Material.make!(:arame_farpado)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      fill_in 'Data do processo', :with => '21/03/2013'
      fill_modal 'Processo administrativo', :with => '2013', :field => 'Ano'
      select 'Estimativo', :from => 'Tipo de empenho'
      fill_in 'Detalhamento do objeto', :with => 'novo detalhamento'
      select 'Menor preço por lote', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Construção', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '10 dias'
      fill_in 'Índice de reajuste', :with => 'IPC'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora da entrega', :with => '15:00'
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      fill_in 'Hora da abertura', :with => '15:00'
      fill_modal 'Prazo de entrega', :with => '3', :field => 'Quantidade'
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
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'Unidade'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor total', :with => '20,00'

      # asserting calculated unit price of the item
      page.should have_field 'Valor unitário', :with => '4,00'
    end

    within_tab 'Publicações' do
      click_button "Remover Publicação"
      click_button "Adicionar Publicação"

      fill_in "Nome do veículo de comunicação", :with => 'Periodico'
      fill_in "Data da publicação", :with => '20/04/2013'
      select "Cancelamento", :from => "Publicação do(a)"
      select "Mural público", :from => "Tipo de circulação do veículo de comunicação"
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Data do processo', :with => '21/03/2013'
      page.should have_field 'Processo administrativo', :with => '1/2013'
      page.should have_select 'Tipo de empenho', :selected => 'Estimativo'
      page.should have_field 'Detalhamento do objeto', :with => 'novo detalhamento'
      page.should have_select 'Tipo da apuração', :with => 'Menor preço por lote'
      page.should have_field 'Fonte de recurso', :with => 'Construção'
      page.should have_field 'Validade da proposta', :with => '10 dias'
      page.should have_field 'Índice de reajuste', :with => 'IPC'
      page.should have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Hora da entrega', :with => '15:00'
      page.should have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow + 1.day)
      page.should have_field 'Hora da abertura', :with => '15:00'
      page.should have_field 'Prazo de entrega', :with => '3 meses'
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
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '20,00'

      page.should have_field 'Material', :with => '02.02.00001 - Arame farpado'
      page.should have_field 'Unidade', :with => 'Unidade'
      page.should have_field 'Quantidade', :with => '5'
      page.should have_field 'Valor unitário', :with => '4,00'
      page.should have_field 'Valor total', :with => '20,00'

      page.should have_field 'Item', :with => '1'
    end

    within_tab 'Publicações' do
      page.should_not have_field 'Nome do veículo de comunicação', :with => 'Jornal'

      page.should have_field 'Nome do veículo de comunicação', :with => 'Periodico'
      page.should have_field 'Data da publicação', :with => '20/04/2013'
      page.should have_select 'Publicação do(a)', :selected => 'Cancelamento'
      page.should have_select 'Tipo de circulação do veículo de comunicação', :selected => 'Mural público'
    end
  end

  scenario 'creating another licitation with the same year to test process number and licitation number' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    AdministrativeProcess.make!(:compra_com_itens_2)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'

      fill_in 'Ano', :with => '2013'
      fill_in 'Data do processo', :with => '21/04/2013'
      fill_modal 'Processo administrativo', :with => '2013', :field => 'Ano'
      select 'Global', :from => 'Tipo de empenho'
      fill_in 'Detalhamento do objeto', :with => 'detalhamento'
      select 'Menor preço global', :from => 'Tipo da apuração'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5 dias'
      fill_in 'Índice de reajuste', :with => 'XPTO'
      fill_in 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora da entrega', :with => '15:00'
      fill_in 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora da abertura', :with => '15:00'
      fill_modal 'Prazo de entrega', :with => '1', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Favorável', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2012'
      fill_in 'Data do contrato', :with => '31/03/2012'
      fill_in 'Validade do contrato (meses)', :with => '5'
      fill_in 'Observações gerais', :with => 'observacoes'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório criado com sucesso.'

    click_link "#{licitation_process.process}/2013"

    within_tab 'Dados gerais' do
      page.should have_field 'Processo', :with => licitation_process.process.to_s
      page.should have_field 'Número da licitação', :with => licitation_process.licitation_number.to_s
    end
  end

  scenario 'cannot include the same material twice on a budget allocation' do
    LicitationProcess.make!(:processo_licitatorio)
    Material.make!(:antivirus)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

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

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações' do
      page.should have_field 'Valor previsto', :with => "20,00"
      page.should have_field 'Valor total dos itens', :with => "20,00"

      fill_in 'Valor total', :with => '21,00'

      page.should have_field 'Valor total dos itens', :with => "21,00"
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'deve ser igual ao valor previsto'
    end
  end

  scenario 'calculating total of items via javascript' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dados gerais' do
      fill_modal 'Processo administrativo', :with => '1', :field => 'Processo'
    end

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

  scenario 'should show only available administrative process in modal' do
    AdministrativeProcess.make!(:compra_de_cadeiras)
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    administrative_process_taken = licitation_process.administrative_process

    administrative_process_taken.protocol.should eq '00088/2012'

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dados gerais' do
      fill_modal 'Processo administrativo', :with => '1', :field => 'Processo' do
        click_button 'Pesquisar'

        page.should have_content '00099/2012'
        page.should_not have_content '00088/2012'
      end
    end
  end

  scenario 'the old administrative_process items should be cleaned on update' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    AdministrativeProcess.make!(:compra_de_computadores)
    Material.make!(:arame_farpado)

    old_administrative_process = licitation_process.administrative_process

    old_administrative_process.administrative_process_budget_allocations.first.items.size.should eq 1

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      fill_modal 'Processo administrativo', :with => '2013', :field => 'Ano'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor total', :with => '20,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Processo administrativo', :with => '1/2013'
    end

    old_administrative_process.administrative_process_budget_allocations.first.items.size.should eq 0
  end

  scenario 'administrative process modal should list only released administrative processes' do
    AdministrativeProcess.make!(:compra_aguardando)
    AdministrativeProcess.make!(:compra_com_itens)
    AdministrativeProcess.make!(:compra_liberada)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dados gerais' do
      within_modal 'Processo administrativo' do
        click_button 'Pesquisar'

        page.should have_css("table.records tbody tr", :count => 1)
        page.should have_content '2012'
        page.should have_content '1'
        page.should have_content '00088/2012'
      end
    end
  end

  scenario 'testing that it cleans the invited bidder when modality is not invitation for construction or purchase' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    AdministrativeProcess.make!(:compra_sem_convite)

    licitation_process.licitation_process_invited_bidders.size.should eq 1

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    page.should have_link 'Licitantes convidados'

    within_tab 'Dados gerais' do
      fill_modal 'Processo administrativo', :with => '2014', :field => 'Ano'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório editado com sucesso.'

    licitation_process.licitation_process_invited_bidders.size.should eq 0

    within_records do
      page.find('a').click
    end

    page.should_not have_link 'Licitantes convidados'
  end

  scenario 'change document types to ensure that the changes are reflected on invited bidder documents' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    DocumentType.make!(:oficial)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes convidados'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Documento', :with => 'Fiscal'

    click_link 'Cancelar'

    click_link 'Voltar ao processo licitatório'

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    click_button 'Salvar'

    page.should have_notice 'Processo Licitatório editado com sucesso.'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes convidados'

    within_records do
      page.find('a').click
    end

    page.should_not have_field 'Documento', :with => 'Fiscal'
    page.should have_field 'Documento', :with => 'Oficial'
  end

  scenario "count link should be available when envelope opening date is the current date" do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      fill_in 'Data da abertura dos envelopes', :with => "#{I18n.l(Date.current)}"
    end

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should have_link 'Apurar'
  end

  scenario "count link should not be available when envelope opening date is not the current date" do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    page.should_not have_link 'Apurar'
  end

  scenario 'cannot show update and nested buttons when the publication is (extension, edital, edital_rectification)' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_publicacao_cancelada)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    click_link licitation_process.to_s

    page.should_not have_button 'Salvar'

    within_tab 'Documentos' do
      page.should_not have_button 'Remover'
    end

    within_tab 'Dotações orçamentárias' do
      page.should_not have_button 'Adicionar Item'
      page.should_not have_button 'Remover Item'
    end

    within_tab 'Publicações' do
      page.should_not have_button 'Adicionar Publicação'
      page.should_not have_button 'Remover Publicação'
    end
  end
end
