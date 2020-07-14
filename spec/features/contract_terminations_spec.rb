require 'spec_helper'

feature 'ContractTerminations', vcr: { cassette_name: :contract_terminations } do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['dissemination_sources', 'contracts', 'contract_termination_annuls']
    sign_in
  end

  scenario 'creating and updating the terminations of a contract' do
    Contract.make!(:primeiro_contrato)
    DisseminationSource.make!(:jornal_bairro)

    navigate 'Contratos > Contratos'

    

    click_link '001'

    click_link 'Rescisão'

    expect(page).to have_content 'Criar nova Rescisão Contratual para Contrato 001'

    expect(page).to have_field 'Status', disabled: true

    expect(page).to have_field 'Número da rescisão', :with => '1', disabled: true

    expect(page).to have_field 'Ano', :with => "#{Date.current.year}", disabled: true

    fill_in 'Motivo da rescisão', :with => 'Foo Bar'
    fill_in 'Data do termo', :with => '15/06/2012'
    fill_in 'Data da rescisão', :with => '20/06/2012'
    fill_in 'Data da publicação', :with => '19/06/2012'
    select_modal 'Local da publicação', :field => 'Descrição', :with => 'Jornal Oficial do Bairro'
    fill_in 'Valor da multa', :with => '15000'
    fill_in 'Valor da indenização', :with => '3000'
    attach_file 'Termo de rescisão', 'spec/fixtures/example_document.txt'

    click_button 'Salvar'

    expect(page).to have_notice 'Rescisão Contratual criada com sucesso.'

    click_link 'Rescisão'

    expect(page).to have_title "Editar Rescisão 1/#{Date.current.year} do Contrato 001"

    expect(page).to have_link 'Anular'

    expect(page).to have_field 'Número da rescisão', :with => '1', disabled: true

    expect(page).to have_field 'Ano', :with => "#{Date.current.year}", disabled: true

    expect(page).to have_field 'Motivo da rescisão', :with => 'Foo Bar'
    expect(page).to have_field 'Data do termo', :with => '15/06/2012'
    expect(page).to have_field 'Data da rescisão', :with => '20/06/2012'
    expect(page).to have_field 'Data da publicação', :with => '19/06/2012'
    expect(page).to have_field 'Local da publicação', :with => 'Jornal Oficial do Bairro'
    expect(page).to have_field 'Valor da multa', :with => '150,00'
    expect(page).to have_field 'Valor da indenização', :with => '30,00'
    expect(page).to have_link 'example_document.txt'

    expect(page).to_not have_link 'Apagar'

    click_link 'Voltar'

    expect(page).to have_title 'Editar Contrato'

    click_link 'Rescisão'

    expect(page).to have_field 'Status', disabled: true

    fill_in 'Motivo da rescisão', :with => 'Motivo vai aqui'

    click_button 'Salvar'

    expect(page).to have_notice 'Rescisão Contratual editada com sucesso.'

    click_link 'Rescisão'

    expect(page).to have_field 'Motivo da rescisão', :with => 'Motivo vai aqui'
  end

  scenario 'contract termination annulled should have fields disabled' do
    ResourceAnnul.make!(:rescisao_de_contrato_anulada)

    navigate 'Contratos > Contratos'

    

    click_link '001'

    click_link 'Rescisão'

    expect(page).to have_field 'Número da rescisão', disabled: true
    expect(page).to have_field 'Ano', disabled: true
    expect(page).to have_field 'Motivo da rescisão', disabled: true
    expect(page).to have_field 'Data do termo', disabled: true
    expect(page).to have_field 'Data da rescisão', disabled: true
    expect(page).to have_field 'Data da publicação', disabled: true
    expect(page).to have_field 'Local da publicação', disabled: true
    expect(page).to have_field 'Valor da multa', disabled: true
    expect(page).to have_field 'Valor da indenização', disabled: true

    expect(page).to_not have_link 'Anular'
    expect(page).to have_disabled_element 'Salvar', :reason => 'não é permitido alterar rescisão anulada'

    expect(page).to have_link 'Anulação'
  end
end
