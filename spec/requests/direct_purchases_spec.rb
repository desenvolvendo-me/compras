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

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    expect(page).to have_content 'Gerar Compra Direta'

    within_tab 'Principal' do
      expect(page).to have_field 'Ano', :with => "#{Date.current.year}"

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'

      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end

      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Registro de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

      # getting data from modal
      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      # getting data from modal
      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      # asserting calculated total price of the item
      expect(page).to have_disabled_field 'Valor total'
      expect(page).to have_field 'Valor total', :with => '700,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Compra', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da compra', :with => '19/03/2012'
      expect(page).to have_field 'Referência legal', :with => 'Referencia legal'
      expect(page).to have_select 'Modalidade', :selected => 'Material ou serviços'
      expect(page).to have_select 'Tipo do empenho', :selected => 'Global'
      expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Objeto da licitação', :with => 'Ponte'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Prazo', :with => '1'
      expect(page).to have_select 'Período do prazo', :selected => 'ano/anos'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Coleta de preços', :with => '99'
      expect(page).to have_field 'Registro de preços', :with => '88'
      expect(page).to have_field 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      expect(page).to have_field 'Dotação orçamentaria', :with => budget_allocation.to_s
      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Marca/Referência', :with => 'Norton'
      expect(page).to have_field 'Quantidade', :with => '3,50'
      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_field 'Valor total', :with => '700,00'

      expect(page).to have_field 'Item', :with => '1'
    end
  end

  scenario 'fill budget allocations from purchase solicitation item group' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)
    LegalReference.make!(:referencia)
    Creditor.make!(:wenderson_sa)
    BudgetStructure.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    ModalityLimit.make!(:modalidade_de_compra_ponte)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'

      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end

      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end

      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Registro de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      expect(page).to_not have_button 'Adicionar Dotação'

      expect(page).to have_field 'Valor total dos itens', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor total dos itens'

      expect(page).to have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentaria'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_readonly_field 'Compl. do elemento'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_readonly_field 'Saldo da dotação'

      expect(page).to_not have_button 'Adicionar Item'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_readonly_field 'Item'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Marca/Referência', :with => 'Arame'
      expect(page).to have_readonly_field 'Marca/Referência'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_readonly_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '99,00'
      expect(page).to have_readonly_field 'Quantidade'

      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_readonly_field 'Valor unitário'

      expect(page).to have_field 'Valor total', :with => '19.800,00'
      expect(page).to have_readonly_field 'Valor total'

      expect(page).to_not have_button 'Remover Dotação'
      expect(page).to_not have_button 'Remover Item'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Compra', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da compra', :with => '19/03/2012'
      expect(page).to have_field 'Referência legal', :with => 'Referencia legal'
      expect(page).to have_select 'Modalidade', :selected => 'Material ou serviços'
      expect(page).to have_select 'Tipo do empenho', :selected => 'Global'
      expect(page).to have_field 'Agrupamento de solicitações de compra', :with => 'Agrupamento de reparo 2013'
      expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Objeto da licitação', :with => 'Ponte'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Prazo', :with => '1'
      expect(page).to have_select 'Período do prazo', :selected => 'ano/anos'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Coleta de preços', :with => '99'
      expect(page).to have_field 'Registro de preços', :with => '88'
      expect(page).to have_field 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      expect(page).to_not have_button 'Adicionar Dotação'

      expect(page).to have_field 'Valor total dos itens', :with => '19.800,00'
      expect(page).to have_disabled_field 'Valor total dos itens'

      expect(page).to have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentaria'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_disabled_field 'Compl. do elemento'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to_not have_button 'Adicionar Item'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_disabled_field 'Item'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Marca/Referência', :with => 'Arame'
      expect(page).to have_readonly_field 'Marca/Referência'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_disabled_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '99,00'
      expect(page).to have_readonly_field 'Quantidade'

      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_readonly_field 'Valor unitário'

      expect(page).to have_field 'Valor total', :with => '19.800,00'
      expect(page).to have_disabled_field 'Valor total'

      expect(page).to_not have_button 'Remover Dotação'
      expect(page).to_not have_button 'Remover Item'
    end
  end

  scenario 'when clear purchase solicitation item group budget allocations should clear too' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end
    end

    within_tab 'Dotações' do
      expect(page).to_not have_button 'Adicionar Dotação'

      expect(page).to have_field 'Valor total dos itens', :with => '19.800,00'

      expect(page).to have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
    end

    within_tab 'Principal' do
      clear_modal 'Agrupamento de solicitações de compra'
    end

    within_tab 'Dotações' do
      expect(page).to have_button 'Adicionar Dotação'

      expect(page).to have_field 'Valor total dos itens', :with => '0,00'

      expect(page).to_not have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to_not have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to_not have_field 'Saldo da dotação', :with => '500,00'
    end
  end

  scenario 'when has budget allocations and select a purchase solicitation item group should clear old budget allocations' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_field 'Saldo da dotação', :with => '500,00'

      click_button 'Adicionar Item'

      fill_modal 'Material', :with => 'Antivirus', :field => 'Descrição'

      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Marca/Referência', :with => 'Norton'
      fill_in 'Quantidade', :with => '3,50'
      fill_in 'Valor unitário', :with => '200,00'

      expect(page).to have_field 'Valor total', :with => '700,00'
    end

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        click_record 'Agrupamento de reparo 2013'
      end
    end

    within_tab 'Dotações' do
      expect(page).to_not have_button 'Adicionar Dotação'

      expect(page).to have_field 'Valor total dos itens', :with => '19.800,00'

      expect(page).to_not have_field 'Marca/Referência', :with => 'Norton'
      expect(page).to_not have_field 'Quantidade', :with => '3,50'
      expect(page).to_not have_field 'Valor total', :with => '700,00'

      expect(page).to have_field 'Dotação orçamentaria', :with => '1 - Alocação'
      expect(page).to have_disabled_field 'Dotação orçamentaria'

      expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
      expect(page).to have_disabled_field 'Compl. do elemento'

      expect(page).to have_field 'Saldo da dotação', :with => '500,00'
      expect(page).to have_disabled_field 'Saldo da dotação'

      expect(page).to_not have_button 'Adicionar Item'

      expect(page).to have_field 'Item', :with => '1'
      expect(page).to have_disabled_field 'Item'

      expect(page).to have_field 'Material', :with => '02.02.00001 - Arame farpado'
      expect(page).to have_disabled_field 'Material'

      expect(page).to have_field 'Marca/Referência', :with => 'Arame'
      expect(page).to have_readonly_field 'Marca/Referência'

      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_readonly_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '99,00'
      expect(page).to have_readonly_field 'Quantidade'

      expect(page).to have_field 'Valor unitário', :with => '200,00'
      expect(page).to have_readonly_field 'Valor unitário'

      expect(page).to have_field 'Valor total', :with => '19.800,00'
      expect(page).to have_disabled_field 'Valor total'
    end
  end

  scenario 'should edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Compra'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'

      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end

      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Registro de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      fill_in 'Quantidade', :with => '2,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Gerar Compra Direta editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Compra', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da compra', :with => '19/03/2012'
      expect(page).to have_field 'Referência legal', :with => 'Referencia legal'
      expect(page).to have_select 'Modalidade', :selected => 'Material ou serviços'
      expect(page).to have_select 'Tipo do empenho', :selected => 'Global'
      expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Estrutura orçamentaria', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Objeto da licitação', :with => 'Ponte'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Prazo', :with => '1'
      expect(page).to have_select 'Período do prazo', :selected => 'ano/anos'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Coleta de preços', :with => '99'
      expect(page).to have_field 'Registro de preços', :with => '88'
      expect(page).to have_field 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      expect(page).to have_disabled_field 'Valor total dos itens'
      expect(page).to have_disabled_field 'Compl. do elemento'
      expect(page).to have_disabled_field 'Saldo da dotação'
      expect(page).to have_disabled_field 'Item'
      expect(page).to have_disabled_field 'Unidade'

      expect(page).to have_field 'Quantidade', :with => '2,00'
      expect(page).to have_field 'Valor total dos itens', :with => '400,00'
    end
  end

  scenario 'it should print when authorized' do
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)
    SupplyAuthorization.make!(:compra_2012)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    expect(page).to have_link 'Imprimir autorização de fornecimento'

    click_link 'Imprimir autorização de fornecimento'

    expect(page).to have_content 'AUTORIZAÇÃO DE FORNECIMENTO'
    expect(page).to have_content "#{direct_purchase.id}/2012"
    expect(page).to have_content '01/12/2012'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Girassol, 9874 - São Francisco'
    expect(page).to have_content 'Curitiba'
    expect(page).to have_content '33400-500'
    expect(page).to have_content '(33) 3333-3333'
    expect(page).to have_content '(33) 3333-3334'
    expect(page).to have_content '23456-0'
    expect(page).to have_content 'Agência Itaú'
    expect(page).to have_content 'Itaú'
    expect(page).to have_content 'Prezados Senhores, Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    expect(page).to have_content '1 - Secretaria de Educação'
    expect(page).to have_content 'Dinheiro'
    expect(page).to have_content '1 ano'
    expect(page).to have_content 'Secretaria da Educação'
    expect(page).to have_content 'Ponte'
    expect(page).to have_content 'Compra de 2012 ainda não autorizada'
    expect(page).to have_content 'Antivirus'
    expect(page).to have_content 'Norton'
  end

  scenario 'it should generate supply authorization' do
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)
    Prefecture.make!(:belo_horizonte)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    click_button 'Gerar autorização de fornecimento'

    expect(page).to have_content 'AUTORIZAÇÃO DE FORNECIMENTO'
    expect(page).to have_content "#{direct_purchase.id}/2012"
    expect(page).to have_content '01/12/2012'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Girassol, 9874 - São Francisco'
    expect(page).to have_content 'Curitiba'
    expect(page).to have_content '33400-500'
    expect(page).to have_content '(33) 3333-3333'
    expect(page).to have_content '(33) 3333-3334'
    expect(page).to have_content '23456-0'
    expect(page).to have_content 'Agência Itaú'
    expect(page).to have_content 'Itaú'
    expect(page).to have_content 'Prezados Senhores, Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    expect(page).to have_content '1 - Secretaria de Educação'
    expect(page).to have_content 'Dinheiro'
    expect(page).to have_content '1 ano'
    expect(page).to have_content 'Secretaria da Educação'
    expect(page).to have_content 'Ponte'
    expect(page).to have_content 'Compra de 2012 ainda não autorizada'
    expect(page).to have_content 'Antivirus'
    expect(page).to have_content 'Norton'
  end

  scenario 'should not have destroy button when edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    expect(page).not_to have_button 'Apagar'
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

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'

      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end

      fill_modal 'Estrutura orçamentaria', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo', :with => '1'
      select 'ano/anos', :from => 'Período do prazo'
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
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'should filter by year' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Filtrar Compras Diretas'

    fill_in 'Ano', :with => '2011'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "#{year_2011.direct_purchase}/#{year_2011.year}"
      expect(page).not_to have_content "#{year_2012.direct_purchase}/#{year_2012.year}"
    end
  end

  scenario 'should filter by date' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011_dez)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Filtrar Compras Diretas'

    fill_in 'Data da compra', :with => '20/12/2011'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "#{year_2011.direct_purchase}/#{year_2011.year}"
      expect(page).not_to have_content "#{year_2012.direct_purchase}/#{year_2012.year}"
    end
  end

  scenario 'should filter by modality' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Filtrar Compras Diretas'

    select 'Obras de engenharia', :from => 'Modalidade'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "#{year_2011.direct_purchase}/#{year_2011.year}"
      expect(page).not_to have_content "#{year_2012.direct_purchase}/#{year_2012.year}"
    end
  end

  scenario 'calculate total value of items' do
    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Dotações' do
      expect(page).to have_disabled_field 'Valor total dos itens'

      click_button 'Adicionar Dotação'

      within 'div.direct-purchase-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          fill_in 'Quantidade', :with => '3,00'
          fill_in 'Valor unitário', :with => '10,00'
          expect(page).to have_field 'Valor total', :with => '30,00'
          expect(page).to have_disabled_field 'Valor total'
        end

        click_button 'Adicionar Item'

        within '.item:first' do
          fill_in 'Quantidade', :with => '5,00'
          fill_in 'Valor unitário', :with => '2,00'
          expect(page).to have_field 'Valor total', :with => '10,00'
          expect(page).to have_disabled_field 'Valor total'
        end
      end

      click_button 'Adicionar Dotação'

      within 'div.direct-purchase-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          fill_in 'Quantidade', :with => '10,00'
          fill_in 'Valor unitário', :with => '5,00'
          expect(page).to have_field 'Valor total', :with => '50,00'
          expect(page).to have_disabled_field 'Valor total'
        end
      end

      expect(page).to have_field 'Valor total dos itens', :with => '90,00'

      # removing an item

      within 'div.direct-purchase-budget-allocation:last' do
        within '.item:first' do
          click_button 'Remover Item'
        end
      end

      expect(page).to have_field 'Valor total dos itens', :with => '80,00'

      # removing an entire budget allocation

      within 'div.direct-purchase-budget-allocation:last' do
        click_button 'Remover Dotação'
      end

      expect(page).to have_field 'Valor total dos itens', :with => '50,00'
    end
  end

  scenario 'set sequencial item order' do
    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      within 'div.direct-purchase-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          expect(page).to have_field 'Item', :with => '1'
        end

        click_button 'Adicionar Item'

        within '.item:last' do
          expect(page).to have_field 'Item', :with => '2'
        end
      end

      click_button 'Adicionar Dotação'

      within 'div.direct-purchase-budget-allocation:first' do
        click_button 'Adicionar Item'

        within '.item:first' do
          expect(page).to have_field 'Item', :with => '1'
        end
      end

      within 'div.direct-purchase-budget-allocation:last' do
        within '.item:first' do
          click_button 'Remover Item'
        end

        expect(page).to have_field 'Item', :with => '1'
      end
    end
  end

  scenario 'it must have at least one budget allocation with at least one item' do
    BudgetAllocation.make!(:alocacao)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    click_button 'Salvar'

    within_tab 'Dotações' do
      expect(page).to have_content 'é necessário cadastrar pelo menos uma dotação'

      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentaria', :with => '1', :field => 'Código'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'when is not over limit should not show error' do
    DirectPurchase.make!(:compra_perto_do_limite)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações' do
      fill_in 'Quantidade', :with => '2,00'
      fill_in 'Valor unitário *', :with => '1.000,00'
    end

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações' do
      expect(page).not_to have_content 'está acima do valor acumulado para este objeto (Ponte), está acima do limite permitido (10.000,00)'
    end
  end

  scenario 'when is over limit should show error' do
    DirectPurchase.make!(:compra_perto_do_limite)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações' do
      fill_in 'Quantidade', :with => '1,00'
      fill_in 'Valor unitário *', :with => '100.000,00'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      expect(page).to have_content 'está acima do valor acumulado para este objeto (Ponte), está acima do limite permitido (10.000,00)'
    end
  end

  scenario 'resend email authorization' do
    SupplyAuthorization.make!(:compra_2012)
    Prefecture.make!(:belo_horizonte)

    navigate 'Compras e Licitações > Gerar Compra Direta'

    within_records do
      page.find('a').click
    end

    click_button 'Reenviar autorização de fornecimento por e-mail'

    expect(page).to have_content 'Autorização de fornecimento enviado por e-mail com sucesso'
  end

  scenario 'should show only purchase_solicitation_item_group not annulled' do
    PurchaseSolicitationItemGroup.make!(:antivirus)

    ResourceAnnul.make!(:anulacao_generica,
                        :annullable => PurchaseSolicitationItemGroup.make!(:reparo_2013))

    navigate 'Compras e Licitações > Gerar Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      within_modal 'Agrupamento de solicitações de compra' do
        click_button 'Pesquisar'

        within_records do
          expect(page).to have_css 'td', :count => 1
        end
      end
    end
  end
end
