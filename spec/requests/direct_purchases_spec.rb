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

    click_link 'Contabilidade'

    click_link 'Compras Diretas'

    click_link 'Criar Compra Direta'

    fill_in 'Ano', :with => '2012'
    fill_in 'Data da compra', :with => '19/03/2012'
    fill_modal 'Referencia legal', :with => 'Referencia legal', :field => 'Descrição'
    select 'Material ou serviços', :from => 'Modalidade'
    fill_modal 'Fornecedor', :with => '456789', :field => 'Número'
    fill_modal 'Unidade orçamentária', :with => 'Secretaria de Educação', :field => 'Descrição'
    fill_modal 'Código do objeto', :with => 'Ponte', :field => 'Descrição'
    fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
    fill_in 'Coleta de preços', :with => '99'
    fill_in 'Reg. de preços', :with => '88'
    fill_in 'Observações gerais', :with => 'obs'

    click_button 'Criar Compra Direta'

    page.should have_notice 'Compra Direta criada com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Ano', :with => '2012'
    page.should have_field 'Data da compra', :with => '19/03/2012'
    page.should have_field 'Referencia legal', :with => 'Referencia legal'
    page.should have_select 'Modalidade', :selected => 'Material ou serviços'
    page.should have_field 'Fornecedor', :with => provider.id.to_s
    page.should have_field 'Unidade orçamentária', :with => '02.00 - Secretaria de Educação'
    page.should have_field 'Código do objeto', :with => 'Ponte'
    page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
    page.should have_field 'Coleta de preços', :with => '99'
    page.should have_field 'Reg. de preços', :with => '88'
    page.should have_field 'Observações gerais', :with => 'obs'
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

    click_link 'Contabilidade'

    click_link 'Compras Diretas'

    within_records do
      page.find('a').click
    end

    fill_in 'Ano', :with => '2013'
    fill_in 'Data da compra', :with => '19/03/2013'
    fill_modal 'Referencia legal', :with => 'Referencia legal dois', :field => 'Descrição'
    select 'Obras de engenharia', :from => 'Modalidade'
    fill_modal 'Fornecedor', :with => '123456', :field => 'Número'
    fill_modal 'Unidade orçamentária', :with => 'Secretaria de Desenvolvimento', :field => 'Descrição'
    fill_modal 'Código do objeto', :with => 'Viaduto', :field => 'Descrição'
    fill_modal 'Local de entrega', :with => 'Secretaria da Saúde', :field => 'Descrição'
    fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
    fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
    fill_in 'Coleta de preços', :with => '77'
    fill_in 'Reg. de preços', :with => '66'
    fill_in 'Observações gerais', :with => 'nova obs'

    click_button 'Atualizar Compra Direta'

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
    page.should have_field 'Código do objeto', :with => 'Viaduto'
    page.should have_field 'Local de entrega', :with => 'Secretaria da Saúde'
    page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
    page.should have_field 'Forma de pagamento', :with => 'Cheque'
    page.should have_field 'Coleta de preços', :with => '77'
    page.should have_field 'Reg. de preços', :with => '66'
    page.should have_field 'Observações gerais', :with => 'nova obs'
  end

  scenario 'destroy an existent direct_purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Contabilidade'

    click_link 'Compras Diretas'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Compra Direta apagada com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content '02/03/2012'
    page.should_not have_content 'Material ou serviços'
  end
end
