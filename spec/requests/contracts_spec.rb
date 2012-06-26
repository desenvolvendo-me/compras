# encoding: utf-8
require 'spec_helper'

feature "Contracts" do
  background do
    sign_in
  end

  scenario 'picking a licitation process' do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Contabilidade'

    click_link 'Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Processo licitatório', :field => 'Ano', :with => '2012'

    page.should have_disabled_field 'Compra direta'
    page.should have_field 'Objeto do contrato', :with => 'Licitação para compra de carteiras'
  end

  scenario 'picking a direct purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Contabilidade'

    click_link 'Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Compra direta', :field => 'Ano', :with => '2012'

    page.should have_disabled_field 'Processo licitatório'
    page.should have_field 'Objeto do contrato', :with => ''
  end

  scenario 'create a new contract' do
    Entity.make!(:detran)
    LicitationProcess.make!(:processo_licitatorio)
    DisseminationSource.make!(:jornal_municipal)
    Creditor.make!(:sobrinho)
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:wenderson)

    click_link 'Contabilidade'

    click_link 'Contratos'

    click_link 'Criar Contrato'

    page.should have_field 'Ano do contrato', :with => "#{Date.current.year}"
    page.should have_disabled_field 'Número sequencial'
    page.should have_disabled_field 'Contrato principal'

    select 'Aditivo', :from => 'Tipo'
    page.should_not have_disabled_field 'Contrato principal'
    select 'Contrato principal', :from => 'Tipo'
    page.should have_disabled_field 'Contrato principal'

    fill_in 'Ano do contrato', :with => '2012'
    fill_modal 'Entidade', :with => 'Detran'
    page.should have_field 'Número sequencial', :with => '1'

    fill_modal 'Local de publicação', :with => 'Jornal Oficial do Município', :field => 'Descrição'

    within_modal 'Fornecedor' do
      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho', :field => 'Nome'
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Data de publicação', :with => '10/01/2012'
    fill_in 'Número do contrato', :with => '001'
    fill_in 'Data da assinatura', :with => '01)01/2012'
    fill_in 'Data de validade', :with => '30/12/2012'

    attach_file 'Contrato', 'spec/fixtures/other_example_document.txt'

    fill_modal 'Processo licitatório', :field => 'Ano', :with => '2012'

    fill_in 'Objeto do contrato', :with => 'Objeto'
    fill_in 'Valor do contrato', :with => '1.000,00'
    fill_in 'Validade do contrato', :with => '12'

    select 'Empreitada integral', :from => 'Forma de execução'
    select 'Fiança bancária', :from => 'Garantias do contrato'
    select 'Sim', :from => 'Subcontração'

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

    page.should have_notice 'Contrato criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Número sequencial', :with => '1'
    page.should have_field 'Ano do contrato', :with => '2012'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Número do contrato', :with => '001'
    page.should have_field 'Data de publicação', :with => '10/01/2012'
    page.should have_field 'Data da assinatura', :with => '01/01/2012'
    page.should have_field 'Data de validade', :with => '30/12/2012'
    page.should have_field 'Objeto do contrato', :with => 'Objeto'
    page.should have_field 'Local de publicação', :with => 'Jornal Oficial do Município'
    page.should have_field 'Valor do contrato', :with => '1.000,00'
    page.should have_field 'Validade do contrato', :with => '12'
    page.should have_field 'Fornecedor', :with => 'Gabriel Sobrinho'

    page.should have_select 'Forma de execução', :selected => 'Empreitada integral'
    page.should have_select 'Garantias do contrato', :selected => 'Fiança bancária'
    page.should have_select 'Subcontração', :selected => 'Sim'
    page.should have_field 'Unidade orçamentaria gestora responsável', :with => '1 - Secretaria de Educação'
    page.should have_field 'Responsável pela unidade orçamentaria gestora', :with => 'Wenderson Malheiros'
    page.should have_field 'Advogado responsável pela gestão do contrato', :with => 'Wenderson Malheiros'
    page.should have_field 'O.A.B. do advogado responsável', :with => '5678'

    page.should have_link 'other_example_document.txt'
  end

  scenario 'update an existent contract' do
    Contract.make!(:primeiro_contrato)
    Entity.make!(:secretaria_de_educacao)

    click_link 'Contabilidade'

    click_link 'Contratos'

    within_records do
      page.find('a').click
    end

    fill_in 'Ano do contrato', :with => '2013'
    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Número do contrato', :with => '111'
    fill_in 'Data da assinatura', :with => '01/01/2013'
    fill_in 'Data de validade', :with => '30/12/2013'
    select 'Não', :from => 'Subcontração'
    attach_file 'Contrato', 'spec/fixtures/example_document.txt'

    click_button 'Salvar'

    page.should have_notice 'Contrato editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Ano do contrato', :with => '2013'
    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Número do contrato', :with => '111'
    page.should have_field 'Data da assinatura', :with => '01/01/2013'
    page.should have_field 'Data de validade', :with => '30/12/2013'
    page.should have_select 'Subcontração', :selected => 'Não'
    page.should have_link 'example_document.txt'
  end

  scenario 'destroy an existent contract' do
    Contract.make!(:primeiro_contrato)

    click_link 'Contabilidade'

    click_link 'Contratos'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Contrato apagado com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content 'Detran'
    page.should_not have_content '001'
    page.should_not have_content '002'
    page.should_not have_content '23/02/2012'
    page.should_not have_content '24/02/2012'
  end

  scenario 'show pledges' do
    Pledge.make!(:empenho_em_quinze_dias)
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Contratos'

    within_records do
      page.find('a').click
    end

    click_link 'Empenhos'

    page.driver.render '/home/tiago/Desktop/debug.png'
    page.should have_content '9,99'
    page.should have_content I18n.l(Date.current + 15.days)
    page.should have_content '19,98'
  end
end
