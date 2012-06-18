#encoding: utf-8
require 'spec_helper'

feature 'PriceCollectionAnnuls' do
  background do
    sign_in
  end

  scenario 'accessing the annul for an price_collection at the first time' do
    PriceCollection.make!(:coleta_de_precos)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    click_link '1/2012'

    click_link 'Anular'

    page.should have_content 'Anular Coleta de Preço 1/2012'
    page.should have_field 'Data', :with => I18n.l(Date.current)

    click_link 'Cancelar'

    page.should have_content 'Editar 1/2012'
  end

  scenario 'creating a price collection annul' do
    PriceCollection.make!(:coleta_de_precos)
    Employee.make!(:wenderson)

    click_link 'Processos'

    click_link 'Coletas de Preços'

    click_link '1/2012'

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    select 'Anulação', :from => 'Tipo da Anulação'

    fill_in 'Justificativa', :with => 'Something'

    click_on 'Salvar'

    click_on 'Anulação'

    page.should have_content 'Anulação da Coleta de Preço 1/2012'
    page.should have_disabled_field 'Responsável'
    page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Justificativa'
    page.should have_field 'Justificativa', :with => 'Something'
    page.should have_disabled_field 'Tipo da Anulação'
    page.should have_select 'Tipo da Anulação', :selected => 'Anulação'

    page.should_not have_link 'Apagar'
    page.should_not have_button 'Salvar'
  end
end
