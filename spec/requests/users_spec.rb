# encoding: utf-8
require 'spec_helper'

feature "Users" do
  background do
    sign_in
  end

  scenario 'create a new user' do
    Profile.make!(:manager)

    click_link 'Administração'

    click_link 'Usuários'

    click_link 'Criar Usuário'

    fill_in 'Nome', :with => 'Wenderson Malheiros'
    fill_in 'Login', :with => 'wenderson.malheiros'
    fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    fill_in 'Senha', :with => '123456'
    fill_in 'Confirme a senha', :with => '123456'

    fill_modal 'Perfil', :with => 'Gestor'

    click_button 'Criar Usuário'

    page.should have_notice 'Usuário criado com sucesso.'

    click_link 'Wenderson Malheiros'

    page.should have_field 'Nome', :with => 'Wenderson Malheiros'
    page.should have_field 'Login', :with => 'wenderson.malheiros'
    page.should have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    page.should have_field 'Senha', :with => ''
    page.should have_field 'Confirme a senha', :with => ''
  end

  scenario 'update an user' do
    click_link 'Administração'

    click_link 'Usuários'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    fill_in 'Nome', :with => 'Gabriel Campos Sobrinho'

    click_button 'Atualizar Usuário'

    page.should have_notice 'Usuário editado com sucesso.'

    within_records do
      click_link 'Gabriel Campos Sobrinho'
    end

    page.should have_field 'Nome', :with => 'Gabriel Campos Sobrinho'
  end

  scenario 'destroy an user' do
    User.make!(:wenderson)

    click_link 'Administração'

    click_link 'Usuários'

    click_link 'Wenderson Malheiros'

    click_link 'Apagar Wenderson Malheiros', :confirm => true

    page.should have_notice 'Usuário apagado com sucesso.'

    page.should_not have_content 'Wenderson Malheiros'
  end
end
