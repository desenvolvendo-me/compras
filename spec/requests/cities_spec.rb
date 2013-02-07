# encoding: utf-8
require 'spec_helper'

feature "Cities" do
  background do
    sign_in
  end

  scenario 'create a new city' do
    State.make!(:rs)

    navigate 'Geral > Parâmetros > Endereços > Cidades'

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

    navigate 'Geral > Parâmetros > Endereços > Cidades'

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

    navigate 'Geral > Parâmetros > Endereços > Cidades'

    click_link 'Porto Alegre'

    click_link 'Apagar'

    expect(page).to have_notice 'Cidade apagada com sucesso.'

    expect(page).to_not have_content 'Porto Alegre'
  end

  scenario 'index with columns at the index' do
    City.make!(:maringa)

    navigate 'Geral > Parâmetros > Endereços > Cidades'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Estado'
      expect(page).to have_content 'Código'

      within 'tbody tr' do
        expect(page).to have_content 'Maringa'
        expect(page).to have_content 'Paraná'
        expect(page).to have_content '12'
      end
    end
  end
end
