# encoding: utf-8
require 'spec_helper'

feature "Pledges" do
  background do
    sign_in
  end

  scenario 'create a new pledge' do
    Entity.make!(:detran)
    ManagementUnit.make!(:unidade_central)
    CommitmentType.make!(:primeiro_empenho)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    PledgeCategory.make!(:geral)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Entidade', :with => 'Detran'
      fill_in 'Exercício', :with => '2012'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      fill_modal 'Tipo de empenho', :with => 'Empenho 01', :field => 'Descrição'
      fill_modal 'Dotação', :with => 'Alocação', :field => 'Descrição'
      fill_in 'Valor', :with => '300,00'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
    end

    click_button 'Criar Empenho'

    page.should have_notice 'Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Entidade', :with => 'Detran'
      page.should have_field 'Exercício', :with => '2012'
      page.should have_field 'Unidade gestora', :with => 'Unidade Central'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
      page.should have_field 'Tipo de empenho', :with => '123 - Empenho 01'
      page.should have_field 'Dotação', :with => "#{budget_allocation.id}/2012"
      page.should have_field 'Valor', :with => '300,00'
      page.should have_field 'Categoria', :with => 'Geral'
    end
  end

  scenario 'update an existent pledge' do
    Pledge.make!(:empenho)
    Entity.make!(:secretaria_de_educacao)
    ManagementUnit.make!(:unidade_auxiliar)
    CommitmentType.make!(:segundo_empenho)
    budget_allocation = BudgetAllocation.make!(:alocacao_extra)
    PledgeCategory.make!(:auxiliar)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_modal 'Entidade', :with => 'Secretaria de Educação'
      fill_in 'Exercício', :with => '2013'
      fill_modal 'Unidade gestora', :with => 'Unidade Auxiliar', :field => 'Descrição'
      fill_in 'Data de emissão', :with => I18n.l(Date.current + 1)
      fill_modal 'Tipo de empenho', :with => 'Empenho 02', :field => 'Descrição'
      fill_modal 'Dotação', :with => 'Alocação extra', :field => 'Descrição'
      fill_in 'Valor', :with => '400,00'
      fill_modal 'Categoria', :with => 'Auxiliar', :field => 'Descrição'
    end

    click_button 'Atualizar Empenho'

    page.should have_notice 'Empenho editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Entidade', :with => 'Secretaria de Educação'
      page.should have_field 'Exercício', :with => '2013'
      page.should have_field 'Unidade gestora', :with => 'Unidade Auxiliar'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current + 1)
      page.should have_field 'Tipo de empenho', :with => '456 - Empenho 02'
      page.should have_field 'Dotação', :with => "#{budget_allocation.id}/2012"
      page.should have_field 'Valor', :with => '400,00'
      page.should have_field 'Categoria', :with => 'Auxiliar'
    end
  end

  scenario 'destroy an existent pledge' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Empenho apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '2012'
    page.should_not have_content I18n.l(Date.current)
    page.should_not have_content '9,99'
  end

  scenario 'getting and cleaning budget delegated fields depending on budget allocation field' do
    budget_allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      page.should have_disabled_field 'Saldo da dotação'
      page.should have_disabled_field 'Função'
      page.should have_disabled_field 'Subfunção'
      page.should have_disabled_field 'Programa'
      page.should have_disabled_field 'Ação'
      page.should have_disabled_field 'Organograma'
      page.should have_disabled_field 'Natureza da despesa'
      page.should have_field 'Saldo da dotação', :with => ''
      page.should have_field 'Função', :with => ''
      page.should have_field 'Subfunção', :with => ''
      page.should have_field 'Programa', :with => ''
      page.should have_field 'Ação', :with => ''
      page.should have_field 'Organograma', :with => ''
      page.should have_field 'Natureza da despesa', :with => ''

      fill_modal 'Dotação', :with => 'Alocação', :field => 'Descrição'

      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Função', :with => '04 - Administração'
      page.should have_field 'Subfunção', :with => '01 - Administração Geral'
      page.should have_field 'Programa', :with => 'Habitação'
      page.should have_field 'Ação', :with => 'Ação Governamental'
      page.should have_field 'Organograma', :with => 'Secretaria de Educação'
      page.should have_field 'Natureza da despesa', :with => '3.1.90.11.01.00.00.00'

      clear_modal 'Dotação'

      page.should have_field 'Saldo da dotação', :with => ''
      page.should have_field 'Função', :with => ''
      page.should have_field 'Subfunção', :with => ''
      page.should have_field 'Programa', :with => ''
      page.should have_field 'Ação', :with => ''
      page.should have_field 'Organograma', :with => ''
      page.should have_field 'Natureza da despesa', :with => ''
    end
  end
end
