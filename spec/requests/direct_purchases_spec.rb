# encoding: utf-8
require 'spec_helper'

feature "DirectPurchases" do
  background do
    sign_in
  end

  scenario 'create a new direct_purchase' do
    LegalReference.make!(:referencia)
    Creditor.make!(:wenderson_sa)
    BudgetStructure.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    ModalityLimit.make!(:modalidade_de_compra)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Gerar Compra Direta'

    page.should have_content 'Gerar Compra Direta'

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => "#{Date.current.year}"

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'
      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end
      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo', :with => '1'
      select 'ano/anos',  :from => 'Período'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Registro de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

      # getting data from modal
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      page.should have_field 'Saldo da dotação', :with => '500,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      # asserting calculated total price of the item
      page.should have_disabled_field 'Valor total'
      page.should have_field 'Valor total', :with => '700,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Compra Direta criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Compra', :with => '1'
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da compra', :with => '19/03/2012'
      page.should have_field 'Referência legal', :with => 'Referencia legal'
      page.should have_select 'Modalidade', :selected => 'Material ou serviços'
      page.should have_select 'Tipo do empenho', :selected => 'Global'
      page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      page.should have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      page.should have_field 'Objeto da licitação', :with => 'Ponte'
      page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Prazo', :with => '1'
      page.should have_select 'Período', :selected => 'ano/anos'
      page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
      page.should have_field 'Coleta de preços', :with => '99'
      page.should have_field 'Registro de preços', :with => '88'
      page.should have_field 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
      page.should have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      page.should have_field 'Saldo da dotação', :with => '500,00'

      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Unidade', :with => 'UN'
      page.should have_field 'Marca/Referência', :with => 'Norton'
      page.should have_field 'Quantidade', :with => '3,50'
      page.should have_field 'Valor unitário', :with => '200,00'
      page.should have_field 'Valor total', :with => '700,00'

      page.should have_field 'Item', :with => '1'
    end
  end

  scenario 'should have all fields disabled when edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Atualizar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      page.should have_disabled_field 'Compra'
      page.should have_disabled_field 'Ano'
      page.should have_disabled_field 'Data da compra'
      page.should have_disabled_field 'Referência legal'
      page.should have_disabled_field 'Modalidade'
      page.should have_disabled_field 'Tipo do empenho'
      page.should have_disabled_field 'Fornecedor'
      page.should have_disabled_field 'Estrutura orçamentaria'
      page.should have_disabled_field 'Objeto da licitação'
      page.should have_disabled_field 'Local de entrega'
      page.should have_disabled_field 'Responsável'
      page.should have_disabled_field 'Prazo'
      page.should have_disabled_field 'Período'
      page.should have_disabled_field 'Forma de pagamento'
      page.should have_disabled_field 'Coleta de preços'
      page.should have_disabled_field 'Registro de preços'
      page.should have_disabled_field 'Observações gerais'
    end

    within_tab 'Dotações' do
      page.should have_disabled_field 'Dotação orçamentaria'
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

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    page.should have_link 'Imprimir autorização de fornecimento'

    click_link 'Imprimir autorização de fornecimento'

    page.should have_content 'Autorização de Fornecimento'
    page.should have_content "#{direct_purchase.id}/2012"
    page.should have_content '01/12/2012'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content 'Girassol, 9874 - São Francisco'
    page.should have_content 'Curitiba'
    page.should have_content '33400-500'
    page.should have_content '(33) 3333-3333'
    page.should have_content '(33) 3333-3334'
    page.should have_content '23456-0'
    page.should have_content 'Agência Itaú'
    page.should have_content 'Itaú'
    page.should have_content 'Prezados Senhores, Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    page.should have_content '1 - Secretaria de Educação'
    page.should have_content 'Dinheiro'
    page.should have_content '1 ano'
    page.should have_content 'Secretaria da Educação'
    page.should have_content 'Ponte'
    page.should have_content 'Compra de 2012 ainda não autorizada'
    page.should have_content 'Antivirus'
    page.should have_content 'Norton'
  end

  scenario 'it should generate supply authorization' do
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    click_button 'Gerar autorização de fornecimento'

    page.should have_content 'Autorização de Fornecimento'
    page.should have_content "#{direct_purchase.id}/2012"
    page.should have_content '01/12/2012'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content 'Girassol, 9874 - São Francisco'
    page.should have_content 'Curitiba'
    page.should have_content '33400-500'
    page.should have_content '(33) 3333-3333'
    page.should have_content '(33) 3333-3334'
    page.should have_content '23456-0'
    page.should have_content 'Agência Itaú'
    page.should have_content 'Itaú'
    page.should have_content 'Prezados Senhores, Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    page.should have_content '1 - Secretaria de Educação'
    page.should have_content 'Dinheiro'
    page.should have_content '1 ano'
    page.should have_content 'Secretaria da Educação'
    page.should have_content 'Ponte'
    page.should have_content 'Compra de 2012 ainda não autorizada'
    page.should have_content 'Antivirus'
    page.should have_content 'Norton'
  end

  scenario 'should not have destroy button when edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Apagar'
  end

  scenario 'asserting that duplicated budget allocations cannot be saved' do
    LegalReference.make!(:referencia)
    Creditor.make!(:wenderson_sa)
    BudgetStructure.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)
    ModalityLimit.make!(:modalidade_de_compra)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'
      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end
      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo', :with => '1'
      select 'ano/anos', :from => 'Período'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Registro de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

      click_button 'Adicionar Dotação'

      within '.direct-purchase-budget-allocation:first' do
        fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'
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

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Gerar Compra Direta'

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

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    fill_in 'Ano', :with => '2011'

    click_button 'Pesquisar'

    within_records do
      page.should have_content "#{year_2011.direct_purchase}/#{year_2011.year}"
      page.should_not have_content "#{year_2012.direct_purchase}/#{year_2012.year}"
    end
  end

  scenario 'should filter by date' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011_dez)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    fill_in 'Data da compra', :with => '20/12/2011'

    click_button 'Pesquisar'

    within_records do
      page.should have_content "#{year_2011.direct_purchase}/#{year_2011.year}"
      page.should_not have_content "#{year_2012.direct_purchase}/#{year_2012.year}"
    end
  end

  scenario 'should filter by modality' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    select 'Obras de engenharia', :from => 'Modalidade'

    click_button 'Pesquisar'

    within_records do
      page.should have_content "#{year_2011.direct_purchase}/#{year_2011.year}"
      page.should_not have_content "#{year_2012.direct_purchase}/#{year_2012.year}"
    end
  end

  scenario 'should filter by status when authorized' do
    SupplyAuthorization.make!(:compra_2012)
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    select 'Autorizado', :from => 'Status'

    click_button 'Pesquisar'

    within_records do
      page.should_not have_content "#{year_2011.direct_purchase}/#{year_2011.year}"
      page.should have_content "#{year_2012.direct_purchase}/#{year_2012.year}"
    end
  end

  scenario 'should filter by status when not authorized' do
    SupplyAuthorization.make!(:compra_2012)
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Filtrar Solitações de Compra Direta'

    select 'Não autorizado', :from => 'Status'

    click_button 'Pesquisar'

    within_records do
      page.should have_content "#{year_2011.direct_purchase}/#{year_2011.year}"
      page.should_not have_content "#{year_2012.direct_purchase}/#{year_2012.year}"
    end
  end

  scenario 'calculate total value of items' do
    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Dotações' do
      page.should have_disabled_field 'Valor total dos itens'

      click_button 'Adicionar Dotação'

      within 'div.direct-purchase-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          fill_in 'Quantidade', :with => '3,00'
          fill_in 'Valor unitário', :with => '10,00'
          page.should have_field 'Valor total', :with => '30,00'
          page.should have_disabled_field 'Valor total'
        end

        click_button 'Adicionar Item'

        within '.item:first' do
          fill_in 'Quantidade', :with => '5,00'
          fill_in 'Valor unitário', :with => '2,00'
          page.should have_field 'Valor total', :with => '10,00'
          page.should have_disabled_field 'Valor total'
        end
      end

      click_button 'Adicionar Dotação'

      within 'div.direct-purchase-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          fill_in 'Quantidade', :with => '10,00'
          fill_in 'Valor unitário', :with => '5,00'
          page.should have_field 'Valor total', :with => '50,00'
          page.should have_disabled_field 'Valor total'
        end
      end

      page.should have_field 'Valor total dos itens', :with => '90,00'

      # removing an item

      within 'div.direct-purchase-budget-allocation:last' do
        within '.item:first' do
          click_button 'Remover Item'
        end
      end

      page.should have_field 'Valor total dos itens', :with => '80,00'

      # removing an entire budget allocation

      within 'div:last' do
        click_button 'Remover Dotação'
      end

      page.should have_field 'Valor total dos itens', :with => '30,00'
    end
  end

  scenario 'set sequencial item order' do
    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      within 'div.direct-purchase-budget-allocation:first' do
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

      within 'div.direct-purchase-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          page.should have_field 'Item', :with => '1'
        end
      end

      within 'div.direct-purchase-budget-allocation:last' do
        within '.item:first' do
          click_button 'Remover Item'
        end

        page.should have_field 'Item', :with => '1'
      end
    end
  end

  scenario 'it must have at least one budget allocation with at least one item' do
    BudgetAllocation.make!(:alocacao)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Gerar Compra Direta'

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'é necessário cadastrar pelo menos uma dotação'

      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'budget allocation item material must belong to selected creditor' do
    Creditor.make!(:nohup)
    Creditor.make!(:sobrinho)
    Material.make!(:arame_comum)

    navigate_through 'Compras e Licitações > Solicitações de Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Arame comum', :field => 'Descrição'
    end

    # selecting creditor that have only the selected material

    within_tab 'Dados gerais' do
      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Nohup', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Nohup'
      end
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should_not have_content 'deve pertencer ao fornecedor selecionado'
    end

    # selecting creditor that have nothing to do with the selected material

    within_tab 'Dados gerais' do
      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Gabriel Sobrinho', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Gabriel Sobrinho'
      end
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      page.should have_content 'deve pertencer ao fornecedor selecionado'
    end
  end
end
