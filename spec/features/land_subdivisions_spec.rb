require 'spec_helper'

feature "LandSubdivisions" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new land subdivision' do
    navigate 'Configurações > Parâmetros > Endereços > Loteamentos'

    click_link 'Criar Loteamento'

    fill_in 'Nome', :with => 'Oportunity'

    click_button 'Salvar'

    expect(page).to have_notice 'Loteamento criado com sucesso.'

    click_link 'Oportunity'

    expect(page).to have_field 'Nome', :with => 'Oportunity'

    fill_in 'Nome', :with => 'Monte Verde'

    click_button 'Salvar'

    expect(page).to have_notice 'Loteamento editado com sucesso.'

    click_link 'Monte Verde'

    expect(page).to have_field 'Nome', :with => 'Monte Verde'

    click_link 'Apagar'

    expect(page).to have_notice 'Loteamento apagado com sucesso.'
    expect(page).to_not have_content 'Monte Verde'
  end

  scenario 'index with columns at the index' do
    navigate 'Configurações > Parâmetros > Endereços > Loteamentos'

    within_records do
      expect(page).to have_content 'Nome'

      within 'tbody tr' do
        expect(page).to have_content 'Horizonte a Vista'
      end
    end
  end
end
