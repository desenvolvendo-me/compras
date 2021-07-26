require 'spec_helper'

feature "Profiles" do
  background do
    sign_in
  end

  scenario 'create a new profile, update and destroy an existing' do
    navigate 'Configurações > Usuários > Perfis'

    click_link 'Criar Perfil'

    fill_in 'Nome', :with => 'Gestor 2'

    click_button 'Salvar'

    expect(page).to have_notice 'Perfil criado com sucesso.'

    click_link 'Gestor 2'

    expect(page).to have_field 'Nome', :with => 'Gestor 2'

    fill_in 'Nome', :with => 'Administrador'

    click_button 'Salvar'

    expect(page).to have_notice 'Perfil editado com sucesso.'

    click_link 'Administrador'

    expect(page).to have_field 'Nome', :with => 'Administrador'

    click_link 'Apagar'

    expect(page).to have_notice 'Perfil apagado com sucesso.'

    within_records do
      expect(page).to_not have_content 'Administrador'
    end
  end

  scenario 'index with columns at the index' do
    navigate 'Configurações > Usuários > Perfis'

    within_records do
      expect(page).to have_content 'Nome'

      within 'tbody tr' do
        expect(page).to have_content 'Gestor'
      end
    end
  end
end
