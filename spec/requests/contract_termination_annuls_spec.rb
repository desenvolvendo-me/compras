#encoding: utf-8
require 'spec_helper'

feature 'ContractTerminationAnnuls' do
  background do
    sign_in
  end

  scenario 'create a contract termination annulment' do
    ContractTermination.make!(:contrato_rescindido)

    navigate 'Comum > Cadastrais > Contratos'

    click_link "Filtrar Contratos"

    clear_modal "Ano"

    click_button "Pesquisar"

    click_link '001'

    click_link 'Rescisão'

    click_link 'Anular'

    expect(page).to have_content "Anular Rescisão Contratual 1/2012"

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '28/06/2012'
    fill_in 'Justificativa', :with => 'Anulação da rescisão do contrato'

    click_button 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criada com sucesso.'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Rescisão Contratual 1/2012"

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Data', :with => '28/06/2012'
    expect(page).to have_field 'Justificativa', :with => 'Anulação da rescisão do contrato'
  end

  scenario 'a contract termination annul should have all fields disabled' do
    ResourceAnnul.make!(:rescisao_de_contrato_anulada)

    navigate 'Comum > Cadastrais > Contratos'

    click_link "Filtrar Contratos"

    clear_modal "Ano"

    click_button "Pesquisar"

    click_link '001'

    click_link 'Rescisão'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Rescisão Contratual 1/2012"

    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data', :with => '28/06/2012'

    expect(page).to have_disabled_field 'Justificativa'
    expect(page).to have_field 'Justificativa', :with => 'Rescisão Anulada'

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end

  scenario 'a contract termination annul cancel should back to contract termination' do
    ResourceAnnul.make!(:rescisao_de_contrato_anulada)

    navigate 'Comum > Cadastrais > Contratos'

    click_link "Filtrar Contratos"

    clear_modal "Ano"

    click_button "Pesquisar"

    click_link '001'

    click_link 'Rescisão'

    click_link 'Anulação'

    click_link 'Voltar'

    expect(page).to have_content 'Editar Rescisão 1/2012 do Contrato 001'
  end
end
