# encoding: utf-8
require 'spec_helper'

feature 'MacroObjectives' do
  background do
    sign_in
  end

  scenario 'create a new macro_objective' do
    navigate 'Cadastros Gerais > Macro Objetivos'

    click_link 'Criar Macro Objetivo'

    fill_in 'Especificação', :with => 'Pavimentação'
    fill_in 'Observação', :with => 'Pavimentação das vias urbanas'

    click_button 'Salvar'

    expect(page).to have_notice 'Macro Objetivo criado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Especificação', :with => 'Pavimentação'
    expect(page).to have_field 'Observação', :with => 'Pavimentação das vias urbanas'
  end

  scenario 'update an existing macro_objective' do
    MacroObjective.make!(:macro_objetivo)

    navigate 'Cadastros Gerais > Macro Objetivos'

    within_records do
      page.find('a').click
    end

    fill_in 'Especificação', :with => 'Pavimentação'
    fill_in 'Observação', :with => 'Pavimentação das vias urbanas'

    click_button 'Salvar'

    expect(page).to have_notice 'Macro Objetivo editado com sucesso.'

    within_records do
      page.find('a').click
    end

    expect(page).to have_field 'Especificação', :with => 'Pavimentação'
    expect(page).to have_field 'Observação', :with => 'Pavimentação das vias urbanas'
  end

  scenario 'destroy and existing macro_objective' do
    MacroObjective.make!(:macro_objetivo)

    navigate 'Cadastros Gerais > Macro Objetivos'

    click_link 'Melhorar qualidade do ensino'

    click_link 'Apagar'

    expect(page).to have_notice 'Macro Objetivo apagado com sucesso.'

    expect(page).to_not have_link 'Melhorar qualidade do ensino'
  end
end
