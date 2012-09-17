#encoding: utf-8
require 'spec_helper'

feature 'A user confirming your account' do
  let :user_without_password do
    User.make!(:creditor_without_password)
  end

  scenario 'confirming my account' do
    visit "/users/confirmation?confirmation_token=#{user_without_password.confirmation_token}"

    fill_in 'Login', :with => 'sobrinho.creditor'
    fill_in 'Senha', :with => '123abc'
    fill_in 'Confirme a senha', :with => '123abc'

    click_button 'Confirmar'

    expect(page).to have_notice 'Usuário confirmado com sucesso'
  end

  scenario 'users should be redirected to the login page if he tries to reconfirm his account' do
    user_without_password.confirm!

    visit "/users/confirmation?confirmation_token=#{user_without_password.confirmation_token}"

    expect(page).to have_field 'user_login'
    expect(page).to have_field 'user_password'
  end
end
