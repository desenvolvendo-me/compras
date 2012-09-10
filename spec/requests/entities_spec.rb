# encoding: utf-8
require 'spec_helper'

feature "Entities" do
  background do
    sign_in
  end

  scenario 'create a new entity' do
    navigate 'Outros > Entidades'

    click_link 'Criar Entidade'

    fill_in 'Nome', :with => 'Denatran'

    click_button 'Salvar'

    expect(page).to have_notice 'Entidade criada com sucesso.'

    click_link 'Denatran'

    expect(page).to have_field 'Nome', :with => 'Denatran'
  end

  scenario 'update an existent entity' do
    Entity.make!(:detran)

    navigate 'Outros > Entidades'

    click_link 'Detran'

    fill_in 'Nome', :with => 'Contran'

    click_button 'Salvar'

    expect(page).to have_notice 'Entidade editada com sucesso.'

    click_link 'Contran'

    expect(page).to have_field 'Nome', :with => 'Contran'
  end

  scenario 'destroy an existent entity' do
    Entity.make!(:detran)

    navigate 'Outros > Entidades'

    click_link 'Detran'

    click_link 'Apagar'

    expect(page).to have_notice 'Entidade apagada com sucesso.'

    expect(page).not_to have_content 'Detran'
  end

  scenario 'should validate uniqueness of name' do
    Entity.make!(:detran)

    navigate 'Outros > Entidades'

    click_link 'Criar Entidade'

    fill_in 'Nome', :with => 'Detran'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
