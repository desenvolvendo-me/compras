# encoding: utf-8
require 'spec_helper'

feature "Users" do
  background do
    sign_in
  end

  scenario 'create a new user' do
    Employee.make!(:wenderson)
    Profile.make!(:manager)

    click_link 'Administração'

    click_link 'Usuários'

    click_link 'Criar Usuário'

    within_modal 'Funcionário' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    fill_in 'Login', :with => 'wenderson.malheiros'
    fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    fill_in 'Senha', :with => '123456'
    fill_in 'Confirme a senha', :with => '123456'

    fill_modal 'Perfil', :with => 'Gestor'

    click_button 'Criar Usuário'

    page.should have_notice 'Usuário criado com sucesso.'

    click_link 'wenderson.malheiros'

    page.should have_field 'Funcionário', :with => 'Wenderson Malheiros'
    page.should have_field 'Login', :with => 'wenderson.malheiros'
    page.should have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    page.should have_field 'Senha', :with => ''
    page.should have_field 'Confirme a senha', :with => ''
  end

  scenario 'update an user' do
    Employee.make!(:sobrinho)

    click_link 'Administração'

    click_link 'Usuários'

    within_records do
      click_link 'sobrinho'
    end

    within_modal 'Funcionário' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    click_button 'Atualizar Usuário'

    page.should have_notice 'Usuário editado com sucesso.'

    within_records do
      click_link 'sobrinho'
    end

    page.should have_field 'Funcionário', :with => 'Gabriel Sobrinho'
  end

  scenario 'destroy an user' do
    User.make!(:wenderson)

    click_link 'Administração'

    click_link 'Usuários'

    click_link 'wenderson.malheiros'

    click_link 'Apagar wenderson.malheiros', :confirm => true

    page.should have_notice 'Usuário apagado com sucesso.'

    page.should_not have_content 'Wenderson Malheiros'
  end

  scenario 'open the window to new perfil through the perfil modal' do
    pending 'waiting for https://github.com/thoughtbot/capybara-webkit/pull/314'
    click_link 'Administração'

    click_link 'Usuários'

    click_link 'Criar Usuário'

    within_modal 'Perfil' do
      click_button 'Pesquisar'

      click_link 'Novo'
    end

    within_window(page.driver.browser.window_handles.last) do
      page.should have_content 'Criar Perfil'
    end
  end

end
