#encoding: utf-8
require 'spec_helper'

feature 'ContractTerminationAnnuls' do
  let :pledge do
    Pledge.new(id: 1, value: 9.99, description: 'Empenho 1',
      year: 2013, to_s: 1, emission_date: "2013-01-01")
  end

  let :pledge_two do
    Pledge.new(id: 2, value: 15.99, description: 'Empenho 2',
      year: 2012, to_s: 2, emission_date: "2012-01-01")
  end

  let :budget_structure do
    BudgetStructure.new(
      id: 1,
      code: '29',
      tce_code: '051',
      description: 'Secretaria de Desenvolvimento',
      acronym: 'SEMUEDU',
      performance_field: 'Desenvolvimento Educacional')
  end

  background do
    sign_in

    UnicoAPI::Resources::Contabilidade::Pledge.stub(:all).and_return([pledge, pledge_two])

    UnicoAPI::Resources::Contabilidade::Pledge.stub(:find).with(1).and_return(pledge)
    UnicoAPI::Resources::Contabilidade::Pledge.stub(:find).with(2).and_return(pledge_two)
    BudgetStructure.stub(:find).and_return(budget_structure)
  end

  scenario 'create a contract termination annulment' do
    ContractTermination.make!(:contrato_rescindido)
    Employee.make!(:sobrinho)

    navigate 'Instrumentos Contratuais > Contratos'

    click_link "Limpar Filtro"

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

    navigate 'Instrumentos Contratuais > Contratos'

    click_link "Limpar Filtro"

    click_link '001'

    click_link 'Rescisão'

    click_link 'Anulação'

    expect(page).to have_content "Anulação da Rescisão Contratual 1/2012"

    expect(page).to have_field 'Responsável', disabled: true
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_field 'Data', disabled: true
    expect(page).to have_field 'Data', :with => '28/06/2012'

    expect(page).to have_field 'Justificativa', disabled: true
    expect(page).to have_field 'Justificativa', :with => 'Rescisão Anulada'

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end

  scenario 'a contract termination annul cancel should back to contract termination' do
    ResourceAnnul.make!(:rescisao_de_contrato_anulada)

    navigate 'Instrumentos Contratuais > Contratos'

    click_link "Limpar Filtro"

    click_link '001'

    click_link 'Rescisão'

    click_link 'Anulação'

    click_link 'Voltar'

    expect(page).to have_content 'Editar Rescisão 1/2012 do Contrato 001'
  end
end
