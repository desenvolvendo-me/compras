# encoding: utf-8
require 'spec_helper'

feature "Neighborhoods" do
  background do
    sign_in
  end

  scenario 'fetch default city from settings' do
    Setting.make!(:default_city)

    navigate_through 'Outros > Bairros'

    click_link 'Criar Bairro'

    page.should have_field 'Cidade', :with => 'Belo Horizonte'
  end

  scenario 'create a new neighborhood' do
    City.make!(:porto_alegre)

    navigate_through 'Outros > Bairros'

    click_link 'Criar Bairro'

    fill_in 'Nome', :with => 'Alvorada'

    within_modal 'Cidade' do
      fill_in 'Nome', :with => 'Porto Alegre'

      click_button 'Pesquisar'

      click_record 'Porto Alegre'
    end

    click_button 'Salvar'

    page.should have_notice 'Bairro criado com sucesso.'

    click_link 'Alvorada'

    page.should have_field 'Nome', :with => 'Alvorada'
    page.should have_field 'Cidade', :with => 'Porto Alegre'
  end

  scenario 'update a neighborhood' do
    Neighborhood.make!(:centro)

    navigate_through 'Outros > Bairros'

    click_link 'Centro'

    fill_in 'Nome', :with => 'Alvorada'

    click_button 'Salvar'

    page.should have_notice 'Bairro editado com sucesso.'

    click_link 'Alvorada'

    page.should have_field 'Nome', :with => 'Alvorada'
    page.should have_field 'Cidade', :with => 'Belo Horizonte'
  end

  scenario 'destroy a neighborhood' do
    Neighborhood.make!(:centro)

    navigate_through 'Outros > Bairros'

    click_link 'Centro'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Bairro apagado com sucesso.'

    page.should_not have_content 'Centro'
  end

  scenario 'cannot destroy a neighborhood with streets' do
    Street.make!(:girassol)

    navigate_through 'Outros > Bairros'

    click_link 'Centro'

    click_link 'Apagar', :confirm => true

    page.should_not have_notice 'Bairro apagado com sucesso.'
  end

  scenario 'validate uniquenes of name scoped to district' do
    City.make!(:porto_alegre)
    Neighborhood.make!(:portugal)
    District.make!(:oeste)

    navigate_through 'Outros > Bairros'

    click_link 'Criar Bairro'

    fill_in 'Nome', :with => 'Portugal'

    within_modal 'Cidade' do
      fill_in 'Nome', :with => 'Porto Alegre'

      click_button 'Pesquisar'

      click_record 'Porto Alegre'
    end

    within_modal 'Distrito' do
      fill_in 'Nome', :with => 'Leste'

      click_button 'Pesquisar'

      click_record 'Leste'
    end

    click_button 'Salvar'
    page.should have_content 'já está em uso'

    within_modal 'Distrito' do
      fill_in 'Nome', :with => 'Oeste'

      click_button 'Pesquisar'

      click_record 'Oeste'
    end

    click_button 'Salvar'
    page.should have_notice 'Bairro criado com sucesso.'
  end

  scenario 'should lock district by city' do
    City.make!(:porto_alegre)

    navigate_through 'Outros > Bairros'

    click_link 'Criar Bairro'

    fill_modal 'Cidade', :with => 'Porto Alegre', :field => 'Nome'

    within_modal 'Distrito' do
      page.should have_disabled_field 'Cidade'
      page.should have_field 'Cidade', :with => 'Porto Alegre'
    end
  end

  scenario 'should filter district by city' do
    District.make!(:centro)
    District.make!(:leste)

    navigate_through 'Outros > Bairros'

    click_link 'Criar Bairro'

    fill_modal 'Cidade', :with => 'Porto Alegre', :field => 'Nome'

    within_modal 'Distrito' do
      click_button 'Pesquisar'

      page.should have_content 'Leste'
      page.should_not have_content 'Centro'
    end
  end
end
