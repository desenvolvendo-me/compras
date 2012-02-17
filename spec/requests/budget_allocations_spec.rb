# encoding: utf-8
require 'spec_helper'

feature "BudgetAllocations" do
  background do
    sign_in
  end

  scenario 'create a new budget_allocation' do
    click_link 'Contabilidade'

    click_link 'Dotações Orçamentárias'

    click_link 'Criar Dotação Orçamentária'

    fill_in 'Descrição', :with => 'Alocação'

    fill_in 'Valor', :with => '500,00'

    click_button 'Criar Dotação Orçamentária'

    page.should have_notice 'Dotação Orçamentária criado com sucesso.'

    click_link 'Alocação'

    page.should have_field 'Descrição', :with => 'Alocação'

    page.should have_field 'Valor', :with => '500,00'
  end

  scenario 'update an existent budget_allocation' do
    BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentárias'

    click_link 'Alocação'

    fill_in 'Descrição', :with => 'Novo nome'

    fill_in 'Valor', :with => '800,00'

    click_button 'Atualizar Dotação Orçamentária'

    page.should have_notice 'Dotação Orçamentária editado com sucesso.'

    click_link 'Novo nome'

    page.should have_field 'Descrição', :with => 'Novo nome'

    page.should have_field 'Valor', :with => '800,00'
  end

  scenario 'destroy an existent budget_allocation' do
    BudgetAllocation.make!(:alocacao)
    click_link 'Contabilidade'

    click_link 'Dotações Orçamentárias'

    click_link 'Alocação'

    click_link 'Apagar Alocação', :confirm => true

    page.should have_notice 'Dotação Orçamentária apagado com sucesso.'

    page.should_not have_content 'Alocação'
  end

  scenario 'validates uniqueness of name' do
    BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Dotações Orçamentárias'

    click_link 'Criar Dotação Orçamentária'

    fill_in 'Descrição', :with => 'Alocação'

    click_button 'Criar Dotação Orçamentária'

    page.should have_content 'já está em uso'
  end
end
