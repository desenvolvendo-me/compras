# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessInvitedBidders" do
  background do
    sign_in
  end

  scenario 'accessing the invited bidders and return to licitation process edit page' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    invited_bidder = licitation_process.licitation_process_invited_bidders.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes convidados'

    page.should have_link invited_bidder.to_s

    click_link 'Voltar ao processo licitatório'

    page.should have_content "Editar #{licitation_process.to_s}"
  end

  scenario 'creating a new invited bidder' do
    LicitationProcess.make!(:processo_licitatorio)
    Provider.make!(:wenderson_sa)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes convidados'

    click_link 'Criar Licitante convidado'

    fill_modal 'Fornecedor', :with => '456789', :field => 'Número do CRC'
    fill_in 'Protocolo', :with => '123456'
    fill_in 'Data do protocolo', :with => I18n.l(Date.current)
    fill_in 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Protocolo', :with => '123456'
    page.should have_field 'Data do protocolo', :with => I18n.l(Date.current)
    page.should have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)
  end

  scenario 'updating an existing invited bidder' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    Provider.make!(:sobrinho_sa)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes convidados'

    within_records do
      page.find('a').click
    end

    fill_modal 'Fornecedor', :with => '123456', :field => 'Número do CRC'
    fill_in 'Protocolo', :with => '111111'
    fill_in 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    fill_in 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)

    click_button 'Salvar'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
    page.should have_field 'Protocolo', :with => '111111'
    page.should have_field 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)
  end

  scenario 'deleting an invited bidder' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    invited_bidder = licitation_process.licitation_process_invited_bidders.first

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes convidados'

    page.should have_link invited_bidder.to_s

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should_not have_link invited_bidder.to_s
  end

  scenario 'marking auto_convocation to disable and clear date fields' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    click_link 'Processos'

    click_link 'Processos Licitatórios'

    within_records do
      page.find('a').click
    end

    click_link 'Licitantes convidados'

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
end
