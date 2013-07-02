# encoding: utf-8
require 'spec_helper'

feature "PriceCollections" do
  background do
    Prefecture.make!(:belo_horizonte)

    sign_in
  end

  scenario 'can not create a new price collection when no set the creditor email' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Material.make!(:antivirus)
    Creditor.make!(:sobrinho_sa_without_email)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Número'
      expect(page).to have_disabled_field 'Status'
      expect(page).to have_select 'Status', :selected => 'Ativo'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data', :with => I18n.l(Date.current)
      select 'Menor preço total por item', :from => 'Tipo de apuração'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '1'
      fill_in 'Vencimento', :with => I18n.l(Date.tomorrow)
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_in 'Validade da proposta', :with => '1'
      select 'ano/anos', :from => 'Período da validade da proposta'
      fill_in 'Objeto', :with => 'objeto da coleta'
      fill_in 'Observações', :with => 'observacoes da coleta'
    end

    within_tab 'Lotes de itens' do
      click_button 'Adicionar Lote'

      fill_in 'Observações', :with => 'lote 1'

      click_button 'Adicionar Item'

      fill_in 'Lote', :with => '3110122013'
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # testing fill reference unit with javascript
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca', :with => 'Norton'
      fill_in 'Quantidade', :with => '10'
    end

    within_tab 'Fornecedores' do
      fill_with_autocomplete 'Fornecedor', :with => 'Gabriel'

      click_button 'Adicionar'

      within_records do
        expect(page).to_not have_css '.nested-record'
      end
    end
  end

  scenario 'create a new price_collection' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Material.make!(:antivirus)
    Creditor.make!(:wenderson_sa)
    Creditor.make!(:mateus)
    Creditor.make!(:ibm)

    PurchaseSolicitation.make!(:reparo_liberado, accounting_year: Date.current.year)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    expect(page).to_not have_link 'Apurar'
    expect(page).to_not have_link 'Relatório'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Número'
      expect(page).to have_disabled_field 'Status'
      expect(page).to have_select 'Status', :selected => 'Ativo'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data', :with => I18n.l(Date.current)
      select 'Menor preço total por item', :from => 'Tipo de apuração'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '1'
      fill_in 'Vencimento', :with => I18n.l(Date.tomorrow)
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_in 'Validade da proposta', :with => '1'
      select 'ano/anos', :from => 'Período da validade da proposta'
      fill_in 'Objeto', :with => 'objeto da coleta'
      fill_in 'Observações', :with => 'observacoes da coleta'
    end

     within_tab "Solicitações de compras" do
      fill_with_autocomplete 'Solicitações de compra', with: '1'

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

    within_tab 'Lotes de itens' do
      click_button 'Adicionar Lote'

      fill_in 'Observações', :with => 'lote 1'

      click_button 'Adicionar Item'

      fill_in 'Lote', :with => '31011020'
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # testing fill reference unit with javascript
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca', :with => 'Norton'
      fill_in 'Quantidade', :with => '10'
    end

    within_tab 'Fornecedores' do
      fill_with_autocomplete 'Fornecedor', :with => 'Wen'
      expect(page).to have_field 'Email', :with => 'wenderson.malheiros@gmail.com'

      click_button 'Adicionar'

      fill_with_autocomplete 'Fornecedor', :with => 'Mateus'
      expect(page).to have_field 'Email', :with => 'mcomogo@gmail.com'

      click_button 'Adicionar'

      fill_with_autocomplete 'Fornecedor', :with => 'IBM'
      expect(page).to have_field 'Email', :with => 'ibm@gmail.com'

      click_button 'Adicionar'

      within_records do
        expect(page).to have_css '.nested-record', :count => 3

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content 'Wenderson Malheiros'
          expect(page).to have_content 'wenderson.malheiros@gmail.com'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content 'Mateus'
          expect(page).to have_content 'mcomogo@gmail.com'
        end

        within 'tbody tr:nth-child(3)' do
          expect(page).to have_content 'IBM'
          expect(page).to have_content 'ibm@gmail.com'
        end
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Coleta de Preços 1/2012 criada com sucesso.'

    expect(page).to have_title 'Editar Coleta de Preços'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Número'
      expect(page).to have_field 'Número', :with => '1'
      expect(page).to have_select 'Status', :selected => 'Ativo'

      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data', :with => I18n.l(Date.current)
      expect(page).to have_select 'Tipo de apuração', :selected => 'Menor preço total por item'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Prazo de entrega', :with => '1'
      expect(page).to have_field 'Vencimento', :with => I18n.l(Date.tomorrow)
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'ano/anos'
      expect(page).to have_field 'Validade da proposta', :with => '1'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'ano/anos'
      expect(page).to have_field 'Objeto', :with => 'objeto da coleta'
      expect(page).to have_field 'Observações', :with => 'observacoes da coleta'
    end

    within_tab "Solicitações de compras" do
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

    within_tab 'Lotes de itens' do
      expect(page).to have_field 'Observações', :with => 'lote 1'
      expect(page).to have_field 'Lote', :with => '31011020'
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca', :with => 'Norton'
      expect(page).to have_field 'Quantidade', :with => '10'
    end

    within_tab 'Fornecedores' do
      within_records do
        expect(page).to have_css '.nested-record', :count => 3

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content 'Wenderson Malheiros'
          expect(page).to have_content 'wenderson.malheiros@gmail.com'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content 'Mateus'
          expect(page).to have_content 'mcomogo@gmail.com'
        end

        within 'tbody tr:nth-child(3)' do
          expect(page).to have_content 'IBM'
          expect(page).to have_content 'ibm@gmail.com'
        end
      end
    end

    click_link 'Propostas'

    click_link '1/2012'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => ''
  end

  scenario 'update an existent price_collection' do
    PriceCollection.make!(:coleta_de_precos)
    DeliveryLocation.make!(:health)
    Employee.make!(:wenderson)
    PaymentMethod.make!(:cheque)
    Material.make!(:arame_farpado)


    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    expect(page).to have_subtitle '1/2012'

    within_tab 'Principal' do
      fill_in 'Data', :with => I18n.l(Date.current + 10.days)
      fill_modal 'Local de entrega', :with => 'Secretaria da Saúde', :field => 'Descrição'
      fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '3'
      fill_in 'Vencimento', :with => I18n.l(Date.tomorrow + 10.days)
      select 'mês/meses', :from => 'Período do prazo de entrega'
      fill_in 'Validade da proposta', :with => '3'
      select 'mês/meses', :from => 'Período da validade da proposta'
      fill_in 'Objeto', :with => 'novo objeto da coleta'
      fill_in 'Observações', :with => 'novo observacoes da coleta'
    end

    within_tab 'Lotes de itens' do
      click_button 'Adicionar Lote'

      within '.price-collection-lot:last' do
        fill_in 'Observações', :with => 'lote 2'

        click_button 'Adicionar Item'

        fill_in 'Lote', :with => '311012501'
        fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'
        fill_in 'Marca', :with => 'Aço inox'
        fill_in 'Quantidade', :with => '100'
      end
    end

    within_tab 'Fornecedores' do
      within_records do
        expect(page).to have_css '.nested-record', :count => 3

        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content 'Wenderson Malheiros'
          expect(page).to have_content 'wenderson.malheiros@gmail.com'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content 'Gabriel Sobrinho'
          expect(page).to have_content 'tiago.geraldi@gmail.com'
        end

        within 'tbody tr:nth-child(3)' do
          expect(page).to have_content 'IBM'
          expect(page).to have_content 'alovisk@gmail.com'
        end
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Coleta de Preços 1/2012 editada com sucesso.'

    expect(page).to have_title 'Editar Coleta de Preços'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Número'
      expect(page).to have_field 'Número', :with => '1'
      expect(page).to have_select 'Status', :selected => 'Ativo'

      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data', :with => I18n.l(Date.current + 10.days)
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Saúde'
      expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Forma de pagamento', :with => 'Cheque'
      expect(page).to have_field 'Prazo de entrega', :with => '3'
      expect(page).to have_field 'Vencimento', :with => I18n.l(Date.tomorrow + 10.days)
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'mês/meses'
      expect(page).to have_field 'Validade da proposta', :with => '3'
      expect(page).to have_select 'Período da validade da proposta', :selected => 'mês/meses'
      expect(page).to have_field 'Objeto', :with => 'novo objeto da coleta'
      expect(page).to have_field 'Observações', :with => 'novo observacoes da coleta'
    end

    within_tab 'Lotes de itens' do
      expect(page).to have_field 'Observações', :with => 'lote 2'
      expect(page).to have_field 'Lote', :with => '311012501'
      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca', :with => 'Aço inox'
      expect(page).to have_field 'Quantidade', :with => '100'
    end

    within_tab 'Fornecedores' do
      expect(page).to_not have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    end
  end

  scenario 'should not have destroy button' do
    PriceCollection.make!(:coleta_de_precos)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_button 'Apagar'
  end

  scenario 'trying to create without items to see the error message' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Creditor.make!(:wenderson_sa)
    Creditor.make!(:mateus)
    Creditor.make!(:ibm)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data', :with => I18n.l(Date.current)
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '1'
      fill_in 'Vencimento', :with => I18n.l(Date.tomorrow)
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_in 'Validade da proposta', :with => '1'
      select 'ano/anos', :from => 'Período da validade da proposta'
      fill_in 'Objeto', :with => 'objeto da coleta'
      fill_in 'Observações', :with => 'observacoes da coleta'
    end

    within_tab 'Lotes de itens' do
      click_button 'Adicionar Lote'

      fill_in 'Observações', :with => 'lote 2'
    end

    within_tab 'Fornecedores' do
      fill_with_autocomplete 'Fornecedor', :with => 'Wen'
      expect(page).to have_field 'Email', :with => 'wenderson.malheiros@gmail.com'

      click_button 'Adicionar'

      fill_with_autocomplete 'Fornecedor', :with => 'Mateus'
      expect(page).to have_field 'Email', :with => 'mcomogo@gmail.com'

      click_button 'Adicionar'

      fill_with_autocomplete 'Fornecedor', :with => 'IBM'
      expect(page).to have_field 'Email', :with => 'ibm@gmail.com'

      click_button 'Adicionar'
    end

    click_button 'Salvar'

    within_tab 'Lotes de itens' do
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'trying to remove all the items to see the error message' do
    price_collection = PriceCollection.make!(:coleta_de_precos)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      click_button 'Remover Item'
    end

    click_button 'Salvar'

    within_tab 'Lotes de itens' do
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'removing an item and adding another one' do
    PriceCollection.make!(:coleta_de_precos)
    Material.make!(:arame_farpado)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Marca', :with => 'Norton'
      expect(page).to have_field 'Quantidade', :with => '10'

      click_button 'Remover Item'

      click_button 'Adicionar Item'

      fill_in 'Lote', :with => '10256987'
      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'
      fill_in 'Marca', :with => 'Aço inox'
      fill_in 'Quantidade', :with => '100'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Coleta de Preços 1/2012 editada com sucesso.'
    expect(page).to have_title 'Editar Coleta de Preços'

    within_tab 'Lotes de itens' do
      expect(page).to have_field 'Lote', :with => '10256987'
      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_field 'Marca', :with => 'Aço inox'
      expect(page).to have_field 'Quantidade', :with => '100'

      expect(page).to_not have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to_not have_field 'Marca', :with => 'Norton'
      expect(page).to_not have_field 'Quantidade', :with => '10'
    end
  end

  scenario 'removing a lot' do
    PriceCollection.make!(:coleta_de_precos)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      expect(page).to have_field 'Observações', :with => 'lote da coleta'

      click_button 'Remover Lote'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Coleta de Preços 1/2012 editada com sucesso.'

    expect(page).to have_title 'Editar Coleta de Preços'

    within_tab 'Lotes de itens' do
      expect(page).to_not have_field 'Observações', :with => 'lote da coleta'
    end
  end

  scenario 'showing numberd labels on each lot' do
    price_collection = PriceCollection.make!(:coleta_de_precos)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      expect(page).to have_content 'Lote 1'
      expect(page).to_not have_content 'Lote 2'

      click_button 'Adicionar Lote'

      expect(page).to have_content 'Lote 1'
      expect(page).to have_content 'Lote 2'

      click_button 'Adicionar Lote'

      expect(page).to have_content 'Lote 1'
      expect(page).to have_content 'Lote 2'
      expect(page).to have_content 'Lote 3'

      # removing the first lot to se that it re-order all the others
      click_button 'Remover Lote'

      expect(page).to have_content 'Lote 1'
      expect(page).to have_content 'Lote 2'
      expect(page).to_not have_content 'Lote 3'
    end
  end

  scenario 'calc by lowest_total_price_by_item' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes,
                          type_of_calculation: PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)

    make_proposals_dependencies!(price_collection)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    expect(page).to have_content 'QUADRO COMPARATIVO DE PREÇOS DA COLETA DE PREÇO 1/2012'

    expect(page).to have_content 'Apuração: Menor preço total por item'

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification-1-3' do
      expect(page).to have_content 'Arame comum'
      expect(page).to have_content '2,00'
      expect(page).to have_content '400,00'
      expect(page).to have_content 'Sim'
    end

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-2' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '40,00'
      expect(page).to have_content '400,00'
      expect(page).to have_content 'Sim'
    end

    click_link 'voltar'

    click_link 'Relatório'

    expect(page).to have_content 'QUADRO COMPARATIVO DE PREÇOS DA COLETA DE PREÇO 1/2012'
  end

  scenario 'calc by lowest_total_price_by_item with zero item' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, type_of_calculation: PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)
    proposal_1 = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, price_collection: price_collection)
    proposal_2 = PriceCollectionProposal.make!(:sobrinho_sa_proposta, price_collection: price_collection,
                   creditor: Creditor.make(:sobrinho_sa, accounts: [ CreditorBankAccount.make(:conta_2, number: '000103') ] ))

    PriceCollectionProposalItem.make!(:wenderson_antivirus,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.first,
                                      :unit_price => 0)
    PriceCollectionProposalItem.make!(:wenderson_arame,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.second,
                                      :unit_price => 3)

    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.first,
                                      :unit_price => 50)
    PriceCollectionProposalItem.make!(:sobrinho_arame,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.second,
                                      :unit_price => 2)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    expect(page).to have_content 'QUADRO COMPARATIVO DE PREÇOS DA COLETA DE PREÇO 1/2012'

    expect(page).to have_content 'Apuração: Menor preço total por item'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '50,00'
      expect(page).to have_content 'Sim'
    end

    within '.classification-1-1' do
      expect(page).to have_content 'Arame comum'
      expect(page).to have_content '2,00'
      expect(page).to have_content 'Sim'
    end
  end

  scenario 'calc by lowest_price_by_lot' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_PRICE_BY_LOT)

    make_proposals_dependencies!(price_collection)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    expect(page).to have_content 'QUADRO COMPARATIVO DE PREÇOS DA COLETA DE PREÇO 1/2012'

    expect(page).to have_content 'Apuração: Menor preço por lote'

    expect(page).to have_content 'Wenderson Malheiros'

    within '.classification--1-0-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '0,00'
      expect(page).to have_content '0,00'
      expect(page).to have_content 'Não'
    end

    within '.classification--1-1-0' do
      expect(page).to have_content 'Arame comum'
      expect(page).to have_content '0,00'
      expect(page).to have_content '0,00'
      expect(page).to have_content 'Não'
    end

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification--1-0-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '0,00'
      expect(page).to have_content '0,00'
      expect(page).to have_content 'Não'
    end

    within '.classification--1-1-0' do
      expect(page).to have_content 'Arame comum'
      expect(page).to have_content '0,00'
      expect(page).to have_content '0,00'
      expect(page).to have_content 'Não'
    end

    expect(page).to have_content 'IBM'

    within '.classification--1-0-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '0,00'
      expect(page).to have_content '0,00'
      expect(page).to have_content 'Não'
    end

    within '.classification--1-1-0' do
      expect(page).to have_content 'Arame comum'
      expect(page).to have_content '0,00'
      expect(page).to have_content '0,00'
      expect(page).to have_content 'Não'
    end
  end

  scenario 'calc by lowest_price_by_lot with item zero' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_itens_no_mesmo_lote, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_PRICE_BY_LOT)
    proposal_1 = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, :price_collection => price_collection)
    proposal_2 = PriceCollectionProposal.make!(:sobrinho_sa_proposta, price_collection: price_collection,
                   creditor: Creditor.make(:sobrinho_sa, accounts: [ CreditorBankAccount.make(:conta_2, number: '000103') ] ))

    PriceCollectionProposalItem.make!(:wenderson_antivirus,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.first,
                                      :unit_price => 0)
    PriceCollectionProposalItem.make!(:wenderson_office,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.second)

    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.first,
                                      :unit_price => 30)
    PriceCollectionProposalItem.make!(:sobrinho_office,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.second)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    expect(page).to have_content 'QUADRO COMPARATIVO DE PREÇOS DA COLETA DE PREÇO 1/2012'

    expect(page).to have_content 'Apuração: Menor preço por lote'

    within '.classification-1-0-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '30,00'
      expect(page).to have_content 'Sim'
    end

    within 'tr.classification-1-0-1' do
      expect(page).to have_content 'Office'
      expect(page).to have_content '5,00'
      expect(page).to have_content 'Sim'
    end
  end

  scenario 'calc by lowest_global_price' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE)
    proposal_1 = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, :price_collection => price_collection)
    proposal_2 = PriceCollectionProposal.make!(:sobrinho_sa_proposta, price_collection: price_collection,
                   creditor: Creditor.make(:sobrinho_sa, accounts: [ CreditorBankAccount.make(:conta_2, number: '000103') ] ))

    PriceCollectionProposalItem.make!(:wenderson_antivirus,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.first,
                                      :unit_price => 0)
    PriceCollectionProposalItem.make!(:wenderson_arame,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.second,
                                      :unit_price => 3)

    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.first,
                                      :unit_price => 50)
    PriceCollectionProposalItem.make!(:sobrinho_arame,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.second,
                                      :unit_price => 2)

    #make_proposals_dependencies!(price_collection)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    expect(page).to have_content 'QUADRO COMPARATIVO DE PREÇOS DA COLETA DE PREÇO 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '50,00'
      expect(page).to have_content '500,00'
      expect(page).to have_content 'Sim'
    end

    within '.classification-1-1' do
      expect(page).to have_content 'Arame comum'
      expect(page).to have_content '2,00'
      expect(page).to have_content '400,00'
      expect(page).to have_content 'Sim'
    end
  end

  scenario 'calc by lowest_global_price with unit price equals zero' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE)
    proposal_1 = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, :price_collection => price_collection)
    proposal_2 = PriceCollectionProposal.make!(:sobrinho_sa_proposta, price_collection: price_collection,
                   creditor: Creditor.make(:sobrinho_sa, accounts: [ CreditorBankAccount.make(:conta_2, number: '000103') ] ))

    PriceCollectionProposalItem.make!(:wenderson_antivirus,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.first,
                                      :unit_price => 0)
    PriceCollectionProposalItem.make!(:wenderson_arame,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.second,
                                      :unit_price => 10)

    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.first,
                                      :unit_price => 10)
    PriceCollectionProposalItem.make!(:sobrinho_arame,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.second,
                                      :unit_price => 10)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    expect(page).to have_content 'QUADRO COMPARATIVO DE PREÇOS DA COLETA DE PREÇO 1/2012'

    expect(page).to have_content 'Apuração: Menor preço global'

    expect(page).to have_content 'Wenderson Malheiros'

    expect(page).to have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      expect(page).to have_content 'Antivirus'
      expect(page).to have_content '10,00'
      expect(page).to have_content 'Sim'
    end

    within '.classification-1-1' do
      expect(page).to have_content 'Arame comum'
      expect(page).to have_content '10,00'
      expect(page).to have_content 'Sim'
    end
  end

  scenario 'showing numbered labels on each item' do
    PriceCollection.make!(:coleta_de_precos)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      expect(page).to have_content 'Item 1'
      expect(page).to_not have_content 'Item 2'

      click_button 'Adicionar Item'

      expect(page).to have_content 'Item 1'
      expect(page).to have_content 'Item 2'

      click_button 'Adicionar Item'

      expect(page).to have_content 'Item 1'
      expect(page).to have_content 'Item 2'
      expect(page).to have_content 'Item 3'

      # removing the first item to se that it re-order all the others
      click_button 'Remover Item'

      expect(page).to have_content 'Item 1'
      expect(page).to have_content 'Item 2'
      expect(page).to_not have_content 'Item 3'

      # adding another lot to see that its items are numbered independently of the first lot
      click_button 'Adicionar Lote'

      within '.price-collection-lot:last' do
        click_button 'Adicionar Item'

        expect(page).to have_content 'Item 1'
      end
    end
  end

  scenario 'disable email when the creditor has a related user' do
    Creditor.make!(:wenderson_sa_with_user)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Fornecedores' do
      fill_with_autocomplete 'Fornecedor', :with => 'Wenderson Malheiros'

      expect(page).to have_disabled_field 'Email'
      expect(page).to have_field 'Email', :with => 'wenderson.malheiros@gmail.com'
    end
  end

  scenario 'opening the filter modal' do
    PriceCollection.make!(:coleta_de_precos)

    PriceCollection.make!(:coleta_de_precos_anulada,
      price_collection_proposals: [ PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, price_collection: nil),
                                    PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, price_collection: nil),
                                    PriceCollectionProposal.make!(:sobrinho_sa_proposta, price_collection: nil,
                                      creditor: Creditor.make!(:ibm, user: User.make!(:geraldi, login: 'alovisk', email: 'alovisk@gmail.com'),
                                        accounts: [ CreditorBankAccount.make(:conta_2, number: '000104') ]))
                                  ])

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_css('a', :count => 2)
    end

    click_link 'Filtrar Coletas de Preços'

    select 'Anulado', :from => 'Status'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_css('a', :count => 1)
    end
  end

  scenario 'index with columns at the index' do
    PriceCollection.make!(:coleta_de_precos)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link "Limpar Filtro"

    within_records do
      expect(page).to have_content 'Código/Ano'
      expect(page).to have_content 'Status'

      within 'tbody tr' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content 'Ativo'
      end
    end
  end

  scenario 'can not create a new price collection when using an email already in use' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Material.make!(:antivirus)
    Creditor.make!(:wenderson_sa)
    Creditor.make!(:mateus)
    Creditor.make!(:sobrinho_sa_without_email)
    User.make!(:geraldi)

    navigate 'Processos de Compra > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Número'
      expect(page).to have_disabled_field 'Status'
      expect(page).to have_select 'Status', :selected => 'Ativo'

      fill_in 'Ano', :with => '2012'
      fill_in 'Data', :with => I18n.l(Date.current)
      select 'Menor preço total por item', :from => 'Tipo de apuração'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '1'
      fill_in 'Vencimento', :with => I18n.l(Date.tomorrow)
      select 'ano/anos', :from => 'Período do prazo de entrega'
      fill_in 'Validade da proposta', :with => '1'
      select 'ano/anos', :from => 'Período da validade da proposta'
      fill_in 'Objeto', :with => 'objeto da coleta'
      fill_in 'Observações', :with => 'observacoes da coleta'
    end

    within_tab 'Lotes de itens' do
      click_button 'Adicionar Lote'

      fill_in 'Observações', :with => 'lote 1'

      click_button 'Adicionar Item'

      fill_in 'Lote', :with => '1'
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # testing fill reference unit with javascript
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca', :with => 'Norton'
      fill_in 'Quantidade', :with => '10'
    end

    within_tab 'Fornecedores' do
      fill_with_autocomplete 'Fornecedor', :with => 'Wen'
      expect(page).to have_field 'Email', :with => 'wenderson.malheiros@gmail.com'

      click_button 'Adicionar'

      fill_with_autocomplete 'Fornecedor', :with => 'Mateus'
      expect(page).to have_field 'Email', :with => 'mcomogo@gmail.com'

      click_button 'Adicionar'

      fill_with_autocomplete 'Fornecedor', :with => 'Gabriel'
      expect(page).to have_field 'Email', :with => ''
      fill_in 'Email', with: 'mcomogo@gmail.com'

      click_button 'Adicionar'
    end

    click_button 'Salvar'

    expect(page).to_not have_notice 'Coleta de Preços 1/2012 criada com sucesso.'

    within_tab 'Fornecedores' do
      expect(page).to have_content 'E-mail já está em uso'
    end
  end

  scenario 'filter purchase solicitation without price_collection and licitation process' do
    licitation_process = LicitationProcess.make!(:pregao_presencial)
    price_collection = PriceCollection.make!(:coleta_de_precos)
    PurchaseSolicitation.make!(:reparo_liberado, accounting_year: 2013, licitation_processes: [licitation_process],
      service_status: PurchaseSolicitationServiceStatus::LIBERATED,
      responsible: Employee.make!(:sobrinho))
    PurchaseSolicitation.make!(:reparo_2013, service_status: PurchaseSolicitationServiceStatus::LIBERATED,
      responsible: Employee.make!(:wenderson))
    PurchaseSolicitation.make!(:reparo, accounting_year: 2013, price_collections: [price_collection], responsible: Employee.make!(:wenderson,
      individual: Person.make!(:joao_da_silva).personable, registration: "12345678"))

    navigate 'Processos de Compra > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Solicitações de compras' do
      within_autocomplete 'Solicitações de compra', with: 'Secretaria' do
        expect(page).to_not have_content '1/2013'
        expect(page).to have_content '2/2013'
        expect(page).to_not have_content '3/2013'
      end
    end
  end

  def make_proposals_dependencies!(price_collection)
    PriceCollectionProposalItem.make!(:wenderson_antivirus,
                                      :price_collection_proposal => price_collection.price_collection_proposals.first,
                                      :price_collection_lot_item => price_collection.items.first)
    PriceCollectionProposalItem.make!(:wenderson_arame,
                                      :price_collection_proposal => price_collection.price_collection_proposals.first,
                                      :price_collection_lot_item => price_collection.items.second)

    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
                                      :price_collection_proposal => price_collection.price_collection_proposals.second,
                                      :price_collection_lot_item => price_collection.items.first)
  end
end
