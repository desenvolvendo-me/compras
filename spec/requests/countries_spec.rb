# encoding: utf-8
require 'spec_helper'

feature "Countries" do
  background do
    sign_in
  end

  scenario 'create a new country' do
    click_link 'Cadastros Diversos'

    click_link 'Países'

    click_link 'Criar País'

    fill_in 'Nome', :with => 'Argentina'

    click_button 'Criar País'

    page.should have_notice 'País criado com sucesso.'

    click_link 'Argentina'

    page.should have_field 'Nome', :with => 'Argentina'
  end

  scenario 'update a country' do
    Country.make!(:brasil)

    click_link 'Cadastros Diversos'

    click_link 'Países'

    click_link 'Brasil'

    fill_in 'Nome', :with => 'Argentina'

    click_button 'Atualizar País'

    page.should have_notice 'País editado com sucesso.'

    click_link 'Argentina'

    page.should have_field 'Nome', :with => 'Argentina'
  end

  scenario 'destroy a country' do
    Country.make!(:argentina)

    click_link 'Cadastros Diversos'

    click_link 'Países'

    click_link 'Argentina'

    click_link 'Apagar Argentina', :confirm => true

    page.should have_notice 'País apagado com sucesso.'

    page.should_not have_content 'Argentina'
  end
end
