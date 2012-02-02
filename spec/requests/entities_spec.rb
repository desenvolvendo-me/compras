# encoding: utf-8
require 'spec_helper'

feature "Entities" do
  background do
    sign_in
  end

  scenario 'create a new entity' do
    click_link 'Cadastros Diversos'

    click_link 'Entidades'

    click_link 'Criar Entidade'

    fill_in 'Nome', :with => 'Denatran'

    click_button 'Criar Entidade'

    page.should have_notice 'Entidade criada com sucesso.'

    click_link 'Denatran'

    page.should have_field 'Nome', :with => 'Denatran'
  end

  scenario 'update an existent entity' do
    Entity.make!(:detran)

    click_link 'Cadastros Diversos'

    click_link 'Entidades'

    click_link 'Detran'

    fill_in 'Nome', :with => 'Contran'

    click_button 'Atualizar Entidade'

    page.should have_notice 'Entidade editada com sucesso.'

    click_link 'Contran'

    page.should have_field 'Nome', :with => 'Contran'
  end

  scenario 'destroy an existent entity' do
    Entity.make!(:detran)
    click_link 'Cadastros Diversos'

    click_link 'Entidades'

    click_link 'Detran'

    click_link 'Apagar Detran', :confirm => true

    page.should have_notice 'Entidade apagada com sucesso.'

    page.should_not have_content 'Detran'
  end

  scenario 'should validate uniqueness of name' do
    Entity.make!(:detran)

    click_link 'Cadastros Diversos'

    click_link 'Entidade'

    click_link 'Criar Entidade'

    fill_in 'Nome', :with => 'Detran'

    click_button 'Criar Entidade'

    page.should have_content 'já está em uso'
  end
end
