#encoding: utf-8
require 'spec_helper'

feature 'PriceCollectionProposalAnnul' do
  background do
    sign_in
  end

  scenario 'accessing the form' do
    PriceCollection.make!(:coleta_de_precos)

    navigate 'Compras e Licitações > Coletas de Preços'

    click_link '1/2012'

    click_link 'Propostas'

    click_link '1/2012 - Wenderson Malheiros'

    click_link 'Anular'

    expect(page).to have_content 'Anular Proposta do Fornecedor Wenderson Malheiros para a Coleta de Preço 1/2012'

    expect(page).to have_field 'Data', :with => I18n.l(Date.current)

    click_link 'Cancelar'

    expect(page).to have_content 'Proposta do Fornecedor Wenderson Malheiros para a Coleta de Preço 1/2012'
  end

  scenario 'creating an annul' do
    PriceCollection.make!(:coleta_de_precos)
    Employee.make!(:wenderson)

    navigate 'Compras e Licitações > Coletas de Preços'

    click_link '1/2012'

    click_link 'Propostas'

    click_link '1/2012 - Wenderson Malheiros'

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    fill_in 'Justificativa', :with => 'Something'

    click_on 'Salvar'

    click_on 'Anulação'

    expect(page).to have_content 'Anulação da Proposta de Wenderson Malheiros para a Coleta de Preço 1/2012'
    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros'
    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_disabled_field 'Justificativa'
    expect(page).to have_field 'Justificativa', :with => 'Something'

    expect(page).to_not have_link 'Apagar'
    expect(page).to_not have_button 'Salvar'
  end
end
