# encoding: utf-8
require 'spec_helper'

feature "CheckountAccountOfFiscalAccounts" do
  background do
    sign_in
  end

  scenario 'create a new checkount_account_of_fiscal_account' do
    navigate 'Contabilidade > Comum > Plano de Contas > Contas Corrente da Conta Contábil'

    click_link 'Criar Conta Corrente da Conta Contábil'

    fill_in 'Cógido TCE', :with => '14'
    fill_in 'Nome', :with => 'Disponibilidade financeira'
    fill_in 'Tag principal', :with => 'DisponibilidadeFinanceira'
    fill_in 'Função', :with => 'Detalhar as movimentações financeiras'

    click_button 'Salvar'

    expect(page).to have_notice 'Conta Corrente da Conta Contábil criado com sucesso.'

    click_link 'Disponibilidade financeira'

    expect(page).to have_field 'Cógido TCE', :with => '14'
    expect(page).to have_field 'Nome', :with => 'Disponibilidade financeira'
    expect(page).to have_field 'Tag principal', :with => 'DisponibilidadeFinanceira'
    expect(page).to have_field 'Função', :with => 'Detalhar as movimentações financeiras'
  end

  scenario 'update an existent checkount_account_of_fiscal_account' do
    CheckountAccountOfFiscalAccount.make!(:disponibilidade_financeira)

    navigate 'Contabilidade > Comum > Plano de Contas > Contas Corrente da Conta Contábil'

    click_link 'Disponibilidade financeira'

    fill_in 'Cógido TCE', :with => '400'
    fill_in 'Nome', :with => 'Disponibilidade'
    fill_in 'Tag principal', :with => 'Disponibilidade'
    fill_in 'Função', :with => 'Detalhar as movimentações dos recursos'

    click_button 'Salvar'

    expect(page).to have_notice 'Conta Corrente da Conta Contábil editado com sucesso.'

    click_link 'Disponibilidade'

    expect(page).to have_field 'Cógido TCE', :with => '400'
    expect(page).to have_field 'Nome', :with => 'Disponibilidade'
    expect(page).to have_field 'Tag principal', :with => 'Disponibilidade'
    expect(page).to have_field 'Função', :with => 'Detalhar as movimentações dos recursos'
  end

  scenario 'destroy an existent checkount_account_of_fiscal_account' do
    CheckountAccountOfFiscalAccount.make!(:disponibilidade_financeira)

    navigate 'Contabilidade > Comum > Plano de Contas > Contas Corrente da Conta Contábil'

    click_link 'Disponibilidade financeira'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Conta Corrente da Conta Contábil apagado com sucesso.'

    expect(page).to_not have_content 'tce_code'
    expect(page).to_not have_content 'name'
    expect(page).to_not have_content 'main_tag'
    expect(page).to_not have_content 'function'
  end
end
