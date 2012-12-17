# encoding: utf-8
require 'spec_helper'

feature "TradingConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new trading_configuration' do
    navigate "Processo Administrativo/Licitatório > Auxiliar > Configuração do Pregão Presencial"

    fill_in 'Porcentagem limite para participar das ofertas', :with => '10,00'

    click_button 'Salvar'

    expect(page).not_to have_button 'Apagar'

    expect(page).to have_notice 'Configuração do Registro de Preço criado com sucesso.'

    navigate "Processo Administrativo/Licitatório > Auxiliar > Configuração do Pregão Presencial"

    expect(page).to have_field 'Porcentagem limite para participar das ofertas', :with => '10,00'
  end

  scenario 'update an existent trading_configuration' do
    TradingConfiguration.make!(:pregao)

    navigate "Processo Administrativo/Licitatório > Auxiliar > Configuração do Pregão Presencial"

    expect(page).to have_field 'Porcentagem limite para participar das ofertas', :with => '10,00'

    fill_in 'Porcentagem limite para participar das ofertas', :with => '20,00'

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração do Registro de Preço editado com sucesso.'

    navigate "Processo Administrativo/Licitatório > Auxiliar > Configuração do Pregão Presencial"

    expect(page).to have_field 'Porcentagem limite para participar das ofertas', :with => '20,00'
  end
end
