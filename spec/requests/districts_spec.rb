# encoding: utf-8
require 'spec_helper'

feature "Districts" do
  background do
    sign_in
  end

  scenario 'create a new district' do
    City.make!(:belo_horizonte)

    click_link 'Cadastros Diversos'

    click_link 'Distritos'

    click_link 'Criar Distrito'

    fill_in 'Nome', :with => 'Leste'
    fill_modal 'Cidade', :with => "Belo Horizonte"

    click_button 'Criar Distrito'

    page.should have_notice 'Distrito criado com sucesso.'

    click_link 'Leste'

    page.should have_field 'Nome', :with => 'Leste'
    page.should have_field 'Cidade', :with => 'Belo Horizonte'
  end

  scenario 'update a district' do
    District.make!(:sul)

    click_link 'Cadastros Diversos'

    click_link 'Distritos'

    click_link 'Sul'

    fill_in 'Nome', :with => 'Oeste'

    click_button 'Atualizar Distrito'

    page.should have_notice 'Distrito editado com sucesso.'

    click_link 'Oeste'

    page.should have_field 'Nome', :with => 'Oeste'
  end

  scenario 'destroy a district' do
    District.make!(:sul)

    click_link 'Cadastros Diversos'

    click_link 'Distritos'

    click_link 'Sul'

    click_link 'Apagar Sul', :confirm => true

    page.should have_notice 'Distrito apagado com sucesso.'

    page.should_not have_content 'Sul'
  end
end
