# encoding: utf-8
require 'spec_helper'

feature "Contracts" do
  background do
    sign_in
  end

  scenario 'picking a licitation process' do
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Contabilidade'

    click_link 'Contratos'

    click_link 'Criar Contrato'

    select_modal 'Processo licitatório', :field => 'Ano', :with => '2012'

    page.should have_disabled_field 'Compra direta'
    page.should have_field 'Objeto do contrato', :with => 'Licitação para compra de carteiras'
  end

  scenario 'picking a direct purchase' do
    DirectPurchase.make!(:compra)

    click_link 'Contabilidade'

    click_link 'Contratos'

    click_link 'Criar Contrato'

    select_modal 'Compra direta', :field => 'Ano', :with => '2012'

    page.should have_disabled_field 'Processo licitatório'
    page.should have_field 'Objeto do contrato', :with => ''
  end

  scenario 'create a new contract' do
    Entity.make!(:detran)
    LicitationProcess.make!(:processo_licitatorio)

    click_link 'Contabilidade'

    click_link 'Contratos'

    click_link 'Criar Contrato'

    page.should have_field 'Ano do contrato', :with => "#{Date.current.year}"
    page.should have_disabled_field 'Número sequencial'
    page.should have_disabled_field 'Contrato principal'

    select 'Aditivo', :from => 'Tipo'
    page.should_not have_disabled_field 'Contrato principal'
    select 'Contrato principal', :from => 'Tipo'
    page.should have_disabled_field 'Contrato principal'

    fill_in 'Ano do contrato', :with => '2012'
    fill_modal 'Entidade', :with => 'Detran'
    page.should have_field 'Número sequencial', :with => '1'

    fill_in 'Número do contrato', :with => '001'
    fill_in 'Data da assinatura', :with => '01/01/2012'
    fill_in 'Data de validade', :with => '30/12/2012'

    attach_file 'Contrato', 'spec/fixtures/other_example_document.txt'

    select_modal 'Processo licitatório', :field => 'Ano', :with => '2012'

    fill_in 'Objeto do contrato', :with => 'Objeto'

    click_button 'Salvar'

    page.should have_notice 'Contrato criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Número sequencial', :with => '1'
    page.should have_field 'Ano do contrato', :with => '2012'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Número do contrato', :with => '001'
    page.should have_field 'Data da assinatura', :with => '01/01/2012'
    page.should have_field 'Data de validade', :with => '30/12/2012'
    page.should have_field 'Objeto do contrato', :with => 'Objeto'
    page.should have_link 'other_example_document.txt'
  end

  scenario 'update an existent contract' do
    Contract.make!(:primeiro_contrato)
    Entity.make!(:secretaria_de_educacao)

    click_link 'Contabilidade'

    click_link 'Contratos'

    within_records do
      page.find('a').click
    end

    fill_in 'Ano do contrato', :with => '2013'
    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_in 'Número do contrato', :with => '111'
    fill_in 'Data da assinatura', :with => '01/01/2013'
    fill_in 'Data de validade', :with => '30/12/2013'
    attach_file 'Contrato', 'spec/fixtures/example_document.txt'

    click_button 'Salvar'

    page.should have_notice 'Contrato editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Ano do contrato', :with => '2013'
    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Número do contrato', :with => '111'
    page.should have_field 'Data da assinatura', :with => '01/01/2013'
    page.should have_field 'Data de validade', :with => '30/12/2013'
    page.should have_link 'example_document.txt'
  end

  scenario 'destroy an existent contract' do
    Contract.make!(:primeiro_contrato)

    click_link 'Contabilidade'

    click_link 'Contratos'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Contrato apagado com sucesso.'

    page.should_not have_content '2012'
    page.should_not have_content 'Detran'
    page.should_not have_content '001'
    page.should_not have_content '002'
    page.should_not have_content '23/02/2012'
    page.should_not have_content '24/02/2012'
  end
end
