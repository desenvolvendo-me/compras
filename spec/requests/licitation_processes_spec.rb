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

    click_link 'Processos Administrativos'

    click_link 'Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '21/03/2012'
      fill_modal 'Número do processo administrativo', :with => '1', :field => 'Processo'
      fill_in 'Detalhamento do objeto', :with => 'detalhamento'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5 dias'
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
      page.should have_field 'Número do processo administrativo', :with => '1/2012'
      page.should have_field 'Detalhamento do objeto', :with => 'detalhamento'
      page.should have_field 'Fonte de recurso', :with => 'Reforma e Ampliação'
      page.should have_field 'Validade da proposta', :with => '5 dias'
      page.should have_field 'Índice de reajuste', :with => 'XPTO'
      page.should have_field 'Prazo de entrega', :with => '1 ano'
      page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
      page.should have_field 'Valor da caução', :with => '50,00'
      page.should have_select 'Parecer jurídico', :selected => 'Favorável'
      page.should have_field 'Data do parecer', :with => '30/03/2012'
      page.should have_field 'Data do contrato', :with => '31/03/2012'
      page.should have_field 'Validade do contrato (meses)', :with => '5'
      page.should have_field 'Observações gerais', :with => 'observacoes'
    end
  end

  scenario 'update an existent licitation_process' do
    LicitationProcess.make!(:processo_licitatorio)
    AdministrativeProcess.make!(:compra_de_computadores)
    Capability.make!(:construcao)
    Period.make!(:tres_meses)
    PaymentMethod.make!(:cheque)

    click_link 'Processos Administrativos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      fill_in 'Data do processo', :with => '21/03/2013'
      fill_modal 'Número do processo administrativo', :with => '2013', :field => 'Ano'
      fill_in 'Detalhamento do objeto', :with => 'novo detalhamento'
      fill_modal 'Fonte de recurso', :with => 'Construção', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '10 dias'
      fill_in 'Índice de reajuste', :with => 'IPC'
      fill_modal 'Prazo de entrega', :with => '3', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '60,00'
      select 'Contrário', :from => 'Parecer jurídico'
      fill_in 'Data do parecer', :with => '30/03/2013'
      fill_in 'Data do contrato', :with => '31/03/2013'
      fill_in 'Validade do contrato (meses)', :with => '6'
      fill_in 'Observações gerais', :with => 'novas observacoes'
    end

    click_button 'Atualizar Processo Licitatório'

    page.should have_notice 'Processo Licitatório editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Data do processo', :with => '21/03/2013'
      page.should have_field 'Número do processo administrativo', :with => '1/2013'
      page.should have_field 'Detalhamento do objeto', :with => 'novo detalhamento'
      page.should have_field 'Fonte de recurso', :with => 'Construção'
      page.should have_field 'Validade da proposta', :with => '10 dias'
      page.should have_field 'Índice de reajuste', :with => 'IPC'
      page.should have_field 'Prazo de entrega', :with => '3 meses'
      page.should have_field 'Forma de pagamento', :with => 'Cheque'
      page.should have_field 'Valor da caução', :with => '60,00'
      page.should have_select 'Parecer jurídico', :selected => 'Contrário'
      page.should have_field 'Data do parecer', :with => '30/03/2013'
      page.should have_field 'Data do contrato', :with => '31/03/2013'
      page.should have_field 'Validade do contrato (meses)', :with => '6'
      page.should have_field 'Observações gerais', :with => 'novas observacoes'
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

  scenario 'creating another licitation with the same year to test process number' do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Processos Administrativos'

    click_link 'Processos Licitatórios'

    click_link 'Criar Processo Licitatório'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Processo'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data do processo', :with => '21/04/2012'
      fill_modal 'Número do processo administrativo', :with => '1', :field => 'Processo'
      fill_in 'Detalhamento do objeto', :with => 'detalhamento'
      fill_modal 'Fonte de recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Validade da proposta', :with => '5 dias'
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

    click_button 'Criar Processo Licitatório'

    page.should have_notice 'Processo Licitatório criado com sucesso.'

    page.should have_link '1/2012'
    page.should have_link '2/2012'
  end
end
