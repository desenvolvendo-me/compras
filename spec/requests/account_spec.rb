# encoding: utf-8
require 'spec_helper'

feature 'Account' do
  background do
    sign_in
  end

  scenario 'update name without providing password' do
    click_link 'Gabriel Sobrinho'

    fill_in 'Nome', :with => 'Sobrinho, Gabriel'
    fill_in 'Login', :with => 'sobrinho.gabriel'
    fill_in 'E-mail', :with => 'sobrinho.gabriel@gmail.com'

    click_button 'Salvar'

    page.should have_notice 'Usuário editado com sucesso.'

    page.should have_field 'Nome', :with => 'Sobrinho, Gabriel'
    page.should have_field 'Login', :with => 'sobrinho.gabriel'
    page.should have_field 'E-mail', :with => 'sobrinho.gabriel@gmail.com'
  end
end
