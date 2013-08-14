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

    expect(page).to have_link 'Usuários'
    expect(page).to have_link 'Perfis'
  end

  scenario 'creates, update and destroy bookmarks' do
    sign_in

    click_link 'Adicionar Cadastros'

    select 'Usuários', :from => 'Cadastros'
    select 'Perfis', :from => 'Cadastros'

    click_button 'Salvar'

    expect(page).to have_content 'Favoritos criado com sucesso.'

    expect(page).to have_link 'Usuários'
    expect(page).to have_link 'Perfis'

    click_link 'Editar'

    expect(page).to have_select 'Cadastros', :selected => ['Usuários', 'Perfis']

    click_link 'Voltar'

    click_link 'Editar'

    unselect 'Usuários', :from => 'Cadastros'
    select 'Perfis', :from => 'Cadastros'

    click_button 'Salvar'

    expect(page).to have_content 'Favoritos editado com sucesso.'

    expect(page).to_not have_link 'Usuários'
    expect(page).to have_link 'Perfis'

    click_link 'Editar'

    expect(page).to have_select 'Cadastros', :selected => 'Perfis'

    select 'Agências', :from => 'Cadastros'
    unselect 'Perfis', :from => 'Cadastros'

    click_button 'Salvar'

    expect(page).to have_content 'Favoritos editado com sucesso.'

    expect(page).to_not have_content 'Sua página inicial está vazia.'
    expect(page).to_not have_content 'Clique no botão abaixo para adicionar atalhos para os cadastros que você mais utiliza.'

    expect(page).to_not have_link 'Adicionar Cadastros'
    expect(page).to     have_link 'Editar'
  end

  scenario 'delete bookmarks and redirect to empty page' do
    Bookmark.make!(:sobrinho)

    sign_in

    click_link 'Editar'

    click_link 'Apagar'

    expect(page).to have_content 'Favoritos apagado com sucesso.'

    expect(page).to have_content 'Sua página inicial está vazia.'
    expect(page).to have_content 'Clique no botão abaixo para adicionar atalhos para os cadastros que você mais utiliza.'

    expect(page).to have_link 'Adicionar Cadastros'
  end

  scenario 'show all links after create for all possible' do
    sign_in

    click_link 'Adicionar Cadastros'

    page.execute_script(%{
      $("#bookmark_link_ids option").each(function(){ $(this).attr("selected", true) })
    })

    click_button 'Salvar'

    expect(page).to have_notice 'Favoritos criado com sucesso.'
  end
end
