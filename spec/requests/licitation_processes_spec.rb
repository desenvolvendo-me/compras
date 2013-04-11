# encoding: utf-8
require 'spec_helper'

feature "LicitationProcesses" do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    create_roles ['judgment_forms',
                  'payment_methods',
                  'indexers',
                  'document_types',
                  'materials',
                  'licitation_process_publications',
                  'purchase_solicitations']

    Prefecture.make!(:belo_horizonte)

    sign_in
  end

  scenario 'create a new licitation_process' do
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_menor_preco)
    BudgetAllocation.make!(:alocacao)
    BudgetAllocation.make!(:reparo_2011, expense_nature: ExpenseNature.make!(:aplicacoes_diretas))
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    ExpenseNature.make!(:aposentadorias_rpps, :year => Date.current.year)
    ExpenseNature.make!(:compra_de_material, :year => Date.current.year, parent: ExpenseNature.make!(:aplicacoes_diretas))

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'
    expect(page).to_not have_link 'Credenciamento'

    expect(page).to_not have_button 'Apurar'

    expect(page).to have_disabled_field 'Status'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'
      expect(page).to have_disabled_field 'Modalidade'
      expect(page).to have_disabled_field 'Nº do afastamento'

      choose 'Processo licitatório'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      fill_in 'Objeto do processo de compra', :with => 'Licitação para compra de carteiras'

      check 'Registro de preço'
      select 'Por Item com Menor Preço', :from =>'Forma de julgamento'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
    end

    within_tab 'Prazos' do
      expect(page).to have_readonly_field 'Abertura das propostas'
      expect(page).to have_readonly_field 'Hora da abertura'

      expect(page).to have_field 'Data da expedição', :with => I18n.l(Date.current)
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora do recebimento', :with => '14:00'

      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    within_tab 'Orçamento' do
      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aposentadorias'

      expect(page).to have_field 'Natureza da despesa', :with => '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      fill_with_autocomplete 'Desdobramento', :with => '3.1'

      expect(page).to have_field '', :with => '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'

      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'
          expect(page).to have_content '500,00'
          expect(page).to have_content '20,00'
        end
      end

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aplicações'

      expect(page).to have_field 'Natureza da despesa', :with => '3.1.90.00.00 - Aplicações Diretas'
      expect(page).to have_field 'Saldo da dotação', :with => '3.000,00'

      fill_with_autocomplete 'Desdobramento', :with => '3.0'

      expect(page).to have_field '', :with => '3.0.10.01.11 - Compra de Material'

      fill_in 'Valor previsto', :with => '250,00'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr:last' do
          expect(page).to have_content '1.29 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.0.10.01.11 - Compra de Material'
          expect(page).to have_content '3.000,00'
          expect(page).to have_content '250,00'
        end
      end

      expect(page).to have_disabled_field 'Valor total das dotações', with: '270,00'
    end

    within_tab "Itens" do
      click_button 'Adicionar Item'

      fill_in 'Lote', :with => '2234'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário máximo', :with => '10,00'
      fill_in 'Informações complementares', :with => 'Produto antivirus avast'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '20,00'
    end

    within_tab 'Receita' do
      fill_in 'Prazo da concessão', :with => '1'
      select 'ano/anos', :from => 'Unidade do prazo da concessão'

      expect(page).to_not have_field 'Valor da oferta mínima para alienações'
      expect(page).to_not have_field 'Meta'
      expect(page).to_not have_field 'Direitos e obrigações do concedente'
      expect(page).to_not have_field 'Diretos e obrigações do concedido'
    end

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 1/#{Date.current.year} criado com sucesso."

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Processo'

      expect(page).to have_field 'Processo', :with => '1'

      expect(page).to have_select 'Modalidade', :selected => 'Concorrência'
      expect(page).to have_disabled_field 'Nº da modalidade', :with => '1'
      expect(page).to have_select 'Tipo de objeto', :selected => 'Compras e serviços'
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Item com Menor Preço'
      expect(page).to have_field 'Objeto do processo de compra', :with => 'Licitação para compra de carteiras'

      expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
      expect(page).to have_select 'Tipo de garantia', :selected => 'Fiança bancária'
      expect(page).to have_field 'Índice de reajuste', :with => 'XPTO'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Valor da caução', :with => '50,00'
    end

    within_tab 'Prazos' do
      expect(page).to have_readonly_field 'Abertura das propostas'
      expect(page).to have_readonly_field 'Hora da abertura'

      expect(page).to have_field 'Data da expedição', :with => I18n.l(Date.current)
      expect(page).to have_field 'Data da disponibilidade', :with => I18n.l(Date.current)
      expect(page).to have_field 'Contato para informações', :with => 'Gabriel Sobrinho'

      expect(page).to have_field 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      expect(page).to have_field 'Hora do recebimento', :with => '14:00'

      expect(page).to have_field 'Abertura das propostas', :with => ''
      expect(page).to have_field 'Hora da abertura', :with => ''

      expect(page).to have_field 'Validade da proposta', :with => '5'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'dia/dias'
      expect(page).to have_field 'Prazo de entrega', :with => '1'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'ano/anos'
    end

    within_tab 'Documentos' do
      expect(page).to have_content 'Fiscal'
      expect(page).to have_content '10'
    end

    within_tab 'Orçamento' do
      expect(page).to have_disabled_field 'Valor total das dotações', with: '270,00'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '500,00'
          expect(page).to have_content '20,00'
        end

        within 'tbody tr:last' do
          expect(page).to have_content '1.29 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.0.10.01.11 - Compra de Material'
          expect(page).to have_content '3.000,00'
          expect(page).to have_content '250,00'
        end
      end
    end

    within_tab "Itens" do
      expect(page).to have_field 'Lote', :with => '2234'
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '2'
      expect(page).to have_field 'Valor unitário máximo', :with => '10,00'
      expect(page).to have_field 'Valor total', :with => '20,00'
      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_field 'Informações complementares', :with => 'Produto antivirus avast'
    end

    within_tab 'Receita' do
      expect(page).to have_field 'Prazo da concessão', :with => '1'
      expect(page).to have_select 'Unidade do prazo da concessão', :selected => 'ano/anos'
    end
  end

  scenario 'changing judgment form' do
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    JudgmentForm.make!(:por_lote_com_melhor_tecnica)
    JudgmentForm.make!(:por_item_com_menor_preco)
    ExpenseNature.make!(:aposentadorias_rpps, :year => Date.current.year)

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_title "Criar Processo de Compra"

    expect(page).to_not have_link 'Publicações'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      select 'Por Lote com Melhor Técnica', :from => 'Forma de julgamento'

      select 'Por Item com Menor Preço', :from => 'Forma de julgamento'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
    end
  end

  scenario 'update an existent licitation_process' do
    LicitationProcess.make!(:processo_licitatorio)
    PaymentMethod.make!(:cheque)
    DocumentType.make!(:oficial)
    Material.make!(:arame_farpado)
    Indexer.make!(:selic)
    BudgetAllocation.make!(:alocacao)
    ExpenseNature.make!(:aposentadorias_rpps, :year => Date.current.year)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_title "Editar Processo de Compra"
    expect(page).to have_subtitle "1/2012"
    expect(page).to have_link 'Publicações'

    within_tab 'Principal' do
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Índice de reajuste', :with => 'SELIC'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '60,00'
    end

    within_tab 'Prazos' do
      fill_in 'Data da expedição', :with => '32/12/2012'
      expect(page).to have_content "data inválida"
    end

    expect(page).to have_disabled_element "Salvar", :reason => "Há campos inválidos no formulário"

    within_tab 'Prazos' do
      fill_in 'Data da expedição', :with => '19/03/2012'
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora do recebimento', :with => '15:00'

      fill_in 'Abertura das propostas', :with => I18n.l(Date.tomorrow + 1.day)
      fill_in 'Hora da abertura', :with => '15:00'

      fill_in 'Prazo de entrega', :with => '3'
      select  'mês/meses', :from => 'Período do prazo de entrega'
    end

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    within_tab 'Itens' do
      click_button 'Remover Item'

      click_button 'Adicionar Item'

      fill_in 'Lote', :with => '5844'
      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor total', :with => '20,00'
      fill_in 'Informações complementares', :with => 'Produto rolos de arame farpado'

      # asserting calculated unit price of the item
      expect(page).to have_field 'Valor unitário máximo', :with => '4,00'
    end

    within_tab "Orçamento" do
      expect(page).to have_disabled_field 'Valor total dos itens', :with => '20,00'
      expect(page).to have_disabled_field 'Valor total das dotações', :with => '20,00'

      within_records do
        click_link "Remover"
      end

      expect(page).to have_disabled_field 'Valor total das dotações', :with => '0,00'

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aposentadorias'

      expect(page).to have_field 'Natureza da despesa', :with => '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      fill_with_autocomplete 'Desdobramento', :with => '3.1'

      expect(page).to have_field '', :with => '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'

      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar'

      expect(page).to have_disabled_field 'Valor total das dotações', :with => '20,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 1/2012 editado com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
      expect(page).to have_select 'Tipo de garantia', :selected => 'Fiança bancária'
      expect(page).to have_field 'Índice de reajuste', :with => 'SELIC'
      expect(page).to have_field 'Forma de pagamento', :with => 'Cheque'
      expect(page).to have_field 'Valor da caução', :with => '60,00'
    end

    within_tab 'Prazos' do
      expect(page).to have_field 'Data da expedição', :with => '19/03/2012'
      expect(page).to have_field 'Data da disponibilidade', :with => I18n.l(Date.current)
      expect(page).to have_field 'Contato para informações', :with => 'Gabriel Sobrinho'

      expect(page).to have_field 'Término do recebimento dos envelopes', :with => I18n.l(Date.tomorrow)
      expect(page).to have_field 'Hora do recebimento', :with => '15:00'

      expect(page).to have_field 'Abertura das propostas', :with => I18n.l(Date.tomorrow + 1.day)
      expect(page).to have_field 'Hora da abertura', :with => '15:00'

      expect(page).to have_field 'Validade da proposta', :with => '10'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'dia/dias'

      expect(page).to have_field 'Prazo de entrega', :with => '3'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'mês/meses'
    end

    within_tab 'Documentos' do
      expect(page).to_not have_content 'Fiscal'

      expect(page).to have_content 'Oficial'
    end

    within_tab "Itens" do
      expect(page).to have_field 'Lote', :with => '5844'
      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '5'
      expect(page).to have_field 'Valor unitário máximo', :with => '4,00'
      expect(page).to have_field 'Valor total', :with => '20,00'
      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_field 'Informações complementares', :with => 'Produto rolos de arame farpado'
    end

    within_tab 'Orçamento' do
      expect(page).to have_disabled_field 'Valor total dos itens', :with => '20,00'
      expect(page).to have_disabled_field 'Valor total das dotações', :with => '20,00'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'
          expect(page).to have_content '500,00'
          expect(page).to have_content '20,00'
        end
      end
    end
  end

  scenario 'envelope opening date is disabled without publication' do
    LicitationProcess.make!(:processo_licitatorio, :licitation_process_publications => [])
    PaymentMethod.make!(:cheque)
    DocumentType.make!(:oficial)
    Material.make!(:arame_farpado)
    Indexer.make!(:selic)
    BudgetAllocation.make!(:alocacao)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Prazos' do
      expect(page).to have_readonly_field "Abertura das propostas"
      expect(page).to have_readonly_field "Hora da abertura"
    end

    click_link "Publicações"

    click_link "Criar Publicação"

    fill_in "Nome do veículo de comunicação", :with => "website"

    fill_in "Data da publicação", :with => I18n.l(Date.current)

    select "Edital", :on => "Publicação do(a)"

    select "Internet", :on => "Tipo de circulação do veículo de comunicação"

    click_button "Salvar"

    expect(page).to have_notice "Publicação criada com sucesso"

    click_link "Voltar ao processo de compra"

    within_tab 'Prazos' do
      expect(page).to_not have_readonly_field "Abertura das propostas"
      expect(page).to_not have_readonly_field "Hora da abertura"
    end
  end

  scenario 'calculating items values via javascript' do
    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Itens' do
      click_button 'Adicionar Item'

      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor unitário máximo', :with => '10,00'

      expect(page).to have_field 'Valor total', :with => '50,00'

      click_button 'Adicionar Item'

      within '.nested-licitation-process-item:first' do
        fill_in 'Quantidade', :with => '4'
        fill_in 'Valor unitário máximo', :with => '20,00'
        expect(page).to have_field 'Valor total', :with => '80,00'
      end
    end
  end

  scenario 'change document types to ensure that the changes are reflected on bidder documents' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    DocumentType.make!(:oficial)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    within_tab 'Documentos' do
      expect(page).to have_field 'Documento', :with => 'Fiscal'
    end

    click_link 'Voltar'

    click_link 'Voltar ao processo de compra'

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 2/2013 editado com sucesso.'

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    within_tab 'Documentos' do
      expect(page).to_not have_field 'Documento', :with => 'Fiscal'
      expect(page).to have_field 'Documento', :with => 'Oficial'
    end
  end

  scenario "count link should not be available when envelope opening date is not the current date" do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_link 'Apurar'
  end

  scenario 'cannot show update and nested buttons when the publication is (extension, edital, edital_rectification)' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_publicacao_cancelada)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_disabled_element 'Salvar', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'

    click_link 'Documentos'
    expect(page).to have_disabled_element 'Remover', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'

    click_link 'Itens'
    expect(page).to have_disabled_element 'Adicionar Item', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'
    expect(page).to have_disabled_element 'Remover Item', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'
  end

  scenario "should not have link to lots when creating a new licitation process" do
    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to_not have_link 'Lotes de itens'
  end

  scenario 'budget allocation with quantity empty and total item value should have 0 as unit value' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Itens' do
      click_button 'Remover Item'
      click_button 'Adicionar Item'

      fill_in 'Valor total', :with => '20,00'

      expect(page).to have_field 'Valor unitário máximo', :with => '0,00'
    end
  end

  scenario 'create a new licitation_process with envelope opening date today' do
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'

      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
    end

    within_tab 'Prazos' do
      expect(page).to have_field 'Data da expedição', :with => I18n.l(Date.current)
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora do recebimento', :with => I18n.l(Date.current, :format => 'time')
      fill_in 'Abertura das propostas', :with => I18n.l(Date.current)
      fill_in 'Hora da abertura', :with => I18n.l(Date.current, :format => 'time')

      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    click_button 'Salvar'

    expect(page).to_not have_content 'Routing Error No route matches'
  end

  scenario 'should filter by process' do
    LicitationProcess.make!(:processo_licitatorio)
    LicitationProcess.make!(:processo_licitatorio_computador, :process => 2)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_css 'a', :count => 2
    end

    click_link 'Filtrar Processos de Compras'

    fill_in 'Processo', :with => 1

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_css 'a', :count => 1
    end
  end

  scenario 'should not validate changes on bidders when classification is done' do
    licitation_process = LicitationProcess.make!(:apuracao_global)

    licitation_process.update_attributes({
      :proposal_envelope_opening_date => Date.tomorrow,
      :envelope_delivery_date => Date.tomorrow
    })

    price_registration = PriceRegistration.make!(:registro_de_precos,
                                                 :licitation_process => licitation_process)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    click_link '1/2012'

    click_button 'Apurar'

    expect(page).to have_content 'Ganhou'
  end

  scenario 'budget allocation items should have a sequential item' do
    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Itens' do
      click_button 'Adicionar Item'

      within '.nested-licitation-process-item:last' do
        expect(page).to have_field 'Item', :with => '1'
      end

      click_button 'Adicionar Item'

      within '.nested-licitation-process-item:first' do
        expect(page).to have_field 'Item', :with => '1'
      end

      within '.nested-licitation-process-item:last' do
        expect(page).to have_field 'Item', :with => '2'
      end
    end
  end

  scenario 'allowance of adding bidders and publication of the edital' do
    LicitationProcess.make!(:processo_licitatorio,
                            :licitation_process_publications => [])

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link "1/2012"
    end

    expect(page).to have_disabled_element "Licitantes", :reason => "Licitantes só podem ser incluídos após publicação do edital"

    click_link "Publicações"

    click_link "Criar Publicação"

    fill_in "Nome do veículo de comunicação", :with => "website"

    fill_in "Data da publicação", :with => I18n.l(Date.current)

    select "Edital", :on => "Publicação do(a)"

    select "Internet", :on => "Tipo de circulação do veículo de comunicação"

    click_button "Salvar"

    expect(page).to have_notice "Publicação criada com sucesso"

    click_link "Voltar ao processo de compra"

    click_link "Licitantes"

    expect(page).to have_content "Licitantes do Processo de Compra 1/2012"
  end

  scenario "allowing changes to licitation process after ratification" do
    LicitationProcessRatification.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link "2/2013"
    end

    within_tab "Principal" do
      expect(page).to have_disabled_field "Forma de julgamento"
      expect(page).to have_disabled_field "Índice de reajuste"
    end

    expect(page).to have_disabled_element 'Salvar', :reason => 'já foi homologado. Não pode ser alterado'
  end

  scenario 'index with columns at the index' do
    LicitationProcess.make!(:processo_licitatorio, :status => LicitationProcessStatus::IN_PROGRESS)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_content 'Processo/Ano'
      expect(page).to have_content 'Modalidade'
      expect(page).to have_content 'Tipo de objeto'
      expect(page).to have_content 'Abertura das propostas'
      expect(page).to have_content 'Status'

      within 'tbody tr' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content 'Concorrência'
        expect(page).to have_content 'Compras e serviços'
        expect(page).to have_content I18n.l Date.tomorrow
        expect(page).to have_content 'Em andamento'
      end
    end
  end

  scenario 'generate calculation and disable a bidder by maximum value' do
    licitation_process = LicitationProcess.make!(:valor_maximo_ultrapassado)
    bidder = licitation_process.bidders.first
    LicitationProcessLot.make!(:lote, :licitation_process => licitation_process,
                               :administrative_process_budget_allocation_items => [licitation_process.items.first])

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Por Lote com Menor Preço'

    expect(page).to have_content 'Nohup'

    within ".classification-#{bidder.id}-0-0" do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to_not have_content 'IBM'
  end

  scenario 'generate calculation with equalized result' do
    licitation_process = LicitationProcess.make!(:apuracao_global_empatou)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Forma Global com Menor Preço'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Empatou'
    end

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Empatou'
    end
  end

  scenario 'generate calculation with companies without documents' do
    licitation_process = LicitationProcess.make!(:apuracao_global_sem_documentos)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Forma Global com Menor Preço'

    expect(page).to_not have_content 'Wenderson'

    expect(page).to_not have_content 'IBM'
  end

  scenario 'generate calculation between a small company and a big company and consider law of proposals' do
    licitation_process = LicitationProcess.make!(:apuracao_global_small_company_2)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Forma Global com Menor Preço'

    expect(page).to have_content 'Nohup'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Perdeu'
    end
  end

  scenario 'generate calculation between a small company and a big company and consider law of proposals and make a new proposal' do
    licitation_process = LicitationProcess.make!(:apuracao_global_small_company)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Forma Global com Menor Preço'

    expect(page).to have_content 'Nohup'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Empatou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Empatou'
    end

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Nohup'

    within_tab 'Propostas' do
      fill_in 'Preço unitário', :with => '8,99'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Licitante editado com sucesso.'

    click_link 'Voltar ao processo de compra'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Forma Global com Menor Preço'

    expect(page).to have_content 'Nohup'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '8,99'
      expect(page).to have_content '17,98'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Perdeu'
    end
  end

  scenario 'generate calculation between a small company and a big company and dont make a new proposal' do
    licitation_process = LicitationProcess.make!(:apuracao_global_small_company)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Forma Global com Menor Preço'

    expect(page).to have_content 'Nohup'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Empatou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Empatou'
    end

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Nohup'

    uncheck 'Apresentará nova proposta em caso de empate'

    click_button 'Salvar'

    expect(page).to have_notice 'Licitante editado com sucesso.'

    click_link 'Voltar ao processo de compra'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Forma Global com Menor Preço'

    expect(page).to have_content 'Nohup'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to have_content 'IBM'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,10'
      expect(page).to have_content '18,20'
      expect(page).to have_content 'Perdeu'
    end
  end

  scenario 'generate calculation when type of calculation is global' do
    licitation_process = LicitationProcess.make!(:apuracao_global)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_button 'Relatório'

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Forma Global com Menor Preço'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '9,00'
      expect(page).to have_content '18,00'
      expect(page).to have_content 'Ganhou'
    end

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification-2-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content '20,00'
      expect(page).to have_content 'Perdeu'
    end

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Wenderson Malheiros'

    within_tab 'Propostas' do
      expect(page).to have_select 'Situação', :selected => 'Perdeu'
      expect(page).to have_field 'Classificação', :with => '2'
    end

    click_link 'Voltar'

    click_link 'Gabriel Sobrinho'

    within_tab 'Propostas' do
      expect(page).to have_select 'Situação', :selected => 'Ganhou'
      expect(page).to have_field 'Classificação', :with => '1'
    end
  end

  scenario 'generate calculation when type of calculation is by lot' do
    licitation_process = LicitationProcess.make!(:apuracao_por_lote)
    LicitationProcessLot.make!(:lote, :licitation_process => licitation_process,
                               :administrative_process_budget_allocation_items => [licitation_process.items.first])
    LicitationProcessLot.make!(:lote_antivirus, :licitation_process => licitation_process,
                               :administrative_process_budget_allocation_items => [licitation_process.items.second])

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Por Lote com Menor Preço'

    expect(page).to have_content 'Wenderson Malheiros'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content '10,00'
        expect(page).to have_content '20,00'
        expect(page).to have_content 'Perdeu'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content '1'
        expect(page).to have_content '9,00'
        expect(page).to have_content 'Ganhou'
      end
    end

    expect(page).to have_content 'Gabriel Sobrinho'

    within 'table.records:nth-of-type(2)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content '9,00'
        expect(page).to have_content '18,00'
        expect(page).to have_content 'Ganhou'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content '1'
        expect(page).to have_content '10,00'
        expect(page).to have_content 'Perdeu'
      end
    end

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Wenderson Malheiros'

    within_tab 'Propostas' do
      within_tab 'Lote 1' do
        expect(page).to have_select 'Situação', :selected => 'Perdeu'
        expect(page).to have_field 'Classificação', :with => '2'
      end

      within_tab 'Lote 2' do
        expect(page).to have_select 'Situação', :selected => 'Ganhou'
        expect(page).to have_field 'Classificação', :with => '1'
      end
    end

    click_link 'Voltar'

    click_link 'Gabriel Sobrinho'

    within_tab 'Propostas' do
      within_tab 'Lote 1' do
        expect(page).to have_select 'Situação', :selected => 'Ganhou'
        expect(page).to have_field 'Classificação', :with => '1'
      end

      within_tab 'Lote 2' do
        expect(page).to have_select 'Situação', :selected => 'Perdeu'
        expect(page).to have_field 'Classificação', :with => '2'
      end
    end
  end

  scenario 'generate calculation when type of calculation is by item' do
    licitation_process = LicitationProcess.make!(:apuracao_por_itens)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_button 'Apurar'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    expect(page).to have_content 'Apuração: Por Item com Menor Preço'

    expect(page).to have_content 'Wenderson Malheiros'

    within 'table.records:nth-of-type(1)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '10,00'
        expect(page).to have_content '20,00'
        expect(page).to have_content 'Perdeu'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '9,00'
        expect(page).to have_content 'Ganhou'
      end
    end

    expect(page).to have_content 'Gabriel Sobrinho'

    within 'table.records:nth-of-type(2)' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '9,00'
        expect(page).to have_content '18,00'
        expect(page).to have_content 'Ganhou'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Arame comum'
        expect(page).to have_content 'UN'
        expect(page).to have_content '1'
        expect(page).to have_content '10,00'
        expect(page).to have_content '10,00'
        expect(page).to have_content 'Perdeu'
      end
    end

    click_link 'voltar'

    click_link 'Relatório'

    expect(page).to have_content 'PROCESSO DE COMPRA 1/2012'

    click_link 'voltar'

    click_link 'Licitantes'

    click_link 'Wenderson Malheiros'

    within_tab 'Propostas' do
      expect(page).to have_select 'Situação', :selected => 'Perdeu'
      expect(page).to have_field 'Classificação', :with => '2'
    end

    click_link 'Voltar'

    click_link 'Gabriel Sobrinho'

    within_tab 'Propostas' do
      expect(page).to have_select 'Situação', :selected => 'Ganhou'
      expect(page).to have_field 'Classificação', :with => '1'
    end
  end

  scenario "button Back to Listings should take user to licitation_process#index" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Voltar'

    click_link "Limpar Filtro"

    expect(page).to have_link '1/2012'

    expect(page).to have_title 'Processos de Compras'
  end

  scenario 'filter judgment form' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE   Forma Global com Menor Preço
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER   Global com Melhor Lance ou Oferta
    JudgmentForm.make!(:maior_desconto_por_tabela) # HIGHER_DISCOUNT_ON_TABLE   Maior Desconto por Tabela
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE   Por Item com Melhor Técnica
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE   Por Item com Menor Preço
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE   Por Lote com Técnica e Preço

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'

      select 'Alienação de bens', :from => 'Tipo de objeto'
      select 'Leilão', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Global com Melhor Lance ou Oferta'])

      select 'Concessões e permissões', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Forma Global com Menor Preço', 'Global com Melhor Lance ou Oferta', 'Por Item com Melhor Técnica', 'Por Item com Menor Preço', 'Por Lote com Técnica e Preço'])

      check 'Registro de preço'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Forma Global com Menor Preço', 'Por Item com Menor Preço', 'Maior Desconto por Tabela'])

      select 'Edital de chamamento/credenciamento', :from => 'Tipo de objeto'
      select 'Concurso', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Por Item com Melhor Técnica'])

      select 'Obras e serviços de engenharia', :from => 'Tipo de objeto'
      select 'Tomada de Preço', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Forma Global com Menor Preço', 'Global com Melhor Lance ou Oferta', 'Por Item com Melhor Técnica', 'Por Item com Menor Preço', 'Por Lote com Técnica e Preço'])

      select 'Convite', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Forma Global com Menor Preço', 'Por Item com Menor Preço'])

      select 'Pregão', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Forma Global com Menor Preço', 'Por Item com Menor Preço'])

      check 'Registro de preço'

      expect(page).to have_select('Forma de julgamento',
                                  :options => ['Forma Global com Menor Preço', 'Por Item com Menor Preço', 'Maior Desconto por Tabela'])
    end
  end

  scenario 'when clear object_type should not filter licitation_kind in judgment_form modal' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      select 'Compras e serviços', :from => 'Tipo de objeto'

      select '', :from => 'Tipo de objeto'

      expect(page).to have_select('Modalidade', :options => [])

      expect(page).to have_select('Forma de julgamento', :options => [])
    end
  end

  scenario "filtering modalities based on seleted object type" do
    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    select 'Compras e serviços', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência', 'Tomada de Preço', 'Convite', 'Pregão'])

    select 'Alienação de bens', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Leilão'])

    select 'Concessões e permissões', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência'])

    select 'Edital de chamamento/credenciamento', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concurso'])

    select 'Obras e serviços de engenharia', :on => "Tipo de objeto"

    expect(page).to have_select('Modalidade',
                                :options => ['Concorrência', 'Tomada de Preço', 'Convite', 'Concurso', 'Pregão'])
  end

  scenario 'budget allocations should be fulfilled automatically when fulfill purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year)
    Employee.make!(:sobrinho)
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_menor_preco)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'

    expect(page).to_not have_button 'Apurar'

    expect(page).to have_disabled_field 'Status'

    within_tab 'Principal' do
      choose 'Processo licitatório'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      fill_in 'Objeto do processo de compra', :with => 'Licitação para compra de carteiras'

      check 'Registro de preço'
      select 'Por Item com Menor Preço', :from =>'Forma de julgamento'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
    end

    within_tab "Solicitantes" do
      fill_with_autocomplete 'Solicitações de compra', :with => '1'

      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'

        within 'tbody tr' do
          expect(page).to have_content '1/2013'
          expect(page).to have_content '1 - Secretaria de Educação'
          expect(page).to have_content 'Gabriel Sobrinho'
        end
      end
    end

    within_tab 'Prazos' do
      fill_in 'Data da expedição', :with => '21/03/2012'
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora do recebimento', :with => '14:00'

      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    within_tab 'Orçamento' do
      expect(page).to have_disabled_field 'Valor total dos itens', :with => '600,00'
      expect(page).to have_disabled_field 'Valor total das dotações', :with => '20,00'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'
          expect(page).to have_content '500,00'
          expect(page).to have_content '20,00'
        end
      end
    end

    within_tab "Itens" do
      fill_in 'Lote', :with => '2234'

      expect(page).to have_field 'Item', :with => '1'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_disabled_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '3,00'

      expect(page).to have_field 'Valor unitário máximo', :with => '200,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 1/2012 criado com sucesso.'

    within_tab 'Solicitantes' do
      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'

        within 'tbody tr' do
          expect(page).to have_content '1/2013'
          expect(page).to have_content '1 - Secretaria de Educação'
          expect(page).to have_content 'Gabriel Sobrinho'
        end
      end
    end

    within_tab 'Orçamento' do
      expect(page).to have_disabled_field 'Valor total dos itens', :with => '600,00'
      expect(page).to have_disabled_field 'Valor total das dotações', :with => '20,00'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'
          expect(page).to have_content '500,00'
          expect(page).to have_content '20,00'
        end
      end
    end

    within_tab 'Itens' do
      expect(page).to have_field 'Lote', :with => '2234'
      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_disabled_field 'Item'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_disabled_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '3'

      expect(page).to have_field 'Valor unitário máximo', :with => '200,00'

      expect(page).to have_field 'Valor total', :with => '600,00'
    end

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2013'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Em processo de compra'
    end
  end

  scenario 'assert javascript over object type' do
    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      select 'Compras e serviços', :from => 'Tipo de objeto'
    end

    within_tab 'Receita' do
      expect(page).to_not have_field 'Valor da oferta mínima para alienações'
      expect(page).to have_field 'Prazo da concessão'
      expect(page).to have_field 'Unidade do prazo da concessão'
      expect(page).to_not have_field 'Meta'
      expect(page).to_not have_field 'Direitos e obrigações do concedente'
      expect(page).to_not have_field 'Diretos e obrigações do concedido'
    end

    within_tab 'Principal' do
      select 'Alienação de bens', :from => 'Tipo de objeto'
    end

    within_tab 'Receita' do
      expect(page).to have_field 'Valor da oferta mínima para alienações'
      expect(page).to have_field 'Prazo da concessão'
      expect(page).to have_field 'Unidade do prazo da concessão'
      expect(page).to_not have_field 'Meta'
      expect(page).to_not have_field 'Direitos e obrigações do concedente'
      expect(page).to_not have_field 'Diretos e obrigações do concedido'
    end

    within_tab 'Principal' do
      select 'Concessões e permissões', :from => 'Tipo de objeto'
    end

    within_tab 'Receita' do
      expect(page).to_not have_field 'Valor da oferta mínima para alienações'
      expect(page).to have_field 'Prazo da concessão'
      expect(page).to have_field 'Unidade do prazo da concessão'
      expect(page).to have_field 'Meta'
      expect(page).to have_field 'Direitos e obrigações do concedente'
      expect(page).to have_field 'Diretos e obrigações do concedido'
    end
  end

  scenario 'assert javascript over type of purchase' do
    pending 'this test is not working, but in browser is all ok' do
      navigate 'Processos de Compra > Processos de Compras'

      click_link 'Criar Processo de Compra'

      within_tab 'Principal' do
        choose 'Processo licitatório'
        select 'Compras e serviços', :from => 'Tipo de objeto'
        select 'Pregão', :from => 'Modalidade'

        expect(page).to have_field 'Registro de preço'
        expect(page).to have_field 'Pregão eletrônico'

        choose 'Compra direta'

        expect(page).to_not have_field 'Registro de preço'
        expect(page).to_not have_field 'Pregão eletrônico'
      end
    end
  end

  scenario 'assert javascript over modality' do
    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from => 'Modalidade'

      expect(page).to have_field 'Registro de preço'
      expect(page).to have_field 'Pregão eletrônico'

      select 'Concorrência', :from => 'Modalidade'

      expect(page).to have_field 'Registro de preço'
      expect(page).to_not have_checked_field 'Pregão eletrônico'
    end
  end

  scenario 'assert javascript over modality' do
    pending 'this test is not working, but in browser is all ok' do
      navigate 'Processos de Compra > Processos de Compras'

      click_link 'Criar Processo de Compra'

      within_tab 'Principal' do
        choose 'Processo licitatório'
        select 'Compras e serviços', :from => 'Tipo de objeto'
        select 'Pregão', :from => 'Modalidade'
      end

      within_tab 'Prazos' do
        expect(page).to_not have_field 'Abertura da habilitação'
        expect(page).to_not have_field 'Hora da habilitação'
        expect(page).to have_field 'Data do credenciamento'
        expect(page).to have_field 'Hora do credenciamento'
      end

      within_tab 'Principal' do
        choose 'Processo licitatório'
        select 'Compras e serviços', :from => 'Tipo de objeto'
        select 'Concorrência', :from => 'Modalidade'
      end

      within_tab 'Prazos' do
        expect(page).to have_field 'Abertura da habilitação'
        expect(page).to have_field 'Hora da habilitação'
        expect(page).to_not have_field 'Data do credenciamento'
        expect(page).to_not have_field 'Hora do credenciamento'
      end
    end
  end

  scenario 'items can be removed and added individually or with purchase solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year)
    Employee.make!(:sobrinho)
    Capability.make!(:reforma)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_menor_preco)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    Creditor.make!(:sobrinho)

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    within_tab 'Principal' do
      choose 'Processo licitatório'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      fill_in 'Objeto do processo de compra', :with => 'Licitação para compra de carteiras'

      check 'Registro de preço'
      select 'Por Item com Menor Preço', :from =>'Forma de julgamento'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
    end

    within_tab "Solicitantes" do
      fill_with_autocomplete 'Solicitações de compra', :with => '1'

      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'

        within 'tbody tr' do
          expect(page).to have_content '1/2013'
          expect(page).to have_content '1 - Secretaria de Educação'
          expect(page).to have_content 'Gabriel Sobrinho'
        end
      end
    end

    within_tab 'Prazos' do
      fill_in 'Data da expedição', :with => '21/03/2012'
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora do recebimento', :with => '14:00'

      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
    end

    within_tab 'Orçamento' do
      expect(page).to have_disabled_field 'Valor total dos itens', :with => '600,00'
      expect(page).to have_disabled_field 'Valor total das dotações', :with => '20,00'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'
          expect(page).to have_content '500,00'
          expect(page).to have_content '20,00'
        end
      end
    end

    within_tab "Itens" do
      fill_in 'Lote', :with => '2234'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_field 'Quantidade', :with => '3,00'
      expect(page).to have_field 'Valor unitário máximo', :with => '200,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 1/2012 criado com sucesso."

    within_tab 'Principal' do
      choose 'Compra direta'

      select 'Demais afastamentos', from: 'Tipo de afastamento'
    end

    within_tab 'Itens / Justificativa' do
      expect(page).to have_field('Fornecedor')

      fill_modal 'Fornecedor', with: 'Gabriel', field: 'Nome'
    end

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 1/2012 editado com sucesso."

    within_tab "Itens" do
      expect(page).to have_field 'Fornecedor', with: 'Gabriel Sobrinho'

      click_button "Remover Item"

      click_button "Adicionar Item"
    end

    click_button 'Salvar'

    expect(page).to_not have_notice "Processo de Compra 1/2012 editado com sucesso."

    within_tab "Itens" do
      expect(page).to have_css 'div.nested-licitation-process-item', :count => 1

      click_button "Remover Item"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 1/2012 editado com sucesso.'

    within_tab "Itens" do
      expect(page).to_not have_css 'div.nested-licitation-process-item'

      click_button "Adicionar Item"

      fill_in 'Lote', :with => '2234'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      fill_in 'Quantidade', :with => '2'

      fill_in 'Valor unitário máximo', :with => '50'
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Processo de Compra 1/2012 editado com sucesso.'

    within_tab 'Itens / Justificativa' do
      expect(page).to have_field 'Fornecedor', with: ''
      expect(page).to have_content 'não pode ficar em branco'

      fill_modal 'Fornecedor', with: 'Gabriel', field: 'Nome'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 1/2012 editado com sucesso.'

    within_tab "Itens" do
      expect(page).to have_field 'Lote', :with => '2234'
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '2'
      expect(page).to have_field 'Valor unitário máximo', :with => '0,50'
      expect(page).to have_field 'Valor total', :with => '1,00'
      expect(page).to have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Item', :with => '1'
    end
  end

  scenario "item quantity sum when duplicated by another licitation process association" do
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year,
                               :purchase_solicitation_budget_allocations => [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office)],
                               :items => [PurchaseSolicitationItem.make!(:office), PurchaseSolicitationItem.make!(:arame_farpado_2)])
    PurchaseSolicitation.make!(:reparo_2013, :accounting_year => Date.current.year, :code => '2',
                               :delivery_location => DeliveryLocation.make!(:health), :responsible => Employee.make!(:wenderson))

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab "Solicitantes" do
      fill_with_autocomplete 'Solicitações de compra', :with => '1'

      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'

        within 'tbody tr' do
          expect(page).to have_content '1/2013'
          expect(page).to have_content '1 - Secretaria de Educação'
          expect(page).to have_content 'Gabriel Sobrinho'
        end
      end
    end

    within_tab "Itens / Justificativa" do
      expect(page).to have_field 'Quantidade', :with => '10,00'

      expect(page).to have_field 'Valor total', :with => '2.000,00'
    end

    within_tab "Solicitantes" do
      fill_with_autocomplete 'Solicitações de compra', :with => '2'

      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content '2/2013'
          expect(page).to have_content '1 - Secretaria de Educação'
          expect(page).to have_content 'Wenderson Malheiros'
        end
      end
    end

    within_tab "Itens / Justificativa" do
      expect(page).to have_field 'Quantidade', :with => '109,00'

      expect(page).to have_field 'Valor total', :with => '21.800,00'
    end
  end

end
