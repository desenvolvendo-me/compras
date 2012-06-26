# encoding: utf-8
require 'spec_helper'

feature "States" do
  background do
    sign_in
  end

  scenario 'create a new state' do
    Country.make!(:brasil)

    navigate_through 'Outros > Estados'

    click_link 'Criar Estado'

    fill_in 'Nome', :with => 'Minas Gerais'
    fill_in 'Sigla', :with => 'MG'
    fill_modal 'País', :with => 'Brasil'

    click_button 'Salvar'

    page.should have_notice 'Estado criado com sucesso.'

    click_link 'Minas Gerais'

    page.should have_field 'Nome', :with => 'Minas Gerais'
    page.should have_field 'Sigla', :with => 'MG'
    page.should have_field 'País', :with => 'Brasil'
  end

  scenario 'update a state' do
    rs = State.make!(:rs)

    navigate_through 'Outros > Estados'

    click_link 'Rio Grande do Sul'

    fill_in 'Nome', :with => 'Rio Grande do Norte'

    click_button 'Salvar'

    page.should have_notice 'Estado editado com sucesso.'

    click_link 'Rio Grande do Norte'

    page.should have_field 'Nome', :with => 'Rio Grande do Norte'
  end

  scenario 'destroy a state' do
    rs = State.make!(:rs)

    navigate_through 'Outros > Estados'

    click_link 'Rio Grande do Sul'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Estado apagado com sucesso.'

    page.should_not have_content 'Rio Grande do Sul'
    page.should_not have_content 'RS'
  end
end
