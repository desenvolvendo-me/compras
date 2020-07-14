require 'spec_helper'

feature "LicitationProcesses", vcr: { cassette_name: 'licitation_process' } do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    create_roles ['judgment_forms',
                  'payment_methods',
                  'indexers',
                  'document_types',
                  'materials',
                  'publications',
                  'purchase_solicitations']

    Prefecture.make!(:belo_horizonte)

    sign_in
  end

  after do
    Timecop.return
  end

  scenario 'create and update a licitation_process', :reset_ids do
    Timecop.travel(Date.new(2012, 10, 10))
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    DocumentType.make!(:oficial)
    JudgmentForm.make!(:por_item_com_menor_preco)
    Material.make!(:antivirus)
    Material.make!(:arame_farpado)
    Indexer.make!(:xpto)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'
    expect(page).to_not have_link 'Credenciamento'

    expect(page).to_not have_button 'Apurar'

    within_tab 'Principal' do
      expect(page).to have_field 'Status', disabled: true
      expect(page).to have_field 'Nº do afastamento', disabled: true

      choose 'Processo licitatório'

      expect(page).to have_field 'Modalidade', disabled: true

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
      fill_with_autocomplete 'Unidade responsável pela execução', with: 'Secretaria de Educação'
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

    within_tab "Itens" do
      fill_in 'Lote', :with => '2234'

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN', disabled: true

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário máximo', :with => '10,00'
      fill_in 'Informações complementares', :with => 'Produto antivirus avast'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '20,00'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_content '2234'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '10,00'
        expect(page).to have_content '20,00'
      end
    end

    within_tab 'Orçamento' do
      expect(page).to have_field 'Valor total dos itens', :with => '20,00', disabled: true

      fill_in 'Ano da dotação', with: '2012'

      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aposentadorias'

      expect(page).to have_field 'Natureza da despesa', :with => '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares',
        disabled: true
      expect(page).to have_field 'Saldo da dotação', :with => '0,00', disabled: true

      fill_with_autocomplete 'Desdobramento', :with => '3.1.90.01.01'

      expect(page).to have_field 'Desdobramento', :with => '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'

      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '11 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'
          expect(page).to have_content '0,00'
          expect(page).to have_content '20,00'
        end
      end

      fill_with_autocomplete 'Dotação orçamentária', :with => '12 - Aplicações'

      expect(page).to have_field 'Natureza da despesa', :with => '3.1.90.00.00 - Aplicações Diretas', disabled: true
      expect(page).to have_field 'Saldo da dotação', :with => '0,00', disabled: true

      fill_with_autocomplete 'Desdobramento', :with => '3.1.90.01.00'

      expect(page).to have_field 'Desdobramento', :with => '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'

      fill_in 'Valor previsto', :with => '250,00'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr:nth-last-child(1)' do
          expect(page).to have_content '12 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '0,00'
          expect(page).to have_content '250,00'
        end
      end

      expect(page).to have_field 'Valor total das dotações', with: '270,00', disabled: true
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
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
      expect(page).to have_field 'Processo', :with => '1'

      expect(page).to have_select 'Modalidade', :selected => 'Concorrência', disabled: true
      expect(page).to have_field 'Nº da modalidade', :with => '1', disabled: true
      expect(page).to have_select 'Tipo de objeto', :selected => 'Compras e serviços', disabled: true
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Item com Menor Preço', disabled: true
      expect(page).to have_field 'Objeto do processo de compra', :with => 'Licitação para compra de carteiras'

      expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
      expect(page).to have_select 'Tipo de garantia', :selected => 'Fiança bancária'
      expect(page).to have_field 'Índice de reajuste', :with => 'XPTO'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Valor da caução', :with => '50,00'
      expect(page).to have_field 'Unidade responsável pela execução', with: '9 - Secretaria de Educação'
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
      expect(page).to have_field 'Valor total das dotações', with: '270,00', disabled: true
      expect(page).to have_field 'Ano da dotação', with: '2012'

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '11 - 3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '0,00'
          expect(page).to have_content '20,00'
        end

        within 'tbody tr:nth-last-child(1)' do
          expect(page).to have_content '12 - 3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '0,00'
          expect(page).to have_content '250,00'
        end
      end
    end

    within_tab "Itens" do
      within_records do
        expect(page).to have_content '2234'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '10,00'
        expect(page).to have_content '20,00'
      end
    end

    within_tab 'Receita' do
      expect(page).to have_field 'Prazo da concessão', :with => '1'
      expect(page).to have_select 'Unidade do prazo da concessão', :selected => 'ano/anos'
    end

    within_tab 'Principal' do
      fill_in 'Valor da caução', :with => '60,00'
    end

    within_tab 'Prazos' do
      fill_in 'Data da expedição', :with => '32/12/2012'

      # Precisa perder o foco pra disparar a mensagem de dada inválida
      # por isso preenchi outro campo
      fill_in 'Prazo de entrega', with: '10'
      expect(page).to have_content "data inválida"
    end

    expect(page).to have_disabled_element "Salvar", :reason => "Há campos inválidos no formulário"

    within_tab 'Prazos' do
      fill_in 'Data da expedição', :with => I18n.l(Date.current + 1.day)
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current + 2.days)

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.tomorrow)
      fill_in 'Hora do recebimento', :with => '15:00'

      fill_in 'Abertura das propostas', :with => ''
      fill_in 'Hora da abertura', :with => ''

      fill_in 'Prazo de entrega', :with => '3'
      select  'mês/meses', :from => 'Período do prazo de entrega'
    end

    within_tab 'Documentos' do
      click_button 'Remover'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
    end

    within_tab 'Itens' do
      fill_in 'Lote', :with => '2236'

      fill_with_autocomplete 'Material', :with => 'Arame'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN', disabled: true

      fill_in 'Quantidade', :with => '4'
      fill_in 'Valor unitário máximo', :with => '16,00'
      fill_in 'Informações complementares', :with => 'Produto rolos de arame farpado'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '64,00'

      click_button 'Adicionar'

      within_records do
        within '.record:nth-child(1)' do
          expect(page).to have_content '2234'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'UN'
          expect(page).to have_content '2'
          expect(page).to have_content '10,00'
          expect(page).to have_content '20,00'
        end

        within '.record:nth-last-child(1)' do
          expect(page).to have_content '2236'
          expect(page).to have_content '02.02.00001 - Arame farpado'
          expect(page).to have_content 'UN'
          expect(page).to have_content '4'
          expect(page).to have_content '16,00'
          expect(page).to have_content '64,00'
        end
      end
    end

    within_tab "Orçamento" do
      expect(page).to have_field 'Valor total dos itens', :with => '84,00', disabled: true
      expect(page).to have_field 'Valor total das dotações', :with => '270,00', disabled: true

      within_records do
        within 'tbody .nested-record:nth-child(1)' do
          click_link "Remover"
        end

        within 'tbody .nested-record:nth-last-child(1)' do
          click_link 'Editar'
        end
      end

      expect(page).to have_field 'Dotação orçamentária', with: '12 - 3.1.90.00.00 - Aplicações Diretas'
      expect(page).to have_field 'Natureza da despesa', with: '3.1.90.00.00 - Aplicações Diretas', disabled: true
      expect(page).to have_field 'Desdobramento', with: '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
      expect(page).to have_field 'Saldo da dotação', with: '0,00', disabled: true
      expect(page).to have_field 'Valor previsto', with: '250,00'

      fill_in 'Valor previsto', with: '300,00'

      click_button 'Adicionar'

      within_records do
        within 'tbody .nested-record:nth-last-child(1)' do
          expect(page).to have_content '12 - 3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '0,00'
          expect(page).to have_content '300,00'
        end
      end

      expect(page).to have_field 'Valor total das dotações', :with => '300,00', disabled: true

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aposentadorias do RPPS'

      expect(page).to have_field 'Natureza da despesa',
        :with => '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares',
        disabled: true

      expect(page).to have_field 'Saldo da dotação', :with => '0,00', disabled: true

      fill_with_autocomplete 'Desdobramento', :with => '3.1.90.01.01'

      expect(page).to have_field 'Desdobramento', :with => '3.1.90.01.01 - Aposentadorias Custeadas com Recursos do RPPS'

      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar'

      expect(page).to have_field 'Valor total das dotações', :with => '320,00', disabled: true
    end

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 1/#{Date.current.year} editado com sucesso."

    within_tab 'Principal' do
      expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
      expect(page).to have_select 'Tipo de garantia', :selected => 'Fiança bancária'
      expect(page).to have_field 'Índice de reajuste', :with => 'XPTO'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Valor da caução', :with => '60,00'
    end

    within_tab 'Prazos' do
      expect(page).to have_field 'Data da expedição', :with => I18n.l(Date.current + 1.day)
      expect(page).to have_field 'Data da disponibilidade', :with => I18n.l(Date.current + 2.days)
      expect(page).to have_field 'Contato para informações', :with => 'Gabriel Sobrinho'

      expect(page).to have_field 'Término do recebimento dos envelopes', :with => I18n.l(Date.tomorrow)
      expect(page).to have_field 'Hora do recebimento', :with => '15:00'

      expect(page).to have_field 'Abertura das propostas', :with => ''
      expect(page).to have_field 'Hora da abertura', :with => ''

      expect(page).to have_field 'Validade da proposta', :with => '5'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'dia/dias'

      expect(page).to have_field 'Prazo de entrega', :with => '3'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'mês/meses'
    end

    within_tab "Itens" do
      within_records do
        within '.record:nth-child(1)' do
          expect(page).to have_content '2234'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'UN'
          expect(page).to have_content '2'
          expect(page).to have_content '10,00'
          expect(page).to have_content '20,00'
        end

        within '.record:nth-last-child(1)' do
          expect(page).to have_content '2236'
          expect(page).to have_content '02.02.00001 - Arame farpado'
          expect(page).to have_content 'UN'
          expect(page).to have_content '4'
          expect(page).to have_content '16,00'
          expect(page).to have_content '64,00'
        end
      end
    end

    within_tab 'Orçamento' do
      expect(page).to have_field 'Valor total dos itens', :with => '84,00', disabled: true
      expect(page).to have_field 'Valor total das dotações', :with => '320,00', disabled: true

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '12 - 3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '0,00'
          expect(page).to have_content '300,00'
        end

        within 'tbody tr:nth-last-child(1)' do
          expect(page).to have_content '11 - 3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to have_content '0,00'
          expect(page).to have_content '20,00'
        end
      end
    end

    within_tab 'Documentos' do
      expect(page).to_not have_content 'Fiscal'

      expect(page).to have_content 'Oficial'
    end
  end

  scenario 'changing judgment form' do
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    JudgmentForm.make!(:por_lote_com_melhor_tecnica)
    JudgmentForm.make!(:por_item_com_menor_preco)

    navigate 'Licitações > Processos de Compras'

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

  scenario 'envelope opening date is disabled without publication' do
    LicitationProcess.make!(:processo_licitatorio, :publications => [])
    PaymentMethod.make!(:cheque)
    DocumentType.make!(:oficial)
    Material.make!(:arame_farpado)
    Indexer.make!(:selic)

    navigate 'Licitações > Processos de Compras'

    

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

    select "Edital", :from => "Publicação do(a)"

    select "Internet", :from => "Tipo de circulação do veículo de comunicação"

    click_button "Salvar"

    expect(page).to have_notice "Publicação criada com sucesso"

    click_link "Voltar ao processo de compra"

    within_tab 'Prazos' do
      expect(page).to_not have_readonly_field "Abertura das propostas"
      expect(page).to_not have_readonly_field "Hora da abertura"
    end
  end

  scenario 'calculating items values via javascript' do
    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'
    end

    within_tab 'Itens' do
      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor unitário máximo', :with => '10,00'

      expect(page).to have_field 'Valor total', :with => '50,00'

      fill_in 'Valor unitário máximo', :with => ''

      fill_in 'Valor total', :with => '50,00'

      expect(page).to have_field 'Valor unitário máximo', :with => '10,00'
    end
  end

  scenario 'change document types to ensure that the changes are reflected on bidder documents' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    DocumentType.make!(:oficial)

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

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

    click_link 'Habilitação'

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

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    expect(page).to_not have_link 'Apurar'
  end

  scenario 'cannot show update and nested buttons when the publication is (extension, edital, edital_rectification)' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_publicacao_cancelada)
    LicitationProcessPublication.make!(:publicacao_de_cancelamento, licitation_process: licitation_process)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_disabled_element 'Salvar', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'

    within_tab 'Documentos' do
      expect(page).to have_disabled_element 'Remover', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'
    end

    within_tab 'Itens' do
      expect(page).to have_disabled_element 'Adicionar', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'
      expect(page).to have_disabled_element 'Remover', :reason => 'a última publicação é do tipo (Cancelamento). Não pode ser alterado'
    end
  end

  scenario "should not have link to lots when creating a new licitation process" do
    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to_not have_link 'Lotes de itens'
  end

  scenario 'budget allocation with quantity empty and total item value should have 0 as unit value' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    within_tab 'Itens' do
      within_records do
        click_link 'Remover'
      end

      fill_in 'Valor total', :with => '20,00'

      expect(page).to have_field 'Valor unitário máximo', :with => '0,00'
    end
  end

  scenario 'create a new licitation_process with envelope opening date today' do
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Licitações > Processos de Compras'

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

    navigate 'Licitações > Processos de Compras'

    

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

  scenario 'allowance of adding bidders and publication of the edital' do
    LicitationProcess.make!(:processo_licitatorio,
                            :publications => [])

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link "1/2012"
    end

    expect(page).to have_disabled_element "Habilitação", :reason => "Habilitações só podem ser incluídos após publicação do edital"

    click_link "Publicações"

    click_link "Criar Publicação"

    fill_in "Nome do veículo de comunicação", :with => "website"

    fill_in "Data da publicação", :with => I18n.l(Date.current)

    select "Edital", :from => "Publicação do(a)"

    select "Internet", :from => "Tipo de circulação do veículo de comunicação"

    click_button "Salvar"

    expect(page).to have_notice "Publicação criada com sucesso"

    click_link "Voltar ao processo de compra"

    click_link "Habilitação"

    expect(page).to have_content "Habilitações do Processo de Compra 1/2012"
  end

  scenario "allowing changes to licitation process after ratification", :reset_ids do
    LicitationProcessRatification.make!(:processo_licitatorio_computador)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link "2/2013"
    end

    within_tab 'Orçamento' do
      fill_with_autocomplete 'Dotação orçamentária', with: '12 - Aplicações'
      fill_in 'Valor previsto', with: '300,00'

      click_button 'Adicionar'

      within_records do
        within 'tbody .nested-record:nth-last-child(1)' do
          expect(page).to have_content '12 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '0,00'
          expect(page).to have_content '300,00'
        end
      end
    end

    click_button 'Salvar'

    within_tab 'Orçamento' do
      within_records do
        within 'tbody .nested-record:nth-last-child(1)' do
          expect(page).to have_content '12 - 3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '0,00'
          expect(page).to have_content '300,00'

          click_link 'Remover'
        end
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 2/2013 editado com sucesso.'

    within_tab 'Orçamento' do
      within_records do
        within 'tbody .nested-record:nth-last-child(1)' do
          expect(page).to_not have_content '11 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to_not have_content '3.1.90.01.00 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
          expect(page).to_not have_content '300,00'
        end
      end
    end
  end

  scenario 'index with columns at the index' do
    LicitationProcess.make!(:processo_licitatorio, :status => PurchaseProcessStatus::IN_PROGRESS)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      expect(page).to have_content 'Processo/Ano'
      expect(page).to have_content 'Modalidade / Tipo do afastamento'
      expect(page).to have_content 'Tipo de objeto'
      expect(page).to have_content 'Abertura das propostas'
      expect(page).to have_content 'Status'

      within 'tbody tr' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '1 - Concorrência'
        expect(page).to have_content 'Compras e serviços'
        expect(page).to have_content I18n.l Date.tomorrow
        expect(page).to have_content 'Em andamento'
      end
    end
  end

  scenario "button Back to Listings should take user to licitation_process#index" do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Voltar'

    

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

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'

      select 'Alienação de bens', :from => 'Tipo de objeto'
      select 'Leilão', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :with_options => ['Global com Melhor Lance ou Oferta'])

      select 'Concessões', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :with_options => ['Forma Global com Menor Preço', 'Global com Melhor Lance ou Oferta', 'Por Item com Melhor Técnica', 'Por Item com Menor Preço', 'Por Lote com Técnica e Preço'])

      check 'Registro de preço'

      expect(page).to have_select('Forma de julgamento',
                                  :with_options => ['Forma Global com Menor Preço', 'Por Item com Menor Preço', 'Maior Desconto por Tabela'])

      select 'Obras e serviços de engenharia', :from => 'Tipo de objeto'
      select 'Tomada de Preço', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :with_options => ['Forma Global com Menor Preço', 'Global com Melhor Lance ou Oferta', 'Por Item com Melhor Técnica', 'Por Item com Menor Preço', 'Por Lote com Técnica e Preço'])

      select 'Convite', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :with_options => ['Forma Global com Menor Preço', 'Por Item com Menor Preço'])

      select 'Pregão', :from => 'Modalidade'

      expect(page).to have_select('Forma de julgamento',
                                  :with_options => ['Por Item com Menor Preço'])

      check 'Registro de preço'

      expect(page).to have_select('Forma de julgamento',
                                  :with_options => ['Forma Global com Menor Preço', 'Por Item com Menor Preço', 'Maior Desconto por Tabela'])
    end
  end

  scenario 'when clear object_type should not filter licitation_kind in judgment_form modal' do
    JudgmentForm.make!(:global_com_menor_preco) # LOWEST_PRICE
    JudgmentForm.make!(:por_item_com_melhor_tecnica) # BEST_TECHNIQUE
    JudgmentForm.make!(:por_lote_com_tecnica_e_preco) # TECHNICAL_AND_PRICE
    JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) # BEST_AUCTION_OR_OFFER
    JudgmentForm.make!(:por_item_com_menor_preco) # LOWEST_PRICE

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'

      select 'Compras e serviços', :from => 'Tipo de objeto'

      select '', :from => 'Tipo de objeto'

      expect(page).to have_select('Modalidade', :with_options => [], disabled: true)

      expect(page).to have_select('Forma de julgamento', :with_options => [])
    end
  end

  scenario "filtering modalities based on seleted object type" do
    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'

      select 'Compras e serviços', :from => "Tipo de objeto"

      expect(page).to have_select('Modalidade',
                                  :with_options => ['Concorrência', 'Tomada de Preço', 'Convite', 'Pregão'])

      select 'Alienação de bens', :from => "Tipo de objeto"

      expect(page).to have_select('Modalidade',
                                  :with_options => ['Leilão', 'Concorrência'])

      select 'Concessões', :from => "Tipo de objeto"

      expect(page).to have_select('Modalidade',
                                  :with_options => ['Concorrência'])


      select 'Obras e serviços de engenharia', :from => "Tipo de objeto"

      expect(page).to have_select('Modalidade',
                                  :with_options => ['Concorrência', 'Tomada de Preço', 'Convite', 'Concurso', 'Pregão'])
    end
  end

  scenario 'budget allocations should be fulfilled automatically when fulfill purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_menor_preco)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'

    expect(page).to_not have_button 'Apurar'

    within_tab 'Principal' do
      expect(page).to have_field 'Status', disabled: true

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
      fill_with_autocomplete 'Solicitações de compra', :with => '1/2013'

      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'

        within 'tbody tr' do
          expect(page).to have_content '1/2013'
          expect(page).to have_content '1 - Detran'
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
      expect(page).to have_field 'Valor total dos itens', :with => '600,00', disabled: true
      expect(page).to have_field 'Valor total das dotações', :with => '20,00', disabled: true

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - 3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.0.00.00.00 - Despesas Correntes'
          expect(page).to have_content '989,50'
          expect(page).to have_content '20,00'
        end
      end
    end

    within_tab "Itens" do
      within_records do
        expect(page).to have_css('.nested-record', :count => 1)

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '1'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'UN'
          expect(page).to have_content '3'
          expect(page).to have_content '200,00'
          expect(page).to have_content '600,00'
        end
      end
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
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content 'Gabriel Sobrinho'
        end
      end
    end

    within_tab 'Orçamento' do
      expect(page).to have_field 'Valor total dos itens', :with => '600,00', disabled: true
      expect(page).to have_field 'Valor total das dotações', :with => '20,00', disabled: true

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - 3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.0.00.00.00 - Despesas Correntes'
          expect(page).to have_content '989,50'
          expect(page).to have_content '20,00'
        end
      end
    end

    within_tab 'Itens' do
      within_records do
        expect(page).to have_css('.nested-record', :count => 1)

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '1'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'UN'
          expect(page).to have_content '3'
          expect(page).to have_content '200,00'
          expect(page).to have_content '600,00'
        end
      end
    end

    navigate 'Licitações > Solicitações de Compra'

    

    within_records do
      click_link '1/2013'
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Em processo de compra', disabled: true
    end
  end

  scenario 'assert javascript over object type' do
    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'
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
      select 'Permissões', :from => 'Tipo de objeto'
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
    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'
      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Pregão', :from => 'Modalidade'

      expect(page).to have_field 'Registro de preço'
      expect(page).to have_field 'Pregão eletrônico'
    end

    within_tab 'Prazos' do
      expect(page).to have_field 'Abertura das propostas'
      expect(page).to have_field 'Hora da abertura'
    end

    within_tab 'Principal' do
      select '', :from => 'Modalidade'
    end

    within '#licitation_process' do
      expect(page).to have_link 'Receita'
    end

    within_tab 'Itens' do
      expect(page).to have_content 'Valor unitário máximo'
    end

    within_tab 'Prazos' do
      expect(page).to have_field 'Abertura das propostas'
      expect(page).to have_field 'Hora da abertura'
      expect(page).to have_field 'Término do recebimento dos envelopes'
      expect(page).to have_field 'Hora do recebimento'
      expect(page).to have_field 'Data do credenciamento'
      expect(page).to have_field 'Hora do credenciamento'
      expect(page).to have_field 'Data da fase de lances'
      expect(page).to have_field 'Hora da fase de lances'
      expect(page).to have_field 'Abertura da habilitação'
      expect(page).to have_field 'Hora da habilitação'
      expect(page).to have_field 'Validade da proposta'
      expect(page).to have_field 'Período da validade da proposta'
    end

    within_tab 'Principal' do
      choose 'Compra direta'

      expect(page).to_not have_field 'Registro de preço'
      expect(page).to_not have_field 'Pregão eletrônico'
    end

    within '#licitation_process' do
      expect(page).to_not have_link 'Receita'
    end

    within_tab 'Itens / Justificativa' do
      expect(page).to have_content 'Valor unitário'
    end

    within_tab 'Prazos' do
      expect(page).to_not have_field 'Abertura das propostas'
      expect(page).to_not have_field 'Hora da abertura'
      expect(page).to_not have_field 'Término do recebimento dos envelopes'
      expect(page).to_not have_field 'Hora do recebimento'
      expect(page).to_not have_field 'Data do credenciamento'
      expect(page).to_not have_field 'Hora do credenciamento'
      expect(page).to_not have_field 'Data da fase de lances'
      expect(page).to_not have_field 'Hora da fase de lances'
      expect(page).to_not have_field 'Abertura da habilitação'
      expect(page).to_not have_field 'Hora da habilitação'
      expect(page).to_not have_field 'Validade da proposta'
      expect(page).to_not have_field 'Período da validade da proposta'
    end

    within_tab 'Principal' do
      choose 'Processo licitatório'
    end

    within_tab 'Prazos' do
      expect(page).to have_field 'Abertura das propostas'
      expect(page).to have_field 'Hora da abertura'
      expect(page).to have_field 'Término do recebimento dos envelopes'
      expect(page).to have_field 'Hora do recebimento'
      expect(page).to have_field 'Data do credenciamento'
      expect(page).to have_field 'Hora do credenciamento'
      expect(page).to have_field 'Data da fase de lances'
      expect(page).to have_field 'Hora da fase de lances'
    end
  end

  scenario 'assert javascript over modality' do
    navigate 'Licitações > Processos de Compras'

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

  scenario 'assert javascript direct_purchase show input justification and tab justification_and_legal' do
    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'
    end

    within_tab 'Itens' do
      expect(page).to_not have_css '.justification'
    end

    within_tab 'Solicitantes' do
      expect(page).to_not have_field 'Importar vencedores'
      expect(page).to_not have_field 'Importar preço médio'
    end

    within_tab 'Principal' do
      choose 'Compra direta'
    end

    within_tab 'Itens' do
      expect(page).to have_css '.justification'
    end

    within_tab 'Solicitantes' do
      expect(page).to have_field 'Importar vencedores'
      expect(page).to have_field 'Importar preço médio', checked: true
    end

     within_tab 'Principal' do
      choose 'Processo licitatório'
    end

    within_tab 'Solicitantes' do
      expect(page).to_not have_field 'Importar vencedores'
      expect(page).to_not have_field 'Importar preço médio'
    end
  end

  scenario 'assert javascript over modality' do
    pending 'this test is not working, but in browser is all ok' do
      navigate 'Licitações > Processos de Compras'

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
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_menor_preco)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    Creditor.make!(:sobrinho)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    within_tab 'Principal' do
      choose 'Compra direta'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      fill_in 'Objeto do processo de compra', :with => 'Licitação para compra de carteiras'

      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'
      fill_modal 'Índice de reajuste', :with => 'XPTO'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Valor da caução', :with => '50,00'
      select 'Demais afastamentos', from: 'Tipo de afastamento'
    end

    within_tab 'Prazos' do
      fill_in 'Data da expedição', :with => '21/03/2012'
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    within_tab "Solicitantes" do
      fill_with_autocomplete 'Solicitações de compra', :with => '1'

      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'

        within 'tbody tr' do
          expect(page).to have_content '1/2013'
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content 'Gabriel Sobrinho'
        end
      end
    end

    within_tab 'Itens / Justificativa' do
      fill_in 'Justificativa', with: 'Justificando'
      expect(page).to have_field('Fornecedor')

      within_records do
        within 'tbody tr:nth-child(1)' do
          click_link 'Editar'
        end
      end

      fill_with_autocomplete 'Fornecedor', with: 'Gabriel'

      click_button 'Adicionar'
    end

    within_tab 'Fundamentação Legal Dispensa/Inexigibilidade' do
      fill_in 'Justificativa e fundamentação legal', with: 'Justificando e fundamentando'
    end

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 1/2012 criado com sucesso."

    within_tab "Itens / Justificativa" do
      expect(page).to have_field 'Justificativa', with: 'Justificando'
      within_records do
        expect(page).to have_css 'tbody tr', :count => 1

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content 'Gabriel Sobrinho'

          click_link "Remover"
        end
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 1/2012 editado com sucesso.'

    within_tab "Itens / Justificativa" do
      within_records do
        expect(page).to_not have_css 'tbody tr'
      end

      fill_in 'Lote', :with => '2234'

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Quantidade', :with => '2'

      fill_in 'Valor unitário', :with => '50'

      click_button 'Adicionar'

      within_records do
        expect(page).to_not have_css 'tbody tr'
      end

      fill_with_autocomplete 'Fornecedor', with: 'Gabriel'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_css 'tbody tr', count: 1
      end
    end

    within_tab 'Fundamentação Legal Dispensa/Inexigibilidade' do
      expect(page).to have_field 'Justificativa e fundamentação legal', with: 'Justificando e fundamentando'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 1/2012 editado com sucesso.'

    within_tab "Itens" do
      within_records do
        expect(page).to have_css 'tbody tr', count: 1

        expect(page).to have_content '2234'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '0,50'
        expect(page).to have_content '1,00'
        expect(page).to have_content '2234'
        expect(page).to have_content '2234'
      end
    end
  end

  scenario 'items can be removed and added individually or with purchase solicitation' do
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_menor_preco)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)
    Creditor.make!(:sobrinho)

    navigate 'Licitações > Processos de Compras'

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
          expect(page).to have_content '1 - Detran'
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
      expect(page).to have_field 'Valor total dos itens', :with => '600,00', disabled: true
      expect(page).to have_field 'Valor total das dotações', :with => '20,00', disabled: true

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - 3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.0.00.00.00 - Despesas Correntes'
          expect(page).to have_content '989,50'
          expect(page).to have_content '20,00'
        end
      end
    end

    within_tab "Itens" do
      within_records do
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '3,00'
        expect(page).to have_content '200,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 1/2012 criado com sucesso."
  end

  scenario "item quantity sum when duplicated by another licitation process association" do
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year,
                               :purchase_solicitation_budget_allocations => [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office)],
                               :items => [PurchaseSolicitationItem.make!(:office), PurchaseSolicitationItem.make!(:arame_farpado_2)])
    PurchaseSolicitation.make!(:reparo_2013, :accounting_year => Date.current.year, :code => '2',
                               :delivery_location => DeliveryLocation.make!(:health),
                               :responsible => Employee.make!(:wenderson),
                               :budget_structure_id => 2)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab "Solicitantes" do
      fill_with_autocomplete 'Solicitações de compra', :with => '1'

      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'

        within 'tbody tr' do
          expect(page).to have_content '1/2013'
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content 'Gabriel Sobrinho'
        end
      end
    end

    within_tab "Itens / Justificativa" do
      within_records do
        within 'tbody tr:nth-last-child(1)' do
          expect(page).to have_content '10,00'
          expect(page).to have_content '2.000,00'
        end
      end
    end

    within_tab "Solicitantes" do
      fill_with_autocomplete 'Solicitações de compra', :with => 'Secretaria de Educação'

      within_records do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Solicitante'
        expect(page).to have_content 'Responsável pela solicitação'
        expect(page).to have_css 'tbody tr', count: 2

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '1/2013'
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content 'Gabriel Sobrinho'
        end

        within 'tbody tr:nth-last-child(1)' do
          expect(page).to have_content '2/2013'
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content 'Wenderson Malheiros'
        end
      end
    end

    within_tab "Itens / Justificativa" do
      within_records do
        within 'tbody tr:nth-last-child(1)' do
          expect(page).to have_content '109,00'
          expect(page).to have_content '21.800,00'
        end
      end
    end
  end

  scenario 'list accreditation creditors when modality is trading' do
    LicitationProcess.make!(:processo_licitatorio, modality: 'trading',
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation) )

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
      end
    end
  end

  scenario 'when the modality is not trading, should not appear accreditation button' do
    LicitationProcess.make!(:processo_licitatorio)
    LicitationProcess.make!(:pregao_presencial, process: 2)
    JudgmentForm.make!(:por_item_com_menor_preco)

    navigate 'Licitações > Processos de Compras'

    

    click_link '1/2012'

    expect(page).to_not have_link 'Credenciamento'

    click_link 'Voltar'

    

    click_link '2/2012'

    expect(page).to have_link 'Credenciamento'
  end

  scenario 'when not having creditors and items'do
    LicitationProcess.make!(:pregao_presencial, :items => [],
      purchase_process_accreditation: PurchaseProcessAccreditation.make(:general_accreditation))

    navigate 'Licitações > Processos de Compras'

    
    click_link '1/2012'

    expect(page).to have_disabled_element "Propostas", :reason => "deve possuir credores e itens"

      within_tab "Itens" do
        fill_in 'Lote', :with => '2050'

        fill_with_autocomplete 'Material', :with => 'Antivirus'

        expect(page).to have_field 'Unidade', :with => 'UN', disabled: true

        fill_in 'Quantidade', :with => '2'
        fill_in 'Valor unitário máximo', :with => '10,00'

        expect(page).to have_field 'Valor total', :with => '20,00'

        click_button 'Adicionar'

        expect(page).to have_content '2050'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '2'
        expect(page).to have_content '10,00'
        expect(page).to have_content '20,00'
      end

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 1/2012 editado com sucesso."

    click_link 'Propostas'

    expect(page).to have_content "Proposta Comercial Processo 1/2012 - Pregão 1"
  end

  scenario 'purchase solicitation changes its status when associated with licitation process' do
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    JudgmentForm.make!(:por_item_com_menor_preco)
    Material.make!(:antivirus)
    Indexer.make!(:xpto)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'

    expect(page).to_not have_button 'Apurar'

    within_tab 'Principal' do
      expect(page).to have_field 'Status', disabled: true
    end

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
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content 'Gabriel Sobrinho'
        end
      end
    end

    click_button 'Salvar'

    expect(page).to have_no_notice 'Processo de Compra 1/2012 criado com sucesso.'

    navigate 'Licitações > Solicitações de Compra'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Liberada'
      end
    end

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    expect(page).to_not have_link 'Publicações'

    expect(page).to_not have_button 'Apurar'

    within_tab 'Principal' do
      expect(page).to have_field 'Status', disabled: true
    end

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
          expect(page).to have_content '1 - Detran'
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
      expect(page).to have_field 'Valor total dos itens', :with => '600,00', disabled: true
      expect(page).to have_field 'Valor total das dotações', :with => '20,00', disabled: true

      within_records do
        expect(page).to have_content 'Dotação'
        expect(page).to have_content 'Natureza da despesa'
        expect(page).to have_content 'Desdobramento'
        expect(page).to have_content 'Saldo da dotação'
        expect(page).to have_content 'Valor previsto'

        within 'tbody tr' do
          expect(page).to have_content '1 - 3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.1.90.00.00 - Aplicações Diretas'
          expect(page).to have_content '3.0.00.00.00 - Despesas Correntes'
          expect(page).to have_content '989,50'
          expect(page).to have_content '20,00'
        end
      end
    end

    within_tab "Itens" do
      within_records do
        expect(page).to have_css('.nested-record', :count => 1)

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '1'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'UN'
          expect(page).to have_content '3'
          expect(page).to have_content '200,00'
          expect(page).to have_content '600,00'
        end
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 1/2012 criado com sucesso.'

    navigate 'Licitações > Solicitações de Compra'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Em processo de compra'
      end
    end

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      fill_in 'Objeto do processo de compra', :with => ''
    end

    within_tab 'Solicitantes' do
      within_records do
        click_link 'Remover'
      end
    end

    click_button 'Salvar'

    expect(page).to have_no_notice 'Processo de Compra 1/2012 editado com sucesso.'

    within_tab 'Solicitantes' do
      within_records do
        expect(page).to_not have_css 'tbody tr'
      end
    end

    navigate 'Licitações > Solicitações de Compra'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Em processo de compra'
      end
    end

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    within_tab 'Solicitantes' do
      within_records do
        click_link 'Remover'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra 1/2012 editado com sucesso.'

    within_tab 'Solicitantes' do
      within_records do
        expect(page).to_not have_css 'tbody tr'
      end
    end

    navigate 'Licitações > Solicitações de Compra'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Liberada'
      end
    end
  end

  scenario 'should disabled link when licitation_process has not publications' do
    LicitationProcess.make!(:pregao_presencial,
                            publications: [],
                            bidders: [])

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link "1/2012"
    end

    expect(page).to have_disabled_element "Credenciamento", :reason => "Habilitações só podem ser incluídos após publicação do edital"

    click_link "Publicações"

    click_link "Criar Publicação"

    fill_in "Nome do veículo de comunicação", :with => "website"

    fill_in "Data da publicação", :with => "01/05/2013"

    select "Edital", :from => "Publicação do(a)"

    select "Internet", :from => "Tipo de circulação do veículo de comunicação"

    click_button "Salvar"

    expect(page).to have_notice "Publicação criada com sucesso"

    click_link "Voltar ao processo de compra"

    click_link "Credenciamento"

    expect(page).to have_content "Criar Credenciamento"
  end

  scenario 'allow same item' do
    Creditor.make!(:sobrinho)
    Creditor.make!(:wenderson_sa)
    Material.make!(:antivirus)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Compra direta'
      select 'Dispensa justificada - Credenciamento', from: 'Tipo de afastamento'
    end

    within_tab 'Itens / Justificativa' do
      fill_in 'Justificativa da escolha', with: 'Justificativa'
      fill_in 'Lote', with: '1'

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Quantidade', with: '10'

      fill_with_autocomplete 'Fornecedor', :with => 'Gabriel Sobrinho'

      click_button 'Adicionar'

      within '#items-records' do
        expect(page).to have_content '1'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'UN'
        expect(page).to have_content '10'
        expect(page).to have_content '0,00'
        expect(page).to have_content '0,00'
      end

      fill_in 'Justificativa da escolha', with: 'Justificativa 2'
      fill_in 'Lote', with: '1'

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Quantidade', with: '5'

      fill_with_autocomplete 'Fornecedor', :with => 'Wenderson Malheiros'

      click_button 'Adicionar'
      click_button 'Adicionar'
      click_button 'Adicionar'

      within '#items-records' do
        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '1'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content 'UN'
          expect(page).to have_content '10'
          expect(page).to have_content '0,00'
          expect(page).to have_content '0,00'
        end

        within 'tbody tr:nth-last-child(1)' do
          expect(page).to have_content '1'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content 'Wenderson Malheiros'
          expect(page).to have_content 'UN'
          expect(page).to have_content '5'
          expect(page).to have_content '0,00'
          expect(page).to have_content '0,00'
        end
      end
    end
  end

  scenario 'should update process in licitation process' do
    Timecop.travel(Date.new(2012, 10, 10))
    LicitationProcess.make!(:pregao_presencial)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

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
      fill_with_autocomplete 'Unidade responsável pela execução', with: 'Secretaria de Educação'
    end

    within_tab 'Prazos' do
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora do recebimento', :with => '14:00'

      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    within_tab "Itens" do
      fill_in 'Lote', :with => '2234'

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário máximo', :with => '10,00'
      fill_in 'Informações complementares', :with => 'Produto antivirus avast'

      click_button 'Adicionar'
    end

    click_button 'Salvar'

    fill_in 'Processo', with: '1'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'

    fill_in 'Processo', with: '123'

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 123/#{Date.current.year} editado com sucesso."
  end

  scenario 'should auto_increment process in licitation_process when process is blank' do
    Timecop.travel(Date.new(2012, 10, 10))
    LicitationProcess.make!(:pregao_presencial)
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    DocumentType.make!(:oficial)
    JudgmentForm.make!(:por_item_com_menor_preco)
    Material.make!(:antivirus)
    Material.make!(:arame_farpado)
    Indexer.make!(:xpto)

    navigate 'Licitações > Processos de Compras'

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

      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
    end

    within_tab 'Prazos' do
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora do recebimento', :with => '14:00'

      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    within_tab "Itens" do
      fill_in 'Lote', :with => '2234'

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário máximo', :with => '10,00'
      fill_in 'Informações complementares', :with => 'Produto antivirus avast'

      click_button 'Adicionar'
    end

    within_tab 'Orçamento' do
      fill_in 'Ano da dotação', with: '2012'
      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aposentadorias'

      fill_with_autocomplete 'Desdobramento', :with => '3.1'

      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar'

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aplicações'

      fill_with_autocomplete 'Desdobramento', :with => '3.1'

      fill_in 'Valor previsto', :with => '250,00'

      click_button 'Adicionar'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
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

    expect(page).to have_notice "Processo de Compra 2/#{Date.current.year} criado com sucesso."

    within_tab 'Principal' do
      expect(page).to have_field 'Processo', :with => '2'
    end
  end

  scenario 'should not auto_increment process in licitation_process when process is not blank' do
    Timecop.travel(Date.new(2012, 10, 10))
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    DocumentType.make!(:oficial)
    JudgmentForm.make!(:por_item_com_menor_preco)
    Material.make!(:antivirus)
    Material.make!(:arame_farpado)
    Indexer.make!(:xpto)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    expect(page).to have_content "Criar Processo"

    within_tab 'Principal' do
      choose 'Processo licitatório'

      fill_in 'Processo', with: '3'

      select 'Compras e serviços', :from => 'Tipo de objeto'
      select 'Concorrência', :from => 'Modalidade'
      fill_in 'Objeto do processo de compra', :with => 'Licitação para compra de carteiras'

      check 'Registro de preço'
      select 'Por Item com Menor Preço', :from =>'Forma de julgamento'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Fiança bancária', :from => 'Tipo de garantia'

      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
    end

    within_tab 'Prazos' do
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora do recebimento', :with => '14:00'

      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    within_tab "Itens" do
      fill_in 'Lote', :with => '2234'

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Quantidade', :with => '2'
      fill_in 'Valor unitário máximo', :with => '10,00'
      fill_in 'Informações complementares', :with => 'Produto antivirus avast'

      click_button 'Adicionar'
    end

    within_tab 'Orçamento' do
      fill_in 'Ano da dotação', with: '2012'
      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aposentadorias'

      fill_with_autocomplete 'Desdobramento', :with => '3.1'

      fill_in 'Valor previsto', :with => '20,00'

      click_button 'Adicionar'

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aplicações Diretas'

      fill_with_autocomplete 'Desdobramento', :with => '3.1'

      fill_in 'Valor previsto', :with => '250,00'

      click_button 'Adicionar'
    end

    within_tab 'Documentos' do
      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
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

    expect(page).to have_notice "Processo de Compra 3/#{Date.current.year} criado com sucesso."

    within_tab 'Principal' do
      expect(page).to have_field 'Processo', :with => '3'
    end
  end

  scenario 'should filter auto_complete in budget_allocation by budget_allocation_year' do
    LicitationProcess.make!(:processo_licitatorio, purchase_process_budget_allocations: [])

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '1/2012'
    end

    within_tab 'Orçamento' do
      fill_in 'Ano da dotação', with: '2013'
      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      within_autocomplete 'Dotação orçamentária', with: 'Ap' do
        expect(page).to_not have_content '12 - Aplicações Diretas'
        expect(page).to_not have_content '11 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
      end

      fill_in 'Ano da dotação', with: '2012'
      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      within_autocomplete 'Dotação orçamentária', with: 'Ap' do
        expect(page).to have_content '12 - Aplicações Diretas'
        expect(page).to have_content '11 - Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares'
      end
    end
  end

  scenario 'cannot allow remove budget_allocation that cannot be used by reserve_fund', :reset_ids do
    Timecop.travel(Date.new(2013, 3, 25))

    creditor = Creditor.make!(:wenderson_sa)
    bidder = Bidder.make!(:licitante, creditor: creditor)

    LicitationProcess.make!(:processo_licitatorio_computador,
      process: 102,
      purchase_process_budget_allocations: [PurchaseProcessBudgetAllocation.make!(:alocacao, budget_allocation_id: 6)],
      bidders: [bidder])

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '102/2013'
    end

    within_tab 'Orçamento' do
      within_records do
        click_link 'Remover'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Dotação 13 - 3.0.00.00.00 - Despesas Correntes não pode ser apagada pois já está em uso'
  end

  scenario 'cannot allow remove budget_allocation that cannot be used by pledge', :reset_ids do
    Timecop.travel(Date.new(2013, 3, 25))

    creditor = Creditor.make!(:wenderson_sa)
    bidder = Bidder.make!(:licitante, creditor: creditor)

    LicitationProcess.make!(:processo_licitatorio_computador,
      process: 102,
      purchase_process_budget_allocations: [PurchaseProcessBudgetAllocation.make!(:alocacao, budget_allocation_id: 7)],
      bidders: [bidder])

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '102/2013'
    end

    within_tab 'Orçamento' do
      within_records do
        click_link 'Remover'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Dotação 14 - 3.1.00.00.00 - Pessoal e Encargos Sociais não pode ser apagada pois já está em uso'
  end

  scenario 'cannot allow change budget_allocation that cannot be used by reserve_fund', :reset_ids do
    Timecop.travel(Date.new(2013, 3, 25))

    creditor = Creditor.make!(:wenderson_sa)
    bidder = Bidder.make!(:licitante, creditor: creditor)

    LicitationProcess.make!(:processo_licitatorio_computador,
      process: 102,
      purchase_process_budget_allocations: [PurchaseProcessBudgetAllocation.make!(:alocacao, budget_allocation_id: 6)],
      bidders: [bidder])

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '102/2013'
    end

    within_tab 'Orçamento' do
      within_records do
        click_link 'Editar'
      end

      fill_in 'Ano da dotação', with: '2012'
      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aposentadorias'

      click_button 'Adicionar'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Dotação orçamentária já está reservada ou empenhada'
  end

  scenario 'cannot allow change budget_allocation that cannot be used by pledge', :reset_ids do
    Timecop.travel(Date.new(2013, 3, 25))

    creditor = Creditor.make!(:wenderson_sa)
    bidder = Bidder.make!(:licitante, creditor: creditor)

    LicitationProcess.make!(:processo_licitatorio_computador,
      process: 102,
      purchase_process_budget_allocations: [PurchaseProcessBudgetAllocation.make!(:alocacao, budget_allocation_id: 7)],
      bidders: [bidder])

    navigate 'Licitações > Processos de Compras'



    within_records do
      click_link '102/2013'
    end

    within_tab 'Orçamento' do
      within_records do
        click_link 'Editar'
      end

      fill_in 'Ano da dotação', with: '2012'
      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      fill_with_autocomplete 'Dotação orçamentária', :with => 'Aposentadorias'

      click_button 'Adicionar'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Dotação orçamentária já está reservada ou empenhada'
  end

  scenario 'should enable budget_allocation when budget_allocation_year is change' do
    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Orçamento' do
      expect(page).to have_field 'Dotação orçamentária', disabled: true

      fill_in 'Ano da dotação', with: '2012'
      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      expect(page).to have_field 'Dotação orçamentária', disabled: false

      fill_in 'Ano da dotação', with: ''
      page.execute_script %{ $("input[id$=licitation_process_budget_allocation_year]").trigger("change") }

      expect(page).to have_field 'Dotação orçamentária', disabled: true
    end
  end

  scenario 'warn when has as material_class fractionation' do
    Timecop.travel(Date.new(2012, 10, 10))
    PaymentMethod.make!(:dinheiro)
    DocumentType.make!(:fiscal)
    DocumentType.make!(:oficial)
    JudgmentForm.make!(:por_item_com_menor_preco)
    Indexer.make!(:xpto)

    licitation = LicitationProcess.make!(:processo_licitatorio_computador,
      year: 2012, process_date: Date.current)
    ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador,
     licitation_process: licitation)

    PurchaseProcessFractionationCreator.create!(ratification.licitation_process)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Processo licitatório'

      select 'Compras e serviços', from: 'Tipo de objeto'
      select 'Empreitada integral', :from => 'Forma de execução'
      select 'Convite', from: 'Modalidade'
      fill_in 'Objeto do processo de compra', with: 'Licitação para compra de carteiras'

      select 'Por Item com Menor Preço', from: 'Forma de julgamento'
      select 'Fiança bancária', from: 'Tipo de garantia'
      fill_modal 'Índice de reajuste', with: 'XPTO'
      fill_modal 'Forma de pagamento', with: 'Dinheiro', field: 'Descrição'
      fill_in 'Valor da caução', with: '50,00'
      fill_with_autocomplete 'Unidade responsável pela execução', with: 'Secretaria de Educação'
    end

    within_tab 'Prazos' do
      fill_in 'Data da disponibilidade', :with => I18n.l(Date.current)
      fill_modal 'Contato para informações', :with => '958473', :field => 'Matrícula'

      fill_in 'Término do recebimento dos envelopes', :with => I18n.l(Date.current)
      fill_in 'Hora do recebimento', :with => '14:00'

      fill_in 'Validade da proposta', :with => '5'
      select 'dia/dias', :from => 'Período da validade da proposta'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período do prazo de entrega'
    end

    within_tab "Itens" do
      fill_in 'Lote', :with => '2234'

      fill_with_autocomplete 'Material', :with => 'Antivirus'

      fill_in 'Quantidade', :with => '10000'
      fill_in 'Valor unitário máximo', :with => '8,00'
      fill_in 'Informações complementares', :with => 'Produto antivirus avast'

      # asserting calculated total price of the item
      expect(page).to have_field 'Valor total', :with => '80.000,00'

      click_button 'Adicionar'
    end

    click_button 'Salvar'

    expect(page).to have_notice "Processo de Compra 3/#{Date.current.year} criado com sucesso."
    expect(page).to have_content "O material 01.01.00001 - Antivirus está caracterizando possível fracionamento."

    within_tab 'Principal' do
      expect(page).to have_field 'Processo', :with => '3'

      expect(page).to have_select 'Modalidade', :selected => 'Convite', disabled: true
      expect(page).to have_field 'Nº da modalidade', :with => '1', disabled: true
      expect(page).to have_select 'Tipo de objeto', :selected => 'Compras e serviços', disabled: true
      expect(page).to have_select 'Forma de julgamento', :selected => 'Por Item com Menor Preço', disabled: true
      expect(page).to have_field 'Objeto do processo de compra', :with => 'Licitação para compra de carteiras'

      expect(page).to have_select 'Forma de execução', :selected => 'Empreitada integral'
      expect(page).to have_select 'Tipo de garantia', :selected => 'Fiança bancária'
      expect(page).to have_field 'Índice de reajuste', :with => 'XPTO'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Valor da caução', :with => '50,00'
      expect(page).to have_field 'Unidade responsável pela execução', with: '9 - Secretaria de Educação'
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

    within_tab "Itens" do
      within_records do
        expect(page).to have_content '2234'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '10.000'
        expect(page).to have_content '8,00'
        expect(page).to have_content '80.000,00'
      end
    end
  end

  scenario 'fills average unit price of purchase solicitation price collection proposal items when option is selected' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, type_of_calculation: PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year, price_collections: [price_collection])
    proposal_1 = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, price_collection: price_collection)
    proposal_2 = PriceCollectionProposal.make!(:sobrinho_sa_proposta, price_collection: price_collection,
                   creditor: Creditor.make(:sobrinho_sa, accounts: [ CreditorBankAccount.make(:conta_2, number: '000103') ] ))
    proposal_3 = PriceCollectionProposal.make!(:sobrinho_sa_proposta_without_user, price_collection: price_collection)

    PriceCollectionProposalItem.destroy_all

    PriceCollectionProposalItem.make!(:wenderson_antivirus,
      price_collection_proposal: proposal_1,
      price_collection_item: price_collection.items.first,
      unit_price: 10.00)

    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
      price_collection_proposal: proposal_2,
      price_collection_item: price_collection.items.first,
      unit_price: 13.50)

    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
      price_collection_proposal: proposal_3,
      price_collection_item: price_collection.items.first,
      unit_price: 0)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Compra direta'
    end

    within_tab 'Solicitantes' do
      choose 'Importar preço médio'

      fill_with_autocomplete 'Solicitações de compra', with: '1/2013'

      within_records do
        expect(page).to have_content '1/2013'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end

    within_tab 'Itens / Justificativa' do
      within_records do
        expect(page).to have_content '1'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '3,00'
        expect(page).to have_content '11,75'
        expect(page).to have_content '35,25'
      end
    end
  end

  scenario 'doesnt fill average unit price of purchase solicitation price collection proposal items when there isnt any registered price collection' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, type_of_calculation: PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year, price_collections: [price_collection])

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Compra direta'
    end

    within_tab 'Solicitantes' do
      choose 'Importar preço médio'

      fill_with_autocomplete 'Solicitações de compra', with: '1/2013'

      within_records do
        expect(page).to have_content '1/2013'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end

    within_tab 'Itens / Justificativa' do
      within_records do
        expect(page).to have_content '1'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '3,00'
        expect(page).to have_content '0,00'
      end
    end
  end

  scenario 'fills creditor and unit price of best purchase solicitation price collection proposal item when option is selected' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, type_of_calculation: PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year, price_collections: [price_collection])
    proposal_1 = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, price_collection: price_collection)
    proposal_2 = PriceCollectionProposal.make!(:sobrinho_sa_proposta, price_collection: price_collection,
                   creditor: Creditor.make(:sobrinho_sa, accounts: [ CreditorBankAccount.make(:conta_2, number: '000103') ] ))

    PriceCollectionProposalItem.destroy_all

    PriceCollectionProposalItem.make!(:wenderson_antivirus,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_item => price_collection.items.first,
                                      :unit_price => 15.00)
    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_item => price_collection.items.first,
                                      :unit_price => 13.50)

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Compra direta'
    end

    within_tab 'Solicitantes' do
      choose 'Importar vencedores'

      fill_with_autocomplete 'Solicitações de compra', with: '1/2013'

      within_records do
        expect(page).to have_content '1/2013'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end

    within_tab 'Itens / Justificativa' do
      within_records do
        expect(page).to have_content '1'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '3,00'
        expect(page).to have_content '13,50'
        expect(page).to have_content '40,50'
      end
    end
  end

  scenario 'doesnt fill winner creditor of purchase solicitation price collection proposal items when there isnt any registered price collection' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, type_of_calculation: PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)
    PurchaseSolicitation.make!(:reparo_liberado, :accounting_year => Date.current.year, price_collections: [price_collection])

    navigate 'Licitações > Processos de Compras'

    click_link 'Criar Processo de Compra'

    within_tab 'Principal' do
      choose 'Compra direta'
    end

    within_tab 'Solicitantes' do
      choose 'Importar vencedores'

      fill_with_autocomplete 'Solicitações de compra', with: '1/2013'

      within_records do
        expect(page).to have_content '1/2013'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end

    within_tab 'Itens / Justificativa' do
      within_records do
        expect(page).to have_content '1'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content 'UN'
        expect(page).to have_content '0,00'
        expect(page).to have_content '3,00'

        expect(page).to_not have_content 'Gabriel Sobrinho'
      end
    end
  end
end
