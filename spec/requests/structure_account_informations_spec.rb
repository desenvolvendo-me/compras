# encoding: utf-8
require 'spec_helper'

feature "StructureAccountInformations" do
  background do
    sign_in
  end

  scenario 'create a new structure_account_information' do
    CapabilitySource.make!(:imposto)

    navigate 'Contabilidade > Comum > Plano de Contas > Identificações da Estrutura Conta Corrente'

    click_link 'Criar Identificação da Estrutura Conta Corrente'

    fill_in 'Nome', :with => 'Fonte de Recursos'
    fill_in 'Cógido TCE', :with => '11'
    fill_modal 'Fonte de recurso', :with => '1', :field => 'Código'

    click_button 'Salvar'

    expect(page).to have_notice 'Identificação da Estrutura Conta Corrente criado com sucesso.'

    click_link 'Fonte de Recursos'

    expect(page).to have_field 'Nome', :with => 'Fonte de Recursos'
    expect(page).to have_field 'Cógido TCE', :with => '11'
    expect(page).to have_field 'Fonte de recurso', :with => 'Imposto'
  end

  scenario 'update an existent structure_account_information' do
    StructureAccountInformation.make!(:fonte_de_recursos)
    CapabilitySource.make!(:transferencia)

    navigate 'Contabilidade > Comum > Plano de Contas > Identificações da Estrutura Conta Corrente'

    click_link 'Fonte de Recursos'

    fill_in 'Nome', :with => 'Recursos'
    fill_in 'Cógido TCE', :with => '222'
    fill_modal 'Fonte de recurso', :with => '2', :field => 'Código'

    click_button 'Salvar'

    expect(page).to have_notice 'Identificação da Estrutura Conta Corrente editado com sucesso.'

    click_link 'Recursos'

    expect(page).to have_field 'Nome', :with => 'Recursos'
    expect(page).to have_field 'Cógido TCE', :with => '222'
    expect(page).to have_field 'Fonte de recurso', :with => 'Transferência'
  end

  scenario 'destroy an existent structure_account_information' do
    StructureAccountInformation.make!(:fonte_de_recursos)

    navigate 'Contabilidade > Comum > Plano de Contas > Identificações da Estrutura Conta Corrente'

    click_link 'Fonte de Recursos'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Identificação da Estrutura Conta Corrente apagado com sucesso.'

    expect(page).to_not have_content 'Fonte de Recursos'
  end
end
