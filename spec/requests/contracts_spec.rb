# encoding: utf-8
require 'spec_helper'

feature "Contracts" do
  background do
    sign_in
  end

  scenario 'picking a licitation process' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Comum > Cadastrais > Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Processo de compra', :field => 'Ano', :with => '2012'

    expect(page).to have_disabled_field 'Compra direta'
    expect(page).to have_field 'Objeto do contrato', :with => 'Licitação para compra de carteiras'
    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência'
    expect(page).to have_disabled_field 'Forma de execução', :with => 'Empreitada integral'
    expect(page).to have_disabled_field 'Garantias do contrato', :with => 'Fiança bancária'

    clear_modal 'Processo de compra'
    expect(page).to have_field 'Modalidade', :with => ''
    expect(page).to have_field 'Forma de execução', :with => ''
    expect(page).to have_field 'Garantias do contrato', :with => ''
    expect(page).to have_field 'Processo de compra', :with => ''
    expect(page).to have_field 'Compra direta', :with => ''
  end

  scenario 'picking a direct purchase' do
    DirectPurchase.make!(:compra)

    navigate 'Comum > Cadastrais > Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Compra direta', :field => 'Ano', :with => '2012'

    expect(page).to have_disabled_field 'Processo de compra'
    expect(page).to have_field 'Objeto do contrato', :with => ''
    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_field 'Modalidade', :with => 'Material ou serviços'
    expect(page).to have_disabled_field 'Forma de execução', :with => ''
    expect(page).to have_disabled_field 'Garantias do contrato', :with => ''
  end

  scenario 'selecting a amendment contract, submeting with error, the main contract should still enabled' do
    navigate 'Comum > Cadastrais > Contratos'

    click_link 'Criar Contrato'

    expect(page).to have_disabled_field 'Contrato principal'
    select 'Aditivo', :from => 'Tipo'
    expect(page).to_not have_disabled_field 'Contrato principal'

    click_button 'Salvar'

    expect(page).to have_select 'Tipo', :selected => 'Aditivo'
    expect(page).to_not have_disabled_field 'Contrato principal'
  end

  scenario 'create, update and destroy a new contract' do
    Entity.make!(:detran)
    LicitationProcess.make!(:processo_licitatorio)
    DisseminationSource.make!(:jornal_municipal)
    Creditor.make!(:sobrinho)
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:wenderson)
    ContractType.make!(:trainees)

    navigate 'Comum > Cadastrais > Contratos'

    click_link 'Criar Contrato'

    expect(page).to have_field 'Ano do contrato', :with => "#{Date.current.year}"
    expect(page).to have_disabled_field 'Número sequencial'
    expect(page).to have_disabled_field 'Contrato principal'
    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_disabled_field 'Forma de execução'
    expect(page).to have_disabled_field 'Garantias do contrato'

    select 'Aditivo', :from => 'Tipo'
    expect(page).to_not have_disabled_field 'Contrato principal'
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

    fill_modal 'Processo de compra', :field => 'Ano', :with => '2012'
    fill_modal 'Tipo de contrato', :with => 'Contratação de estagiários', :field => 'Descrição'

    fill_in 'Objeto do contrato', :with => 'Objeto'
    fill_in 'Valor do contrato', :with => '1.000,00'
    fill_in 'Validade do contrato', :with => '12'

    select 'Sim', :from => 'Subcontratação'

    fill_modal 'Unidade orçamentária gestora responsável', :with => 'Secretaria de Educação', :field => 'Descrição'

    within_modal 'Advogado responsável pela gestão do contrato' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    within_modal 'Responsável pela unidade orçamentária gestora' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    fill_in 'O.A.B. do advogado responsável', :with => '5678'

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato criado com sucesso.'

    click_link "Limpar Filtro"

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

    expect(page).to have_select 'Subcontratação', :selected => 'Sim'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência'
    expect(page).to have_field 'Forma de execução', :with => 'Empreitada integral'
    expect(page).to have_field 'Garantias do contrato', :with => 'Fiança bancária'
    expect(page).to have_field 'Unidade orçamentária gestora responsável', :with => '1 - Secretaria de Educação'
    expect(page).to have_field 'Responsável pela unidade orçamentária gestora', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Advogado responsável pela gestão do contrato', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'O.A.B. do advogado responsável', :with => '5678'

    expect(page).to have_link 'other_example_document.txt'

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

    click_link 'Apagar'

    expect(page).to have_notice 'Contrato apagado com sucesso.'

    expect(page).to_not have_content '2012'
    expect(page).to_not have_content 'Detran'
    expect(page).to_not have_content '001'
    expect(page).to_not have_content '002'
    expect(page).to_not have_content '23/02/2012'
    expect(page).to_not have_content '24/02/2012'
  end

  scenario 'show pledges' do
    Pledge.make!(:empenho_em_quinze_dias)
    Pledge.make!(:founded_debt)

    navigate 'Comum > Cadastrais > Contratos'

    click_link "Limpar Filtro"

    within_records do
      click_link '001'
    end

    click_link 'Empenhos'

    expect(page).to have_content '9,99'
    expect(page).to have_content I18n.l(Date.current + 15.days)
    expect(page).to have_content '19,98'
  end

  scenario 'add delivery schedule' do
    DeliverySchedule.make!(:primeira_entrega)

    navigate 'Comum > Cadastrais > Contratos'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Cronogramas de entrega'

    expect(page).to have_field 'Observações', :with => 'entregue com atraso'
    expect(page).to have_field 'Data de entrega', :with => '02/01/2012'
    expect(page).to have_field 'Data prevista', :with => '01/01/2012'
    expect(page).to have_select 'Status', :selected => 'Entregue'

    click_button 'Adicionar Cronograma de Entrega'

    within '.nested-delivery-schedule:last' do
      expect(page).to have_field 'Sequência', :with => '2'

      fill_in 'Data de entrega', :with => '10/01/2012'
      select 'Vencido', :from => 'Status'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato editado com sucesso.'

    click_link "Limpar Filtro"

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

    navigate 'Comum > Cadastrais > Contratos'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Cronogramas de entrega'

    click_button 'Remover Cronograma de Entrega'

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato editado com sucesso.'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Cronogramas de entrega'

    expect(page).to_not have_field 'Observações', :with => 'entregue com atraso'
    expect(page).to_not have_field 'Data de entrega', :with => '02/01/2012'
    expect(page).to_not have_field 'Data prevista', :with => '01/01/2012'
    expect(page).to_not have_select 'Status', :selected => 'Entregue'
  end

  scenario 'index with columns at the index' do
    Contract.make!(:primeiro_contrato)

    navigate 'Comum > Cadastrais > Contratos'

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_content 'Número do contrato'
      expect(page).to have_content 'Ano do contrato'
      expect(page).to have_content 'Data de publicação'
      expect(page).to have_content 'Fornecedor'


      within 'tbody tr' do
        expect(page).to have_content '001'
        expect(page).to have_content '2012'
        expect(page).to have_content '10/01/2012'
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end
  end
end
