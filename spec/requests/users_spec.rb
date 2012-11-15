# encoding: utf-8
require 'spec_helper'

feature "Users" do
  background do
    sign_in
  end

  scenario 'create a new user' do
    Employee.make!(:wenderson)
    Profile.make!(:manager)

    navigate 'Geral > Usuários > Usuários'

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

    click_button 'Salvar'

    expect(page).to have_notice 'Usuário criado com sucesso.'

    click_link 'wenderson.malheiros'

    expect(page).to have_field 'Funcionário', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Login', :with => 'wenderson.malheiros'
    expect(page).to have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    expect(page).to have_field 'Senha', :with => ''
    expect(page).to have_field 'Confirme a senha', :with => ''
  end

  scenario 'update an user' do
    User.make!(:wenderson)
    Employee.make!(:sobrinho)

    navigate 'Geral > Usuários > Usuários'

    within_records do
      click_link 'wenderson.malheiros'
    end

    within_modal 'Funcionário' do
      click_button 'Pesquisar'
      click_record 'Gabriel Sobrinho'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Usuário editado com sucesso.'

    within_records do
      click_link 'wenderson.malheiros'
    end

    expect(page).to have_field 'Funcionário', :with => 'Gabriel Sobrinho'
  end

  scenario 'destroy an user' do
    User.make!(:wenderson)

    navigate 'Geral > Usuários > Usuários'

    click_link 'wenderson.malheiros'

    click_link 'Apagar'

    expect(page).to have_notice 'Usuário apagado com sucesso.'

    expect(page).to_not have_content 'Wenderson Malheiros'
  end

  scenario 'open the window to new perfil through the perfil modal' do
    navigate 'Geral > Usuários > Usuários'

    click_link 'Criar Usuário'

    within_modal 'Perfil' do
      click_button 'Pesquisar'

      expect(page).to have_link 'Novo', :href => new_profile_path
    end
  end

  scenario 'should list only users with authenticable_type == employee' do
    User.make!(:wenderson)
    User.make!(:sobrinho_as_admin)
    User.make!(:creditor_with_password)

    navigate 'Geral > Usuários > Usuários'

    within_records do
      expect(page).to have_link 'wenderson.malheiros'
      expect(page).to_not have_link 'gabriel.sobrinho'
      expect(page).to_not have_link 'sobrinhosa'

      expect(page).to have_css 'a', :count => 1
    end
  end

  scenario 'translate message when was already authenticated' do
    visit new_user_session_path

    expect(page).to have_alert 'Você já está autenticado.'
  end
end
