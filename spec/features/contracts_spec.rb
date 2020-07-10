require 'spec_helper'

feature "Contracts", vcr: { cassette_name: :contracts } do
  background do
    sign_in
  end

  scenario 'picking a licitation process' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Contratos > Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Processo de compra', :field => 'Ano', :with => '2012'

    expect(page).to have_field 'Objeto do contrato', :with => 'Licitação para compra de carteiras'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência', disabled: true
    expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
    expect(page).to have_select 'Garantias do contrato', :selected => 'Fiança bancária'

    clear_modal 'Processo de compra'
    expect(page).to have_field 'Modalidade', :with => '', disabled: true
    expect(page).to have_select 'Forma de execução', :selected => ''
    expect(page).to have_select 'Garantias do contrato', :selected => ''
    expect(page).to have_field 'Processo de compra', :with => ''
  end

  scenario 'create, update and destroy a new contract' do
    LicitationProcess.make!(:processo_licitatorio)
    DisseminationSource.make!(:jornal_municipal)
    Creditor.make!(:sobrinho)
    Employee.make!(:wenderson)
    ContractType.make!(:trainees)

    navigate 'Contratos > Contratos'

    click_link 'Criar Contrato'

    expect(page).to have_field 'Ano do contrato', :with => "#{Date.current.year}"
    expect(page).to have_field 'Número sequencial', disabled: true
    expect(page).to_not have_field 'Contrato principal', disabled: true
    expect(page).to have_field 'Modalidade', disabled: true
    expect(page).to have_field 'Contrato principal'

    fill_in 'Ano do contrato', :with => '2012'

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

    

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Número sequencial', :with => '1', disabled: true
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
    expect(page).to have_field 'Modalidade', :with => 'Concorrência', disabled: true
    expect(page).to have_field 'Unidade responsável', :with => '9 - Secretaria de Educação'
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

  scenario 'show pledges', :reset_ids do
    Contract.make!(:primeiro_contrato)
    navigate 'Contratos > Contratos'

    

    within_records do
      click_link '001'
    end

    click_link 'Empenhos'

    expect(page).to have_content '10'
    expect(page).to have_content '01/10/2012'
    expect(page).to have_content '100,00'
  end

  scenario 'add contract additives' do
    Contract.make!(:primeiro_contrato)

    navigate 'Contratos > Contratos'



    within_records do
      page.find('a').click
    end

    click_link 'Aditivo/Apostilamento'

    click_link 'Criar Aditivo'

    choose 'Apostilamento'
    fill_in 'Número', with: '666'
    select 'Outros', from: 'Tipo'
    fill_in 'Data da assinatura', with: '13/10/2013'
    fill_in 'Data de publicação', with: '13/10/2013'
    fill_modal 'Meio de divulgação', with: 'Jornal Oficial do Município', field: 'Descrição'
    fill_in 'Observações', with: 'aditivo 1'
    fill_in 'Descrição', with: 'Descrição do aditivo 1'

    click_button 'Salvar'

    expect(page).to have_notice 'Aditivo/Apostilamento criado com sucesso'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Número', with: '666'
    expect(page).to have_select 'Tipo', selected: 'Outros'
    expect(page).to have_field 'Data da assinatura', with: '13/10/2013'
    expect(page).to have_field 'Data de publicação', with: '13/10/2013'
    expect(page).to have_field 'Meio de divulgação', with: 'Jornal Oficial do Município'
    expect(page).to have_field 'Observações', with: 'aditivo 1'
    expect(page).to have_field 'Descrição', with: 'Descrição do aditivo 1'

    choose 'Aditivo'
    fill_in 'Número', with: '667'
    select 'Reajuste', from: 'Tipo'
    fill_in 'Data da assinatura', with: '13/11/2013'
    fill_in 'Data de publicação', with: '13/11/2013'
    fill_modal 'Meio de divulgação', with: 'Jornal Oficial do Município', field: 'Descrição'
    fill_in 'Observações', with: 'aditivo 1'
    fill_in 'Valor', with: '100,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Aditivo/Apostilamento editado com sucesso'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Número', with: '667'
    expect(page).to have_select 'Tipo', selected: 'Reajuste'
    expect(page).to have_field 'Data da assinatura', with: '13/11/2013'
    expect(page).to have_field 'Data de publicação', with: '13/11/2013'
    expect(page).to have_field 'Meio de divulgação', with: 'Jornal Oficial do Município'
    expect(page).to have_field 'Observações', with: 'aditivo 1'
    expect(page).to have_field 'Valor', with: '100,00'

    click_link 'Apagar'

    within_records do
      expect(page).to_not have_content '667'
    end
  end

  scenario 'add delivery schedule' do
    DeliverySchedule.make!(:primeira_entrega)

    navigate 'Contratos > Contratos'

    

    within_records do
      page.find('a').click
    end

    click_link 'Cronogramas de entrega'

    expect(page).to have_field 'Observações', :with => 'entregue com atraso'
    expect(page).to have_field 'Data de entrega', :with => '02/01/2012'
    expect(page).to have_field 'Data prevista', :with => '01/01/2012'
    expect(page).to have_select 'Status', :selected => 'Entregue'

    click_button 'Adicionar Cronograma de Entrega'

    within '.nested-delivery-schedule:nth-last-child(1)' do
      expect(page).to have_field 'Sequência', :with => '2', disabled: true

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

    navigate 'Contratos > Contratos'

    

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

    expect(page).to_not have_field 'Observações', :with => 'entregue com atraso'
    expect(page).to_not have_field 'Data de entrega', :with => '02/01/2012'
    expect(page).to_not have_field 'Data prevista', :with => '01/01/2012'
    expect(page).to_not have_select 'Status', :selected => 'Entregue'
  end

  scenario 'index with columns at the index' do
    Contract.make!(:primeiro_contrato)

    navigate 'Contratos > Contratos'

    

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

  scenario 'should filter creditor by licitation process when licitation process is not nil' do
    creditor_nohup = Creditor.make!(:nohup)
    creditor_sobrinho = Creditor.make!(:sobrinho_sa)

    purchase_process_one = LicitationProcess.make(:processo_licitatorio)

    Bidder.make!(:licitante, creditor: creditor_sobrinho, enabled: true, licitation_process: purchase_process_one)
    Bidder.make!(:licitante, creditor: creditor_nohup, enabled: true, licitation_process: purchase_process_one)

    JudgmentCommissionAdvice.make!(:parecer, licitation_process: purchase_process_one)

    FactoryGirl.create(:process_responsible, licitation_process: purchase_process_one,
      stage_process: StageProcess.make(:emissao_edital))

    LicitationProcessRatification.make!(:processo_licitatorio_computador, licitation_process: purchase_process_one,
      creditor: creditor_sobrinho, ratification_date: "2013-01-31".to_date, adjudication_date: "2013-01-31".to_date)

    navigate 'Contratos > Contratos'

    click_link 'Criar Contrato'

    fill_modal 'Processo de compra', with: '2012', field: 'Ano'

    within_modal 'Fornecedor' do
      click_button 'Pesquisar'

      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to_not have_content 'Nohup'

      click_link 'Voltar'
    end

    clear_modal 'Processo de compra'

    within_modal 'Fornecedor' do
      click_button 'Pesquisar'

      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Nohup'
    end
  end

  scenario 'should disabled creditor when contract has one creditor and contract is not consortium_agreement' do
    Creditor.make!(:sobrinho_sa)
    Creditor.make!(:nohup)
    Contract.make!(:primeiro_contrato)

    navigate 'Contratos > Contratos'



    click_link '001'

    expect(page).to have_field 'Fornecedor', disabled: true

    check 'Consórcio/Convênio'

    expect(page).to_not have_field 'Fornecedor', disabled: true

    fill_modal 'Fornecedor', with: 'Nohup'

    click_button 'Salvar'

    expect(page).to have_notice 'Contrato editado com sucesso.'


    click_link '001'

    within 'tbody.contract_creditor_records' do
      expect(page).to have_content 'Nohup'
      expect(page).to have_content 'Gabriel Sobrinho'
    end

    click_link 'Voltar'

    click_link 'Criar Contrato'

    expect(page).to_not have_field 'Fornecedor', disabled: true

    fill_modal 'Fornecedor', with: 'Gabriel Sobrinho'

    expect(page).to have_field 'Fornecedor', disabled: true

    check 'Consórcio/Convênio'

    fill_modal 'Fornecedor', with: 'Nohup'

    uncheck 'Consórcio/Convênio'

    expect(page).to have_field 'Fornecedor', disabled: true

    click_button 'Salvar'

    expect(page).to have_content 'não pode ter mais de um fornecedor quando o contrato não for Consórcio/Convênio'
  end
end
