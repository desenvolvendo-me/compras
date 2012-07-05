#encoding: utf-8
require 'spec_helper'

feature 'ContractTerminations' do
  background do
    sign_in
  end

  scenario 'creating the terminations of a contract' do
    Contract.make!(:primeiro_contrato)
    DisseminationSource.make!(:jornal_bairro)

    navigate_through 'Contabilidade > Comum > Contratos'

    click_link '001'

    click_link 'Rescisões'

    page.should have_content 'Rescisões do Contrato 001'
    page.should have_link 'Voltar para o Contrato 001'

    click_link 'Criar Rescisão Contratual'

    page.should have_content 'Criar nova Rescisão Contratual para Contrato 001'

    page.should have_disabled_field 'Número da rescisão'
    page.should have_field 'Número da rescisão', :with => '1'

    page.should have_disabled_field 'Ano'
    page.should have_field 'Ano', :with => "#{Date.current.year}"

    fill_in 'Motivo da rescisão', :with => 'Foo Bar'
    fill_in 'Data do termo', :with => '15/06/2012'
    fill_in 'Data da rescisão', :with => '20/06/2012'
    fill_in 'Data da publicação', :with => '19/06/2012'
    select_modal 'Local da publicação', :field => 'Descrição', :with => 'Jornal Oficial do Bairro'
    fill_in 'Valor da multa', :with => '15000'
    fill_in 'Valor da indenização', :with => '3000'
    attach_file 'Termo de rescisão', 'spec/fixtures/example_document.txt'

    click_button 'Salvar'

    page.should have_content 'Rescisão Contratual criado com sucesso.'

    click_link "1/#{Date.current.year}"

    page.should have_content "Editar Rescisão 1/#{Date.current.year} do Contrato 001"

    page.should have_link 'Anular'

    page.should have_disabled_field 'Número da rescisão'
    page.should have_field 'Número da rescisão', :with => '1'

    page.should have_disabled_field 'Ano'
    page.should have_field 'Ano', :with => "#{Date.current.year}"

    page.should have_field 'Motivo da rescisão', :with => 'Foo Bar'
    page.should have_field 'Data do termo', :with => '15/06/2012'
    page.should have_field 'Data da rescisão', :with => '20/06/2012'
    page.should have_field 'Data da publicação', :with => '19/06/2012'
    page.should have_field 'Local da publicação', :with => 'Jornal Oficial do Bairro'
    page.should have_field 'Valor da multa', :with => '150,00'
    page.should have_field 'Valor da indenização', :with => '30,00'
    page.should have_link 'example_document.txt'

    page.should_not have_link 'Apagar'

    click_link 'Cancelar'

    page.should have_content 'Rescisões do Contrato 001'
  end

  scenario 'editing a contract termination' do
    ContractTermination.make!(:contrato_rescindido)

    navigate_through 'Contabilidade > Comum > Contratos'

    click_link '001'

    click_link 'Rescisões'

    click_link '1/2012'

    fill_in 'Motivo da rescisão', :with => 'Motivo vai aqui'

    click_button 'Salvar'

    page.should have_content 'Rescisão Contratual editado com sucesso.'

    click_link '1/2012'

    page.should have_field 'Motivo da rescisão', :with => 'Motivo vai aqui'
  end

  scenario 'contract termination annulled should have fields disabled' do
    ResourceAnnul.make!(:rescisao_de_contrato_anulada)

    navigate_through 'Contabilidade > Comum > Contratos'

    click_link '001'

    click_link 'Rescisões'

    click_link '1/2012'

    page.should have_disabled_field 'Número da rescisão'
    page.should have_disabled_field 'Ano'
    page.should have_disabled_field 'Motivo da rescisão'
    page.should have_disabled_field 'Data do termo'
    page.should have_disabled_field 'Data da rescisão'
    page.should have_disabled_field 'Data da publicação'
    page.should have_disabled_field 'Local da publicação'
    page.should have_disabled_field 'Valor da multa'
    page.should have_disabled_field 'Valor da indenização'

    page.should_not have_link 'Anular'
    page.should_not have_button 'Salvar'

    page.should have_link 'Anulação'
  end
end
