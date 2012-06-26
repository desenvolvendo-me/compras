# encoding: utf-8
require 'spec_helper'

feature "Positions" do
  background do
    sign_in
  end

  scenario 'create a new position' do
    navigate_through 'Outros > Cargos'

    click_link 'Criar Cargo'

    fill_in 'Nome', :with => 'Gerente'

    click_button 'Salvar'

    page.should have_notice 'Cargo criado com sucesso.'

    click_link 'Gerente'

    page.should have_field 'Nome', :with => 'Gerente'
  end

  scenario 'update an existent position' do
    Position.make!(:gerente)

    navigate_through 'Outros > Cargos'

    click_link 'Gerente'

    fill_in 'Nome', :with => 'Gerente de Setor'

    click_button 'Salvar'

    page.should have_notice 'Cargo editado com sucesso.'

    click_link 'Gerente de Setor'

    page.should have_field 'Nome', :with => 'Gerente de Setor'
  end

  scenario 'destroy an existent position' do
    Position.make!(:gerente)

    navigate_through 'Outros > Cargos'

    click_link 'Gerente'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Cargo apagado com sucesso.'

    page.should_not have_content 'Gerente'
  end

  scenario 'validate uniqueness of code' do
    Position.make!(:gerente)

    navigate_through 'Outros > Cargos'

    click_link 'Criar Cargo'

    fill_in 'Nome', :with => 'Gerente'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end
end
