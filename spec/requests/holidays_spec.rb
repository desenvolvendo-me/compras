# encoding: utf-8
require 'spec_helper'

feature "Holidays" do
  let(:navigate_to_holidays) { navigate 'Comum > Cadastrais > Feriados' }

  background do
    sign_in
  end

  scenario 'create a new holiday' do
    navigate_to_holidays
    click_link 'Criar Feriado'

    fill_in 'Nome', :with => 'Dia do Trabalho'
    fill_in 'Ano', :with => '2013'
    fill_in 'Mês', :with => '5'
    fill_in 'Dia', :with => '1'
    check 'Esse feriado é recorrente?'

    click_button 'Salvar'

    expect(page).to have_notice 'Feriado criado com sucesso.'

    click_link 'Dia do Trabalho'

    expect(page).to have_field 'Nome', :with => 'Dia do Trabalho'
    expect(page).to have_field 'Ano', :with => '2013'
    expect(page).to have_field 'Mês', :with => '5'
    expect(page).to have_field 'Dia', :with => '1'
    expect(page).to have_checked_field 'Esse feriado é recorrente?'
  end

  scenario 'update an existent holiday' do
    Holiday.make!(:example)

    navigate_to_holidays

    click_link 'Dia do Trabalho'

    fill_in 'Nome', :with => 'Natal'
    fill_in 'Ano', :with => '2013'
    fill_in 'Mês', :with => '12'
    fill_in 'Dia', :with => '25'
    check 'Esse feriado é recorrente?'

    click_button 'Salvar'

    expect(page).to have_notice 'Feriado editado com sucesso.'

    click_link 'Natal'

    expect(page).to have_field 'Nome', :with => 'Natal'
    expect(page).to have_field 'Ano', :with => '2013'
    expect(page).to have_field 'Mês', :with => '12'
    expect(page).to have_field 'Dia', :with => '25'
    expect(page).to have_checked_field 'Esse feriado é recorrente?'
  end

  scenario 'destroy an existent holiday' do
    Holiday.make!(:example)
    navigate_to_holidays

    click_link 'Dia do Trabalho'

    click_link 'Apagar'

    expect(page).to have_notice 'Feriado apagado com sucesso.'
    expect(page).to_not have_content 'Dia do Trabalho'
  end
end
