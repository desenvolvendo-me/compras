# encoding: utf-8
require 'spec_helper'

feature "TradingConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new trading_configuration and update an existent' do
    navigate "Processos de Compra > Auxiliar > Configuração do Pregão Presencial"

    fill_in 'Porcentagem limite para participar das ofertas', :with => '10,00'

    expect(page).not_to have_button 'Apagar'

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração do Registro de Preço criado com sucesso.'

    expect(page).to have_field 'Porcentagem limite para participar das ofertas', :with => '10,00'

    fill_in 'Porcentagem limite para participar das ofertas', :with => '15,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração do Registro de Preço editado com sucesso.'

    expect(page).to have_field 'Porcentagem limite para participar das ofertas', :with => '15,00'
  end
end
