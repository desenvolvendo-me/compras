# encoding: utf-8
require 'spec_helper'

feature "Indexers" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new indexer' do
    Currency.make!(:real)

    navigate 'Comum > Cadastrais > Indexadores'

    click_link 'Criar Indexador'

    fill_in 'Nome', :with => 'SELIC'

    fill_modal 'Moeda', :with => 'Real'

    click_button 'Adicionar Valor de Indexador'

    fill_in 'Data', :with => '01/05/2011'
    fill_in 'Valor', :with => '0,990000'

    click_button 'Salvar'

    expect(page).to have_notice 'Indexador criado com sucesso.'

    click_link 'SELIC'

    expect(page).to have_field 'Nome', :with => 'SELIC'
    expect(page).to have_field 'Moeda', :with => 'Real'
    expect(page).to have_field 'Data', :with => '01/05/2011'
    expect(page).to have_field 'Valor', :with => '0,990000'

    fill_in 'Valor', :with => '0,840000'

    click_button 'Salvar'

    expect(page).to have_notice 'Indexador editado com sucesso.'

    click_link 'SELIC'

    expect(page).to have_field 'Valor', :with => '0,840000'

    click_link 'Apagar'

    expect(page).to have_notice 'Indexador apagado com sucesso.'

    expect(page).to_not have_content 'SELIC'
    expect(page).to_not have_content 'Real'
    expect(page).to_not have_content '01/05/2011'
    expect(page).to_not have_content '084,0000'
  end

  scenario 'index with columns at the index' do
    Indexer.make!(:selic)

    navigate 'Comum > Cadastrais > Indexadores'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Moeda'

      within 'tbody tr' do
        expect(page).to have_content 'SELIC'
        expect(page).to have_content 'Real'
      end
    end
  end
end
