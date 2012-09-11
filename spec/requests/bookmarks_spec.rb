# encoding: utf-8
require 'spec_helper'

feature 'Bookmarks' do
  scenario 'redirects to the blank slate page when have no bookmarks' do
    sign_in

    expect(page).to have_content 'Sua página inicial está vazia.'
    expect(page).to have_content 'Clique no botão abaixo para adicionar atalhos para os cadastros que você mais utiliza.'

    expect(page).to have_link 'Adicionar Cadastros'
  end

  scenario 'shows the bookmarks' do
    Bookmark.make!(:sobrinho)

    sign_in

    expect(page).to have_content 'Adicione os cadastros que você utiliza com frequência para a lista de favoritos.'
    expect(page).to have_content 'Sempre que você acessar o sistema, eles estarão disponíveis aqui para facilitar o seu trabalho.'

    expect(page).to have_link 'Cidades'
    expect(page).to have_link 'Países'
  end

  scenario 'creates bookmarks' do
    sign_in

    click_link 'Adicionar Cadastros'

    select 'Cidades', :from => 'Cadastros'
    select 'Países', :from => 'Cadastros'

    click_button 'Salvar'

    expect(page).to have_link 'Cidades'
    expect(page).to have_link 'Países'

    click_link 'Editar'

    expect(page).to have_select 'Cadastros', :value => ['Cidades', 'Países']
  end

  scenario 'updates bookmarks' do
    Bookmark.make!(:sobrinho)

    sign_in

    click_link 'Editar'

    unselect 'Cidades', :from => 'Cadastros'
    unselect 'Cidades', :from => 'Cadastros'
    select 'Países', :from => 'Cadastros'

    click_button 'Salvar'

    expect(page).to_not have_link 'Cidades'
    expect(page).to have_link 'Países'

    click_link 'Editar'

    expect(page).to have_select 'Cadastros', :value => ['Cidades']
  end

  scenario 'remove all bookmarks and redirect to empty page' do
    Bookmark.make!(:sobrinho)

    sign_in

    click_link 'Editar'

    unselect 'Cidades', :from => 'Cadastros'
    unselect 'Países', :from => 'Cadastros'

    click_button 'Salvar'

    expect(page).to have_content 'Sua página inicial está vazia.'
    expect(page).to have_content 'Clique no botão abaixo para adicionar atalhos para os cadastros que você mais utiliza.'

    expect(page).to have_link 'Adicionar Cadastros'
  end
end
