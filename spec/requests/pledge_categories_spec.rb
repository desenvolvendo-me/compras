# encoding: utf-8
require 'spec_helper'

feature "PledgeCategories" do
  background do
    sign_in
  end

  scenario 'create a new pledge_category' do
    navigate 'Contabilidade > Execução > Empenho > Categorias de Empenho'

    click_link 'Criar Categoria de Empenho'

    fill_in 'Descrição', :with => 'Geral'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    expect(page).to have_notice 'Categoria de Empenho criada com sucesso.'

    click_link 'Geral'

    expect(page).to have_field 'Descrição', :with => 'Geral'
    expect(page).to have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent pledge_category' do
    PledgeCategory.make!(:geral)

    navigate 'Contabilidade > Execução > Empenho > Categorias de Empenho'

    click_link 'Geral'

    fill_in 'Descrição', :with => 'Municipal'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    expect(page).to have_notice 'Categoria de Empenho editada com sucesso.'

    click_link 'Municipal'

    expect(page).to have_field 'Descrição', :with => 'Municipal'
    expect(page).to have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent pledge_category' do
    PledgeCategory.make!(:geral)

    navigate 'Contabilidade > Execução > Empenho > Categorias de Empenho'

    click_link 'Geral'

    click_link 'Apagar'

    expect(page).to have_notice 'Categoria de Empenho apagada com sucesso.'

    expect(page).not_to have_content 'Geral'
    expect(page).not_to have_content 'Ativo'
  end

  scenario 'validate uniqueness of description' do
    PledgeCategory.make!(:geral)

    navigate 'Contabilidade > Execução > Empenho > Categorias de Empenho'

    click_link 'Criar Categoria de Empenho'

    fill_in 'Descrição', :with => 'Geral'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
