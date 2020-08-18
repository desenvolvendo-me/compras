require 'spec_helper'

feature 'PriceCollectionAnnuls' do
  background do
    sign_in
  end

  scenario 'accessing the annul for an price_collection at the first time' do
    PriceCollection.make!(:coleta_de_precos)

    navigate 'Compras > Coletas de Preços'

    

    click_link '1/2012'

    click_link 'Anular'

    expect(page).to have_content 'Anular Coleta de Preço 1/2012'
    expect(page).to have_field 'Data', :with => I18n.l(Date.current)

    click_link 'Voltar'

    expect(page).to have_title 'Editar Coleta de Preços'
  end

  scenario 'creating a price collection annul' do
    PriceCollection.make!(:coleta_de_precos)
    Employee.make!(:wenderson)

    navigate 'Compras > Coletas de Preços'

    

    click_link '1/2012'

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'
      click_record 'Wenderson Malheiros'
    end

    select 'Anulação', :from => 'Tipo da anulação'

    fill_in 'Justificativa', :with => 'Something'

    click_on 'Salvar'

    expect(page).to have_notice 'Anulação de Coleta de Preço criada com sucesso.'

    click_on 'Anulação'

    expect(page).to have_content 'Anulação da Coleta de Preço 1/2012'
    expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros', disabled: true
    expect(page).to have_field 'Data', :with => I18n.l(Date.current), disabled: true
    expect(page).to have_field 'Justificativa', :with => 'Something', disabled: true
    expect(page).to have_select 'Tipo da anulação', :selected => 'Anulação', disabled: true

    expect(page).to_not have_link 'Apagar'
    expect(page).to_not have_button 'Salvar'
  end
end
