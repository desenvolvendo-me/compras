# encoding: utf-8
require 'spec_helper'

feature "Currencies" do
  background do
    sign_in
  end

  scenario 'create a new currency' do
    navigate 'Comum > Cadastrais > Moedas'

    click_link 'Criar Moeda'

    fill_in 'Nome', :with => 'Real'
    fill_in 'Sigla', :with => 'R$'

    click_button 'Salvar'

    expect(page).to have_notice 'Moeda criada com sucesso.'

    click_link 'Real'

    expect(page).to have_field 'Nome', :with => 'Real'
    expect(page).to have_field 'Sigla', :with => 'R$'
  end

  scenario 'update a currency' do
    Currency.make!(:real)

    navigate 'Comum > Cadastrais > Moedas'

    click_link 'Real'

    fill_in 'Nome', :with => 'Peso'
    fill_in 'Sigla', :with => '$'

    click_button 'Salvar'

    expect(page).to have_notice 'Moeda editada com sucesso.'

    click_link 'Peso'

    expect(page).to have_field 'Nome', :with => 'Peso'
    expect(page).to have_field 'Sigla', :with => '$'
  end

  scenario 'destroy a currency' do
    Currency.make!(:real)

    navigate 'Comum > Cadastrais > Moedas'

    click_link 'Real'

    click_link 'Apagar'

    expect(page).to have_notice 'Moeda apagada com sucesso.'

    expect(page).to_not have_content 'Real'
  end

  scenario 'index with columns at the index' do
    Currency.make!(:real)

    navigate 'Comum > Cadastrais > Moedas'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Sigla'

      within 'tbody tr' do
        expect(page).to have_content 'Real'
        expect(page).to have_content 'R$'
      end
    end
  end
end
