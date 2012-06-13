# encoding: utf-8
require 'spec_helper'

feature "PriceCollections" do
  background do
    sign_in
  end

  scenario 'can not create a new price collection when no set the provider email and login' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Material.make!(:antivirus)
    Provider.make!(:wenderson_sa)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

      fill_mask 'Ano', :with => '2012'
      fill_mask 'Data', :with => I18n.l(Date.current)
      select 'Menor preço total por item', :from => 'Tipo de apuração'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período'
      fill_in 'Validade da proposta', :with => '1'
      select 'ano/anos', :from => 'Unidade da validade da proposta'
      fill_mask 'Vencimento', :with => I18n.l(Date.tomorrow)
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

      fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'
    end

    click_button 'Salvar'

    page.should have_content 'Criar Coleta de Preços'
  end

  scenario 'create a new price_collection' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Material.make!(:antivirus)
    Provider.make!(:wenderson_sa)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

      fill_mask 'Ano', :with => '2012'
      fill_mask 'Data', :with => I18n.l(Date.current)
      select 'Menor preço total por item', :from => 'Tipo de apuração'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período'
      fill_in 'Validade da proposta', :with => '1'
      select 'ano/anos', :from => 'Unidade da validade da proposta'
      fill_mask 'Vencimento', :with => I18n.l(Date.tomorrow)
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

      fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'
      page.should have_field 'Email', :with => 'wenderson.malheiros@gmail.com'
      page.should have_disabled_field 'Email'
      fill_in 'Login', :with => 'wenderson.sa'
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
      page.should have_select 'Período', :selected => 'ano/anos'
      page.should have_field 'Validade da proposta', :with => '1'
      page.should have_select 'Unidade da validade da proposta', :selected => 'ano/anos'
      page.should have_field 'Vencimento', :with => I18n.l(Date.tomorrow)
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
      page.should have_field 'Email', :with => 'wenderson.malheiros@gmail.com'
      page.should have_disabled_field 'Email'
      page.should have_field 'Login', :with => 'wenderson.sa'
      page.should have_disabled_field 'Login'
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
    Provider.make!(:sobrinho_sa_without_email)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_mask 'Data', :with => I18n.l(Date.current + 10.days)
      fill_modal 'Local de entrega', :with => 'Secretaria da Saúde', :field => 'Descrição'
      fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '3'
      select 'mês/meses', :from => 'Período'
      fill_in 'Validade da proposta', :with => '3'
      select 'mês/meses', :from => 'Unidade da validade da proposta'
      fill_mask 'Vencimento', :with => I18n.l(Date.tomorrow + 10.days)
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

      fill_modal 'Fornecedor', :with => '123456', :field => 'Número do CRC'
      page.should_not have_disabled_field 'Email'
      page.should_not have_disabled_field 'Login'
      fill_in 'Email', :with => 'contato@sobrinho.com'
      fill_in 'Login', :with => 'sobrinho.sa'
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
      page.should have_select 'Período', :selected => 'mês/meses'
      page.should have_field 'Validade da proposta', :with => '3'
      page.should have_select 'Unidade da validade da proposta', :selected => 'mês/meses'
      page.should have_field 'Vencimento', :with => I18n.l(Date.tomorrow + 10.days)
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
      page.should have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
      page.should have_field 'Email', :with => 'contato@sobrinho.com'
      page.should have_field 'Login', :with => 'sobrinho.sa'
    end
  end

  scenario 'should not have destroy button' do
    PriceCollection.make!(:coleta_de_precos)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Apagar'
  end

  scenario 'trying to create without items to see the error message' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      fill_mask 'Ano', :with => '2012'
      fill_mask 'Data', :with => I18n.l(Date.current)
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período'
      fill_in 'Validade da proposta', :with => '1'
      select 'ano/anos', :from => 'Unidade da validade da proposta'
      fill_mask 'Vencimento', :with => I18n.l(Date.tomorrow)
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

    click_link 'Processos'

    click_link 'Coletas de Preços'

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

    click_link 'Processos'

    click_link 'Coletas de Preços'

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

    click_link 'Processos'

    click_link 'Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

      fill_mask 'Ano', :with => '2012'
      fill_mask 'Data', :with => I18n.l(Date.current)
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos', :from => 'Período'
      fill_in 'Validade da proposta', :with => '1'
      select 'ano/anos', :from => 'Unidade da validade da proposta'
      fill_mask 'Vencimento', :with => I18n.l(Date.tomorrow)
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

    click_link 'Processos'

    click_link 'Coletas de Preços'

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

  scenario 'calc by lowest_total_price_by_item' do
    PriceCollection.make!(:coleta_de_precos)
    PriceCollectionProposalItem.first.update_attributes!(:unit_price => 50)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    page.should have_content 'Apuração: Menor preço total por item'
    page.should have_content 'Antivirus'
    page.should have_content '10'
    page.should have_content '50,00 '
    page.should have_content '500,00 '
    page.should have_content 'Wenderson Malheiros'
  end

  scenario 'calc by lowest_total_price_by_item' do
    PriceCollection.make!(:coleta_de_precos, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_PRICE_BY_LOT)
    PriceCollectionProposalItem.first.update_attributes!(:unit_price => 50)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    page.should have_content 'Apuração: Menor preço por lote'
    page.should have_content 'Lote 1'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content '500,00 '
  end

  scenario 'calc by lowest_global_price' do
    PriceCollection.make!(:coleta_de_precos, :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE)
    PriceCollectionProposalItem.first.update_attributes!(:unit_price => 50)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    within_records do
      page.find('a').click
    end

    click_link 'Apurar'

    page.should have_content 'Apuração: Menor preço global'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content '500,00 '
  end

  scenario 'showing numberd labels on each lot' do
    PriceCollection.make!(:coleta_de_precos)

    click_link 'Processos'

    click_link 'Coletas de Preços'

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

  scenario 'showing numbered labels on each item' do
    PriceCollection.make!(:coleta_de_precos)

    click_link 'Processos'

    click_link 'Coletas de Preços'

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

  scenario 'disable login and email when the provider has a related user' do
    Provider.make!(:wenderson_sa_with_user)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Fornecedores' do
      click_button 'Adicionar Fornecedor'

      fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'

      page.should have_disabled_field 'Email'
      page.should have_field 'Email', :with => 'wenderson.malheiros@gmail.com'
      page.should have_disabled_field 'Login'
      page.should have_field 'Login', :with => 'wenderson.malheiros'
    end
  end

  scenario 'can not edit any data from a annulled price collection' do
    PriceCollectionAnnul.make!(:coleta_anulada)

    click_link 'Processos'

    click_link 'Coletas de Preços'

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
      page.should have_disabled_field 'Período'
      page.should have_disabled_field 'Validade da proposta'
      page.should have_disabled_field 'Unidade da validade da proposta'
      page.should have_disabled_field 'Vencimento'
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
      page.should have_disabled_field 'Email'
      page.should have_disabled_field 'Login'

      page.should_not have_button 'Adicionar Fornecedor'
      page.should_not have_button 'Remover Fornecedor'
    end

    page.should_not have_button 'Salvar'
  end
end
