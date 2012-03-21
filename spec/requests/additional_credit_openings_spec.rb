# encoding: utf-8
require 'spec_helper'

feature "AdditionalCreditOpenings" do
  background do
    sign_in
  end

  scenario 'create a new additional_credit_opening' do
    Entity.make!(:detran)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link 'Criar Abertura de Créditos Suplementares'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => 2012
    select 'Especial', :from => 'Tipo de crédito'

    click_button 'Criar Abertura de Créditos Suplementares'

    page.should have_notice 'Abertura de Créditos Suplementares criado com sucesso.'

    click_link '2012'

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_select 'Tipo de crédito', :selected => 'Especial'
  end

  scenario 'update an existent additional_credit_opening' do
    Entity.make!(:secretaria_de_educacao)
    AdditionalCreditOpening.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link '2012'

    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Exercício', :with => 2011
    select 'Suplementar', :from => 'Tipo de crédito'

    click_button 'Atualizar Abertura de Créditos Suplementares'

    page.should have_notice 'Abertura de Créditos Suplementares editado com sucesso.'

    click_link '2011'

    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Exercício', :with => '2011'
    page.should have_select 'Tipo de crédito', :selected => 'Suplementar'
  end

  scenario 'destroy an existent additional_credit_opening' do
    AdditionalCreditOpening.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link '2012'

    click_link 'Apagar 2012', :confirm => true

    page.should have_notice 'Abertura de Créditos Suplementares apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '2012'
    page.should_not have_content 'Especial'
  end
end
