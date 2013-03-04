# encoding: utf-8
require 'spec_helper'

feature "SupplyAuthorizations" do
  background do
    sign_in
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    supply_authorization = SupplyAuthorization.make!(:compra_2012)
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    navigate 'Processos de Compra > Compra Direta'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Imprimir autorização de fornecimento'

    expect(page).to have_content 'AUTORIZAÇÃO DE FORNECIMENTO'
    expect(page).to have_content 'Número'
    expect(page).to have_content 'Compra Direta Número'
    expect(page).to have_content 'Data da compra'
    expect(page).to have_content 'Status'
    expect(page).to have_content "#{supply_authorization}"
    expect(page).to have_content "1/2012"
    expect(page).to have_content '01/12/2012'
    expect(page).to have_content 'Ativo'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Girassol, 9874 - São Francisco'
    expect(page).to have_content 'Curitiba'
    expect(page).to have_content '33400-500'
    expect(page).to have_content '(33) 3333-3333'
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
    expect(page).to have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
    expect(page).to have_content 'Gabriel Sobrinho'
    expect(page).to have_content 'Gerente'
  end

  scenario 'should be printable with a company' do
    Prefecture.make!(:belo_horizonte)
    supply_authorization = SupplyAuthorization.make!(:nohup)
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    navigate 'Processos de Compra > Compra Direta'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Imprimir autorização de fornecimento'

    expect(page).to have_content 'AUTORIZAÇÃO DE FORNECIMENTO'
    expect(page).to have_content "#{supply_authorization}"
    expect(page).to have_content "1/2011"
    expect(page).to have_content '20/12/2011'
    expect(page).to have_content 'Nohup'
    expect(page).to have_content 'Girassol, 9874 - São Francisco'
    expect(page).to have_content 'Curitiba'
    expect(page).to have_content '33400-500'
    expect(page).to have_content '(11) 7070-9999'
    expect(page).to have_content '45678-0'
    expect(page).to have_content 'Agência Itaú'
    expect(page).to have_content 'Itaú'
    expect(page).to have_content 'Prezados Senhores, Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    expect(page).to have_content '1 - Secretaria de Educação'
    expect(page).to have_content 'Dinheiro'
    expect(page).to have_content '1 ano'
    expect(page).to have_content 'Secretaria da Educação'
    expect(page).to have_content 'Ponte'
    expect(page).to have_content 'Compra feita em 2011 e não autorizada'
    expect(page).to have_content 'Antivirus'
    expect(page).to have_content 'Norton'
    expect(page).to have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
    expect(page).to have_content 'Gabriel Sobrinho'
    expect(page).to have_content 'Gerente'
  end

  scenario 'should be printable when annulled' do
    Prefecture.make!(:belo_horizonte)

    annul = ResourceAnnul.make!(
      :anulacao_generica,
      :annullable => DirectPurchase.make!(:compra_nao_autorizada)
    )

    supply_authorization = SupplyAuthorization.make!(
      :compra_2012,
      :direct_purchase => annul.annullable
    )

    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    navigate 'Processos de Compra > Compra Direta'

    click_link "Limpar Filtro"

    within_records do
      page.find('a').click
    end

    click_link 'Imprimir autorização de fornecimento'

    expect(page).to have_content 'AUTORIZAÇÃO DE FORNECIMENTO'
    expect(page).to have_content 'Número'
    expect(page).to have_content 'Compra Direta Número'
    expect(page).to have_content 'Data da compra'
    expect(page).to have_content 'Status'
    expect(page).to have_content "#{supply_authorization}"
    expect(page).to have_content "1/2012"
    expect(page).to have_content '01/12/2012'
    expect(page).to have_content 'Inativo'
    expect(page).to have_content 'Wenderson Malheiros'
    expect(page).to have_content 'Girassol, 9874 - São Francisco'
    expect(page).to have_content 'Curitiba'
    expect(page).to have_content '33400-500'
    expect(page).to have_content '(33) 3333-3333'
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
    expect(page).to have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
    expect(page).to have_content 'Gabriel Sobrinho'
    expect(page).to have_content 'Gerente'
  end
end
