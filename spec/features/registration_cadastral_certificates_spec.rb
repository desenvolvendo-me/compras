# encoding: utf-8
require 'spec_helper'

feature "RegistrationCadastralCertificates" do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['creditors']
    sign_in
  end

  scenario 'should be printable' do
    Prefecture.make!(:belo_horizonte)
    Creditor.make!(:nohup)
    SignatureConfiguration.make!(:crc)

    navigate 'Comum > Pessoas > Credores'

    click_link 'Nohup'

    click_link 'CRC'

    click_link '1/2012'

    click_link 'Imprimir certificado de registro cadastral'

    expect(page).to have_content 'CERTIFICADO DE REGISTRO CADASTRAL'
    expect(page).to have_content I18n.l(Date.yesterday)
    expect(page).to have_content I18n.l(Date.current)

    within '#general-data' do
      expect(page).to have_content 'Nohup'
      expect(page).to have_content '1'
      expect(page).to have_content 'Comércio varejista de mercadorias em geral'
      expect(page).to have_content 'Rua Girassol, 9874 - São Francisco'
      expect(page).to have_content 'Curitiba'
      expect(page).to have_content 'Paraná'
      expect(page).to have_content 'Brasil'
      expect(page).to have_content '33400-500'
      expect(page).to have_content '(11) 7070-9999'
      expect(page).to have_content '(11) 7070-8888'
      expect(page).to have_content '00.000.000/9999-62'
      expect(page).to have_content 'SP'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content '003.149.513-34'
      expect(page).to have_content 'Especificação do certificado do registro cadastral'
    end

    expect(page).to have_content 'RAMO DE ATIVIDADE'

    within '#branch-activity' do
      expect(page).to have_content '4712100'
      expect(page).to have_content 'Comércio varejista de mercadorias em geral'
      expect(page).to have_content '7739099'
      expect(page).to have_content 'Aluguel de outras máquinas'
    end

    expect(page).to have_content 'DOCUMENTAÇÃO'

    within '#documentation' do
      expect(page).to have_content 'Fiscal'
      expect(page).to have_content '123456'
      expect(page).to have_content I18n.l(Date.current)
      expect(page).to have_content I18n.l(Date.tomorrow)
    end

    expect(page).to have_content 'Este certificado obedece o estipulado na lei 8.666 de 21.06.1993 e suas atualizações.'
    expect(page).to have_content "Belo Horizonte, #{I18n.l(Date.current, :format => :long)}"
    expect(page).to have_content 'Gerente'
    expect(page).to have_content 'Gabriel Sobrinho'
  end
end
