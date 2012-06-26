# encoding: utf-8
require 'spec_helper'

feature "SupplyAuthorizations" do
  background do
    sign_in
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    direct_purchase = DirectPurchase.make!(:compra_nao_autorizada)
    supply_authorization = SupplyAuthorization.make!(:compra_2012)
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    navigate_through 'Compras e Licitações > Compras Diretas > Solicitações de Compra Direta'

    within_records do
      page.find('a').click
    end

    click_link 'Imprimir autorização de fornecimento'

    page.should have_content 'Autorização de Fornecimento'
    page.should have_content "#{supply_authorization}"
    page.should have_content "#{direct_purchase.id}/2012"
    page.should have_content '01/12/2012'
    page.should have_content 'Wenderson Malheiros'
    page.should have_content 'Girassol, 9874 - São Francisco'
    page.should have_content 'Curitiba'
    page.should have_content '33400-500'
    page.should have_content '(33) 3333-3333'
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
    page.should have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
    page.should have_content 'Gabriel Sobrinho'
    page.should have_content 'Gerente'
  end
end
