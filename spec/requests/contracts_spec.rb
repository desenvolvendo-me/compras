# encoding: utf-8
require 'spec_helper'

feature "Contracts" do
  let :pledge do
    Pledge.new(id: 1, value: 9.99, description: 'Empenho 1',
      year: 2013, to_s: 1, emission_date: "2013-01-01")
  end

  let :pledge_two do
    Pledge.new(id: 2, value: 15.99, description: 'Empenho 2',
      year: 2012, to_s: 2, emission_date: "2012-01-01")
  end

  background do
    sign_in

    UnicoAPI::Resources::Contabilidade::Pledge.stub(:all).and_return([pledge, pledge_two])

    UnicoAPI::Resources::Contabilidade::Pledge.stub(:find).with(1).and_return(pledge)
    UnicoAPI::Resources::Contabilidade::Pledge.stub(:find).with(2).and_return(pledge_two)
  end

  scenario 'picking a licitation process' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Instrumentos Contratuais > Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Processo de compra', :field => 'Ano', :with => '2012'

    expect(page).to have_field 'Objeto do contrato', :with => 'Licitação para compra de carteiras'
    expect(page).to have_disabled_field 'Modalidade'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência'
    expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
    expect(page).to have_select 'Garantias do contrato', :selected => 'Fiança bancária'

    clear_modal 'Processo de compra'
    expect(page).to have_field 'Modalidade', :with => ''
    expect(page).to have_select 'Forma de execução', :with => ''
    expect(page).to have_select 'Garantias do contrato', :with => ''
    expect(page).to have_field 'Processo de compra', :with => ''
  end

  scenario 'selecting a amendment contract, submeting with error, the main contract should still enabled' do
    navigate 'Instrumentos Contratuais > Contratos'

    click_link 'Criar Contrato'

    expect(page).to have_disabled_field 'Contrato principal'
    select 'Aditivo', :from => 'Tipo'
    expect(page).to_not have_disabled_field 'Contrato principal'

    click_button 'Salvar'

    expect(page).to have_select 'Tipo', :selected => 'Aditivo'
    expect(page).to_not have_disabled_field 'Contrato principal'
  end

  scenario 'create, update and destroy a new contract' do
    LicitationProcess.make!(:processo_licitatorio)
    DisseminationSource.make!(:jornal_municipal)
    Creditor.make!(:sobrinho)
    BudgetStructure.make!(:secretaria_de_educacao)
    Employee.make!(:wenderson)
    ContractType.make!(:trainees)

    navigate 'Instrumentos Contratuais > Contratos'

    click_link 'Criar Contrato'

    expect(page).to have_field 'Ano do contrato', :with => "#{Date.current.year}"
    expect(page).to have_disabled_field 'Número sequencial'
    expect(page).to have_disabled_field 'Contrato principal'
    expect(page).to have_disabled_field 'Modalidade'

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
    fill_in 'Data da assinatura', :with => '01/01/2012'
    fill_in 'Início da vigência', :with => '01/01/2012'
    fill_in 'Data de validade', :with => '30/12/2012'

    attach_file 'Contrato', 'spec/fixtures/other_example_document.txt'

    fill_modal 'Processo de compra', :field => 'Ano', :with => '2012'
    fill_modal 'Tipo de contrato', :with => 'Contratação de estagiários', :field => 'Descrição'

    fill_in 'Objeto do contrato', :with => 'Objeto'
    fill_in 'Valor do contrato', :with => '1.000,00'
    fill_in 'Multa rescisória', :with => 'rescisória'
    fill_in 'Multa inadimplemento', :with => 'inadimplemento'
    fill_in 'Validade do contrato', :with => '12'

    select 'Sim', :from => 'Subcontratação'

    fill_modal 'Unidade responsável', :with => 'Secretaria de Educação', :field => 'Descrição'

    within_modal 'Advogado responsável pela gestão do contrato' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    within_modal 'Pessoa responsável' do
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
    expect(page).to have_field 'Início da vigência', :with => '01/01/2012'
    expect(page).to have_field 'Data de validade', :with => '30/12/2012'
    expect(page).to have_field 'Objeto do contrato', :with => 'Objeto'
    expect(page).to have_field 'Local de publicação', :with => 'Jornal Oficial do Município'
    expect(page).to have_field 'Valor do contrato', :with => '1.000,00'
    expect(page).to have_field 'Multa rescisória', :with => 'rescisória'
    expect(page).to have_field 'Multa inadimplemento', :with => 'inadimplemento'
    expect(page).to have_field 'Validade do contrato', :with => '12'
    expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
    expect(page).to have_select 'Garantias do contrato', :selected => 'Fiança bancária'

    within '#creditors' do
      expect(page).to have_content 'Gabriel Sobrinho'
    end

    expect(page).to have_select 'Subcontratação', :selected => 'Sim'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência'
    expect(page).to have_field 'Unidade responsável', :with => '1 - Secretaria de Educação'
    expect(page).to have_field 'Pessoa responsável', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Advogado responsável pela gestão do contrato', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'O.A.B. do advogado responsável', :with => '5678'

    expect(page).to have_link 'other_example_document.txt'

    fill_in 'Ano do contrato', :with => '2013'
    fill_in 'Número do contrato', :with => '111'
    fill_in 'Data da assinatura', :with => '01/01/2013'
    fill_in 'Início da vigência', :with => '01/12/2012'
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
    expect(page).to have_field 'Início da vigência', :with => '01/12/2012'
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
    Contract.make!(:primeiro_contrato)
    navigate 'Instrumentos Contratuais > Contratos'

    click_link "Limpar Filtro"

    within_records do
      click_link '001'
    end

    click_link 'Empenhos'

    expect(page).to have_content '9,99'
    expect(page).to have_content '01/01/2013'
    expect(page).to have_content '15,99'
    expect(page).to have_content '01/01/2012'
    expect(page).to have_content '25,98'
  end

  scenario 'add contract additives' do
    ContractAdditive.make!(:aditivo)

    navigate 'Instrumentos Contratuais > Contratos'

    click_link 'Limpar Filtro'

    within_records do
      page.find('a').click
    end

    within '#additives' do
      expect(page).to have_field 'Número', with: '666'
      expect(page).to have_select 'Tipo', with: 'Outros'
      expect(page).to have_field 'Data da assinatura', with: '13/10/2013'
      expect(page).to have_field 'Data de publicação', with: '13/10/2013'
      expect(page).to have_field 'Meio de divulgação', with: 'Jornal Oficial do Município'
      expect(page).to have_field 'Observações', with: 'aditivo 1'
    end

    click_link 'Adicionar Aditivo'

    within '.nested-additives:last' do
      select 'Prorrogação de Prazo', from: 'Tipo'
      expect(page).to have_field 'Data de término'
      expect(page).not_to have_field 'Valor'

      select 'Outros', from: 'Tipo'
      expect(page).not_to have_field 'Data de término'
      expect(page).not_to have_field 'Valor'

      select 'Acréscimo de valor', from: 'Tipo'
      expect(page).not_to have_field 'Data de término'
      expect(page).to have_field 'Valor'

      fill_in 'Número', with: '123'
      select 'Outros', from: 'Tipo'
      fill_in 'Data da assinatura', with: '13/10/2013'
      fill_in 'Data de publicação', with: '13/10/2013'
      fill_modal 'Meio de divulgação', with: 'Jornal Oficial do Município', field: 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato editado com sucesso'

    click_link 'Limpar Filtro'

    within_records do
      page.find('a').click
    end

    within '#additives' do
      expect(page).to have_field 'Número', with: '666'
      expect(page).to have_select 'Tipo', with: 'Outros'
      expect(page).to have_field 'Data da assinatura', with: '13/10/2013'
      expect(page).to have_field 'Data de publicação', with: '13/10/2013'
      expect(page).to have_field 'Meio de divulgação', with: 'Jornal Oficial do Município'
      expect(page).to have_field 'Observações', with: 'aditivo 1'
    end
  end

  scenario 'add delivery schedule' do
    DeliverySchedule.make!(:primeira_entrega)

    navigate 'Instrumentos Contratuais > Contratos'

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

    navigate 'Instrumentos Contratuais > Contratos'

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

    navigate 'Instrumentos Contratuais > Contratos'

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_content 'Número do contrato'
      expect(page).to have_content 'Ano do contrato'
      expect(page).to have_content 'Data de publicação'


      within 'tbody tr' do
        expect(page).to have_content '001'
        expect(page).to have_content '2012'
        expect(page).to have_content '10/01/2012'
      end
    end
  end
end
