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

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_modal 'Material', :with => "Antivirus", :field => "Descrição"
      page.should have_field 'Unidade de referência', :with => "Unidade"
      fill_in 'Marca/Ref.', :with => "Norton"
      fill_in 'Quantidade', :with => "5"
      fill_in 'Valor unitário', :with => "100,00"
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

    within_tab 'Itens' do
      page.should have_field 'Material', :with => "01.01.00001 - Antivirus"
      page.should have_field 'Unidade de referência', :with => "Unidade"
      page.should have_field 'Marca/Ref.', :with => "Norton"
      page.should have_field 'Quantidade', :with => "5"
      page.should have_field 'Valor unitário', :with => "100,00"
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

    within_tab 'Itens' do
      fill_modal 'Material', :with => "Arame farpado", :field => "Descrição"
      fill_in 'Marca/Ref.', :with => "Aço inox"
      fill_in 'Quantidade', :with => "6"
      fill_in 'Valor unitário', :with => "200,00"
    end

    click_button 'Atualizar Solicitação de Compra Direta'

    page.should have_notice 'Compra Direta editada com sucesso.'

    within_records do
      page.find('a').click
    end

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

    within_tab 'Itens' do
      page.should have_field 'Material', :with => "02.02.00001 - Arame farpado"
      page.should have_field 'Marca/Ref.', :with => "Aço inox"
      page.should have_field 'Quantidade', :with => "6"
      page.should have_field 'Valor unitário', :with => "200,00"
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

  scenario 'removing an item from an existing direct purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    within_tab 'Itens' do
      page.should have_field 'Material', :with => '01.01.00001 - Antivirus'
      click_button 'Remover Item'
    end

    click_button 'Atualizar Solicitação de Compra Direta'

    page.should have_notice 'Compra Direta editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Itens' do
      page.should_not have_field 'Material', :with => '01.01.00001 - Antivirus'
    end
  end

  scenario 'trying to create a new direct purchase with duplicated items to ensure the error' do
    LegalReference.make!(:referencia)
    provider = Provider.make!(:wenderson_sa)
    Organogram.make!(:secretaria_de_educacao)
    LicitationObject.make!(:ponte)
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Period.make!(:um_ano)
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

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_modal 'Material', :with => "Antivirus", :field => "Descrição"
      page.should have_field 'Unidade de referência', :with => "Unidade"
      fill_in 'Marca/Ref.', :with => "Norton"
      fill_in 'Quantidade', :with => "5"
      fill_in 'Valor unitário', :with => "100,00"

      click_button "Adicionar Item"

      within '.direct-purchase-item:last' do
        fill_modal 'Material', :with => "Antivirus", :field => "Descrição"
        page.should have_field 'Unidade de referência', :with => "Unidade"
        fill_in 'Marca/Ref.', :with => "Norton"
        fill_in 'Quantidade', :with => "5"
        fill_in 'Valor unitário', :with => "100,00"
      end
    end

    click_button 'Criar Solicitação de Compra Direta'

    within_tab 'Itens' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'Calculate the total item price' do
    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_in 'Quantidade', :with => "5"
      fill_in 'Valor unitário', :with => "100,00"

      page.should have_field 'Preço total', :with => "500,00"
    end
  end

  scenario 'Calculate the unit price of item' do
    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_in 'Quantidade', :with => "5"
      fill_in 'Preço total', :with => "500,00"

      page.should have_field 'Valor unitário', :with => "100,00"
    end
  end

  scenario 'Calculate the total of two items' do
    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_in 'Quantidade', :with => "5"
      fill_in 'Valor unitário', :with => "10,00"

      click_button "Adicionar Item"

      within '.direct-purchase-item:last' do
        fill_in 'Quantidade', :with => "5"
        fill_in 'Preço total', :with => "500,00"
      end

      page.should have_field 'Total', :with => "550,00"
    end
  end

  scenario 'Calculate the total when removing one item' do
    click_link 'Solicitações'

    click_link 'Solicitações de Compra Direta'

    click_link 'Criar Solicitação de Compra Direta'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_in 'Quantidade', :with => "5"
      fill_in 'Valor unitário', :with => "10,00"

      click_button "Adicionar Item"

      within '.direct-purchase-item:last' do
        fill_in 'Quantidade', :with => "5"
        fill_in 'Preço total', :with => "500,00"
      end

      page.should have_field 'Total', :with => "550,00"

      within '.direct-purchase-item:last' do
        click_button 'Remover Item'
      end

      page.should have_field 'Total', :with => "50,00"
    end
  end
end
