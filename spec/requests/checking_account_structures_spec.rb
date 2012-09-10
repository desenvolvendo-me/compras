# encoding: utf-8
require 'spec_helper'

feature "CheckingAccountStructures" do
  background do
    sign_in
  end

  scenario 'create a new checking_account_structure' do
    CheckingAccountOfFiscalAccount.make!(:disponibilidade_financeira)
    CheckingAccountStructureInformation.make!(:fonte_de_recursos)

    navigate 'Contabilidade > Comum > Plano de Contas > Estruturas das Contas Correntes'

    click_link 'Criar Estrutura da Conta Corrente'

    fill_modal 'Conta corrente', :with => 'Disponibilidade financeira'
    fill_in 'Nome', :with => 'Fonte de Recursos'
    fill_in 'Tag', :with => 'FonteRecursos'
    fill_in 'Descrição', :with => 'Identificação da origem dos recursos'
    fill_in 'Preenchimento', :with => 'Limite'
    fill_in 'Referência', :with => 'Referente ao limite'
    fill_modal 'Identificação', :with => 'Fonte de Recursos'

    click_button 'Salvar'

    expect(page).to have_notice 'Estrutura da Conta Corrente criado com sucesso.'

    click_link 'Fonte de Recursos'

    expect(page).to have_field 'Conta corrente', :with => 'Disponibilidade financeira'
    expect(page).to have_field 'Nome', :with => 'Fonte de Recursos'
    expect(page).to have_field 'Tag', :with => 'FonteRecursos'
    expect(page).to have_field 'Descrição', :with => 'Identificação da origem dos recursos'
    expect(page).to have_field 'Preenchimento', :with => 'Limite'
    expect(page).to have_field 'Referência', :with => 'Referente ao limite'
    expect(page).to have_field 'Identificação', :with => 'Fonte de Recursos'
  end

  scenario 'update an existent checking_account_structure' do
    CheckingAccountStructureInformation.make!(:outras_fontes)
    CheckingAccountOfFiscalAccount.make!(:disponibilidade)
    CheckingAccountStructure.make!(:fonte_recursos)

    navigate 'Contabilidade > Comum > Plano de Contas > Estruturas das Contas Correntes'

    click_link 'Fonte de Recursos'

    fill_modal 'Conta corrente', :with => 'Disponibilidade'
    fill_in 'Nome', :with => 'Outra Fonte de Recursos'
    fill_in 'Tag', :with => 'OutraFonte'
    fill_in 'Descrição', :with => 'Identificar a origem das outras fontes'
    fill_in 'Preenchimento', :with => 'Outras'
    fill_in 'Referência', :with => 'Referente a outras fontes'
    fill_modal 'Identificação', :with => 'Outras Fontes'

    click_button 'Salvar'

    expect(page).to have_notice 'Estrutura da Conta Corrente editado com sucesso.'

    click_link 'Outra Fonte de Recursos'

    expect(page).to have_field 'Conta corrente', :with => 'Disponibilidade'
    expect(page).to have_field 'Nome', :with => 'Outra Fonte de Recursos'
    expect(page).to have_field 'Tag', :with => 'OutraFonte'
    expect(page).to have_field 'Descrição', :with => 'Identificar a origem das outras fontes'
    expect(page).to have_field 'Preenchimento', :with => 'Outras'
    expect(page).to have_field 'Referência', :with => 'Referente a outras fontes'
    expect(page).to have_field 'Identificação', :with => 'Outras Fontes'
  end

  scenario 'destroy an existent checking_account_structure' do
    CheckingAccountStructure.make!(:fonte_recursos)

    navigate 'Contabilidade > Comum > Plano de Contas > Estruturas das Contas Correntes'

    click_link 'Fonte de Recursos'

    click_link 'Apagar'

    expect(page).to have_notice 'Estrutura da Conta Corrente apagado com sucesso.'

    expect(page).to_not have_content 'Fonte de Recursos'
  end
end
