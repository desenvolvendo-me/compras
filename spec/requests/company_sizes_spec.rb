# encoding: utf-8
require 'spec_helper'

feature "CompanySizes" do
  background do
    sign_in
  end

  scenario 'create a new company_size' do
    navigate 'Compras e Licitações > Cadastros Gerais > Portes das Empresas'

    click_link 'Criar Porte da Empresa'

    fill_in 'Nome', :with => 'Empresa de médio porte'
    fill_in 'Sigla', :with => 'EMP'
    fill_in 'Número', :with => '3'
    check 'Beneficiado pela lei 123/2006'

    click_button 'Salvar'

    expect(page).to have_notice 'Porte da Empresa criado com sucesso.'

    click_link 'Empresa de médio porte'

    expect(page).to have_field 'Nome', :with => 'Empresa de médio porte'
    expect(page).to have_field 'Sigla', :with => 'EMP'
    expect(page).to have_field 'Número', :with => '3'
    expect(page).to have_checked_field 'Beneficiado pela lei 123/2006'
  end

  scenario 'update an existent company_size' do
    CompanySize.make!(:micro_empresa)

    navigate 'Compras e Licitações > Cadastros Gerais > Portes das Empresas'

    click_link 'Microempresa'

    fill_in 'Nome', :with => 'Microempreendedor individual'
    fill_in 'Sigla', :with => 'MEI'
    fill_in 'Número', :with => '5'

    click_button 'Salvar'

    expect(page).to have_notice 'Porte da Empresa editado com sucesso.'

    click_link 'Microempreendedor individual'

    expect(page).to have_field 'Nome', :with => 'Microempreendedor individual'
    expect(page).to have_field 'Sigla', :with => 'MEI'
    expect(page).to have_field 'Número', :with => '5'
  end

  scenario 'destroy an existent company_size' do
    CompanySize.make!(:empresa_de_grande_porte)

    navigate 'Compras e Licitações > Cadastros Gerais > Portes das Empresas'

    click_link 'Empresa de grande porte'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Porte da Empresa apagado com sucesso.'

    expect(page).not_to have_content 'Empresa de grande porte'
  end
end
