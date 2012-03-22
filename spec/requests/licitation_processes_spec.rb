# encoding: utf-8
require 'spec_helper'

feature "LicitationProcesses" do
  background do
    sign_in
  end

  scenario 'create a new licitation_process' do
    AdministrativeProcess.make!(:compra_de_cadeiras)
    Capability.make!(:reforma)
    Period.make!(:um_ano)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Processos Administrativos'

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

      # testing delegated fields of administrative process (filled by javascript)
      page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Modalidade', :with => 'Pregão presencial'
      page.should have_field 'Tipo de objeto', :with => 'Compras e serviços'
      page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Inciso', :with => 'Item 1'
      page.should have_field 'Abrev. modalidade', :with => 'PP'

      fill_in 'Detalhamento do objeto', :with => 'detalhamento'
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
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
      fill_in 'Valor previsto', :with => '50,00'
      select 'Global', :from => 'Tipo de empenho'

      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Compl. do elemento', :with => '3.1.90.11.01.00.00.00'
    end

    click_button 'Criar Processo Licitatório'

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

      # testing delegated fields of administrative process
      page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Modalidade', :with => 'Pregão presencial'
      page.should have_field 'Tipo de objeto', :with => 'Compras e serviços'
      page.should have_field 'Forma de julgamento', :with => 'Forma Global com Menor Preço'
      page.should have_field 'Objeto do processo licitatório', :with => 'Licitação para compra de carteiras'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Inciso', :with => 'Item 1'

      page.should have_field 'Detalhamento do objeto', :with => 'detalhamento'
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
      page.should have_field 'Abrev. modalidade', :with => 'PP'

      # testing that delegated fields are cleaned when administrative proccess is cleaned
      clear_modal 'Processo administrativo'

      page.should have_field 'Unidade orçamentária', :with => ''
      page.should have_field 'Modalidade', :with => ''
      page.should have_field 'Tipo de objeto', :with => ''
      page.should have_field 'Forma de julgamento', :with => ''
      page.should have_field 'Objeto do processo licitatório', :with => ''
      page.should have_field 'Responsável', :with => ''
      page.should have_field 'Inciso', :with => ''
      page.should have_field 'Abrev. modalidade', :with => ''
    end

    within_tab 'Documentos' do
      page.should have_content 'Fiscal'
      page.should have_content '10'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => "#{allocation.id}/2012 - Alocação"
      page.should have_field 'Compl. do elemento', :with => '3.1.90.11.01.00.00.00'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Valor previsto', :with => '50,00'
      page.should have_select 'Tipo de empenho', :selecte => 'Global'
    end
  end

  scenario 'update an existent licitation_process' do
    LicitationProcess.make!(:processo_licitatorio)
    AdministrativeProcess.make!(:compra_de_computadores)
    Capability.make!(:construcao)
    Period.make!(:tres_meses)
    PaymentMethod.make!(:cheque)
    DocumentType.make!(:oficial)
    allocation = BudgetAllocation.make!(:alocacao_extra)

    click_link 'Processos Administrativos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      fill_in 'Data do processo', :with => '21/03/2013'
      fill_modal 'Processo administrativo', :with => '2013', :field => 'Ano'
      fill_in 'Detalhamento do objeto', :with => 'novo detalhamento'
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
      click_button 'Remover Dotação'
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2011', :field => 'Exercício'
      fill_in 'Valor previsto', :with => '70,00'
      select 'Ordinário', :from => 'Tipo de empenho'

      page.should have_field 'Saldo da dotação', :with => '200,00'
      page.should have_field 'Compl. do elemento', :with => '3.1.90.11.01.00.00.00'
    end

    click_button 'Atualizar Processo Licitatório'

    page.should have_notice 'Processo Licitatório editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Data do processo', :with => '21/03/2013'
      page.should have_field 'Processo administrativo', :with => '1/2013'
      page.should have_field 'Detalhamento do objeto', :with => 'novo detalhamento'
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
      page.should_not have_content '10'

      page.should have_content 'Oficial'
      page.should have_content '20'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => "#{allocation.id}/2011 - Alocação extra"
      page.should have_field 'Compl. do elemento', :with => '3.1.90.11.01.00.00.00'
      page.should have_field 'Saldo da dotação', :with => '200,00'
      page.should have_field 'Valor previsto', :with => '70,00'
      page.should have_select 'Tipo de empenho', :selecte => 'Ordinário'
    end
  end

  scenario 'destroy an existent licitation_process' do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos Administrativos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Processo Licitatório apagado com sucesso.'

    page.should_not have_content '19/03/2012'
    page.should_not have_content '1/2012'
    page.should_not have_content 'Reforma e Ampliação'
    page.should_not have_content '1 ano'
  end

  scenario 'creating another licitation with the same year to test process number and licitation number' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos Administrativos'

    click_link 'Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '21/04/2012'
      fill_modal 'Processo administrativo', :with => '1', :field => 'Processo'
      fill_in 'Detalhamento do objeto', :with => 'detalhamento'
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

    click_button 'Criar Processo Licitatório'

    page.should have_notice 'Processo Licitatório criado com sucesso.'

    new_licitation_link = (licitation_process.id+1).to_s
    click_link new_licitation_link

    within_tab 'Dados gerais' do
      page.should have_field 'Processo', :with => '2'
      page.should have_field 'Número da licitação', :with => '2'
    end
  end
end
