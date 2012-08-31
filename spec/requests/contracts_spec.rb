# encoding: utf-8
require 'spec_helper'

feature "Contracts" do
  background do
    sign_in
  end

  scenario 'picking a licitation process' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Contabilidade > Comum > Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Processo licitatório', :field => 'Ano', :with => '2012'

    expect(page).to have_disabled_field 'Compra direta'
    expect(page).to have_field 'Objeto do contrato', :with => 'Licitação para compra de carteiras'
    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_field 'Modalidade', :with => 'Convite para compras e serviços'
  end

  scenario 'picking a direct purchase' do
    DirectPurchase.make!(:compra)

    navigate 'Contabilidade > Comum > Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Compra direta', :field => 'Ano', :with => '2012'

    expect(page).to have_disabled_field 'Processo licitatório'
    expect(page).to have_field 'Objeto do contrato', :with => ''
    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_field 'Modalidade', :with => 'Material ou serviços'
  end

  scenario 'selecting a amendment contract, submeting with error, the main contract should still enabled' do
    navigate 'Contabilidade > Comum > Contratos'

    click_link 'Criar Contrato'

    expect(page).to have_disabled_field 'Contrato principal'
    select 'Aditivo', :from => 'Tipo'
    expect(page).not_to have_disabled_field 'Contrato principal'

    click_button 'Salvar'

    expect(page).to have_select 'Tipo', :selected => 'Aditivo'
    expect(page).not_to have_disabled_field 'Contrato principal'
  end

  scenario 'create a new contract' do
    Entity.make!(:detran)
    LicitationProcess.make!(:processo_licitatorio)
    DisseminationSource.make!(:jornal_municipal)
    Creditor.make!(:sobrinho)
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:wenderson)
    ServiceOrContractType.make!(:trainees)

    navigate 'Contabilidade > Comum > Contratos'

    click_link 'Criar Contrato'

    expect(page).to have_field 'Ano do contrato', :with => "#{Date.current.year}"
    expect(page).to have_disabled_field 'Número sequencial'
    expect(page).to have_disabled_field 'Contrato principal'
    expect(page).to have_disabled_field 'Modalidade'

    select 'Aditivo', :from => 'Tipo'
    expect(page).not_to have_disabled_field 'Contrato principal'
    select 'Contrato principal', :from => 'Tipo'
    expect(page).to have_disabled_field 'Contrato principal'

    fill_in 'Ano do contrato', :with => '2012'
    expect(page).to have_field 'Número sequencial', :with => '1'

    fill_modal 'Local de publicação', :with => 'Jornal Oficial do Município', :field => 'Descrição'

    fill_modal 'Fornecedor', :with => 'Gabriel Sobrinho'

    fill_in 'Data de publicação', :with => '10/01/2012'
    fill_in 'Número do contrato', :with => '001'
    fill_in 'Data da assinatura', :with => '01)01/2012'
    fill_in 'Data de validade', :with => '30/12/2012'

    attach_file 'Contrato', 'spec/fixtures/other_example_document.txt'

    fill_modal 'Processo licitatório', :field => 'Ano', :with => '2012'
    fill_modal 'Tipo de contrato', :with => 'Contratação de estagiários', :field => 'Descrição'

    fill_in 'Objeto do contrato', :with => 'Objeto'
    fill_in 'Valor do contrato', :with => '1.000,00'
    fill_in 'Validade do contrato', :with => '12'

    select 'Empreitada integral', :from => 'Forma de execução'
    select 'Fiança bancária', :from => 'Garantias do contrato'
    select 'Sim', :from => 'Subcontratação'

    fill_modal 'Unidade orçamentaria gestora responsável', :with => 'Secretaria de Educação', :field => 'Descrição'

    within_modal 'Advogado responsável pela gestão do contrato' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    within_modal 'Responsável pela unidade orçamentaria gestora' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    fill_in 'O.A.B. do advogado responsável', :with => '5678'

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato criado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Número sequencial', :with => '1'
    expect(page).to have_field 'Ano do contrato', :with => '2012'
    expect(page).to have_field 'Número do contrato', :with => '001'
    expect(page).to have_field 'Data de publicação', :with => '10/01/2012'
    expect(page).to have_field 'Data da assinatura', :with => '01/01/2012'
    expect(page).to have_field 'Data de validade', :with => '30/12/2012'
    expect(page).to have_field 'Objeto do contrato', :with => 'Objeto'
    expect(page).to have_field 'Local de publicação', :with => 'Jornal Oficial do Município'
    expect(page).to have_field 'Valor do contrato', :with => '1.000,00'
    expect(page).to have_field 'Validade do contrato', :with => '12'
    expect(page).to have_field 'Fornecedor', :with => 'Gabriel Sobrinho'

    expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
    expect(page).to have_select 'Garantias do contrato', :selected => 'Fiança bancária'
    expect(page).to have_select 'Subcontratação', :selected => 'Sim'
    expect(page).to have_field 'Modalidade', :with => 'Convite para compras e serviços'
    expect(page).to have_field 'Unidade orçamentaria gestora responsável', :with => '1 - Secretaria de Educação'
    expect(page).to have_field 'Responsável pela unidade orçamentaria gestora', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Advogado responsável pela gestão do contrato', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'O.A.B. do advogado responsável', :with => '5678'

    expect(page).to have_link 'other_example_document.txt'
  end

  scenario 'update an existent contract' do
    Contract.make!(:primeiro_contrato)
    Entity.make!(:secretaria_de_educacao)

    navigate 'Contabilidade > Comum > Contratos'

    within_records do
      page.find('a').click
    end

    fill_in 'Ano do contrato', :with => '2013'
    fill_in 'Número do contrato', :with => '111'
    fill_in 'Data da assinatura', :with => '01/01/2013'
    fill_in 'Data de validade', :with => '30/12/2013'
    select 'Não', :from => 'Subcontratação'
    attach_file 'Contrato', 'spec/fixtures/example_document.txt'

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato editado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Ano do contrato', :with => '2013'
    expect(page).to have_field 'Número do contrato', :with => '111'
    expect(page).to have_field 'Data da assinatura', :with => '01/01/2013'
    expect(page).to have_field 'Data de validade', :with => '30/12/2013'
    expect(page).to have_select 'Subcontratação', :selected => 'Não'
    expect(page).to have_link 'example_document.txt'
  end

  scenario 'destroy an existent contract' do
    Contract.make!(:primeiro_contrato)

    navigate 'Contabilidade > Comum > Contratos'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Contrato apagado com sucesso.'

    expect(page).not_to have_content '2012'
    expect(page).not_to have_content 'Detran'
    expect(page).not_to have_content '001'
    expect(page).not_to have_content '002'
    expect(page).not_to have_content '23/02/2012'
    expect(page).not_to have_content '24/02/2012'
  end

  scenario 'show pledges' do
    Pledge.make!(:empenho_em_quinze_dias)
    Pledge.make!(:founded_debt)

    navigate 'Contabilidade > Comum > Contratos'

    within_records do
      page.find('a').click
    end

    click_link 'Empenhos'

    expect(page).to have_content '9,99'
    expect(page).to have_content I18n.l(Date.current + 15.days)
    expect(page).to have_content '19,98'
  end

  scenario 'add delivery schedule' do
    DeliverySchedule.make!(:primeira_entrega)

    navigate 'Contabilidade > Comum > Contratos'

    within_records do
      page.find('a').click
    end

    click_link 'Cronogramas de entrega'

    expect(page).to have_field 'Observações', :with => 'entregue com atraso'
    expect(page).to have_field 'Data de entrega', :with => '02/01/2012'
    expect(page).to have_field 'Data prevista', :with => '01/01/2012'
    expect(page).to have_select 'Status', :selected => 'Entregue'

    click_button 'Adicionar Cronograma de Entrega'

    within '.delivery_schedule:last' do
      expect(page).to have_field 'Sequência', :with => '2'

      fill_in 'Data de entrega', :with => '10/01/2012'
      select 'Vencido', :from => 'Status'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato editado com sucesso.'

    within_records do
      page.find('a').click
    end

    click_link 'Cronogramas de entrega'

    expect(page).to have_field 'Observações', :with => 'entregue com atraso'
    expect(page).to have_field 'Data de entrega', :with => '02/01/2012'
    expect(page).to have_field 'Data prevista', :with => '01/01/2012'
    expect(page).to have_select 'Status', :selected => 'Entregue'

    expect(page).to have_field 'Data de entrega', :with => '10/01/2012'
    expect(page).to have_select 'Status', :selected => 'Vencido'
  end

  scenario 'remove delivery schedule' do
    DeliverySchedule.make!(:primeira_entrega)

    navigate 'Contabilidade > Comum > Contratos'

    within_records do
      page.find('a').click
    end

    click_link 'Cronogramas de entrega'

    click_button 'Remover Cronograma de Entrega'

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato editado com sucesso.'

    within_records do
      page.find('a').click
    end

    click_link 'Cronogramas de entrega'

    expect(page).not_to have_field 'Observações', :with => 'entregue com atraso'
    expect(page).not_to have_field 'Data de entrega', :with => '02/01/2012'
    expect(page).not_to have_field 'Data prevista', :with => '01/01/2012'
    expect(page).not_to have_select 'Status', :selected => 'Entregue'
  end
end
