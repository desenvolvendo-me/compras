# encoding: utf-8
require 'spec_helper'

feature "Countries" do
  background do
    sign_in
  end

  scenario 'create a new country' do
    navigate 'Outros > Países'

    click_link 'Criar País'

    fill_in 'Nome', :with => 'Argentina'

    click_button 'Salvar'

    expect(page).to have_notice 'País criado com sucesso.'

    click_link 'Argentina'

    expect(page).to have_field 'Nome', :with => 'Argentina'
  end

  scenario 'update a country' do
    Country.make!(:brasil)

    navigate 'Outros > Países'

    click_link 'Brasil'

    fill_in 'Nome', :with => 'Argentina'

    click_button 'Salvar'

    expect(page).to have_notice 'País editado com sucesso.'

    click_link 'Argentina'

    expect(page).to have_field 'Nome', :with => 'Argentina'
  end

  scenario 'destroy a country' do
    Country.make!(:argentina)

    navigate 'Outros > Países'

    click_link 'Argentina'

    click_link 'Apagar'

    expect(page).to have_notice 'País apagado com sucesso.'

    expect(page).not_to have_content 'Argentina'
  end
end
