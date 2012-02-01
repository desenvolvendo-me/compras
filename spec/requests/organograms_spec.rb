# encoding: utf-8
require 'spec_helper'

feature "Organograms" do
  background do
    sign_in
  end

  scenario 'create a new organogram' do
    ConfigurationOrganogram.make!(:detran_sopa)
    TypeOfAdministractiveAct.make!(:lei)

    click_link 'Cadastros Diversos'

    click_link 'Organogramas'

    click_link 'Criar Organograma'

    fill_in 'Nome', :with => 'Secretaria de Educação'
    fill_modal 'Configuração de organograma', :with => 'Configuração do Detran'
    fill_in 'Organograma', :with => '02.00'
    fill_in 'Código TCE', :with => '051'
    fill_in 'Sigla', :with => 'SEMUEDU'
    fill_modal 'Tipo de administração', :with => 'Lei'
    fill_in 'Área de atuação', :with => 'Desenvolvimento Educacional'

    click_button 'Criar Organograma'

    page.should have_notice 'Organograma criado com sucesso.'

    click_link 'Secretaria de Educação'

    page.should have_field 'Nome', :with => 'Secretaria de Educação'
    page.should have_field 'Configuração de organograma', :with => 'Configuração do Detran'
    page.should have_field 'Organograma', :with => '02.00'
    page.should have_field 'Código TCE', :with => '051'
    page.should have_field 'Sigla', :with => 'SEMUEDU'
    page.should have_field 'Tipo de administração', :with => 'Lei'
    page.should have_field 'Área de atuação', :with => 'Desenvolvimento Educacional'
  end

  scenario 'update an existent organogram' do
    Organogram.make!(:secretaria_de_educacao)

    click_link 'Cadastros Diversos'

    click_link 'Organogramas'

    click_link 'Secretaria de Educação'

    fill_in 'Nome', :with => 'Secretaria de Transporte'
    fill_modal 'Configuração de organograma', :with => 'Configuração do Detran'
    fill_in 'Organograma', :with => '02.11'
    fill_in 'Código TCE', :with => '081'
    fill_in 'Sigla', :with => 'SEMUTRA'
    fill_modal 'Tipo de administração', :with => 'Lei'
    fill_in 'Área de atuação', :with => 'Desenvolvimento de Transporte'

    click_button 'Atualizar Organograma'

    page.should have_notice 'Organograma editado com sucesso.'

    click_link 'Secretaria de Transporte'

    page.should have_field 'Nome', :with => 'Secretaria de Transporte'
    page.should have_field 'Configuração de organograma', :with => 'Configuração do Detran'
    page.should have_field 'Organograma', :with => '02.11'
    page.should have_field 'Código TCE', :with => '081'
    page.should have_field 'Sigla', :with => 'SEMUTRA'
    page.should have_field 'Tipo de administração', :with => 'Lei'
    page.should have_field 'Área de atuação', :with => 'Desenvolvimento de Transporte'
  end

  scenario 'destroy an existent organogram' do
    Organogram.make!(:secretaria_de_educacao)

    click_link 'Cadastros Diversos'

    click_link 'Organogramas'

    click_link 'Secretaria de Educação'

    click_link 'Apagar Secretaria de Educação', :confirm => true

    page.should have_notice 'Organograma apagado com sucesso.'

    page.should_not have_content 'Secretaria de Educação'
    page.should_not have_content 'Configuração do Detran'
    page.should_not have_content '02.00'
    page.should_not have_content '051'
    page.should_not have_content 'SEMUEDU'
    page.should_not have_content 'Lei'
    page.should_not have_content 'Desenvolvimento Educacional'
  end
end
