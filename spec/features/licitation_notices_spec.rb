require 'spec_helper'

feature "LicitationNotices" do
  background do
    sign_in
  end

  let(:date_current) { I18n.l Date.current }

  scenario 'create, update and destroy destroy a new licitation_notice' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Avisos de Licitações'

    click_link 'Criar Aviso de Licitação'

    fill_modal 'Processo de compra', :with => '2012', :field => 'Ano'

    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Concorrência 1'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência', disabled: true
    expect(page).to have_field 'Data do processo', :with => '19/03/2012', disabled: true
    expect(page).to have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras', disabled: true

    fill_in 'Data do aviso', :with => '05/04/2012'
    fill_in 'Observações gerais', :with => 'Aviso de processo'

    click_button 'Salvar'

    expect(page).to have_notice 'Aviso de Licitação criado com sucesso.'

    within_records do
      click_link '1/2012 - Concorrência 1 - 05/04/2012'
    end

    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Concorrência 1'
    expect(page).to have_field 'Número do aviso', :with => '1', disabled: true
    expect(page).to have_field 'Data do aviso', :with => '05/04/2012'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência', disabled: true
    expect(page).to have_field 'Data do processo', :with => '19/03/2012', disabled: true
    expect(page).to have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras', disabled: true
    expect(page).to have_field 'Observações gerais', :with => 'Aviso de processo'

    fill_in 'Data do aviso', :with => '06/04/2012'
    fill_in 'Observações gerais', :with => 'Novo aviso de processo, continuação.'

    click_button 'Salvar'

    expect(page).to have_notice 'Aviso de Licitação editado com sucesso.'

    within_records do
      click_link '1/2012 - Concorrência 1 - 06/04/2012'
    end

    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Concorrência 1'
    expect(page).to have_field 'Número do aviso', :with => '1', disabled: true
    expect(page).to have_field 'Data do aviso', :with => '06/04/2012'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência', disabled: true
    expect(page).to have_field 'Data do processo', :with => '19/03/2012', disabled: true
    expect(page).to have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras', disabled: true
    expect(page).to have_field 'Observações gerais', :with => 'Novo aviso de processo, continuação.'

    click_link 'Apagar'

    expect(page).to have_notice 'Aviso de Licitação apagado com sucesso.'

    expect(page).to_not have_content '1/2012 - Concorrência 1 - 06/04/2012'
    expect(page).to_not have_content 'A licitação começou.'
  end

  scenario 'create a new licitation_notice when already exists a licitation_notice with the same licitation process year' do
    LicitationNotice.make!(:aviso_de_licitacao)
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Licitações > Avisos de Licitações'

    click_link 'Criar Aviso de Licitação'

    fill_modal 'Processo de compra', :with => '2013', :field => 'Ano'
    fill_in 'Data do aviso', :with => '07/04/2012'
    fill_in 'Observações gerais', :with => 'Aviso de processo 3'

    click_button 'Salvar'

    expect(page).to have_notice 'Aviso de Licitação criado com sucesso.'

    within_records do
      click_link "2/2013 - Concorrência 1 - 07/04/2012"
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Concorrência 1'
    expect(page).to have_field 'Número do aviso', :with => '1', disabled: true
    expect(page).to have_field 'Data do aviso', :with => '07/04/2012'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência', disabled: true
    expect(page).to have_field 'Data do processo', :with => '20/03/2013', disabled: true
    expect(page).to have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras', disabled: true
    expect(page).to have_field 'Observações gerais', :with => 'Aviso de processo 3'
  end

  scenario 'create a new licitation_notice when already exists a licitation_notice with other licitation process year' do
    LicitationNotice.make!(:aviso_de_licitacao)

    navigate 'Licitações > Avisos de Licitações'

    click_link 'Criar Aviso de Licitação'

    fill_modal 'Processo de compra', :with => '2012', :field => 'Ano'
    fill_in 'Data do aviso', :with => '06/04/2012'
    fill_in 'Observações gerais', :with => 'Aviso de processo 2'

    click_button 'Salvar'

    expect(page).to have_notice 'Aviso de Licitação criado com sucesso.'

    within_records do
      click_link "1/2012 - Concorrência 1 - 06/04/2012"
    end

    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Concorrência 1'
    expect(page).to have_field 'Número do aviso', :with => '2', disabled: true
    expect(page).to have_field 'Data do aviso', :with => '06/04/2012'
    expect(page).to have_field 'Modalidade', :with => 'Concorrência', disabled: true
    expect(page).to have_field 'Data do processo', :with => '19/03/2012', disabled: true
    expect(page).to have_field 'Objeto da licitação', :with => 'Licitação para compra de carteiras', disabled: true
    expect(page).to have_field 'Observações gerais', :with => 'Aviso de processo 2'
  end

  scenario 'delegate fields should be empty when clear licitaion process' do
    LicitationNotice.make!(:aviso_de_licitacao)

    navigate 'Licitações > Avisos de Licitações'

    within_records do
      click_link "1/2012 - Concorrência 1 - #{date_current}"
    end

    clear_modal 'Processo de compra'

    expect(page).to have_field 'Processo de compra', :with => ''
    expect(page).to have_field 'Modalidade', :with => '', disabled: true
    expect(page).to have_field 'Data do processo', :with => '', disabled: true
    expect(page).to have_field 'Objeto da licitação', :with => '', disabled: true
  end
end
