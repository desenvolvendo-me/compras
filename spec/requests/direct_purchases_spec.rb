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
    PriceRegistration.make!(:registro_de_precos)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    expect(page).to have_content 'Compra Direta'

    within_tab 'Principal' do
      expect(page).to have_field 'Ano', :with => "#{Date.current.year}"

      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'

      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'

      fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_modal 'Registro de preços', :with => 'Aquisição de combustíveis', :field => 'Objeto'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '1', :field => 'Código'

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

    expect(page).to have_notice 'Compra Direta 1/2012 criada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Compra', :with => '1'
      expect(page).to have_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da compra', :with => '19/03/2012'
      expect(page).to have_field 'Referência legal', :with => 'Referencia legal'
      expect(page).to have_select 'Modalidade', :selected => 'Material ou serviços'
      expect(page).to have_select 'Tipo do empenho', :selected => 'Global'
      expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Solicitante', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Objeto da licitação', :with => 'Ponte'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Prazo de entrega', :with => '1'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'ano/anos'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Coleta de preços', :with => '99'
      expect(page).to have_field 'Registro de preços', :with => '1/2012'
      expect(page).to have_field 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      expect(page).to have_field 'Dotação orçamentária', :with => budget_allocation.to_s
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

  scenario 'should edit an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      page.find('a').click
    end

    expect(page).to have_subtitle '1/2012'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Compra'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'

      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'

      fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_modal 'Registro de preços', :with => 'Aquisição de combustíveis', :field => 'Objeto'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      fill_in 'Quantidade', :with => '2,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 editada com sucesso.'

    within_tab 'Principal' do
      expect(page).to have_field 'Compra', :with => '1'
      expect(page).to have_disabled_field 'Ano', :with => '2012'
      expect(page).to have_field 'Data da compra', :with => '19/03/2012'
      expect(page).to have_field 'Referência legal', :with => 'Referencia legal'
      expect(page).to have_select 'Modalidade', :selected => 'Material ou serviços'
      expect(page).to have_select 'Tipo do empenho', :selected => 'Global'
      expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Solicitante', :with => '1 - Secretaria de Educação'
      expect(page).to have_field 'Objeto da licitação', :with => 'Ponte'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Prazo de entrega', :with => '1'
      expect(page).to have_select 'Período do prazo de entrega', :selected => 'ano/anos'
      expect(page).to have_field 'Forma de pagamento', :with => 'Dinheiro'
      expect(page).to have_field 'Coleta de preços', :with => '99'
      expect(page).to have_field 'Registro de preços', :with => '1/2012'
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

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

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

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

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

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      page.find('a').click
    end

    expect(page).to_not have_button 'Apagar'
  end

  scenario 'should filter by year' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    fill_in 'Ano', :with => '2011'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "3/2011"
      expect(page).to_not have_content "1/2012"
    end
  end

  scenario 'should filter by date' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011_dez)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    fill_in 'Data da compra', :with => '20/12/2011'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "3/2011"
      expect(page).to_not have_content "1/2012"
    end
  end

  scenario 'should filter by modality' do
    year_2012 = DirectPurchase.make!(:compra_nao_autorizada)
    year_2011 = DirectPurchase.make!(:compra_2011)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    select 'Obras de engenharia', :from => 'Modalidade'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "3/2011"
      expect(page).to_not have_content "1/2012"
    end
  end

  scenario 'should filter by yearly sequence' do
    DirectPurchase.make!(:compra)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    fill_in 'Compra', :with => 1

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "1/2012"
    end
  end

  scenario 'should filter by budget structure' do
    DirectPurchase.make!(:compra)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    fill_modal 'Solicitante', :with => 'Secretaria de Educação',
                                         :field => 'Descrição'
    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "1/2012"
    end
  end

  scenario 'should filter by creditor' do
    DirectPurchase.make!(:compra)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    fill_modal 'Fornecedor', :with => 'Wenderson Malheiros',
                             :field => 'Nome'
    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "1/2012"
    end
  end

  scenario 'should filter by purchase date' do
    DirectPurchase.make!(:compra)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    fill_in 'Data da compra', :with => '02/03/2012'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "1/2012"
    end
  end

  scenario 'calculate total value of items' do
    navigate 'Processos de Compra > Compra Direta'

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
    navigate 'Processos de Compra > Compra Direta'

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

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    click_button 'Salvar'

    within_tab 'Dotações' do
      expect(page).to have_content 'é necessário cadastrar pelo menos uma dotação'

      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '1', :field => 'Código'
    end

    click_button 'Salvar'

    within_tab 'Dotações' do
      expect(page).to have_content 'é necessário cadastrar pelo menos um item'
    end
  end

  scenario 'when is not over limit should not show error' do
    DirectPurchase.make!(:compra_perto_do_limite)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      page.find('a').click
    end

    within_tab 'Dotações' do
      fill_in 'Quantidade', :with => '2,00'
      fill_in 'Valor unitário *', :with => '1.000,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 editada com sucesso.'

    within_tab 'Dotações' do
      expect(page).to_not have_content 'está acima do valor acumulado para este objeto (Ponte), está acima do limite permitido (10.000,00)'
    end
  end

  scenario 'when is over limit should show error' do
    DirectPurchase.make!(:compra_perto_do_limite)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

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

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      page.find('a').click
    end

    expect(page).to have_button 'Enviar autorização de fornecimento por e-mail'
  end

  scenario 'when a purchase solicitation is selected, fill in budget structure automatically' do
    PurchaseSolicitation.make!(:reparo_liberado)
    LegalReference.make!(:referencia)
    Creditor.make!(:wenderson_sa)
    BudgetStructure.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    ModalityLimit.make!(:modalidade_de_compra_ponte)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'
      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'

      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
    end

    expect(page).to have_disabled_field 'Solicitante', :with => '1 - Secretaria de Educação'

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 criada com sucesso.'

    expect(page).to have_disabled_field 'Solicitante', :with => '1 - Secretaria de Educação'
  end

  scenario 'fulfill the responsible and delivery_location only when they are not fulfilled' do
    PurchaseSolicitation.make!(:reparo_liberado)
    Employee.make!(:wenderson)
    DeliveryLocation.make!(:health)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      fill_modal 'Local de entrega', :field => 'Descrição', :with => 'Secretaria da Saúde'
      fill_modal 'Responsável', :field => 'Matrícula', :with => '12903412'
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Saúde'

      clear_modal 'Responsável'
      clear_modal 'Local de entrega'
      clear_modal 'Solicitação de compra'

      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Local de entrega', :with => 'Secretaria da Educação'
    end
  end

  scenario 'doesnt allow selection of purchase solicitations with "attended" status' do
    purchase_solicitation = PurchaseSolicitation.make!(
      :reparo,
      :service_status => PurchaseSolicitationServiceStatus::ATTENDED
    )

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      within_records do
        expect(page).to_not have_content 'Gabriel Sobrinho'
      end
    end
  end

  scenario 'doesnt allow selection of purchase solicitations with "pending" status' do
    purchase_solicitation = PurchaseSolicitation.make!(
      :reparo,
      :service_status => PurchaseSolicitationServiceStatus::PENDING
    )

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      within_records do
        expect(page).to_not have_content 'Gabriel Sobrinho'
      end
    end
  end

  scenario 'allows choosing a PurchaseSolicitation with a "liberated" status' do
    purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_modal 'Solicitação de compra' do
      click_button 'Pesquisar'

      within_records do
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end
  end

  scenario 'generate supply authorization when direct_purchase has purchase_solicitation' do
    purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

    DirectPurchase.make!(
      :compra_nao_autorizada,
      :purchase_solicitation => purchase_solicitation
    )
    Prefecture.make!(:belo_horizonte)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link purchase_solicitation.decorator.code_and_year
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_select 'Status', :selected => 'Pendente'
    end

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      page.find('a').click
    end

    click_button 'Gerar autorização de fornecimento'

    expect(page).to have_content 'AUTORIZAÇÃO DE FORNECIMENTO'
    expect(page).to have_content "1/2012"
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

    click_link 'voltar'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link purchase_solicitation.decorator.code_and_year
    end

    within_tab 'Principal' do
      expect(page).to have_select 'Status de atendimento', :selected => 'Atendida'
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_select 'Status', :selected => 'Atendido'
    end
  end

  scenario "changing the status of a purchase solicitation" do
    PurchaseSolicitation.make!(:reparo_liberado)

    PurchaseSolicitation.make!(:reparo_liberado,
      :accounting_year => 2013,
      :responsible => Employee.make!(:wenderson),
      :purchase_solicitation_budget_allocations => [
        PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office)])

    LegalReference.make!(:referencia)
    Creditor.make!(:wenderson_sa)
    BudgetStructure.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    ModalityLimit.make!(:modalidade_de_compra_ponte)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'
      fill_modal 'Solicitação de compra', :with => '2012', :field => 'Ano'
      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 criada com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    click_link '1/2012'

    expect(page).to have_select "Status de atendimento", :selected => 'Parcialmente atendido'

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    click_link '1/2012'

    within_tab 'Principal' do
      fill_modal 'Solicitação de compra', :with => '2013', :field => 'Ano'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 editada com sucesso.'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    click_link '1/2012'

    expect(page).to have_select "Status de atendimento", :selected => 'Liberada'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    click_link '1/2013'

    expect(page).to have_select "Status de atendimento", :selected => 'Parcialmente atendido'
  end

  scenario 'calculate total value of items when update' do
    DirectPurchase.make!(
      :compra,
      :direct_purchase_budget_allocations => [
        DirectPurchaseBudgetAllocation.make!(
          :alocacao_compra,
          :items => [
            DirectPurchaseBudgetAllocationItem.make!(:compra_direta_item),
            DirectPurchaseBudgetAllocationItem.make!(:office)
          ]
        )
      ]
    )

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações' do
      expect(page).to have_field 'Valor total dos itens', :with => '3.600,00'

      within 'div.direct-purchase-budget-allocation:first' do
        within '.item:first' do
          click_button 'Remover Item'
        end
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 editada com sucesso.'

    within_tab 'Dotações' do
      expect(page).to have_field 'Valor total dos itens', :with => '3.000,00'
    end
  end

  scenario 'clear budget allocations on clear purchase solicitation' do
    DirectPurchase.make!(
      :compra,
      :purchase_solicitation => PurchaseSolicitation.make!(:reparo_liberado)
    )

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    click_link '1/2012'

    within_tab 'Principal' do
      clear_modal 'Solicitação de compra'
      fill_modal 'Solicitante', :with => 'Secretaria de Educação', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 editada com sucesso.'

    within_tab 'Dotações' do
      expect(page).to have_field 'Valor total dos itens', :with => '0,00'
      expect(page).to have_button 'Adicionar Dotação'
      expect(page).to_not have_field 'Item'
    end
  end

  scenario 'clear old budget_allocations on change purchase_solicitation' do
    PurchaseSolicitation.make!(:reparo_office,
      :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
      :purchase_solicitation_liberations => [PurchaseSolicitationLiberation.make(:reparo)]
    )

    DirectPurchase.make!(
      :compra,
      :purchase_solicitation => PurchaseSolicitation.make!(:reparo_liberado)
    )

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    click_link '1/2012'

    within_tab 'Dotações' do
      expect(page).to have_field 'Valor total dos itens', :with => '600,00'

      within '.direct-purchase-budget-allocation:first' do
        expect(page).to have_field 'Dotação orçamentária', :with => '1 - Vencimentos e Salários'
        expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
        expect(page).to have_field 'Saldo da dotação', :with => '500,00'

        within '.item:first' do
          expect(page).to have_field 'Item', :with => '1'
          expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
          expect(page).to have_field 'Marca/Referência', :with => 'Norton'
          expect(page).to have_field 'Unidade', :with => 'UN'
          expect(page).to have_field 'Quantidade', :with => '3,00'
          expect(page).to have_field 'Valor unitário', :with => '200,00'
          expect(page).to have_field 'Valor total', :with => '600,00'
        end
      end
    end

    within_tab 'Principal' do
      fill_modal 'Solicitação de compra', :with => '1', :field => 'Código'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 editada com sucesso.'

    within_tab 'Dotações' do
      expect(page).to have_field 'Valor total dos itens', :with => '600,00'

      within '.direct-purchase-budget-allocation:first' do
        expect(page).to have_field 'Dotação orçamentária', :with => '1 - Vencimentos e Salários'
        expect(page).to have_field 'Compl. do elemento', :with => '3.0.10.01.12 - Vencimentos e Salários'
        expect(page).to have_field 'Saldo da dotação', :with => '200,00'

        within '.item:first' do
          expect(page).to have_field 'Item', :with => '1'
          expect(page).to have_field 'Material', :with => '01.01.00002 - Office'
          expect(page).to have_field 'Marca/Referência', :with => 'Office'
          expect(page).to have_field 'Unidade', :with => 'UN'
          expect(page).to have_field 'Quantidade', :with => '3,00'
          expect(page).to have_field 'Valor unitário', :with => '200,00'
          expect(page).to have_field 'Valor total', :with => '600,00'
        end
      end
    end
  end

  scenario 'index with columns at the index' do
    DirectPurchase.make!(:compra)
    DirectPurchase.make!(:compra_2011)

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content 'Código/Ano'
      expect(page).to have_content 'Solicitante'
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Status'

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '3/2011'
        expect(page).to have_content '1 - Secretaria de Educação'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Concluída'
      end

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '1 - Secretaria de Educação'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Concluída'
      end
    end
  end

  scenario 'Filter purchase solicitations without pending item at modal' do
    LegalReference.make!(:referencia)
    Creditor.make!(:wenderson_sa)
    BudgetStructure.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    ModalityLimit.make!(:modalidade_de_compra_ponte)

    budget_allocation = PurchaseSolicitationBudgetAllocation.make!(
      :alocacao_primaria,
      :items => [
        PurchaseSolicitationBudgetAllocationItem.make!(:item),
        PurchaseSolicitationBudgetAllocationItem.make!(:office,
          :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
      ])

    purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado,
      :purchase_solicitation_budget_allocations => [budget_allocation])

    item_group_material = PurchaseSolicitationItemGroupMaterial.make(
      :reparo_office,
      :purchase_solicitations => [purchase_solicitation])

    item_group = PurchaseSolicitationItemGroup.make!(:office,
      :purchase_solicitation_item_group_materials => [item_group_material])

    item_group.purchase_solicitation_items.each do |item|
      item.update_column :purchase_solicitation_item_group_id, item_group.id
    end

    PurchaseSolicitation.make!(:reparo_liberado,
      :accounting_year => 2013,
      :responsible => Employee.make!(:wenderson),
      :purchase_solicitation_budget_allocations => [
        PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office)])

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      within '.item:nth-child(1)' do
        expect(page).to have_select 'Status', :selected => 'Pendente'
      end

      within '.item:nth-child(2)' do
        expect(page).to have_select 'Status', :selected => 'Agrupado'
      end
    end

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referência legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      select 'Global', :from => 'Tipo do empenho'
      fill_modal 'Solicitação de compra', :with => '2012', :field => 'Ano'
      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Prazo de entrega', :with => '1'
      select 'ano/anos',  :from => 'Período do prazo de entrega'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 criada com sucesso.'

    click_link 'Voltar'

    click_link 'Gerar Compra Direta'

    within_tab 'Principal' do
      within_modal 'Solicitação de compra' do
        click_button 'Pesquisar'

        within_records do
          expect(page).to have_css('tbody tr', :count => 1)
          expect(page).to_not have_content '2012'
        end

        click_link 'Voltar'
      end
    end

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      within '.item:nth-child(1)' do
        expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
      end

      within '.item:nth-child(2)' do
        expect(page).to have_select 'Status', :selected => 'Agrupado'
      end
    end

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      click_link '1/2012'
    end

    within_tab 'Principal' do
      fill_modal 'Solicitação de compra', :with => '2013', :field => 'Ano'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Compra Direta 1/2012 editada com sucesso.'

    click_link 'Voltar'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    within_tab 'Dotações orçamentárias' do
      within '.item:nth-child(1)' do
        expect(page).to have_select 'Status', :selected => 'Pendente'
      end

      within '.item:nth-child(2)' do
        expect(page).to have_select 'Status', :selected => 'Agrupado'
      end
    end

    click_link 'Voltar'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2013'
    end

    within_tab 'Dotações orçamentárias' do
      within '.item:nth-child(1)' do
        expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
      end
    end

    within_tab 'Dotações orçamentárias' do
      within '.item:nth-child(1)' do
        expect(page).to have_select 'Status', :selected => 'Parcialmente atendido'
        expect(page).to have_field 'Atendido por', :with => 'Compra direta 1/2012'
      end
    end
  end

  scenario 'Filter and clear direct purchase filter' do
    DirectPurchase.make!(:compra)
    DirectPurchase.make!(:compra, :year => 2013, :code => 2, :date => Date.new(2013, 2, 3))

    navigate 'Processos de Compra > Compra Direta'

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "1/2012"
      expect(page).to have_content "2/2013"
    end

    click_link 'Filtrar Compras Diretas'

    fill_in 'Ano', :with => '2013'

    click_button 'Pesquisar'

    within_records do
      expect(page).to_not have_content "1/2012"
      expect(page).to have_content "2/2013"
    end

    click_link 'Filtrar Compras Diretas'

    clear_mask "Ano"

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_content "1/2012"
      expect(page).to have_content "2/2013"
    end
  end
end
