# encoding: utf-8
require 'spec_helper'

feature "SignInAndSignOut" do
  background do
    User.make!(:sobrinho_as_admin)
  end

  scenario 'sign in with invalid credentials' do
    visit root_path

    fill_in 'Login', :with => 'gabriel.sobrinho'
    fill_in 'Senha', :with => '12345'

    click_button 'Login'

    page.should have_alert 'Login ou senha inválidos.'
  end

  scenario 'sign in with valid credentials' do
    visit root_path

    fill_in 'Login', :with => 'gabriel.sobrinho'
    fill_in 'Senha', :with => '123456'

    click_button 'Login'

    page.should have_notice 'Login efetuado com sucesso.'
  end

  scenario 'sign out' do
    visit root_path

    fill_in 'Login', :with => 'gabriel.sobrinho'
    fill_in 'Senha', :with => '123456'

    click_button 'Login'

    page.should have_notice 'Login efetuado com sucesso.'

    click_link 'Sair'

    page.should have_notice 'Logout efetuado com sucesso.'
  end
end
