# encoding:utf-8
require 'spec_helper'

feature "Condominiums" do
  background do
    sign_in
  end

  scenario 'create a new condominium' do
    Neighborhood.make!(:sao_francisco)
    Street.make!(:girassol)

    click_link 'Cadastros Diversos'

    click_link 'Condomínios'

    click_link 'Criar Condomínio'

    fill_in 'Nome', :with => 'Edifício Paulista'
    select 'Vertical', :from => "Tipo de condomínio"

    click_button 'Criar Condomínio'

    page.should have_notice 'Condomínio criado com sucesso.'

    click_link 'Edifício Paulista'

    page.should have_field 'Nome', :with => 'Edifício Paulista'
    page.should have_select 'Tipo de condomínio', :with => "Vertical"
  end

  scenario 'update a condominium' do
    Condominium.make!(:parque_das_flores)

    click_link 'Cadastros Diversos'

    click_link 'Condomínios'

    click_link 'Parque das Flores'

    fill_in 'Nome', :with => 'Parque das Plantas'

    click_button 'Atualizar Condomínio'

    page.should have_notice 'Condomínio editado com sucesso.'

    click_link 'Parque das Plantas'

    page.should have_field 'Nome', :with => 'Parque das Plantas'
  end

  scenario 'destroy a condominium' do
    Condominium.make!(:tambuata)

    click_link 'Cadastros Diversos'

    click_link 'Condomínios'

    click_link 'Tambuata'

    click_link 'Apagar Tambuata', :confirm => true

    page.should have_notice 'Condomínio apagado com sucesso.'

    page.should_not have_content 'Tambuata'
  end
end
