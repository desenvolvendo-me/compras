#encoding: utf-8
require 'spec_helper'

feature 'ContractTerminationAnnuls' do
  background do
    sign_in
  end

  scenario 'create a contract termination annulment' do
    ContractTermination.make!(:contrato_rescindido)

    navigate_through 'Contabilidade > Comum > Contratos de Gestão'

    click_link '001'

    click_link 'Rescisões'

    click_link '2012/1'

    click_link 'Anular'

    page.should have_content "Anulação da Rescisão do Contrato 2012/1"

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '28/06/2012'
    fill_in 'Justificativa', :with => 'Anulação da rescisão do contrato'

    click_button 'Salvar'

    page.should have_notice 'Anulação de Recurso criado com sucesso.'

    click_link 'Anulação'

    page.should have_content "Anulação da Rescisão do Contrato 2012/1"

    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_field 'Data', :with => '28/06/2012'
    page.should have_field 'Justificativa', :with => 'Anulação da rescisão do contrato'
  end

  scenario 'a contract termination annul should have all fields disabled' do
    ResourceAnnul.make!(:rescisao_de_contrato_anulada)

    navigate_through 'Contabilidade > Comum > Contratos de Gestão'

    click_link '001'

    click_link 'Rescisões'

    click_link '2012/1'

    click_link 'Anulação'

    page.should have_content "Anulação da Rescisão do Contrato 2012/1"

    page.should have_disabled_field 'Responsável'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'

    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => '28/06/2012'

    page.should have_disabled_field 'Justificativa'
    page.should have_field 'Justificativa', :with => 'Rescisão Anulada'

    page.should_not have_button 'Salvar'
    page.should_not have_link 'Apagar'
  end

  scenario 'a contract termination annul cancel should bat to contract termination' do
    ResourceAnnul.make!(:rescisao_de_contrato_anulada)

    navigate_through 'Contabilidade > Comum > Contratos de Gestão'

    click_link '001'

    click_link 'Rescisões'

    click_link '2012/1'

    click_link 'Anulação'

    click_link 'Cancelar'

    page.should have_content 'Editar rescisão 2012/1 do Contrato 001'
  end
end
