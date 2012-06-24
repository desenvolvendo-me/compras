# encoding: utf-8
require 'spec_helper'

feature "RevenueAccountings" do
  background do
    sign_in
  end

  scenario 'create a new revenue_accounting' do
    Descriptor.make!(:detran_2012)
    RevenueNature.make!(:imposto)
    Capability.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link 'Criar Receita Contábel'

    within_tab 'Principal' do
      page.should have_disabled_field 'Código'

      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Natureza da receita', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana', :field => 'Especificação'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
    end

    within_tab 'Programação' do
      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
    end

    click_button 'Salvar'

    page.should have_notice 'Receita Contábel criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2012 - Detran'
      page.should have_field 'Data', :with => I18n.l(Date.current)
      page.should have_disabled_field 'Código'
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto s/ Propriedade Predial e Territ. Urbana'
      page.should have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita'
      page.should have_field 'Recurso', :with => 'Reforma e Ampliação'
    end

    within_tab 'Programação' do
      page.should have_select 'Tipo de programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'create a new revenue_accounting with other descriptor and restart code' do
    RevenueAccounting.make!(:reforma)
    Descriptor.make!(:detran_2011)
    RevenueNature.make!(:imposto_sobre_renda)
    Capability.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link 'Criar Receita Contábel'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Natureza da receita', :with => 'Imposto sobre a renda', :field => 'Especificação'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
    end

    within_tab 'Programação' do
      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
    end

    click_button 'Salvar'

    page.should have_notice 'Receita Contábel criado com sucesso.'

    within_records do
      click_link '1/2011'
    end

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2011 - Detran'
      page.should have_field 'Data', :with => I18n.l(Date.current)
      page.should have_disabled_field 'Código'
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto sobre a renda'
      page.should have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita referente a renda'
      page.should have_field 'Recurso', :with => 'Reforma e Ampliação'
    end

    within_tab 'Programação' do
      page.should have_select 'Tipo de programação', :selected => 'Média de arrecadação mensal dos últimos 3 anos'
    end
  end

  scenario 'fill/clear revenue_natured docket when select revenue_nature' do
    RevenueNature.make!(:imposto)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link 'Criar Receita Contábel'

    within_tab 'Principal' do
      fill_modal 'Natureza da receita', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana', :field => 'Especificação'

      page.should have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto s/ Propriedade Predial e Territ. Urbana'
      page.should have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita'

      clear_modal 'Natureza da receita'
      page.should have_field 'Natureza da receita', :with => ''
      page.should have_field 'Descrição da natureza da receita', :with => ''
    end
  end

  scenario 'should apply month value based on kind and value' do
    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link 'Criar Receita Contábel'

    within_tab 'Programação' do
      page.should have_disabled_field 'Valor previsto'

      select 'Média de arrecadação mensal dos últimos 3 anos', :from => 'Tipo'
      page.should have_field 'Valor previsto', :with => ''
      page.should have_disabled_field 'Valor previsto'
      page.should have_content '0,00'

      select 'Dividir valor previsto por 12', :from => 'Tipo'
      fill_in 'Valor previsto', :with => '222,22'
      page.should have_content '18,51'
      page.should have_content '18,61'
    end
  end

  scenario 'update an existent revenue_accounting' do
    RevenueAccounting.make!(:reforma)
    Descriptor.make!(:secretaria_de_educacao_2011)
    RevenueNature.make!(:imposto_sobre_renda)
    Capability.make!(:construcao)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

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

    page.should have_notice 'Receita Contábel editado com sucesso.'

    click_link '1'

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2011 - Secretaria de Educação'
      page.should have_disabled_field 'Código'
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Natureza da receita', :with => '1.1.1.2.12.34 - Imposto sobre a renda'
      page.should have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita referente a renda'
      page.should have_field 'Recurso', :with => 'Construção'
    end

    within_tab 'Programação' do
      page.should have_select 'Tipo', :selected => 'Dividir valor previsto por 12'
      page.should have_content '18,51'
      page.should have_content '18,61'
    end
  end

  scenario 'validate uniqueness of revenue_nature' do
    RevenueAccounting.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link 'Criar Receita Contábel'

    within_tab 'Principal' do
      fill_modal 'Natureza da receita', :with => 'Imposto s/ Propriedade Predial e Territ. Urbana', :field => 'Especificação'
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'destroy an existent revenue_accounting' do
    RevenueAccounting.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link '1'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Receita Contábel apagado com sucesso.'

    page.should_not have_content '1'
  end
end
