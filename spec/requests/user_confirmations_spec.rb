#encoding: utf-8
require 'spec_helper'

feature 'A user confirming your account' do
  let :user_without_password do
    User.make!(:creditor_without_password)
  end

  scenario 'confirming my account' do
    visit "/users/confirmation?confirmation_token=#{user_without_password.confirmation_token}"
    
    fill_in 'Senha', :with => '123abc'
    fill_in 'Confirme a senha', :with => '123abc'
    
    click_button 'Confirmar'
    
    page.should have_notice 'Usuário confirmado com sucesso'
  end

  scenario 'can confirm a already confirmed account' do
    user_without_password.confirm!
    
    visit "/users/confirmation?confirmation_token=#{user_without_password.confirmation_token}"

    page.should have_content 'Por favor, efetue seu login.'
  end
end
