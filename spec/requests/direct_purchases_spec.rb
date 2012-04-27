# encoding: utf-8
require 'spec_helper'

feature "DirectPurchases" do
  background do
    sign_in
  end

  scenario 'create a new direct_purchase' do
    LegalReference.make!(:referencia)
    Provider.make!(:wenderson_sa)
    BudgetUnit.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Period.make!(:um_ano)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    ModalityLimit.make!(:modalidade_de_compra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'
      fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'
      fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Prazo', :with => '1', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Registro de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

      # getting data from modal
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12'
      page.should have_field 'Saldo da dotação', :with => '500,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'Unidade'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3'
      fill_in 'Valor unitário', :with => '200,00'

      # asserting calculated total price of the item
      page.should have_field 'Valor total', :with => '600,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Compra Direta criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da compra', :with => '19/03/2012'
      page.should have_field 'Referência legal', :with => 'Referencia legal'
      page.should have_select 'Modalidade', :selected => 'Material ou serviços'
      page.should have_select 'Tipo do empenho', :selected => 'Global'
      page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Objeto da licitação', :with => 'Ponte'
      page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Prazo', :with => '1 ano'
      page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
      page.should have_field 'Coleta de preços', :with => '99'
      page.should have_field 'Registro de preços', :with => '88'
      page.should have_field 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2012 - Alocação"
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12'
      page.should have_field 'Saldo da dotação', :with => '500,00'

      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Unidade', :with => 'Unidade'
      page.should have_field 'Marca/Referência', :with => 'Norton'
      page.should have_field 'Quantidade', :with => '3'
      page.should have_field 'Valor unitário', :with => '200,00'
      page.should have_field 'Valor total', :with => '600,00'

      page.should have_field 'Item', :with => '1'
    end
  end

  scenario 'should have all fields disabled when edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Atualizar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Ano'
      page.should have_disabled_field 'Data da compra'
      page.should have_disabled_field 'Referência legal'
      page.should have_disabled_field 'Modalidade'
      page.should have_disabled_field 'Tipo do empenho'
      page.should have_disabled_field 'Fornecedor'
      page.should have_disabled_field 'Unidade orçamentária'
      page.should have_disabled_field 'Objeto da licitação'
      page.should have_disabled_field 'Local de entrega'
      page.should have_disabled_field 'Responsável'
      page.should have_disabled_field 'Prazo'
      page.should have_disabled_field 'Forma de pagamento'
      page.should have_disabled_field 'Coleta de preços'
      page.should have_disabled_field 'Registro de preços'
      page.should have_disabled_field 'Observações gerais'
    end

    within_tab 'Dotações' do
      page.should have_disabled_field 'Dotação orçamentária'
      page.should have_disabled_field 'Compl. do elemento'
      page.should have_disabled_field 'Saldo da dotação'
      page.should have_disabled_field 'Material'
      page.should have_disabled_field 'Unidade'
      page.should have_disabled_field 'Marca/Referência'
      page.should have_disabled_field 'Quantidade'
      page.should have_disabled_field 'Valor unitário'
      page.should have_disabled_field 'Valor total'
      page.should_not have_button 'Adicionar Dotação'
      page.should_not have_button 'Remover Dotação'
      page.should_not have_button 'Adicionar Item'
      page.should_not have_button 'Remover Item'
    end
  end

  scenario 'it should print when authorized' do
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)
    SupplyAuthorization.make!(:compra_2012)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    page.should have_link 'Imprimir autorização de fornecimento'

    click_link 'Imprimir autorização de fornecimento'

    page.should have_content 'Autorização de Fornecimento'
    page.should have_content "Compra direta: #{direct_purchase.id}/2012"
    page.should have_content 'Data da compra: 01/12/2012'
    page.should have_content 'Fornecedor: Wenderson Malheiros'
    page.should have_content 'Endereço: Girassol, 9874 - São Francisco'
    page.should have_content 'Cidade: Curitiba'
    page.should have_content 'CEP: 33400-500'
    page.should have_content 'Telefone: (33) 3333-3333'
    page.should have_content 'Fax: (33) 3333-3334'
    page.should have_content 'Conta: 123456'
    page.should have_content 'Agência: Agência Itaú'
    page.should have_content 'Banco: Itaú'
    page.should have_content 'Prezados Senhores, Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    page.should have_content 'Unidade orçamentária: 02.00 - Secretaria de Educação'
    page.should have_content 'Condições de Pagamento: Dinheiro'
    page.should have_content 'Prazo de entrega: 1 ano'
    page.should have_content 'Local de entrega: Secretaria da Educação'
    page.should have_content 'Objeto da compra: Ponte'
    page.should have_content 'Observações: Compra de 2012 ainda não autorizada'
    page.should have_content 'Antivirus'
    page.should have_content 'Norton'
  end

  scenario 'it should generate supply authorization' do
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    click_button 'Gerar autorização de fornecimento'

    page.should have_content 'Autorização de Fornecimento'
    page.should have_content "Compra direta: #{direct_purchase.id}/2012"
    page.should have_content 'Data da compra: 01/12/2012'
    page.should have_content 'Fornecedor: Wenderson Malheiros'
    page.should have_content 'Endereço: Girassol, 9874 - São Francisco'
    page.should have_content 'Cidade: Curitiba'
    page.should have_content 'CEP: 33400-500'
    page.should have_content 'Telefone: (33) 3333-3333'
    page.should have_content 'Fax: (33) 3333-3334'
    page.should have_content 'Conta: 123456'
    page.should have_content 'Agência: Agência Itaú'
    page.should have_content 'Banco: Itaú'
    page.should have_content 'Prezados Senhores, Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    page.should have_content 'Unidade orçamentária: 02.00 - Secretaria de Educação'
    page.should have_content 'Condições de Pagamento: Dinheiro'
    page.should have_content 'Prazo de entrega: 1 ano'
    page.should have_content 'Local de entrega: Secretaria da Educação'
    page.should have_content 'Objeto da compra: Ponte'
    page.should have_content 'Observações: Compra de 2012 ainda não autorizada'
    page.should have_content 'Antivirus'
    page.should have_content 'Norton'
  end

  scenario 'should not have destroy button when edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Apagar'
  end

  scenario 'asserting that duplicated budget allocations cannot be saved' do
    LegalReference.make!(:referencia)
    Provider.make!(:wenderson_sa)
    BudgetUnit.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Period.make!(:um_ano)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    ModalityLimit.make!(:modalidade_de_compra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'
      fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'
      fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Prazo', :with => '1', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Registro de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

      click_button 'Adicionar Dotação'

      within '.direct-purchase-budget-allocation:first' do
        fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
      end
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'material must have same licitation object' do
    LicitationObject.make!(:ponte)
    Material.make!(:arame_farpado)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'
    end

    within_tab 'Dados gerais' do
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'deve pertencer ao objeto de licitação selecionado'
    end
  end

  scenario 'should filter by year' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    fill_in 'Ano', :with => '2011'

    click_button 'Pesquisar'

    within_records do
      page.should have_content year_2011.id
      page.should_not have_content year_2012.id
    end
  end

  scenario 'should filter by date' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    fill_in 'Data da compra', :with => '11/11/2011'

    click_button 'Pesquisar'

    within_records do
      page.should have_content year_2011.id
      page.should_not have_content year_2012.id
    end
  end

  scenario 'should filter by modality' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    select 'Obras de engenharia', :from => 'Modalidade'

    click_button 'Pesquisar'

    within_records do
      page.should have_content year_2011.id
      page.should_not have_content year_2012.id
    end
  end

  scenario 'should filter by status when authorized' do
    SupplyAuthorization.make!(:compra_2012)
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    select 'Autorizado', :from => 'Status'

    click_button 'Pesquisar'

    within_records do
      page.should_not have_content year_2011.id
      page.should have_content year_2012.id
    end
  end

  scenario 'should filter by status when not authorized' do
    SupplyAuthorization.make!(:compra_2012)
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    select 'Não autorizado', :from => 'Status'

    click_button 'Pesquisar'

    within_records do
      page.should have_content year_2011.id
      page.should_not have_content year_2012.id
    end
  end

  scenario 'calculate total value of items' do
    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dotações' do
      page.should have_disabled_field 'Total em itens'

      click_button 'Adicionar Dotação'

      within 'fieldset:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          fill_in 'Quantidade', :with => 3
          fill_in 'Valor unitário', :with => '10,00'
          page.should have_field 'Valor total', :with => '30,00'
        end

        click_button 'Adicionar Item'

        within '.item:last' do
          fill_in 'Quantidade', :with => 5
          fill_in 'Valor unitário', :with => '2,00'
          page.should have_field 'Valor total', :with => '10,00'
        end
      end

      click_button 'Adicionar Dotação'

      within 'fieldset:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          fill_in 'Quantidade', :with => 10
          fill_in 'Valor total', :with => '50,00'
          page.should have_field 'Valor unitário', :with => '5,00'
        end
      end

      page.should have_field 'Total em itens', :with => '90,00'

      # removing an item

      within 'fieldset:last' do
        within '.item:last' do
          click_button 'Remover Item'
        end
      end

      page.should have_field 'Total em itens', :with => '80,00'

      # removing an entire budget allocation

      within 'fieldset:first' do
        click_button 'Remover Dotação'
      end

      page.should have_field 'Total em itens', :with => '30,00'
    end
  end

  scenario 'set sequencial item order' do
    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      within 'fieldset:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          page.should have_field 'Item', :with => '1'
        end

        click_button 'Adicionar Item'

        within '.item:last' do
          page.should have_field 'Item', :with => '2'
        end
      end

      click_button 'Adicionar Dotação'

      within 'fieldset:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          page.should have_field 'Item', :with => '1'
        end
      end

      within 'fieldset:last' do
        within '.item:first' do
          click_button 'Remover Item'
        end

        page.should have_field 'Item', :with => '1'
      end
    end
  end

  scenario 'filtering materials on items by licitation object' do
    LicitationObject.make!(:ponte)
    LicitationObject.make!(:viaduto)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'
      click_button 'Adicionar Item'

      fill_modal 'Material', :with => '', :field => 'Descrição' do
        click_button 'Pesquisar'

        page.should have_content 'Antivirus'
        page.should_not have_content 'Arame comum'
      end
    end

    within_tab 'Dados gerais' do
      fill_modal 'Objeto da licitação', :with => 'Viaduto', :field => 'Descrição'
    end

    within_tab 'Dotações' do
      fill_modal 'Material', :with => '', :field => 'Descrição' do
        click_button 'Pesquisar'

        page.should have_content 'Arame comum'
        page.should_not have_content 'Antivirus'
      end
    end
  end

  scenario 'it must have at least one budget allocation with at least one item' do
    BudgetAllocation.make!(:alocacao)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'é necessário cadastrar pelo menos uma dotação'

      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'budget allocation item material must belong to selected provider' do
    Provider.make!(:wenderson_sa)
    Provider.make!(:sobrinho_sa)
    Provider.make!(:fornecedor_class_arames)
    Provider.make!(:fornecedor_arame)
    Material.make!(:arame_comum)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame comum', :field => 'Descrição'
    end

    # selecting provider that have only the group of selected material

    within_tab 'Dados gerais' do
      fill_modal 'Fornecedor', :with => '123456', :field => 'Número do CRC'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should_not have_content 'deve pertencer ao fornecedor selecionado'
    end

    # selecting provider that have only the class of selected material

    within_tab 'Dados gerais' do
      fill_modal 'Fornecedor', :with => '222222', :field => 'Número do CRC'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should_not have_content 'deve pertencer ao fornecedor selecionado'
    end

    # selecting provider that have only the selected material

    within_tab 'Dados gerais' do
      fill_modal 'Fornecedor', :with => '333333', :field => 'Número do CRC'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should_not have_content 'deve pertencer ao fornecedor selecionado'
    end

    # selecting provider that have nothing to do with the selected material

    within_tab 'Dados gerais' do
      fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'deve pertencer ao fornecedor selecionado'
    end
  end
end
