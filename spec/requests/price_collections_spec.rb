# encoding: utf-8
require 'spec_helper'

feature "PriceCollections" do
  background do
    sign_in
  end

  scenario 'create a new price_collection' do
    DeliveryLocation.make!(:education)
    Employee.make!(:sobrinho)
    PaymentMethod.make!(:dinheiro)
    Period.make!(:um_ano)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    click_link 'Criar Coleta de Preços'

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

      fill_mask 'Ano', :with => '2012'
      fill_mask 'Data', :with => I18n.l(Date.current)
      fill_modal 'Local de entrega', :with => 'Secretaria da Educação', :field => 'Descrição'
      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Dinheiro', :field => 'Descrição'
      fill_modal 'Prazo de entrega', :with => '1', :field => 'Quantidade'
      fill_modal 'Validade da proposta', :with => '1', :field => 'Quantidade'
      fill_mask 'Vencimento', :with => I18n.l(Date.tomorrow)
      fill_in 'Objeto', :with => 'objeto da coleta'
      fill_in 'Observações', :with => 'observacoes da coleta'
    end

    click_button 'Salvar'

    page.should have_notice 'Coleta de Preços criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_field 'Número', :with => '1'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data', :with => I18n.l(Date.current)
      page.should have_field 'Local de entrega', :with => 'Secretaria da Educação'
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Forma de pagamento', :with => 'Dinheiro'
      page.should have_field 'Prazo de entrega', :with => '1 ano'
      page.should have_field 'Validade da proposta', :with => '1 ano'
      page.should have_field 'Vencimento', :with => I18n.l(Date.tomorrow)
      page.should have_field 'Objeto', :with => 'objeto da coleta'
      page.should have_field 'Observações', :with => 'observacoes da coleta'
    end
  end

  scenario 'update an existent price_collection' do
    PriceCollection.make!(:coleta_de_precos)
    DeliveryLocation.make!(:health)
    Employee.make!(:wenderson)
    PaymentMethod.make!(:cheque)
    Period.make!(:tres_meses)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_mask 'Data', :with => I18n.l(Date.current + 10.days)
      fill_modal 'Local de entrega', :with => 'Secretaria da Saúde', :field => 'Descrição'
      fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Forma de pagamento', :with => 'Cheque', :field => 'Descrição'
      fill_modal 'Prazo de entrega', :with => '3', :field => 'Quantidade'
      fill_modal 'Validade da proposta', :with => '3', :field => 'Quantidade'
      fill_mask 'Vencimento', :with => I18n.l(Date.tomorrow + 10.days)
      fill_in 'Objeto', :with => 'novo objeto da coleta'
      fill_in 'Observações', :with => 'novo observacoes da coleta'
    end

    click_button 'Salvar'

    page.should have_notice 'Coleta de Preços editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_disabled_field 'Número'
      page.should have_field 'Número', :with => '1'
      page.should have_disabled_field 'Status'
      page.should have_select 'Status', :selected => 'Ativo'

      page.should have_field 'Ano', :with => '2012'
      page.should have_field 'Data', :with => I18n.l(Date.current + 10.days)
      page.should have_field 'Local de entrega', :with => 'Secretaria da Saúde'
      page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
      page.should have_field 'Forma de pagamento', :with => 'Cheque'
      page.should have_field 'Prazo de entrega', :with => '3 meses'
      page.should have_field 'Validade da proposta', :with => '3 meses'
      page.should have_field 'Vencimento', :with => I18n.l(Date.tomorrow + 10.days)
      page.should have_field 'Objeto', :with => 'novo objeto da coleta'
      page.should have_field 'Observações', :with => 'novo observacoes da coleta'
    end
  end

  scenario 'should not have destroy button' do
    PriceCollection.make!(:coleta_de_precos)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    within_records do
      page.find('a').click
    end

    page.should_not have_button 'Apagar'
  end
end
