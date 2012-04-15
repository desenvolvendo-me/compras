# encoding: utf-8
require 'spec_helper'

feature "RevenueNatures" do
  background do
    sign_in
  end

  scenario 'create a new revenue_nature' do
    Entity.make!(:detran)
    RegulatoryAct.make!(:sopa)
    RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

    click_link 'Contabilidade'

    click_link 'Naturezas das Receitas'

    click_link 'Criar Natureza da Receita'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    fill_in 'Classificação', :with => '12344569'
    fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'
    fill_in 'Especificação', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana'
    select 'Ambos', :from => 'Tipo'
    fill_in 'Súmula', :with => 'Registra o valor da arrecadação da receita'

    click_button 'Criar Natureza da Receita'

    page.should have_notice 'Natureza da Receita criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Ato regulamentador', :with => '1234'
    page.should have_field 'Tipo', :with => 'Lei'
    page.should have_field 'Data de publicação', :with => '02/01/2012'
    page.should have_field 'Classificação', :with => '12344569'
    page.should have_field 'Código completo', :with => '1.1.1.2.12344569'
    page.should have_field 'Rúbrica da receita', :with => '2 - IMPOSTOS SOBRE O PATRIMÔNIO E A RENDA'
    page.should have_field 'Especificação', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana'
    page.should have_select 'Tipo', :selected => 'Ambos'
    page.should have_field 'Súmula', :with => 'Registra o valor da arrecadação da receita'
  end

  scenario 'generate full code using js' do
    RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

    click_link 'Contabilidade'

    click_link 'Naturezas das Receitas'

    click_link 'Criar Natureza da Receita'

    fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'
    fill_in 'Classificação', :with => '12344569'

    page.should have_field 'Código completo', :with => '1.1.1.2.12344569'
  end

  scenario 'generate full code using js without classification' do
    RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

    click_link 'Contabilidade'

    click_link 'Naturezas das Receitas'

    click_link 'Criar Natureza da Receita'

    fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'

    page.should have_field 'Código completo', :with => '1.1.1.2.________'
  end

  scenario 'when fill regulatory act should fill/clear regulatory_act_type and publication_date' do
    RegulatoryAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Naturezas das Receitas'

    click_link 'Criar Natureza da Receita'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    page.should have_field 'Tipo', :with => 'Lei'
    page.should have_field 'Data de publicação', :with => '02/01/2012'

    # and should clear fields too
    clear_modal 'Ato regulamentador'

    page.should have_field 'Tipo', :with => ''
    page.should have_field 'Data de publicação', :with => ''
  end

  scenario 'update an existent revenue_nature' do
    Entity.make!(:secretaria_de_educacao)
    RegulatoryAct.make!(:emenda)
    RevenueRubric.make!(:imposto_sobre_a_producao_e_a_circulacao)
    RevenueNature.make!(:imposto)

    click_link 'Contabilidade'

    click_link 'Naturezas das Receitas'

    click_link '1.1.1.2.12344569 - Imposto s/ Propriedade Predial e Territ. Urbana'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Exercício', :with => '2011'
    fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
    fill_in 'Classificação', :with => '11111111'
    fill_modal 'Rúbrica da receita', :with => '3', :field => 'Código'
    fill_in 'Especificação', :with => 'Imposto sobre Propriedade Predial e Territorial Urbana'
    select 'Analítico', :from => 'Tipo'
    fill_in 'Súmula', :with => 'Registra o valor da arrecadação do imposto'

    click_button 'Atualizar Natureza da Receita'

    page.should have_notice 'Natureza da Receita editado com sucesso.'

    click_link '1.1.1.3.11111111 - Imposto sobre Propriedade Predial e Territorial Urbana'

    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Exercício', :with => '2011'
    page.should have_field 'Ato regulamentador', :with => '4567'
    page.should have_field 'Tipo', :with => 'Emenda constitucional'
    page.should have_field 'Data de publicação', :with => '02/01/2012'
    page.should have_field 'Classificação', :with => '11111111'
    page.should have_field 'Código completo', :with => '1.1.1.3.11111111'
    page.should have_field 'Rúbrica da receita', :with => '3 - IMPOSTOS SOBRE A PRODUÇÃO E A CIRCULAÇÃO'
    page.should have_field 'Especificação', :with => 'Imposto sobre Propriedade Predial e Territorial Urbana'
    page.should have_select 'Tipo', :selected => 'Analítico'
    page.should have_field 'Súmula', :with => 'Registra o valor da arrecadação do imposto'
  end

  scenario 'destroy an existent revenue_nature' do
    RevenueNature.make!(:imposto)

    click_link 'Contabilidade'

    click_link 'Naturezas das Receitas'

    click_link '1.1.1.2.12344569 - Imposto s/ Propriedade Predial e Territ. Urbana'

    click_link "Apagar", :confirm => true

    page.should have_notice 'Natureza da Receita apagado com sucesso.'

    page.should_not have_content '1.1.1.2.12344569 - Imposto s/ Propriedade Predial e Territ. Urbana'
  end
end
