# encoding: utf-8
require 'spec_helper'

feature "Neighborhoods" do
  background do
    sign_in
  end

  scenario 'create a new neighborhood' do
    navigate 'Geral > Parâmetros > Endereços > Bairros'

    click_link 'Criar Bairro'

    fill_in 'Nome', :with => 'Alvorada'

    fill_modal 'Cidade', :with => 'Porto Alegre'

    within_modal 'Distrito' do
      expect(page).to have_field 'Cidade', :with => 'Porto Alegre'
      expect(page).to have_disabled_field 'Cidade'

      click_button 'Pesquisar'
      click_record 'Leste'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Bairro criado com sucesso.'

    click_link 'Alvorada'

    expect(page).to have_field 'Nome', :with => 'Alvorada'
    expect(page).to have_field 'Cidade', :with => 'Porto Alegre'
    expect(page).to have_field 'Distrito', :with => 'Leste'
  end

  scenario 'update a neighborhood' do

    navigate 'Geral > Parâmetros > Endereços > Bairros'

    click_link 'Centro'

    fill_in 'Nome', :with => 'Alvorada'

    click_button 'Salvar'

    expect(page).to have_notice 'Bairro editado com sucesso.'

    click_link 'Alvorada'

    expect(page).to have_field 'Nome', :with => 'Alvorada'
    expect(page).to have_field 'Cidade', :with => 'Belo Horizonte'
  end

  scenario 'destroy a neighborhood' do

    navigate 'Geral > Parâmetros > Endereços > Bairros'

    click_link 'Centro'

    click_link 'Apagar'

    expect(page).to have_notice 'Bairro apagado com sucesso.'

    expect(page).to_not have_content 'Centro'
  end

  scenario 'cannot destroy a neighborhood with streets' do
    Street.make!(:girassol)

    navigate 'Geral > Parâmetros > Endereços > Bairros'

    click_link 'Centro'

    click_link 'Apagar'

    expect(page).to_not have_notice 'Bairro apagado com sucesso.'

    expect(page).to have_alert 'Bairro não pode ser apagado.'
  end

  scenario 'should lock district by city' do
    navigate 'Geral > Parâmetros > Endereços > Bairros'

    click_link 'Criar Bairro'

    fill_modal 'Cidade', :with => 'Porto Alegre'

    within_modal 'Distrito' do
      expect(page).to have_disabled_field 'Cidade'
      expect(page).to have_field 'Cidade', :with => 'Porto Alegre'
    end
  end

  scenario 'should filter district by city' do
    FactoryGirl.create(:district, name: 'Centro', city: cities(:belo_horizonte))

    navigate 'Geral > Parâmetros > Endereços > Bairros'

    click_link 'Criar Bairro'

    fill_modal 'Cidade', :with => 'Porto Alegre'

    within_modal 'Distrito' do
      click_button 'Pesquisar'

      expect(page).to have_content 'Leste'
      expect(page).to_not have_content 'Centro'
    end
  end

  scenario 'index with columns at the index' do

    navigate 'Geral > Parâmetros > Endereços > Bairros'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Cidade'

      within 'tbody tr' do
        expect(page).to have_content 'Centro'
        expect(page).to have_content 'Belo Horizonte'
      end
    end
  end
end
