# encoding: utf-8
require 'spec_helper'

feature "Cities" do
  background do
    sign_in
  end

  scenario 'create a new city' do
    State.make!(:rs)

    click_link 'Cadastros Diversos'

    click_link 'Cidades'

    click_link 'Criar Cidade'

    fill_in 'Nome', :with => 'Porto Alegre'
    fill_mask 'Código', :with => '4929'
    fill_modal 'Estado', :with => 'Rio Grande do Sul'

    click_button 'Salvar'

    page.should have_notice 'Cidade criada com sucesso.'

    click_link 'Porto Alegre'

    page.should have_field 'Nome', :with => 'Porto Alegre'
    page.should have_field 'Código', :with => '4929'
    page.should have_field 'Estado', :with => 'Rio Grande do Sul'
  end

  scenario 'update a city' do
    City.make!(:belo_horizonte)

    click_link 'Cadastros Diversos'

    click_link 'Cidades'

    click_link 'Belo Horizonte'

    fill_in 'Nome', :with => 'B. Horizonte'
    fill_mask 'Código', :with => 'BHORIZO'

    click_button 'Salvar'

    page.should have_notice 'Cidade editada com sucesso.'

    click_link 'B. Horizonte'

    page.should have_field 'Nome', :with => 'B. Horizonte'
    page.should have_field 'Código', :with => 'BHORIZO'
    page.should have_field 'Estado', :with => 'Minas Gerais'
  end

  scenario 'destroy a city' do
    City.make!(:porto_alegre)

    click_link 'Cadastros Diversos'

    click_link 'Cidades'

    click_link 'Porto Alegre'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Cidade apagada com sucesso.'

    page.should_not have_content 'Porto Alegre'
  end
end
