# encoding: utf-8
require 'spec_helper'

feature "Indexers" do
  background do
    sign_in
  end

  scenario 'create a new indexer' do
    Currency.make!(:real)

    navigate 'Outros > Indexadores'

    click_link 'Criar Indexador'

    fill_in 'Nome', :with => 'SELIC'

    fill_modal 'Moeda', :with => 'Real'

    click_button 'Adicionar Valor de Indexador'

    fill_in 'Data', :with => '01/05/2011'
    fill_in 'Valor', :with => '0,990000'

    click_button 'Salvar'

    page.should have_notice 'Indexador criado com sucesso.'

    click_link 'SELIC'

    page.should have_field 'Nome', :with => 'SELIC'
    page.should have_field 'Moeda', :with => 'Real'
    page.should have_field 'Data', :with => '01/05/2011'
    page.should have_field 'Valor', :with => '0,990000'
  end

  scenario 'update a indexer' do
    Indexer.make!(:selic)

    navigate 'Outros > Indexadores'

    click_link 'SELIC'

    fill_in 'Valor', :with => '0,840000'

    click_button 'Salvar'

    page.should have_notice 'Indexador editado com sucesso.'

    click_link 'SELIC'

    page.should have_field 'Valor', :with => '0,840000'
  end

  scenario 'destroy an existent indexer' do
    Indexer.make!(:selic)

    navigate 'Outros > Indexadores'

    click_link 'SELIC'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Indexador apagado com sucesso.'

    page.should_not have_content 'SELIC'
    page.should_not have_content 'Real'
    page.should_not have_content '01/05/2011'
    page.should_not have_content '0,990000'
  end
end
