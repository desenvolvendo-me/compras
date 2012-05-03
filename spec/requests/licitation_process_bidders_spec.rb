# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessBidders" do
  background do
    sign_in
  end

  scenario 'accessing the bidders and return to licitation process edit page' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    bidder = licitation_process.licitation_process_bidders.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    page.should have_link bidder.to_s

    click_link 'Voltar ao processo licitatório'

    page.should have_content "Editar #{licitation_process.to_s}"
  end

  scenario 'creating a new bidder' do
    LicitationProcess.make!(:processo_licitatorio)
    Provider.make!(:wenderson_sa)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'
    fill_in 'Protocolo', :with => '123456'
    fill_in 'Data do protocolo', :with => I18n.l(Date.current)
    fill_in 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    # testing that document type from licitation process are automaticaly included in bidder
    page.should have_disabled_field 'Documento'
    page.should have_field 'Documento', :with => 'Fiscal'

    fill_in 'Número/certidão', :with => '222222'
    fill_in 'Data de emissão', :with => I18n.l(Date.tomorrow)
    fill_in 'Validade', :with => I18n.l(Date.tomorrow + 5.days)

    click_button 'Salvar'

    page.should have_content 'Licitante criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Protocolo', :with => '123456'
    page.should have_field 'Data do protocolo', :with => I18n.l(Date.current)
    page.should have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    page.should have_field 'Documento', :with => 'Fiscal'
    page.should have_field 'Número/certidão', :with => '222222'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Validade', :with => I18n.l(Date.tomorrow + 5.days)
  end

  scenario 'updating an existing bidder' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    Provider.make!(:sobrinho_sa)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    fill_modal 'Fornecedor', :with => '123456', :field => 'Número do CRC'
    fill_in 'Protocolo', :with => '111111'
    fill_in 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    fill_in 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)

    fill_in 'Número/certidão', :with => '333333'
    fill_in 'Data de emissão', :with => I18n.l(Date.tomorrow + 1.day)
    fill_in 'Validade', :with => I18n.l(Date.tomorrow + 6.days)

    click_button 'Salvar'

    page.should have_content 'Licitante editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
    page.should have_field 'Protocolo', :with => '111111'
    page.should have_field 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)

    page.should have_field 'Documento', :with => 'Fiscal'
    page.should have_field 'Número/certidão', :with => '333333'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.tomorrow + 1.day)
    page.should have_field 'Validade', :with => I18n.l(Date.tomorrow + 6.days)
  end

  scenario 'deleting an bidder' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    bidder = licitation_process.licitation_process_bidders.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    page.should have_link bidder.to_s

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Licitante apagado com sucesso.'

    page.should_not have_link bidder.to_s
  end

  scenario 'marking auto_convocation to disable and clear date fields' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Data do protocolo', :with => I18n.l(Date.current)
    page.should have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    page.should_not have_disabled_field 'Data do protocolo'
    page.should_not have_disabled_field 'Data do recebimento'

    check 'Auto convocação'

    page.should have_disabled_field 'Data do protocolo'
    page.should have_disabled_field 'Data do recebimento'

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should have_checked_field 'Auto convocação'
    page.should have_field 'Data do protocolo', :with => ''
    page.should have_field 'Data do recebimento', :with => ''

    page.should have_disabled_field 'Data do protocolo'
    page.should have_disabled_field 'Data do recebimento'
  end

  scenario 'validating uniqueness of provider on licitation process scope' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end
end
