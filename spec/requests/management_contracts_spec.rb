# encoding: utf-8
require 'spec_helper'

feature "ManagementContracts" do
  background do
    sign_in
  end

  scenario 'create a new management_contract' do
    Entity.make!(:detran)

    click_link 'Contabilidade'

    click_link 'Contratos de Gestão'

    click_link 'Criar Contrato de Gestão'

    fill_mask 'Exercício', :with => '2012'
    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Número do contrato', :with => '001'
    fill_in 'Número do processo', :with => '002'
    fill_mask 'Data da assinatura', :with => '01/01/2012'
    fill_mask 'Data do término', :with => '30/12/2012'
    fill_in 'Objeto', :with => 'Objeto'

    click_button 'Salvar'

    page.should have_notice 'Contrato de Gestão criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Número do contrato', :with => '001'
    page.should have_field 'Número do processo', :with => '002'
    page.should have_field 'Data da assinatura', :with => '01/01/2012'
    page.should have_field 'Data do término', :with => '30/12/2012'
    page.should have_field 'Objeto', :with => 'Objeto'
  end

  scenario 'update an existent management_contract' do
    ManagementContract.make!(:primeiro_contrato)
    Entity.make!(:secretaria_de_educacao)

    click_link 'Contabilidade'

    click_link 'Contratos de Gestão'

    within_records do
      page.find('a').click
    end

    fill_mask 'Exercício', :with => '2013'
    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Número do contrato', :with => '111'
    fill_in 'Número do processo', :with => '222'
    fill_mask 'Data da assinatura', :with => '01/01/2013'
    fill_mask 'Data do término', :with => '30/12/2013'
    fill_in 'Objeto', :with => 'Novo Objeto'

    click_button 'Salvar'

    page.should have_notice 'Contrato de Gestão editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Exercício', :with => '2013'
    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Número do contrato', :with => '111'
    page.should have_field 'Número do processo', :with => '222'
    page.should have_field 'Data da assinatura', :with => '01/01/2013'
    page.should have_field 'Data do término', :with => '30/12/2013'
    page.should have_field 'Objeto', :with => 'Novo Objeto'
  end

  scenario 'destroy an existent management_contract' do
    ManagementContract.make!(:primeiro_contrato)

    click_link 'Contabilidade'

    click_link 'Contratos de Gestão'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Contrato de Gestão apagado com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content 'Detran'
    page.should_not have_content '001'
    page.should_not have_content '002'
    page.should_not have_content '23/02/2012'
    page.should_not have_content '24/02/2012'
  end
end
