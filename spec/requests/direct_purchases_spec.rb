# encoding: utf-8
require 'spec_helper'

feature "DirectPurchases" do
  background do
    sign_in
  end

  scenario 'create a new direct_purchase' do
    LegalReference.make!(:referencia)
    provider = Provider.make!(:wenderson_sa)
    Organogram.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Period.make!(:um_ano)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referencia legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      fill_modal 'Fornecedor', :with => '456789', :field => 'Número'
      fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Prazo', :with => '1', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Reg. de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'

      # getting data from modal
      page.should have_field 'Classificação econômica de despesa', :with => '3.1.90.11.01.00.00.00'
      page.should have_field 'Saldo da dotação', :with => '500,00'

      select 'Global', :from => 'Tipo do empenho'

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

    click_button 'Criar Solicitação de Compra Direta'

    page.should have_notice 'Compra Direta criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data da compra', :with => '19/03/2012'
      page.should have_field 'Referencia legal', :with => 'Referencia legal'
      page.should have_select 'Modalidade', :selected => 'Material ou serviços'
      page.should have_field 'Fornecedor', :with => provider.id.to_s
      page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Objeto da licitação', :with => 'Ponte'
      page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Prazo', :with => '1 - Ano'
      page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
      page.should have_field 'Coleta de preços', :with => '99'
      page.should have_field 'Reg. de preços', :with => '88'
      page.should have_field 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2012"
      page.should have_field 'Classificação econômica de despesa', :with => '3.1.90.11.01.00.00.00'
      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_select 'Tipo do empenho', :selected => 'Global'

      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      page.should have_field 'Unidade', :with => 'Unidade'
      page.should have_field 'Marca/Referência', :with => 'Norton'
      page.should have_field 'Quantidade', :with => '3'
      page.should have_field 'Valor unitário', :with => '200,00'
      page.should have_field 'Valor total', :with => '600,00'
    end
  end

  scenario 'update an existent direct_purchase' do
    DirectPurchase.make!(:compra)
    LegalReference.make!(:referencia_dois)
    provider = Provider.make!(:sobrinho_sa)
    Organogram.make!(:secretaria_de_desenvolvimento)
    LicitationObject.make!(:viaduto)
    DeliveryLocation.make!(:health)
    Employee.make!(:wenderson)
    PaymentMethod.make!(:cheque)
    Period.make!(:tres_meses)
    budget_allocation = BudgetAllocation.make!(:alocacao_extra)
    Material.make!(:arame_farpado)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2013'
      fill_in 'Data da compra', :with => '19/03/2013'
      fill_modal 'Referencia legal', :with => 'Referencia legal dois', :field => 'Descrição'
      select 'Obras de engenharia', :from => 'Modalidade'
      fill_modal 'Fornecedor', :with => '123456', :field => 'Número'
      fill_modal 'Unidade orçamentária', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Viaduto', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Saúde', :field => 'Descrição'
      fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Prazo', :with => '3', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '77'
      fill_in 'Reg. de preços', :with => '66'
      fill_in 'Observações gerais', :with => 'nova obs'
    end

    within_tab 'Dotações' do
      fill_modal 'Dotação orçamentária', :with => '2011', :field => 'Exercício'

      # getting data from modal
      page.should have_field 'Classificação econômica de despesa', :with => '3.1.90.11.01.00.00.00'
      page.should have_field 'Saldo da dotação', :with => '200,00'

      select 'Ordinário', :from => 'Tipo do empenho'

      fill_modal 'Material', :with => 'Arame farpado', :field => 'Descrição'

      # getting data from modal
      page.should have_field 'Unidade', :with => 'Unidade'

      fill_in 'Marca/Referência', :with => 'Aço inox'
      fill_in 'Quantidade', :with => '20'
      fill_in 'Valor total', :with => '60,00'

      # asserting calculated unit price of the item
      page.should have_field 'Valor unitário', :with => '3,00'
    end

    click_button 'Atualizar Solicitação de Compra Direta'

    page.should have_notice 'Compra Direta editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_field 'Ano', :with => '2013'
      page.should have_field 'Data da compra', :with => '19/03/2013'
      page.should have_field 'Referencia legal', :with => 'Referencia legal dois'
      page.should have_select 'Modalidade', :selected => 'Obras de engenharia'
      page.should have_field 'Fornecedor', :with => provider.id.to_s
      page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Desenvolvimento'
      page.should have_field 'Objeto da licitação', :with => 'Viaduto'
      page.should have_field 'Local de entrega', :with => 'Secretaria da Saúde'
      page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
      page.should have_field 'Prazo', :with => '3 - Mês'
      page.should have_field 'Forma de pagamento', :with => 'Cheque'
      page.should have_field 'Coleta de preços', :with => '77'
      page.should have_field 'Reg. de preços', :with => '66'
      page.should have_field 'Observações gerais', :with => 'nova obs'
    end

    within_tab 'Dotações' do
      page.should have_field 'Dotação orçamentária', :with => "#{budget_allocation.id}/2011"
      page.should have_field 'Classificação econômica de despesa', :with => '3.1.90.11.01.00.00.00'
      page.should have_field 'Saldo da dotação', :with => '200,00'
      page.should have_select 'Tipo do empenho', :selected => 'Ordinário'

      page.should have_field 'Material', :with => '02.02.00001 - Arame farpado'
      page.should have_field 'Unidade', :with => 'Unidade'
      page.should have_field 'Marca/Referência', :with => 'Aço inox'
      page.should have_field 'Quantidade', :with => '20'
      page.should have_field 'Valor unitário', :with => '3,00'
      page.should have_field 'Valor total', :with => '60,00'
    end
  end

  scenario 'destroy an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Compra Direta apagada com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content '02/03/2012'
    page.should_not have_content 'Material ou serviços'
  end

  scenario 'asserting that duplicated budget allocations cannot be saved' do
    LegalReference.make!(:referencia)
    provider = Provider.make!(:wenderson_sa)
    Organogram.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Period.make!(:um_ano)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Material.make!(:antivirus)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Dados gerais' do
      fill_in 'Ano', :with => '2012'
      fill_in 'Data da compra', :with => '19/03/2012'
      fill_modal 'Referencia legal', :with => 'Referencia legal', :field => 'Descrição'
      select 'Material ou serviços', :from => 'Modalidade'
      fill_modal 'Fornecedor', :with => '456789', :field => 'Número'
      fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
      fill_modal 'Objeto da licitação', :with => 'Ponte', :field => 'Descrição'
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Prazo', :with => '1', :field => 'Quantidade'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_in 'Coleta de preços', :with => '99'
      fill_in 'Reg. de preços', :with => '88'
      fill_in 'Observações gerais', :with => 'obs'
    end

    within_tab 'Dotações' do
      click_button 'Adicionar Dotação'

      fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
      select 'Global', :from => 'Tipo do empenho'

      click_button 'Adicionar Dotação'

      within '.direct-purchase-budget-allocation:last' do
        fill_modal 'Dotação orçamentária', :with => '2012', :field => 'Exercício'
        select 'Ordinário', :from => 'Tipo do empenho'
      end
    end

    click_button 'Criar Solicitação de Compra Direta'

    within_tab 'Dotações' do
      page.should have_content 'já está em uso'
    end
  end
end
