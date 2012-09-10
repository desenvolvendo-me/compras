# encoding: utf-8
require 'spec_helper'

feature "LandSubdivisions" do
  background do
    sign_in
  end

  scenario 'create a new land subdivision' do
    navigate 'Outros > Loteamentos'

    click_link 'Criar Loteamento'

    fill_in 'Nome', :with => 'Oportunity'

    click_button 'Salvar'

    expect(page).to have_notice 'Loteamento criado com sucesso.'

    click_link 'Oportunity'

    expect(page).to have_field 'Nome', :with => 'Oportunity'
  end

  scenario 'update a land subdivision' do
    LandSubdivision.make!(:solar_da_serra)

    navigate 'Outros > Loteamentos'

    click_link 'Solar da Serra'

    fill_in 'Nome', :with => 'Monte Verde'

    click_button 'Salvar'

    expect(page).to have_notice 'Loteamento editado com sucesso.'

    click_link 'Monte Verde'

    expect(page).to have_field 'Nome', :with => 'Monte Verde'
  end

  scenario 'destroy a land subdivision' do
    LandSubdivision.make!(:terra_prometida)

    navigate 'Outros > Loteamentos'

    click_link 'Terra Prometida'

    click_link 'Apagar'

    expect(page).to have_notice 'Loteamento apagado com sucesso.'

    within_records do
      expect(page).not_to have_content 'Terra Prometida'
    end
  end
end
