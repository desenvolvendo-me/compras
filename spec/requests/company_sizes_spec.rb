# encoding: utf-8
require 'spec_helper'

feature "CompanySizes" do
  background do
    sign_in
  end

  scenario 'create a new company_size' do
    click_link 'Cadastros Diversos'

    click_link 'Portes das Empresas'

    click_link 'Criar Porte da Empresa'

    fill_in 'Nome', :with => 'Empresa de médio porte'
    fill_in 'Sigla', :with => 'EMP'
    fill_in 'Número', :with => '3'

    click_button 'Salvar'

    page.should have_notice 'Porte da Empresa criado com sucesso.'

    click_link 'Empresa de médio porte'

    page.should have_field 'Nome', :with => 'Empresa de médio porte'
    page.should have_field 'Sigla', :with => 'EMP'
    page.should have_field 'Número', :with => '3'
  end

  scenario 'update an existent company_size' do
    CompanySize.make!(:micro_empresa)

    click_link 'Cadastros Diversos'

    click_link 'Portes das Empresas'

    click_link 'Microempresa'

    fill_in 'Nome', :with => 'Microempreendedor individual'
    fill_in 'Sigla', :with => 'MEI'
    fill_in 'Número', :with => '5'

    click_button 'Salvar'

    page.should have_notice 'Porte da Empresa editado com sucesso.'

    click_link 'Microempreendedor individual'

    page.should have_field 'Nome', :with => 'Microempreendedor individual'
    page.should have_field 'Sigla', :with => 'MEI'
    page.should have_field 'Número', :with => '5'
  end

  scenario 'destroy an existent company_size' do
    CompanySize.make!(:empresa_de_grande_porte)

    click_link 'Cadastros Diversos'

    click_link 'Portes das Empresas'

    click_link 'Empresa de grande porte'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Porte da Empresa apagado com sucesso.'

    page.should_not have_content 'Empresa de grande porte'
  end
end
