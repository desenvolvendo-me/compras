# encoding: utf-8
require 'spec_helper'

feature 'Account' do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    sign_in
  end

  scenario 'update login without providing password' do
    click_link 'gabriel.sobrinho'

    fill_in 'Login', :with => 'sobrinho.campos.gabriel'
    fill_in 'E-mail', :with => 'sobrinho.gabriel@gmail.com'

    click_button 'Salvar'

    page.should have_notice 'Usuário editado com sucesso.'

    page.should have_field 'Nome', :with => 'Gabriel Sobrinho'
    page.should have_field 'Login', :with => 'sobrinho.campos.gabriel'
    page.should have_field 'E-mail', :with => 'sobrinho.gabriel@gmail.com'
  end
end
