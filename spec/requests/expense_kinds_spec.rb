# encoding: utf-8
require 'spec_helper'

feature "ExpenseKinds" do
  background do
    sign_in
  end

  scenario 'create a new expense_kind' do
    navigate 'Outros > Contabilidade > Execução > Empenho > Tipos de Despesas'

    click_link 'Criar Tipo de Despesa'

    fill_in 'Descrição', :with => 'Pagamentos'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Despesa criado com sucesso.'

    click_link 'Pagamentos'

    expect(page).to have_field 'Descrição', :with => 'Pagamentos'
    expect(page).to have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent expense_kind' do
    ExpenseKind.make!(:pagamentos)

    navigate 'Outros > Contabilidade > Execução > Empenho > Tipos de Despesas'

    click_link 'Pagamentos'

    fill_in 'Descrição', :with => 'Limpeza'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Despesa editado com sucesso.'

    click_link 'Limpeza'

    expect(page).to have_field 'Descrição', :with => 'Limpeza'
    expect(page).to have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent expense_kind' do
    ExpenseKind.make!(:pagamentos)

    navigate 'Outros > Contabilidade > Execução > Empenho > Tipos de Despesas'

    click_link 'Pagamentos'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Despesa apagado com sucesso.'

    expect(page).to_not have_content 'Pagamentos'
    expect(page).to_not have_content 'Ativo'
  end

  scenario 'validate uniqueness of description' do
    ExpenseKind.make!(:pagamentos)

    navigate 'Outros > Contabilidade > Execução > Empenho > Tipos de Despesas'

    click_link 'Criar Tipo de Despesa'

    fill_in 'Descrição', :with => 'Pagamentos'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
