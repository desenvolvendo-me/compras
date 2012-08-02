# encoding: utf-8
require 'spec_helper'

feature "LicitationNotices" do
  background do
    sign_in
  end

  scenario 'create a new licitation_notice' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Avisos de Licitações'

    click_link 'Criar Aviso de Licitação'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Modalidade', :with => 'Convite para compras e serviços de engenharia'
    page.should have_field 'Número da licitação', :with => '1'
    page.should have_field 'Data do processo', :with => '19/03/2012'
    page.should have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras'

    fill_in 'Data do aviso', :with => '05/04/2012'
    fill_in 'Observações gerais', :with => 'Aviso de processo'

    click_button 'Salvar'

    page.should have_notice 'Aviso de Licitação criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Número do aviso', :with => '1'
    page.should have_field 'Data do aviso', :with => '05/04/2012'
    page.should have_field 'Modalidade', :with => 'Convite para compras e serviços de engenharia'
    page.should have_field 'Número da licitação', :with => '1'
    page.should have_field 'Data do processo', :with => '19/03/2012'
    page.should have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras'
    page.should have_field 'Observações gerais', :with => 'Aviso de processo'
  end

  scenario 'update an existent licitation_notice' do
    licitation_notice = LicitationNotice.make!(:aviso_de_licitacao)
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Avisos de Licitações'

    click_link licitation_notice.to_s

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'
    fill_in 'Data do aviso', :with => '12/04/2012'
    fill_in 'Observações gerais', :with => 'Aviso de processo, continuação.'

    click_button 'Salvar'

    page.should have_notice 'Aviso de Licitação editado com sucesso.'

    click_link licitation_notice.to_s

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Número do aviso', :with => '1'
    page.should have_field 'Data do aviso', :with => '12/04/2012'
    page.should have_field 'Modalidade', :with => 'Convite para compras e serviços de engenharia'
    page.should have_field 'Número da licitação', :with => '1'
    page.should have_field 'Data do processo', :with => '20/03/2013'
    page.should have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras'
    page.should have_field 'Observações gerais', :with => 'Aviso de processo, continuação.'
  end

  scenario 'create a new licitation_notice when already exists a licitation_notice with the same licitation process year' do
    LicitationNotice.make!(:aviso_de_licitacao)
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Avisos de Licitações'

    click_link 'Criar Aviso de Licitação'

    fill_modal 'Processo licitatório', :with => '2013', :field => 'Ano'
    fill_in 'Data do aviso', :with => '07/04/2012'
    fill_in 'Observações gerais', :with => 'Aviso de processo 3'

    click_button 'Salvar'

    page.should have_notice 'Aviso de Licitação criado com sucesso.'

    within_records do
      click_link LicitationNotice.last.to_s
    end

    page.should have_field 'Processo licitatório', :with => '1/2013'
    page.should have_field 'Número do aviso', :with => '1'
    page.should have_field 'Data do aviso', :with => '07/04/2012'
    page.should have_field 'Modalidade', :with => 'Convite para compras e serviços de engenharia'
    page.should have_field 'Número da licitação', :with => '1'
    page.should have_field 'Data do processo', :with => '20/03/2013'
    page.should have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras'
    page.should have_field 'Observações gerais', :with => 'Aviso de processo 3'
  end

  scenario 'create a new licitation_notice when already exists a licitation_notice with other licitation process year' do
    LicitationNotice.make!(:aviso_de_licitacao)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Avisos de Licitações'

    click_link 'Criar Aviso de Licitação'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
    fill_in 'Data do aviso', :with => '06/04/2012'
    fill_in 'Observações gerais', :with => 'Aviso de processo 2'

    click_button 'Salvar'

    page.should have_notice 'Aviso de Licitação criado com sucesso.'

    within_records do
      click_link LicitationNotice.last.to_s
    end

    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Número do aviso', :with => '2'
    page.should have_field 'Data do aviso', :with => '06/04/2012'
    page.should have_field 'Modalidade', :with => 'Convite para compras e serviços de engenharia'
    page.should have_field 'Número da licitação', :with => '1'
    page.should have_field 'Data do processo', :with => '19/03/2012'
    page.should have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras'
    page.should have_field 'Observações gerais', :with => 'Aviso de processo 2'
  end

  scenario 'destroy an existent licitation_notice' do
    licitation_notice = LicitationNotice.make!(:aviso_de_licitacao)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Avisos de Licitações'

    click_link licitation_notice.to_s

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Aviso de Licitação apagado com sucesso.'

    page.should_not have_content I18n.l(Date.current)
    page.should_not have_content "A licitação começou."
  end

  scenario 'delegate fields should be empty when clear licitaion process' do
    licitation_notice = LicitationNotice.make!(:aviso_de_licitacao)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Licitatório > Avisos de Licitações'

    click_link licitation_notice.to_s

    clear_modal 'Processo licitatório'

    page.should have_field 'Processo licitatório', :with => ''
    page.should have_field 'Modalidade', :with => ''
    page.should have_field 'Número da licitação', :with => ''
    page.should have_field 'Data do processo', :with => ''
    page.should have_field 'Objeto da licitação', :with => ''
  end
end
