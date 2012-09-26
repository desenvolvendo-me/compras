# encoding: utf-8
require 'spec_helper'

feature "EventCheckingConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new event_checking_configuration' do
    Descriptor.make!(:detran_2012)

    navigate 'Contabilidade > Comum > Plano de Contas > Configurações de Eventos Contábeis'

    click_link 'Criar Configuração de Evento Contábil'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_in 'Evento', :with => 'Evento Tal'
    fill_in 'Função', :with => 'Função Tal'

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Evento Contábil criado com sucesso.'

    click_link 'Evento Tal'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Evento', :with => 'Evento Tal'
    expect(page).to have_field 'Função', :with => 'Função Tal'
  end

  scenario 'update an existent event_checking_configuration' do
    EventCheckingConfiguration.make!(:detran)

    navigate 'Contabilidade > Comum > Plano de Contas > Configurações de Eventos Contábeis'

    click_link 'Evento Tal'

    fill_in 'Função', :with => 'Função alterada'

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Evento Contábil editado com sucesso.'

    click_link 'Evento Tal'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Evento', :with => 'Evento Tal'
    expect(page).to have_field 'Função', :with => 'Função alterada'
  end

  scenario 'destroy an existent event_checking_configuration' do
    EventCheckingConfiguration.make!(:detran)

    navigate 'Contabilidade > Comum > Plano de Contas > Configurações de Eventos Contábeis'

    click_link 'Evento Tal'

    click_link 'Apagar'

    expect(page).to have_notice 'Configuração de Evento Contábil apagado com sucesso.'

    expect(page).to_not have_content '2012 - Detran'
    expect(page).to_not have_content 'Evento Tal'
  end
end
