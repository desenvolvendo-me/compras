# encoding: utf-8
require 'spec_helper'

feature "TypeOfAdministractiveActs" do
  background do
    sign_in
  end

  scenario 'create a new type_of_administractive_act' do
    click_link 'Cadastros Diversos'

    click_link 'Tipos de Ato Administrativo'

    click_link 'Criar Tipo de Ato Administrativo'

    fill_in 'Nome', :with => 'Lei'

    click_button 'Criar Tipo de Ato Administrativo'

    page.should have_notice 'Tipo de Ato Administrativo criado com sucesso.'

    click_link 'Lei'

    page.should have_field 'Nome', :with => 'Lei'
  end

  scenario 'update an existent type_of_administractive_act' do
    TypeOfAdministractiveAct.make!(:lei)

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Ato Administrativo'

    click_link 'Lei'

    fill_in 'Nome', :with => 'Outra Lei'

    click_button 'Atualizar Tipo de Ato Administrativo'

    page.should have_notice 'Tipo de Ato Administrativo editado com sucesso.'

    click_link 'Outra Lei'

    page.should have_field 'Nome', :with => 'Outra Lei'
  end

  scenario 'destroy an existent type_of_administractive_act' do
    TypeOfAdministractiveAct.make!(:lei)

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Ato Administrativo'

    click_link 'Lei'

    click_link 'Apagar Lei', :confirm => true

    page.should have_notice 'Tipo de Ato Administrativo apagado com sucesso.'

    page.should_not have_content 'Lei'
  end
end
