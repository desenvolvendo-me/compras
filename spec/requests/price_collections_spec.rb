# encoding: utf-8
require 'spec_helper'

feature "PriceCollections" do
  background do
    sign_in
  end

  scenario 'can not create a new price collection when no set the creditor email' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Material.make!(:antivirus)
    Creditor.make!(:sobrinho_sa_without_email)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

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
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # testing fill reference unit with javascript
      page.should have_disabled_field 'Unidade'
      page.should have_field 'Unidade', :with => 'UN'

      fill_in 'Marca', :with => 'Norton'
      fill_in 'Quantidade', :with => '10'
    end

    within_tab 'Fornecedores' do
      click_on 'Adicionar Fornecedor'

      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Gabriel Sobrinho SA', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Gabriel Sobrinho SA'
      end
    end

    click_button 'Salvar'

    page.should_not have_content 'Coleta de Preços criada com sucesso'

    within_tab 'Fornecedores' do
      page.should have_content 'não pode ficar em branco'
    end
  end

  scenario 'create a new price_collection' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Material.make!(:antivirus)
    Creditor.make!(:wenderson_sa)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    page.should_not have_button 'Apurar'
    page.should_not have_link 'Relatório'

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

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
      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # testing fill reference unit with javascript
      page.should have_disabled_field 'Unidade'
      page.should have_field 'Unidade', :with => 'UN'

      fill_in 'Marca', :with => 'Norton'
      fill_in 'Quantidade', :with => '10'
    end

    within_tab 'Fornecedores' do
      click_on 'Adicionar Fornecedor'

      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end

      page.should have_field 'Email', :with => 'wenderson.malheiros@gmail.com'
    end

    click_button 'Salvar'

    page.should have_notice 'Coleta de Preços criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_field 'Número', :with => '1'
      page.should have_select 'Status', :selected => 'Ativo'

      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data', :with => I18n.l(Date.current)
      page.should have_select 'Tipo de apuração', :selected => 'Menor preço total por item'
      page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
      page.should have_field 'Prazo de entrega', :with => '1'
      page.should have_field 'Vencimento', :with => I18n.l(Date.tomorrow)
      page.should have_select 'Período do prazo de entrega', :selected => 'ano/anos'
      page.should have_field 'Validade da proposta', :with => '1'
      page.should have_select 'Período da validade da proposta', :selected => 'ano/anos'
      page.should have_field 'Objeto', :with => 'objeto da coleta'
      page.should have_field 'Observações', :with => 'observacoes da coleta'
    end

    within_tab 'Lotes de itens' do
      page.should have_field 'Observações', :with => 'lote 1'
      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_disabled_field 'Unidade'
      page.should have_field 'Unidade', :with => 'UN'
      page.should have_field 'Marca', :with => 'Norton'
      page.should have_field 'Quantidade', :with => '10'
    end

    within_tab 'Fornecedores' do
      page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      page.should have_disabled_field 'Fornecedor'
      page.should have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
      page.should have_disabled_field 'E-mail'
    end

    click_link 'Propostas'

    click_link '1/2012 - Wenderson Malheiros'

    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent price_collection' do
    PriceCollection.make!(:coleta_de_precos)
    DeliveryLocation.make!(:health)
    Employee.make!(:wenderson)
    PaymentMethod.make!(:cheque)
    Material.make!(:arame_farpado)
    Creditor.make!(:sobrinho_sa, :person => Person.make!(:sobrinho_without_email, :name => 'José Gomes'))

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

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
        fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'
        fill_in 'Marca', :with => 'Aço inox'
        fill_in 'Quantidade', :with => '100'
      end
    end

    within_tab 'Fornecedores' do
      page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'

      click_button 'Remover'

      click_on 'Adicionar Fornecedor'

      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'José Gomes', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'José Gomes'
      end
      page.should_not have_disabled_field 'Email'
      fill_in 'Email', :with => 'contato@sobrinho.com'
    end

    click_button 'Salvar'

    page.should have_notice 'Coleta de Preços editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_field 'Número', :with => '1'
      page.should have_select 'Status', :selected => 'Ativo'

      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data', :with => I18n.l(Date.current + 10.days)
      page.should have_field 'Local de entrega', :with => 'Secretaria da Saúde'
      page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
      page.should have_field 'Forma de pagamento', :with => 'Cheque'
      page.should have_field 'Prazo de entrega', :with => '3'
      page.should have_field 'Vencimento', :with => I18n.l(Date.tomorrow + 10.days)
      page.should have_select 'Período do prazo de entrega', :selected => 'mês/meses'
      page.should have_field 'Validade da proposta', :with => '3'
      page.should have_select 'Período da validade da proposta', :selected => 'mês/meses'
      page.should have_field 'Objeto', :with => 'novo objeto da coleta'
      page.should have_field 'Observações', :with => 'novo observacoes da coleta'
    end

    within_tab 'Lotes de itens' do
      page.should have_field 'Observações', :with => 'lote 2'
      page.should have_field 'Material', :with => '02.02.00001 - Arame farpado'
      page.should have_disabled_field 'Unidade'
      page.should have_field 'Unidade', :with => 'UN'
      page.should have_field 'Marca', :with => 'Aço inox'
      page.should have_field 'Quantidade', :with => '100'
    end

    within_tab 'Fornecedores' do
      page.should_not have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      page.should have_field 'Fornecedor', :with => 'José Gomes'
      page.should have_field 'E-mail', :with => 'contato@sobrinho.com'
    end
  end

  scenario 'should not have destroy button' do
    PriceCollection.make!(:coleta_de_precos)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Apagar'
  end

  scenario 'trying to create without items to see the error message' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)

    navigate_through 'Compras e Licitações > Coletas de Preços'

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

    click_button 'Salvar'

    within_tab 'Lotes de itens' do
      page.should have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'trying to remove all the items to see the error message' do
    PriceCollection.make!(:coleta_de_precos)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      click_button 'Remover Item'
    end

    click_button 'Salvar'

    within_tab 'Lotes de itens' do
      page.should have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'removing an item and adding another one' do
    PriceCollection.make!(:coleta_de_precos)
    Material.make!(:arame_farpado)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Marca', :with => 'Norton'
      page.should have_field 'Quantidade', :with => '10'

      click_button 'Remover Item'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'
      fill_in 'Marca', :with => 'Aço inox'
      fill_in 'Quantidade', :with => '100'
    end

    click_button 'Salvar'

    page.should have_notice 'Coleta de Preços editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      page.should have_field 'Material', :with => '02.02.00001 - Arame farpado'
      page.should have_field 'Marca', :with => 'Aço inox'
      page.should have_field 'Quantidade', :with => '100'

      page.should_not have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should_not have_field 'Marca', :with => 'Norton'
      page.should_not have_field 'Quantidade', :with => '10'
    end
  end

  scenario 'trying to add duplicated items to see the error message' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Material.make!(:antivirus)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

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

      within '.price-collection-lot:last' do
        fill_in 'Observações', :with => 'lote 1'

        click_button 'Adicionar Item'

        fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
        fill_in 'Marca', :with => 'Norton'
        fill_in 'Quantidade', :with => '10'

        click_button 'Adicionar Item'

        within '.item:last' do
          fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'
          fill_in 'Marca', :with => 'Norton'
          fill_in 'Quantidade', :with => '20'
        end
      end
    end

    click_button 'Salvar'

    within_tab 'Lotes de itens' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'removing a lot' do
    PriceCollection.make!(:coleta_de_precos)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      page.should have_field 'Observações', :with => 'lote da coleta'

      click_button 'Remover Lote'
    end

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      page.should_not have_field 'Observações', :with => 'lote da coleta'
    end
  end

  scenario 'showing numberd labels on each lot' do
    PriceCollection.make!(:coleta_de_precos)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      page.should have_content 'Lote 1'
      page.should_not have_content 'Lote 2'

      click_button 'Adicionar Lote'

      page.should have_content 'Lote 1'
      page.should have_content 'Lote 2'

      click_button 'Adicionar Lote'

      page.should have_content 'Lote 1'
      page.should have_content 'Lote 2'
      page.should have_content 'Lote 3'

      # removing the first lot to se that it re-order all the others
      click_button 'Remover Lote'

      page.should have_content 'Lote 1'
      page.should have_content 'Lote 2'
      page.should_not have_content 'Lote 3'
    end
  end

  scenario 'calc by lowest_total_price_by_item' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)

    make_proposals_dependencies!(price_collection)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    click_button 'Apurar'

    page.should have_content 'Quadro Comparativo de Preços da Coleta de preço 1/2012'

    page.should have_content 'Apuração: Menor preço total por item'

    page.should have_content 'Gabriel Sobrinho'

    within '.classification-1-1' do
      page.should have_content 'Antivirus'
      page.should have_content '40,00'
      page.should have_content '400,00'
      page.should have_content 'Sim'
    end

    within '.classification-2-0' do
      page.should have_content 'Arame comum'
      page.should have_content '3,00'
      page.should have_content '600,00'
      page.should have_content 'Não'
    end

    page.should have_content 'Wenderson Malheiros'

    within '.classification-2-1' do
      page.should have_content 'Antivirus'
      page.should have_content '50,00'
      page.should have_content '500,00'
      page.should have_content 'Não'
    end

    within '.classification-1-0' do
      page.should have_content 'Arame comum'
      page.should have_content '2,00'
      page.should have_content '400,00'
      page.should have_content 'Sim'
    end

    click_link 'cancelar'

    click_link 'Relatório'

    page.should have_content 'Quadro Comparativo de Preços da Coleta de preço 1/2012'
  end

  scenario 'calc by lowest_price_by_lot' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_PRICE_BY_LOT)

    make_proposals_dependencies!(price_collection)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    click_button 'Apurar'

    page.should have_content 'Quadro Comparativo de Preços da Coleta de preço 1/2012'

    page.should have_content 'Apuração: Menor preço por lote'

    page.should have_content 'Wenderson Malheiros'

    within '.classification-2-0' do
      page.should have_content 'Antivirus'
      page.should have_content '50,00'
      page.should have_content '500,00'
      page.should have_content 'Não'
    end

    within '.classification-1-1' do
      page.should have_content 'Arame comum'
      page.should have_content '2,00'
      page.should have_content '400,00'
      page.should have_content 'Sim'
    end

    page.should have_content 'Gabriel Sobrinho'

    within '.classification-1-0' do
      page.should have_content 'Antivirus'
      page.should have_content '40,00'
      page.should have_content '400,00'
      page.should have_content 'Sim'
    end

    within 'tr.classification-2-1' do
      page.should have_content 'Arame comum'
      page.should have_content '3,00'
      page.should have_content '600,00'
      page.should have_content 'Não'
    end
  end

  scenario 'calc by lowest_global_price' do
    price_collection = PriceCollection.make!(:coleta_de_precos_com_2_lotes, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE)

    make_proposals_dependencies!(price_collection)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    click_button 'Apurar'

    page.should have_content 'Quadro Comparativo de Preços da Coleta de preço 1/2012'

    page.should have_content 'Apuração: Menor preço global'

    page.should have_content 'Wenderson Malheiros'

    within '.classification-1-0' do
      page.should have_content 'Antivirus'
      page.should have_content '50,00'
      page.should have_content '500,00'
      page.should have_content 'Sim'
    end

    within '.classification-1-1' do
      page.should have_content 'Arame comum'
      page.should have_content '2,00'
      page.should have_content '400,00'
      page.should have_content 'Sim'
    end

    page.should have_content 'Gabriel Sobrinho'

    within '.classification-2-0' do
      page.should have_content 'Antivirus'
      page.should have_content '40,00'
      page.should have_content '400,00'
      page.should have_content 'Não'
    end

    within '.classification-2-1' do
      page.should have_content 'Arame comum'
      page.should have_content '3,00'
      page.should have_content '600,00'
      page.should have_content 'Não'
    end
  end

  scenario 'showing numbered labels on each item' do
    PriceCollection.make!(:coleta_de_precos)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    within_records do
      page.find('a').click
    end

    within_tab 'Lotes de itens' do
      page.should have_content 'Item 1'
      page.should_not have_content 'Item 2'

      click_button 'Adicionar Item'

      page.should have_content 'Item 1'
      page.should have_content 'Item 2'

      click_button 'Adicionar Item'

      page.should have_content 'Item 1'
      page.should have_content 'Item 2'
      page.should have_content 'Item 3'

      # removing the first item to se that it re-order all the others
      click_button 'Remover Item'

      page.should have_content 'Item 1'
      page.should have_content 'Item 2'
      page.should_not have_content 'Item 3'

      # adding another lot to see that its items are numbered independently of the first lot
      click_button 'Adicionar Lote'

      within '.price-collection-lot:last' do
        click_button 'Adicionar Item'

        page.should have_content 'Item 1'
      end
    end
  end

  scenario 'disable email when the creditor has a related user' do
    Creditor.make!(:wenderson_sa_with_user)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Fornecedores' do
      click_button 'Adicionar Fornecedor'

      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end

      page.should have_disabled_field 'Email'
      page.should have_field 'Email', :with => 'wenderson.malheiros@gmail.com'
    end
  end

  scenario 'can not edit any data from a annulled price collection' do
    PriceCollectionAnnul.make!(:coleta_anulada)

    navigate_through 'Compras e Licitações > Coletas de Preços'

    click_link '1/2012'

    within_tab 'Principal' do
      page.should have_disabled_field 'Ano'
      page.should have_disabled_field 'Data'
      page.should have_disabled_field 'Status'
      page.should have_disabled_field 'Tipo de apuração'
      page.should have_disabled_field 'Local de entrega'
      page.should have_disabled_field 'Responsável'
      page.should have_disabled_field 'Forma de pagamento'
      page.should have_disabled_field 'Prazo de entrega'
      page.should have_disabled_field 'Vencimento'
      page.should have_disabled_field 'Período do prazo de entrega'
      page.should have_disabled_field 'Validade da proposta'
      page.should have_disabled_field 'Período da validade da proposta'
      page.should have_disabled_field 'Objeto'
      page.should have_disabled_field 'Observações'
    end

    within_tab 'Lotes de itens' do
      page.should have_disabled_field 'Observações'
      page.should have_disabled_field 'Material'
      page.should have_disabled_field 'Marca'
      page.should have_disabled_field 'Unidade'
      page.should have_disabled_field 'Quantidade'

      page.should_not have_button 'Remover Item'
      page.should_not have_button 'Adicionar Item'
      page.should_not have_button 'Remover Lote'
      page.should_not have_button 'Adicionar Lote'
    end

    within_tab 'Fornecedores' do
      page.should have_disabled_field 'Fornecedor'
      page.should have_disabled_field 'E-mail'

      page.should_not have_button 'Adicionar Fornecedor'
      page.should_not have_button 'Remover Fornecedor'
    end

    page.should_not have_button 'Salvar'
  end

  def make_proposals_dependencies!(price_collection)
    proposal_1 = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, :price_collection => price_collection)
    proposal_2 = PriceCollectionProposal.make!(:sobrinho_sa_proposta, :price_collection => price_collection)

    PriceCollectionProposalItem.make!(:wenderson_antivirus,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.first)
    PriceCollectionProposalItem.make!(:wenderson_arame,
                                      :price_collection_proposal => proposal_1,
                                      :price_collection_lot_item => price_collection.items.second)

    PriceCollectionProposalItem.make!(:sobrinho_antivirus,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.first)
    PriceCollectionProposalItem.make!(:sobrinho_arame,
                                      :price_collection_proposal => proposal_2,
                                      :price_collection_lot_item => price_collection.items.second)
  end
end
