# encoding: utf-8
require 'spec_helper'

feature "LicitationModalities" do
  background do
    sign_in
  end

  scenario 'create a new licitation_modality' do
    RegulatoryAct.make!(:sopa)

    navigate 'Compras e Licitações > Cadastros Gerais > Modalidades de Licitação'

    click_link 'Criar Modalidade de Licitação'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
    fill_in 'Modalidade', :with => 'Pública'
    fill_in 'Valor inicial', :with => '500,00'
    fill_in 'Valor final', :with => '800,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Modalidade de Licitação criada com sucesso.'

    click_link 'Pública'

    expect(page).to have_field 'Ato regulamentador', :with => '1234'
    expect(page).to have_field 'Modalidade', :with => 'Pública'
    expect(page).to have_field 'Valor inicial', :with => '500,00'
    expect(page).to have_field 'Valor final', :with => '800,00'
  end

  scenario 'update an existent licitation_modality' do
    LicitationModality.make!(:publica)
    RegulatoryAct.make!(:emenda)

    navigate 'Compras e Licitações > Cadastros Gerais > Modalidades de Licitação'

    click_link 'Pública'

    fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
    fill_in 'Modalidade', :with => 'Privada'
    fill_in 'Valor inicial', :with => '600,00'
    fill_in 'Valor final', :with => '900,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Modalidade de Licitação editada com sucesso.'

    click_link 'Privada'

    expect(page).to have_field 'Ato regulamentador', :with => '4567'
    expect(page).to have_field 'Modalidade', :with => 'Privada'
    expect(page).to have_field 'Valor inicial', :with => '600,00'
    expect(page).to have_field 'Valor final', :with => '900,00'
  end

  scenario 'destroy an existent licitation_modality' do
    LicitationModality.make!(:publica)

    navigate 'Compras e Licitações > Cadastros Gerais > Modalidades de Licitação'

    click_link 'Pública'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Modalidade de Licitação apagada com sucesso.'

    expect(page).not_to have_content 'Pública'
    expect(page).not_to have_content '1234'
    expect(page).not_to have_content '500,00'
    expect(page).not_to have_content '700,00'
  end

  scenario 'should get the publication date when administractive act is selected' do
    RegulatoryAct.make!(:sopa)

    navigate 'Compras e Licitações > Cadastros Gerais > Modalidades de Licitação'

    click_link 'Criar Modalidade de Licitação'

    expect(page).to have_disabled_field 'Data da publicação'
    expect(page).to have_field 'Data da publicação', :with => ''

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    expect(page).to have_disabled_field 'Data da publicação'
    expect(page).to have_field 'Data da publicação', :with => '02/01/2012'
  end

  scenario 'should clean the publication date when administractive act is removed' do
    LicitationModality.make!(:publica)

    navigate 'Compras e Licitações > Cadastros Gerais > Modalidades de Licitação'

    click_link 'Pública'

    expect(page).to have_disabled_field 'Data da publicação'
    expect(page).to have_field 'Data da publicação', :with => '02/01/2012'

    clear_modal 'Ato regulamentador'

    expect(page).to have_disabled_field 'Data da publicação'
    expect(page).to have_field 'Data da publicação', :with => ''
  end

  scenario 'should validate initial and final value range taken' do
    LicitationModality.make!(:publica)

    navigate 'Compras e Licitações > Cadastros Gerais > Modalidades de Licitação'

    click_link 'Criar Modalidade de Licitação'

    fill_in 'Valor inicial', :with => '500,00'
    fill_in 'Valor final', :with => '700,00'

    click_button 'Salvar'

    expect(page).to have_content 'esta combinação de valor inicial e valor final já está em uso'
  end
end
