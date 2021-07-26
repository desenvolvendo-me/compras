require 'spec_helper'

feature "Positions" do
  background do
    sign_in
  end

  scenario 'create a new position, update and destroy an existing' do
    navigate 'Configurações > Usuários > Cargos'

    click_link 'Criar Cargo'

    fill_in 'Nome', :with => 'Gerente 2'

    click_button 'Salvar'

    expect(page).to have_notice 'Cargo criado com sucesso.'

    click_link 'Gerente 2'

    expect(page).to have_field 'Nome', :with => 'Gerente 2'

    fill_in 'Nome', :with => 'Gerente de Setor'

    click_button 'Salvar'

    expect(page).to have_notice 'Cargo editado com sucesso.'

    click_link 'Gerente de Setor'

    expect(page).to have_field 'Nome', :with => 'Gerente de Setor'

    click_link 'Apagar'

    expect(page).to have_notice 'Cargo apagado com sucesso.'
    expect(page).to_not have_content 'Gerente de Setor'
  end

  scenario 'index with columns at the index' do
    navigate 'Configurações > Usuários > Cargos'

    within_records do
      expect(page).to have_content 'Nome'

      within 'tbody tr' do
        expect(page).to have_content 'Gerente'
      end
    end
  end
end
