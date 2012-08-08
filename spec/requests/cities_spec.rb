# encoding: utf-8
require 'spec_helper'

feature "Cities" do
  background do
    sign_in
  end

  scenario 'create a new city' do
    State.make!(:rs)

    navigate 'Outros > Cidades'

    click_link 'Criar Cidade'

    fill_in 'Nome', :with => 'Porto Alegre'
    fill_in 'Código', :with => '4929'
    fill_modal 'Estado', :with => 'Rio Grande do Sul'

    click_button 'Salvar'

    expect(page).to have_notice 'Cidade criada com sucesso.'

    click_link 'Porto Alegre'

    expect(page).to have_field 'Nome', :with => 'Porto Alegre'
    expect(page).to have_field 'Código', :with => '4929'
    expect(page).to have_field 'Estado', :with => 'Rio Grande do Sul'
  end

  scenario 'update a city' do
    City.make!(:belo_horizonte)

    navigate 'Outros > Cidades'

    click_link 'Belo Horizonte'

    fill_in 'Nome', :with => 'B. Horizonte'
    fill_in 'Código', :with => 'BHORIZO'

    click_button 'Salvar'

    expect(page).to have_notice 'Cidade editada com sucesso.'

    click_link 'B. Horizonte'

    expect(page).to have_field 'Nome', :with => 'B. Horizonte'
    expect(page).to have_field 'Código', :with => 'BHORIZO'
    expect(page).to have_field 'Estado', :with => 'Minas Gerais'
  end

  scenario 'destroy a city' do
    City.make!(:porto_alegre)

    navigate 'Outros > Cidades'

    click_link 'Porto Alegre'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Cidade apagada com sucesso.'

    expect(page).not_to have_content 'Porto Alegre'
  end
end
