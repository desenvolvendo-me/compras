# encoding: utf-8
require 'spec_helper'

feature "RegistrationCadastralCertificates" do
  background do
    sign_in
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    Creditor.make!(:nohup)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    click_link 'CRC'

    click_link '1/2012'

    click_link 'Imprimir certificado de registro cadastral'

    page.should have_content 'CERTIFICADO DE REGISTRO CADASTRAL'
    page.should have_content I18n.l(Date.yesterday)
    page.should have_content I18n.l(Date.current)

    within '#general-data' do
      page.should have_content 'Nohup'
      page.should have_content '1'
      page.should have_content 'Comércio varejista de mercadorias em geral'
      page.should have_content 'Rua Girassol, 9874 - São Francisco'
      page.should have_content 'Curitiba'
      page.should have_content 'Parana'
      page.should have_content 'Brasil'
      page.should have_content '33400-500'
      page.should have_content '(11) 7070-9999'
      page.should have_content '(11) 7070-8888'
      page.should have_content '00.000.000/9999-62'
      page.should have_content 'SP'
      page.should have_content 'Wenderson Malheiros'
      page.should have_content '003.149.513-34'
      page.should have_content 'Especificação do certificado do registro cadastral'
    end

    page.should have_content 'RAMO DE ATIVIDADE'

    within '#branch-activity' do
      page.should have_content '4712100'
      page.should have_content 'Comércio varejista de mercadorias em geral'
      page.should have_content '7739099'
      page.should have_content 'Aluguel de outras máquinas'
    end

    page.should have_content 'DOCUMENTAÇÃO'

    within '#documentation' do
      page.should have_content 'Fiscal'
      page.should have_content '123456'
      page.should have_content I18n.l(Date.current)
      page.should have_content I18n.l(Date.tomorrow)
    end

    page.should have_content 'Este certificado obedece o estipulado na lei 8.666 de 21.06.1993 e suas atualizações.'
    page.should have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
  end
end
