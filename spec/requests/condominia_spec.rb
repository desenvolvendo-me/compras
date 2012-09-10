# encoding:utf-8
require 'spec_helper'

feature "Condominia" do
  background do
    sign_in
  end

  scenario 'create a new condominium' do
    Neighborhood.make!(:sao_francisco)
    Street.make!(:girassol)

    navigate 'Outros > Condomínios'

    click_link 'Criar Condomínio'

    fill_in 'Nome', :with => 'Tambuata'
    select 'Vertical', :from => 'Tipo de condomínio'

    click_button 'Salvar'

    expect(page).to have_notice 'Condomínio criado com sucesso.'

    click_link 'Tambuata'

    expect(page).to have_field 'Nome', :with => 'Tambuata'
    expect(page).to have_select 'Tipo de condomínio', :selected => 'Vertical'
  end

  scenario 'update a condominium' do
    Condominium.make!(:tambuata)

    navigate 'Outros > Condomínios'

    click_link 'Tambuata'

    fill_in 'Nome', :with => 'Parque das Flores'

    click_button 'Salvar'

    expect(page).to have_notice 'Condomínio editado com sucesso.'

    click_link 'Parque das Flores'

    expect(page).to have_field 'Nome', :with => 'Parque das Flores'
  end

  scenario 'destroy a condominium' do
    Condominium.make!(:tambuata)

    navigate 'Outros > Condomínios'

    click_link 'Tambuata'

    click_link 'Apagar'

    expect(page).to have_notice 'Condomínio apagado com sucesso.'

    expect(page).not_to have_content 'Tambuata'
  end
end
