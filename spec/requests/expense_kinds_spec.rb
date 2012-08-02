# encoding: utf-8
require 'spec_helper'

feature "ExpenseKinds" do
  background do
    sign_in
  end

  scenario 'create a new expense_kind' do
    navigate 'Contabilidade > Execução > Empenho > Tipos de Despesas'

    click_link 'Criar Tipo de Despesa'

    fill_in 'Descrição', :with => 'Pagamentos'
    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    page.should have_notice 'Tipo de Despesa criado com sucesso.'

    click_link 'Pagamentos'

    page.should have_field 'Descrição', :with => 'Pagamentos'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent expense_kind' do
    ExpenseKind.make!(:pagamentos)

    navigate 'Contabilidade > Execução > Empenho > Tipos de Despesas'

    click_link 'Pagamentos'

    fill_in 'Descrição', :with => 'Limpeza'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Tipo de Despesa editado com sucesso.'

    click_link 'Limpeza'

    page.should have_field 'Descrição', :with => 'Limpeza'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent expense_kind' do
    ExpenseKind.make!(:pagamentos)

    navigate 'Contabilidade > Execução > Empenho > Tipos de Despesas'

    click_link 'Pagamentos'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Tipo de Despesa apagado com sucesso.'

    page.should_not have_content 'Pagamentos'
    page.should_not have_content 'Ativo'
  end

  scenario 'validate uniqueness of description' do
    ExpenseKind.make!(:pagamentos)

    navigate 'Contabilidade > Execução > Empenho > Tipos de Despesas'

    click_link 'Criar Tipo de Despesa'

    fill_in 'Descrição', :with => 'Pagamentos'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end
end
