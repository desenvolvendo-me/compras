# encoding: utf-8
require 'spec_helper'

feature "OccurrenceContractualHistorics" do
  background do
    sign_in
  end

  scenario 'create a new occurrence_contractual_historic' do
    Contract.make!(:primeiro_contrato)

    navigate_through 'Contabilidade > Comum > Contratos > Contratos de Gestão'

    within_records do
      page.find('a').click
    end

    click_link 'Históricos de Ocorrências Contratuais'

    click_link 'Criar Histórico de Ocorrências Contratuais'

    fill_in 'Data da ocorrência', :with => '01/07/2012'
    select 'Outros', :from => 'Tipo de histórico'
    select 'Bilateral', :from => 'Tipo de alteração'
    fill_in 'Observações', :with => 'divergência contratual'

    click_button 'Salvar'

    page.should have_notice 'Histórico de Ocorrências Contratuais criado com sucesso.'

    click_link '1'

    page.should have_field 'Sequência', :with => '1'
    page.should have_field 'Data da ocorrência', :with => '01/07/2012'
    page.should have_field 'Observações', :with => 'divergência contratual'
    page.should have_select 'Tipo de alteração', :selected => 'Bilateral'
    page.should have_select 'Tipo de histórico', :selected => 'Outros'
  end

  scenario 'update an existent occurrence_contractual_historic' do
    OccurrenceContractualHistoric.make!(:example)

    navigate_through 'Contabilidade > Comum > Contratos > Contratos de Gestão'

    within_records do
      page.find('a').click
    end

    click_link 'Históricos de Ocorrências Contratuais'

    click_link '1'

    fill_in 'Data da ocorrência', :with => '10/07/2012'
    fill_in 'Observações', :with => 'problemas judiciais'

    click_button 'Salvar'

    page.should have_notice 'Histórico de Ocorrências Contratuais editado com sucesso.'

    click_link '1'

    page.should have_field 'Data da ocorrência', :with => '10/07/2012'
    page.should have_field 'Observações', :with => 'problemas judiciais'
  end

  scenario 'destroy an existent occurrence_contractual_historic' do
    OccurrenceContractualHistoric.make!(:example)

    navigate_through 'Contabilidade > Comum > Contratos > Contratos de Gestão'

    within_records do
      page.find('a').click
    end

    click_link 'Históricos de Ocorrências Contratuais'

    click_link '1'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Histórico de Ocorrências Contratuais apagado com sucesso.'
  end
end
