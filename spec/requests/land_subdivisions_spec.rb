# encoding: utf-8
require 'spec_helper'

feature "LandSubdivisions" do
  background do
    sign_in
  end

  scenario 'create a new land subdivision' do
    click_link 'Cadastros Diversos'

    click_link 'Loteamentos'

    click_link 'Criar Loteamento'

    fill_in 'Nome', :with => 'Oportunity'

    click_button 'Criar Loteamento'

    page.should have_notice 'Loteamento criado com sucesso.'

    click_link 'Oportunity'

    page.should have_field 'Nome', :with => 'Oportunity'
  end

  scenario 'update a land subdivision' do
    LandSubdivision.make!(:solar_da_serra)

    click_link 'Cadastros Diversos'

    click_link 'Loteamentos'

    click_link 'Solar da Serra'

    fill_in 'Nome', :with => 'Monte Verde'

    click_button 'Atualizar Loteamento'

    page.should have_notice 'Loteamento editado com sucesso.'

    click_link 'Monte Verde'

    page.should have_field 'Nome', :with => 'Monte Verde'
  end

  scenario 'destroy a land subdivision' do
    LandSubdivision.make!(:terra_prometida)

    click_link 'Cadastros Diversos'

    click_link 'Loteamentos'

    click_link 'Terra Prometida'

    click_link 'Apagar Terra Prometida', :confirm => true

    page.should have_notice 'Loteamento apagado com sucesso.'

    within_records do
      page.should_not have_content 'Terra Prometida'
    end
  end
end
