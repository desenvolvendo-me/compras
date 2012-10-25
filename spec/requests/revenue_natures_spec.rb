# encoding: utf-8
require 'spec_helper'

feature "RevenueNatures" do
  background do
    sign_in
  end

  scenario 'create a new revenue_nature' do
    Descriptor.make!(:detran_2012)
    RegulatoryAct.make!(:sopa)
    RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

    click_link 'Criar Natureza da Receita'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    fill_modal 'Categoria da receita', :with => '1', :field => 'Código'
    fill_modal 'Subcategoria da receita', :with => '1', :field => 'Código'
    fill_modal 'Fonte da receita', :with => '1', :field => 'Código'
    fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'
    fill_in 'Classificação', :with => '12.34'
    fill_in 'Especificação', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana'
    select 'Ambos', :from => 'Tipo'
    fill_in 'Súmula', :with => 'Registra o valor da arrecadação da receita'

    click_button 'Salvar'

    expect(page).to have_notice 'Natureza da Receita criada com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
    expect(page).to have_field 'Tipo', :with => 'Lei'
    expect(page).to have_field 'Data de publicação', :with => '02/01/2012'
    expect(page).to have_field 'Classificação', :with => '12.34'
    expect(page).to have_field 'Natureza da receita', :with => '1.1.1.2.12.34'
    expect(page).to have_field 'Rúbrica da receita', :with => '2 - IMPOSTOS SOBRE O PATRIMÔNIO E A RENDA'
    expect(page).to have_field 'Especificação', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana'
    expect(page).to have_select 'Tipo', :selected => 'Ambos'
    expect(page).to have_field 'Súmula', :with => 'Registra o valor da arrecadação da receita'
  end

  scenario 'generate full code using js' do
    RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

    click_link 'Criar Natureza da Receita'

    fill_modal 'Categoria da receita', :with => '1', :field => 'Código'
    expect(page).to have_field 'Natureza da receita', :with => '1.0.0.0.00.00'

    fill_modal 'Subcategoria da receita', :with => '1', :field => 'Código'
    expect(page).to have_field 'Natureza da receita', :with => '1.1.0.0.00.00'

    fill_modal 'Fonte da receita', :with => '1', :field => 'Código'
    expect(page).to have_field 'Natureza da receita', :with => '1.1.1.0.00.00'

    fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'
    expect(page).to have_field 'Natureza da receita', :with => '1.1.1.2.00.00'

    fill_in 'Classificação', :with => '12.34'
    expect(page).to have_field 'Natureza da receita', :with => '1.1.1.2.12.34'
  end

  context 'should cascate clear fields' do
    scenario 'when clear category' do
      RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Criar Natureza da Receita'

      fill_modal 'Categoria da receita', :with => '1', :field => 'Código'
      fill_modal 'Subcategoria da receita', :with => '1', :field => 'Código'
      fill_modal 'Fonte da receita', :with => '1', :field => 'Código'
      fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'
      fill_in 'Classificação', :with => '12.34'

      clear_modal 'Categoria da receita'

      expect(page).to have_field 'Categoria da receita', :with => ''
      expect(page).to have_disabled_field 'Subcategoria da receita'
      expect(page).to have_field 'Subcategoria da receita', :with => ''
      expect(page).to have_disabled_field 'Fonte da receita'
      expect(page).to have_field 'Fonte da receita', :with => ''
      expect(page).to have_disabled_field 'Rúbrica da receita'
      expect(page).to have_field 'Rúbrica da receita', :with => ''
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_field 'Classificação', :with => ''
      expect(page).to have_field 'Natureza da receita', :with => '0.0.0.0.00.00'
    end

    scenario 'when clear subcategory' do
      RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Criar Natureza da Receita'

      fill_modal 'Categoria da receita', :with => '1', :field => 'Código'
      fill_modal 'Subcategoria da receita', :with => '1', :field => 'Código'
      fill_modal 'Fonte da receita', :with => '1', :field => 'Código'
      fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'
      fill_in 'Classificação', :with => '12.34'

      clear_modal 'Subcategoria da receita'

      expect(page).to have_field 'Categoria da receita', :with => '1 - RECEITAS CORRENTES'
      expect(page).to have_field 'Subcategoria da receita', :with => ''
      expect(page).to have_disabled_field 'Fonte da receita'
      expect(page).to have_field 'Fonte da receita', :with => ''
      expect(page).to have_disabled_field 'Rúbrica da receita'
      expect(page).to have_field 'Rúbrica da receita', :with => ''
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_field 'Classificação', :with => ''
      expect(page).to have_field 'Natureza da receita', :with => '1.0.0.0.00.00'
    end

    scenario 'when clear source' do
      RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Criar Natureza da Receita'

      fill_modal 'Categoria da receita', :with => '1', :field => 'Código'
      fill_modal 'Subcategoria da receita', :with => '1', :field => 'Código'
      fill_modal 'Fonte da receita', :with => '1', :field => 'Código'
      fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'
      fill_in 'Classificação', :with => '12.34'

      clear_modal 'Fonte da receita'

      expect(page).to have_field 'Categoria da receita', :with => '1 - RECEITAS CORRENTES'
      expect(page).to have_field 'Subcategoria da receita', :with => '1 - RECEITA TRIBUTÁRIA'
      expect(page).to have_field 'Fonte da receita', :with => ''
      expect(page).to have_disabled_field 'Rúbrica da receita'
      expect(page).to have_field 'Rúbrica da receita', :with => ''
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_field 'Classificação', :with => ''
      expect(page).to have_field 'Natureza da receita', :with => '1.1.0.0.00.00'
    end

    scenario 'when clear rubric' do
      RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Criar Natureza da Receita'

      fill_modal 'Categoria da receita', :with => '1', :field => 'Código'
      fill_modal 'Subcategoria da receita', :with => '1', :field => 'Código'
      fill_modal 'Fonte da receita', :with => '1', :field => 'Código'
      fill_modal 'Rúbrica da receita', :with => '2', :field => 'Código'
      fill_in 'Classificação', :with => '12.34'

      clear_modal 'Rúbrica da receita'

      expect(page).to have_field 'Categoria da receita', :with => '1 - RECEITAS CORRENTES'
      expect(page).to have_field 'Subcategoria da receita', :with => '1 - RECEITA TRIBUTÁRIA'
      expect(page).to have_field 'Fonte da receita', :with => '1 - IMPOSTOS'
      expect(page).to have_field 'Rúbrica da receita', :with => ''
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_field 'Classificação', :with => ''
      expect(page).to have_field 'Natureza da receita', :with => '1.1.1.0.00.00'
    end
  end

  scenario 'when fill regulatory act should fill/clear regulatory_act_type and publication_date' do
    RegulatoryAct.make!(:sopa)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

    click_link 'Criar Natureza da Receita'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    expect(page).to have_field 'Tipo', :with => 'Lei'
    expect(page).to have_field 'Data de publicação', :with => '02/01/2012'

    # and should clear fields too
    clear_modal 'Ato regulamentador'

    expect(page).to have_field 'Tipo', :with => ''
    expect(page).to have_field 'Data de publicação', :with => ''
  end

  scenario 'update an existent revenue_nature' do
    Descriptor.make!(:secretaria_de_educacao_2011)
    RegulatoryAct.make!(:emenda)
    RevenueRubric.make!(:imposto_sobre_a_producao_e_a_circulacao)
    RevenueNature.make!(:imposto)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

    click_link '1.1.1.2.12.34 - Imposto s/ Propriedade Predial e Territ. Urbana'

    fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
    fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
    fill_in 'Classificação', :with => '11.11'
    fill_modal 'Rúbrica da receita', :with => '3', :field => 'Código'
    fill_in 'Especificação', :with => 'Imposto sobre Propriedade Predial e Territorial Urbana'
    select 'Analítico', :from => 'Tipo'
    fill_in 'Súmula', :with => 'Registra o valor da arrecadação do imposto'

    click_button 'Salvar'

    expect(page).to have_notice 'Natureza da Receita editada com sucesso.'

    click_link '1.1.1.3.11.11 - Imposto sobre Propriedade Predial e Territorial Urbana'

    expect(page).to have_field 'Descritor', :with => '2011 - Secretaria de Educação'
    expect(page).to have_field 'Ato regulamentador', :with => 'Emenda constitucional 4567'
    expect(page).to have_field 'Tipo', :with => 'Emenda constitucional'
    expect(page).to have_field 'Data de publicação', :with => '02/01/2012'
    expect(page).to have_field 'Classificação', :with => '11.11'
    expect(page).to have_field 'Natureza da receita', :with => '1.1.1.3.11.11'
    expect(page).to have_field 'Rúbrica da receita', :with => '3 - IMPOSTOS SOBRE A PRODUÇÃO E A CIRCULAÇÃO'
    expect(page).to have_field 'Especificação', :with => 'Imposto sobre Propriedade Predial e Territorial Urbana'
    expect(page).to have_select 'Tipo', :selected => 'Analítico'
    expect(page).to have_field 'Súmula', :with => 'Registra o valor da arrecadação do imposto'
  end

  scenario 'destroy an existent revenue_nature' do
    RevenueNature.make!(:imposto)

    navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

    click_link '1.1.1.2.12.34 - Imposto s/ Propriedade Predial e Territ. Urbana'

    click_link "Apagar"

    expect(page).to have_notice 'Natureza da Receita apagada com sucesso.'

    expect(page).to_not have_content '1.1.1.2.12.34 - Imposto s/ Propriedade Predial e Territ. Urbana'
  end

  context 'filtering' do
    scenario 'should filter by revenue_nature' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      fill_in 'Natureza da receita', :with => '1.1.1.2.12.34'

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end

    scenario 'should filter by specification' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      fill_in 'Especificação', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana'

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end

    scenario 'should filter by descriptor' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      within_modal 'Descritor' do
        fill_in 'Exercício', :with => '2009'

        click_button 'Pesquisar'

        click_record '2009'
      end

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end

    scenario 'should filter by kind' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      select 'Ambos', :from => 'Tipo'

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end

    scenario 'should filter by revenue_category' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      within_modal 'Categoria da receita' do
        fill_in 'Código', :with => '1'

        click_button 'Pesquisar'

        click_record 'RECEITAS CORRENTES'
      end

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end

    scenario 'should filter by revenue_subcategory' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      within_modal 'Subcategoria da receita' do
        fill_in 'Código', :with => '1'

        click_button 'Pesquisar'

        click_record 'RECEITA TRIBUTÁRIA'
      end

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end

    scenario 'should filter by revenue_source' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      within_modal 'Fonte da receita' do
        fill_in 'Código', :with => '1'

        click_button 'Pesquisar'

        click_record 'IMPOSTOS'
      end

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end

    scenario 'should filter by revenue_rubric' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      within_modal 'Rúbrica da receita' do
        fill_in 'Código', :with => '2'

        click_button 'Pesquisar'

        click_record 'IMPOSTOS SOBRE O PATRIMÔNIO E A RENDA'
      end

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end

    scenario 'should filter by classification' do
      RevenueNature.make!(:imposto)
      RevenueNature.make!(:receitas_intra_orcamentaria)

      navigate 'Outros > Contabilidade > Orçamento > Receita Orçamentária > Naturezas das Receitas'

      click_link 'Filtrar Naturezas das Receitas'

      fill_in 'Classificação', :with => '12.34'

      click_button 'Pesquisar'

      expect(page).to have_content '1.1.1.2.12.34'
      expect(page).to_not have_content '7.9.4.0.00.00'
    end
  end
end
