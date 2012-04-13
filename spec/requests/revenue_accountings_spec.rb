# encoding: utf-8
require 'spec_helper'

feature "RevenueAccountings" do
  background do
    sign_in
  end

  scenario 'create a new revenue_accounting' do
    Entity.make!(:detran)
    RevenueNature.make!(:imposto)
    Capability.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link 'Criar Receita Contábel'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_in 'Código', :with => '150'
    fill_modal 'Natureza da receita', :with => '2009', :field => 'Exercício'
    fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'

    click_button 'Criar Receita Contábel'

    page.should have_notice 'Receita Contábel criado com sucesso.'

    click_link '150'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Data', :with => I18n.l(Date.current)
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Código', :with => '150'
    page.should have_field 'Natureza da receita', :with => '1.1.1.2.12344569 - Imposto s/ Propriedade Predial e Territ. Urbana'
    page.should have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita'
    page.should have_field 'Recurso', :with => 'Reforma e Ampliação'
  end

  scenario 'fill/clear revenue_natured docket when select revenue_nature' do
    RevenueNature.make!(:imposto)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link 'Criar Receita Contábel'

    fill_modal 'Natureza da receita', :with => '2009', :field => 'Exercício'

    page.should have_field 'Natureza da receita', :with => '1.1.1.2.12344569 - Imposto s/ Propriedade Predial e Territ. Urbana'
    page.should have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita'


    clear_modal 'Natureza da receita'
    page.should have_field 'Natureza da receita', :with => ''
    page.should have_field 'Descrição da natureza da receita', :with => ''
  end

  scenario 'update an existent revenue_accounting' do
    RevenueAccounting.make!(:reforma)
    Entity.make!(:secretaria_de_educacao)
    RevenueNature.make!(:imposto_sobre_renda)
    Capability.make!(:construcao)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link '150'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Exercício', :with => '2011'
    fill_in 'Código', :with => '151'
    fill_modal 'Natureza da receita', :with => '2012', :field => 'Exercício'
    fill_modal 'Recurso', :with => 'Construção', :field => 'Descrição'

    click_button 'Atualizar Receita Contábel'

    page.should have_notice 'Receita Contábel editado com sucesso.'

    click_link '151'

    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Exercício', :with => '2011'
    page.should have_field 'Código', :with => '151'
    page.should have_field 'Natureza da receita', :with => '1.1.1.2.12344569 - Imposto sobre a renda'
    page.should have_field 'Descrição da natureza da receita', :with => 'Registra o valor da arrecadação da receita referente a renda'
    page.should have_field 'Recurso', :with => 'Construção'
  end

  scenario 'validate uniqueness of thing' do
    RevenueAccounting.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link 'Criar Receita Contábel'

    fill_modal 'Natureza da receita', :with => '2009', :field => 'Exercício'

    click_button 'Criar Receita Contábel'

    page.should have_content 'já está em uso'
  end

  scenario 'destroy an existent revenue_accounting' do
    RevenueAccounting.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Receitas Contábeis'

    click_link '150'

    click_link 'Apagar 150', :confirm => true

    page.should have_notice 'Receita Contábel apagado com sucesso.'

    page.should_not have_content '150'
  end
end
