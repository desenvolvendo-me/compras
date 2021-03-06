require 'spec_helper'

feature 'PriceCollectionProposalAnnul' do
  background do
    sign_in
  end

  scenario 'accessing the form' do
    PriceCollection.make!(:coleta_de_precos)

    navigate 'Licitações > Coletas de Preços'

    

    click_link '1/2012'

    click_link 'Propostas'

    click_link '1/2012'

    click_link 'Anular'

    expect(page).to have_content 'Anular Proposta do Fornecedor Wenderson Malheiros para a Coleta de Preço 1/2012'

    expect(page).to have_field 'Data', :with => I18n.l(Date.current)

    click_link 'Voltar'

    expect(page).to have_content 'Proposta do Fornecedor Wenderson Malheiros para a Coleta de Preço 1/2012'
  end

  scenario 'creating an annul' do
    PriceCollection.make!(:coleta_de_precos)
    Employee.make!(:wenderson)

    navigate 'Licitações > Coletas de Preços'

    

    click_link '1/2012'

    click_link 'Propostas'

    click_link '1/2012'

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    fill_in 'Justificativa', :with => 'Something'

    click_on 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criado com sucesso.'

    click_on 'Anulação'

    expect(page).to have_content 'Anulação da Proposta de Wenderson Malheiros para a Coleta de Preço 1/2012'
    expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros', disabled: true
    expect(page).to have_field 'Data', :with => I18n.l(Date.current), disabled: true
    expect(page).to have_field 'Justificativa', :with => 'Something', disabled: true

    expect(page).to_not have_link 'Apagar'
    expect(page).to_not have_button 'Salvar'
  end
end
