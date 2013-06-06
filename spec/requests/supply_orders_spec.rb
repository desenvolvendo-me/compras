# encoding: utf-8
require 'spec_helper'

feature "SupplyOrder" do
  background do
    sign_in
  end

  scenario 'create a new supply order, update and destroy an existing' do
    Creditor.make!(:sobrinho)
    LicitationProcess.make!(:pregao_presencial)

    navigate 'Instrumentos Contratuais > Ordem de Fornecimento'

    click_link 'Criar Ordem de Fornecimento'

    fill_modal 'Fornecedor', with: 'Gabriel Sobrinho'
    fill_modal 'Processo de compra', with: '1', field: 'Processo'

    fill_in 'Data da autorização', with: I18n.l(Date.new(2013, 12, 13))

    click_button 'Salvar'

    expect(page).to have_notice 'Ordem de Fornecimento criado com sucesso.'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'Fornecedor', with: 'Gabriel Sobrinho'
    expect(page).to have_field 'Processo de compra', with: '1/2012 - Pregão 1'
    expect(page).to have_field 'Data da autorização', with: '13/12/2013'

    fill_in 'Data da autorização', with: I18n.l(Date.new(2013, 12, 15))

    click_button 'Salvar'

    expect(page).to have_notice 'Ordem de Fornecimento editado com sucesso.'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'Fornecedor', with: 'Gabriel Sobrinho'
    expect(page).to have_field 'Processo de compra', with: '1/2012 - Pregão 1'
    expect(page).to have_field 'Data da autorização', with: '15/12/2013'

    click_link 'Apagar'

    expect(page).to have_notice 'Ordem de Fornecimento apagado com sucesso.'

    expect(page).to_not have_link 'Gabriel Sobrinho'
  end
end
