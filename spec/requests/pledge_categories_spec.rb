# encoding: utf-8
require 'spec_helper'

feature "PledgeCategories" do
  background do
    sign_in
  end

  scenario 'create a new pledge_category' do
    navigate_through 'Contabilidade > Empenho > Categorias de Empenho'

    click_link 'Criar Categoria de Empenho'

    fill_in 'Descrição', :with => 'Geral'
    page.should have_disabled_field 'Status'
    page.should have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    page.should have_notice 'Categoria de Empenho criada com sucesso.'

    click_link 'Geral'

    page.should have_field 'Descrição', :with => 'Geral'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent pledge_category' do
    PledgeCategory.make!(:geral)

    navigate_through 'Contabilidade > Empenho > Categorias de Empenho'

    click_link 'Geral'

    fill_in 'Descrição', :with => 'Municipal'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    page.should have_notice 'Categoria de Empenho editada com sucesso.'

    click_link 'Municipal'

    page.should have_field 'Descrição', :with => 'Municipal'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent pledge_category' do
    PledgeCategory.make!(:geral)

    navigate_through 'Contabilidade > Empenho > Categorias de Empenho'

    click_link 'Geral'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Categoria de Empenho apagada com sucesso.'

    page.should_not have_content 'Geral'
    page.should_not have_content 'Ativo'
  end

  scenario 'validate uniqueness of description' do
    PledgeCategory.make!(:geral)

    navigate_through 'Contabilidade > Empenho > Categorias de Empenho'

    click_link 'Criar Categoria de Empenho'

    fill_in 'Descrição', :with => 'Geral'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end
end
