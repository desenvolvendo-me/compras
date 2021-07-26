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

    expect(page).to have_alert 'Login ou senha inválidos.'
  end

  scenario 'sign in with valid credentials' do
    visit root_path

    fill_in 'Login', :with => 'gabriel.sobrinho'
    fill_in 'Senha', :with => '123456'

    click_button 'Login'

    expect(page).to have_notice 'Login efetuado com sucesso.'
  end

  scenario 'sign out and sign in' do
    visit root_path

    fill_in 'Login', :with => 'gabriel.sobrinho'
    fill_in 'Senha', :with => '123456'

    click_button 'Login'

    expect(page).to have_notice 'Login efetuado com sucesso.'

    click_link 'Sair'

    expect(page).to have_alert 'Por favor, efetue seu login.'
  end

  scenario 'shared account not allowed' do
    sign_in

    current_user.update_attribute(:login_token, 'some_different_thing')

    visit root_path

    expect(page).to have_alert 'Sua conta de usuário foi acessada em outro local. Em caso de dúvida, entre em contato com o administrador.'
  end
end
