# encoding: utf-8
require 'spec_helper'

feature "CheckingAccountStructureInformations" do
  background do
    sign_in
  end

  scenario 'create a new checking_account_structure' do
    CapabilitySource.make!(:imposto)

    navigate 'Contabilidade > Comum > Plano de Contas > Identificações da Estrutura de Conta Corrente'

    click_link 'Criar Identificação da Estrutura de Conta Corrente'

    fill_in 'Nome', :with => 'Fonte de Recursos'
    fill_in 'Cógido TCE', :with => '11'
    fill_in 'Tabela referenciada', :with => 'Tabela fonte de recursos'

    click_button 'Salvar'

    expect(page).to have_notice 'Identificação da Estrutura de Conta Corrente criado com sucesso.'

    click_link 'Fonte de Recursos'

    expect(page).to have_field 'Nome', :with => 'Fonte de Recursos'
    expect(page).to have_field 'Cógido TCE', :with => '11'
    expect(page).to have_field 'Tabela referenciada', :with => 'Tabela fonte de recursos'
  end

  scenario 'update an existent checking_account_structure' do
    CheckingAccountStructureInformation.make!(:fonte_de_recursos)
    CapabilitySource.make!(:transferencia)

    navigate 'Contabilidade > Comum > Plano de Contas > Identificações da Estrutura de Conta Corrente'

    click_link 'Fonte de Recursos'

    fill_in 'Nome', :with => 'Recursos'
    fill_in 'Cógido TCE', :with => '222'
    fill_in 'Tabela referenciada', :with => 'Identificação dos recursos'

    click_button 'Salvar'

    expect(page).to have_notice 'Identificação da Estrutura de Conta Corrente editado com sucesso.'

    click_link 'Recursos'

    expect(page).to have_field 'Nome', :with => 'Recursos'
    expect(page).to have_field 'Cógido TCE', :with => '222'
    expect(page).to have_field 'Tabela referenciada', :with => 'Identificação dos recursos'
  end

  scenario 'destroy an existent checking_account_structure' do
    CheckingAccountStructureInformation.make!(:fonte_de_recursos)

    navigate 'Contabilidade > Comum > Plano de Contas > Identificações da Estrutura de Conta Corrente'

    click_link 'Fonte de Recursos'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Identificação da Estrutura de Conta Corrente apagado com sucesso.'

    expect(page).to_not have_content 'Fonte de Recursos'
  end
end
