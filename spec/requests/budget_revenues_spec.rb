# encoding: utf-8
require 'spec_helper'

feature "BudgetRevenues" do
  background do
    sign_in
  end

  scenario 'create a new budget_revenue' do
    Descriptor.make!(:detran_2012)
    RevenueNature.make!(:imposto)
    Capability.make!(:reforma)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Receitas Orçamentarias'

    click_link 'Criar Receita Orçamentaria'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Código'

      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Natureza da receita', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana', :field => 'Especificação'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
    end

    within_tab 'Programação' do
      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Receita Orçamentaria criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2012 - Detran'
      expect(page).to have_field 'Data', :with => I18n.l(Date.current)
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto s/ Propriedade Predial e Territ. Urbana'
      expect(page).to have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita'
      expect(page).to have_field 'Recurso', :with => 'Reforma e Ampliação'
    end

    within_tab 'Programação' do
      expect(page).to have_select 'Tipo de programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'create a new budget_revenue with same descriptor and use 1 as code' do
    BudgetRevenue.make!(:reforma)
    RevenueNature.make!(:imposto_sobre_renda)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Receitas Orçamentarias'

    click_link 'Criar Receita Orçamentaria'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Natureza da receita', :with => 'Imposto sobre a renda', :field => 'Especificação'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
    end

    within_tab 'Programação' do
      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Receita Orçamentaria criado com sucesso.'

    within_records do
      click_link '2/2012'
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2012 - Detran'
      expect(page).to have_field 'Data', :with => I18n.l(Date.current)
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '2'
      expect(page).to have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto sobre a renda'
      expect(page).to have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita referente a renda'
      expect(page).to have_field 'Recurso', :with => 'Reforma e Ampliação'
    end

    within_tab 'Programação' do
      expect(page).to have_select 'Tipo de programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'create a new budget_revenue with other descriptor and restart code' do
    BudgetRevenue.make!(:reforma)
    Descriptor.make!(:detran_2011)
    RevenueNature.make!(:imposto_sobre_renda)
    Capability.make!(:reforma)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Receitas Orçamentarias'

    click_link 'Criar Receita Orçamentaria'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Natureza da receita', :with => 'Imposto sobre a renda', :field => 'Especificação'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
    end

    within_tab 'Programação' do
      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Receita Orçamentaria criado com sucesso.'

    within_records do
      click_link '1/2011'
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2011 - Detran'
      expect(page).to have_field 'Data', :with => I18n.l(Date.current)
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto sobre a renda'
      expect(page).to have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita referente a renda'
      expect(page).to have_field 'Recurso', :with => 'Reforma e Ampliação'
    end

    within_tab 'Programação' do
      expect(page).to have_select 'Tipo de programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'fill/clear revenue_natured docket when select revenue_nature' do
    RevenueNature.make!(:imposto)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Receitas Orçamentarias'

    click_link 'Criar Receita Orçamentaria'

    within_tab 'Principal' do
      fill_modal 'Natureza da receita', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana', :field => 'Especificação'

      expect(page).to have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto s/ Propriedade Predial e Territ. Urbana'
      expect(page).to have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita'

      clear_modal 'Natureza da receita'
      expect(page).to have_field 'Natureza da receita', :with => ''
      expect(page).to have_field 'Descrição da natureza da receita', :with => ''
    end
  end

  scenario 'should apply month value based on kind and value' do
    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Receitas Orçamentarias'

    click_link 'Criar Receita Orçamentaria'

    within_tab 'Programação' do
      expect(page).to have_disabled_field 'Valor previsto'

      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
      expect(page).to have_field 'Valor previsto', :with => ''
      expect(page).to have_disabled_field 'Valor previsto'
      expect(page).to have_content '0,00'

      select 'Dividir valor previsto por 12', :from => 'Tipo'
      fill_in 'Valor previsto', :with => '222,22'
      expect(page).to have_content '18,51'
      expect(page).to have_content '18,61'
    end
  end

  scenario 'update an existent budget_revenue' do
    BudgetRevenue.make!(:reforma)
    Descriptor.make!(:secretaria_de_educacao_2011)
    RevenueNature.make!(:imposto_sobre_renda)
    Capability.make!(:construcao)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Receitas Orçamentarias'

    click_link '1'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Natureza da receita', :with => 'Imposto sobre a renda', :field => 'Especificação'
      fill_modal 'Recurso', :with => 'Construção', :field => 'Descrição'
    end

    within_tab 'Programação' do
      select 'Dividir valor previsto por 12', :from => 'Tipo'
      fill_in 'Valor previsto', :with => '222,22'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Receita Orçamentaria editado com sucesso.'

    click_link '1'

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2011 - Secretaria de Educação'
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto sobre a renda'
      expect(page).to have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita referente a renda'
      expect(page).to have_field 'Recurso', :with => 'Construção'
    end

    within_tab 'Programação' do
      expect(page).to have_select 'Tipo', :selected => 'Dividir valor previsto por 12'
      expect(page).to have_content '18,51'
      expect(page).to have_content '18,61'
    end
  end

  scenario 'destroy an existent budget_revenue' do
    BudgetRevenue.make!(:reforma)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Receitas Orçamentarias'

    click_link '1'

    click_link 'Apagar'

    expect(page).to have_notice 'Receita Orçamentaria apagado com sucesso.'

    expect(page).to_not have_content '1'
  end
end
