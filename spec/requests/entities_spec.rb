# encoding: utf-8
require 'spec_helper'

feature "Entities" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new entity' do
    navigate 'Geral > Parâmetros > Entidades'

    click_link 'Criar Entidade'

    fill_in 'Nome', :with => 'Denatran'

    click_button 'Salvar'

    expect(page).to have_notice 'Entidade criada com sucesso.'

    click_link 'Denatran'

    expect(page).to have_field 'Nome', :with => 'Denatran'

    fill_in 'Nome', :with => 'Contran'

    click_button 'Salvar'

    expect(page).to have_notice 'Entidade editada com sucesso.'

    click_link 'Contran'

    expect(page).to have_field 'Nome', :with => 'Contran'

    click_link 'Apagar'

    expect(page).to have_notice 'Entidade apagada com sucesso.'

    expect(page).to_not have_content 'Contran'
  end

  scenario 'index with columns at the index' do
    Entity.make!(:detran)

    navigate 'Geral > Parâmetros > Entidades'

    within_records do
      expect(page).to have_content 'Nome'

      within 'tbody tr' do
        expect(page).to have_content 'Detran'
      end
    end
  end
end
