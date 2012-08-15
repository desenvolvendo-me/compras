# encoding: utf-8
require 'spec_helper'

feature "RecordPrices" do
  background do
    sign_in
  end

  scenario 'create a new record_price' do
    LicitationProcess.make!(:processo_licitatorio)
    DeliveryLocation.make!(:education)
    ManagementUnit.make!(:unidade_central)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)

    navigate 'Compras e Licitações > Registros de Preços'

    click_link 'Criar Registro de Preço'

    fill_in 'Número', :with => '2'
    fill_in 'Ano', :with => '2012'
    fill_in 'Data', :with => '05/04/2012'
    fill_in 'Data da validade', :with => '05/04/2013'
    select 'Ativo', :from => 'Situação'
    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
    fill_in 'Objeto', :with => 'Aquisição de combustíveis'
    fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
    fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'

    within_modal 'Responsável' do
      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

      click_button 'Pesquisar'

      click_record 'Gabriel Sobrinho'
    end

    fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
    fill_in 'Entrega', :with => '1'
    select 'mês/meses', :from => 'Período da entrega'
    fill_in 'Validade', :with => '2'
    select 'ano/anos', :from => 'Período da validade'
    fill_in 'Observações', :with => 'Aquisição de combustíveis'

    click_button 'Salvar'

    page.should have_notice 'Registro de Preço criado com sucesso.'

    click_link '2'

    page.should have_field 'Número', :with => '2'
    page.should have_field 'Ano', :with => '2012'
    page.should have_field 'Data', :with => '05/04/2012'
    page.should have_field 'Data da validade', :with => '05/04/2013'
    page.should have_select 'Situação', :selected => 'Ativo'
    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Objeto', :with => 'Aquisição de combustíveis'
    page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
    page.should have_field 'Unidade gestora', :with => 'Unidade Central'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
    page.should have_field 'Entrega', :with => '1'
    page.should have_select 'Período da entrega', :selected => 'mês/meses'
    page.should have_field 'Validade', :with => '2'
    page.should have_select 'Período da validade', :selected => 'ano/anos'
    page.should have_field 'Observações', :with => 'Aquisição de combustíveis'
  end

  scenario 'update an existent record_price' do
    RecordPrice.make!(:registro_de_precos)

    navigate 'Compras e Licitações > Registros de Preços'

    click_link '1'

    fill_in 'Número', :with => '2'
    fill_in 'Ano', :with => '2013'
    fill_in 'Data', :with => '05/04/2013'
    fill_in 'Data da validade', :with => '05/04/2014'
    select 'Ativo', :from => 'Situação'
    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
    fill_in 'Objeto', :with => 'Aquisição de combustíveis'
    fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
    fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'

    within_modal 'Responsável' do
      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

      click_button 'Pesquisar'

      click_record 'Gabriel Sobrinho'
    end

    fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
    fill_in 'Entrega', :with => '2'
    select 'mês/meses', :from => 'Período da entrega'
    fill_in 'Validade', :with => '3'
    select 'ano/anos', :from => 'Período da validade'
    fill_in 'Observações', :with => 'Aquisição de carne'

    click_button 'Salvar'

    page.should have_notice 'Registro de Preço editado com sucesso.'

    click_link '2'

    page.should have_field 'Número', :with => '2'
    page.should have_field 'Ano', :with => '2013'
    page.should have_field 'Data', :with => '05/04/2013'
    page.should have_field 'Data da validade', :with => '05/04/2014'
    page.should have_select 'Situação', :selected => 'Ativo'
    page.should have_field 'Processo licitatório', :with => '1/2012'
    page.should have_field 'Objeto', :with => 'Aquisição de combustíveis'
    page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
    page.should have_field 'Unidade gestora', :with => 'Unidade Central'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
    page.should have_field 'Entrega', :with => '2'
    page.should have_select 'Período da entrega', :selected => 'mês/meses'
    page.should have_field 'Validade', :with => '3'
    page.should have_select 'Período da validade', :selected => 'ano/anos'
    page.should have_field 'Observações', :with => 'Aquisição de carne'
  end

  scenario 'destroy an existent record_price' do
    RecordPrice.make!(:registro_de_precos)

    navigate 'Compras e Licitações > Registros de Preços'

    click_link '1'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Registro de Preço apagado com sucesso.'

    page.should_not have_content '1'
    page.should_not have_content '05/04/2012'
    page.should_not have_content 'Aquisição de combustíveis'
  end
end
