require 'spec_helper'

feature "Condominia" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new condominium' do
    navigate 'Configurações > Parâmetros > Endereços > Condomínios'

    click_link 'Criar Condomínio'

    fill_in 'Nome', :with => 'Tambuata 2'
    select 'Vertical', :from => 'Tipo de condomínio'

    click_button 'Salvar'

    expect(page).to have_notice 'Condomínio criado com sucesso.'

    click_link 'Tambuata 2'

    expect(page).to have_field 'Nome', :with => 'Tambuata 2'
    expect(page).to have_select 'Tipo de condomínio', :selected => 'Vertical'

    fill_in 'Nome', :with => 'Parque das Flores 2'

    click_button 'Salvar'

    expect(page).to have_notice 'Condomínio editado com sucesso.'

    click_link 'Parque das Flores 2'

    expect(page).to have_field 'Nome', :with => 'Parque das Flores 2'

    click_link 'Apagar'

    expect(page).to have_notice 'Condomínio apagado com sucesso.'

    expect(page).to_not have_content 'Tambuata 2'
  end

  scenario 'index with columns at the index' do
    navigate 'Configurações > Parâmetros > Endereços > Condomínios'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Tipo de condomínio'

      within 'tbody tr:nth-last-child(1)' do
        expect(page).to have_content 'Tambuata'
        expect(page).to have_content 'Vertical'
      end
    end
  end
end
