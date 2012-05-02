# encoding: utf-8
require 'spec_helper'

feature "SupplyAuthorizations" do
  background do
    sign_in
  end

  scenario 'create a new supply_authorization' do
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    click_link 'Criar Autorização de Fornecimento'

    fill_in 'Exercício', :with => '2012'
    fill_modal 'Solicitação de compra direta', :with => '2012', :field => 'Ano'

    click_button 'Salvar'

    page.should have_notice 'Autorização de Fornecimento criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Código', :with => '1'
    page.should have_field 'Solicitação de compra direta', :with => "#{direct_purchase.id}"
  end

  scenario 'should use unauthorized as status to search direct_purchases' do
    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    click_link 'Criar Autorização de Fornecimento'

    within_modal 'Solicitação de compra direta' do
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Não autorizado'
    end
  end

  scenario 'should filter only by unauthorized' do
    SupplyAuthorization.make!(:compra_2012)
    DirectPurchase.make!(:compra_2011)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    click_link 'Criar Autorização de Fornecimento'

    within_modal 'Solicitação de compra direta' do
      click_button 'Pesquisar'

      page.should have_content '11/11/2011'
      page.should_not have_content '01/12/2012'
    end
  end

  scenario 'should show all fields as disabled' do
    SupplyAuthorization.make!(:compra_2012)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    within_records do
      page.find('a').click
    end

    page.should have_disabled_field 'Exercício'
    page.should have_disabled_field 'Código'
    page.should have_disabled_field 'Solicitação de compra direta'
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)
    supply_authorization = SupplyAuthorization.make!(:compra_2012)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    within_records do
      page.find('a').click
    end

    click_link 'Versão para impressão'

    page.should have_content 'Autorização de Fornecimento'
    page.should have_content "Número da autorização: #{supply_authorization}"
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
    page.should have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
  end

  scenario 'should not have destroy button when edit' do
    SupplyAuthorization.make!(:compra_2012)

    click_link 'Solicitações'

    click_link 'Autorizações de Fornecimento'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Apagar'
  end
end
