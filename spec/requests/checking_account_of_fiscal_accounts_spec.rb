# encoding: utf-8
require 'spec_helper'

feature "CheckingAccountOfFiscalAccounts" do
  background do
    sign_in
  end

  scenario 'create a new checking_account_of_fiscal_account' do
    navigate 'Cadastros Gerais > Plano de Contas > Contas Correntes das Contas Contábeis'

    click_link 'Criar Conta Corrente da Conta Contábil'

    within_tab 'Principal' do
      fill_in 'Cógido do TCE', :with => '14'
      fill_in 'Nome', :with => 'Disponibilidade financeira'
      fill_in 'Tag principal', :with => 'DisponibilidadeFinanceira'
      fill_in 'Função', :with => 'Detalhar as movimentações financeiras'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Conta Corrente da Conta Contábil criado com sucesso.'

    click_link 'Disponibilidade financeira'

    within_tab 'Principal' do
      expect(page).to have_field 'Cógido do TCE', :with => '14'
      expect(page).to have_field 'Nome', :with => 'Disponibilidade financeira'
      expect(page).to have_field 'Tag principal', :with => 'DisponibilidadeFinanceira'
      expect(page).to have_field 'Função', :with => 'Detalhar as movimentações financeiras'
    end
  end

  scenario 'update an existent checking_account_of_fiscal_account' do
    CheckingAccountOfFiscalAccount.make!(:disponibilidade_financeira)

    navigate 'Cadastros Gerais > Plano de Contas > Contas Correntes das Contas Contábeis'

    click_link 'Disponibilidade financeira'

    within_tab 'Principal' do
      fill_in 'Cógido do TCE', :with => '400'
      fill_in 'Nome', :with => 'Disponibilidade'
      fill_in 'Tag principal', :with => 'Disponibilidade'
      fill_in 'Função', :with => 'Detalhar as movimentações dos recursos'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Conta Corrente da Conta Contábil editado com sucesso.'

    click_link 'Disponibilidade'

    within_tab 'Principal' do
      expect(page).to have_field 'Cógido do TCE', :with => '400'
      expect(page).to have_field 'Nome', :with => 'Disponibilidade'
      expect(page).to have_field 'Tag principal', :with => 'Disponibilidade'
      expect(page).to have_field 'Função', :with => 'Detalhar as movimentações dos recursos'
    end
  end

  scenario 'destroy an existent checking_account_of_fiscal_account' do
    CheckingAccountOfFiscalAccount.make!(:disponibilidade_financeira)

    navigate 'Cadastros Gerais > Plano de Contas > Contas Correntes das Contas Contábeis'

    click_link 'Disponibilidade financeira'

    click_link 'Apagar'

    expect(page).to have_notice 'Conta Corrente da Conta Contábil apagado com sucesso.'

    expect(page).to_not have_content 'Disponibilidade financeira'
  end

  scenario 'should show structures to checking_account_of_fiscal_account' do
    CheckingAccountStructure.make!(:fonte_recursos)

    navigate 'Cadastros Gerais > Plano de Contas > Contas Correntes das Contas Contábeis'

    click_link 'Disponibilidade financeira'

    within_tab 'Estruturas' do
      expect(page).to have_content 'Fonte de Recursos'
      expect(page).to have_content 'FonteRecursos'
    end
  end

  scenario 'should have more info link to structure' do
    CheckingAccountStructure.make!(:fonte_recursos)

    navigate 'Cadastros Gerais > Plano de Contas > Contas Correntes das Contas Contábeis'

    click_link 'Disponibilidade financeira'

    within_tab 'Estruturas' do
      click_link 'Detalhes'
    end

    expect(page).to have_content 'Fonte de Recursos'
    expect(page).to have_content 'FonteRecursos'
    expect(page).to have_content 'Identificação da origem dos recursos'
    expect(page).to have_content 'Limite'
    expect(page).to have_content 'Referente ao limite'
  end
end
