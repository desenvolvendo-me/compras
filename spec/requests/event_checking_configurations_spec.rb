# encoding: utf-8
require 'spec_helper'

feature "EventCheckingConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new event_checking_configuration' do
    Descriptor.make!(:detran_2012)
    CheckingAccountOfFiscalAccount.make!(:disponibilidade_financeira)

    navigate 'Cadastros Gerais > Plano de Contas > Configurações de Eventos Contábeis'

    click_link 'Criar Configuração de Evento Contábil'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_in 'Evento', :with => 'Evento Tal'
      fill_in 'Função', :with => 'Função Tal'
    end

    within_tab 'Contas Contábeis' do
      click_button 'Adicionar Conta Contábil'

      fill_modal 'Conta corrente da conta contábil', :with => 'Disponibilidade financeira'
      select 'Crédito', :from => 'Natureza de lançamento'
      select 'Somar', :from => 'Operação'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Evento Contábil criado com sucesso.'

    click_link 'Evento Tal'

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2012 - Detran'
      expect(page).to have_field 'Evento', :with => 'Evento Tal'
      expect(page).to have_field 'Função', :with => 'Função Tal'
    end

    within_tab 'Contas Contábeis' do
      expect(page).to have_field 'Conta corrente da conta contábil', :with => '14 - Disponibilidade financeira'
      expect(page).to have_select 'Natureza de lançamento', :selected => 'Crédito'
      expect(page).to have_select 'Operação', :selected => 'Somar'
    end
  end

  scenario 'update an existent event_checking_configuration' do
    EventCheckingConfiguration.make!(:detran)
    CheckingAccountOfFiscalAccount.make!(:disponibilidade)

    navigate 'Cadastros Gerais > Plano de Contas > Configurações de Eventos Contábeis'

    click_link 'Evento Tal'

    within_tab 'Principal' do
      fill_in 'Função', :with => 'Função alterada'
    end

    within_tab 'Contas Contábeis' do
      click_button 'Remover'

      click_button 'Adicionar Conta Contábil'

      fill_modal 'Conta corrente da conta contábil', :with => 'Disponibilidade financeira'
      select 'Crédito', :from => 'Natureza de lançamento'
      select 'Somar', :from => 'Operação'

      click_button 'Adicionar Conta Contábil'

      within '.nested-event-account:nth-child(3)' do
        fill_modal 'Conta corrente da conta contábil', :with => 'Disponibilidade'
        select 'Débito', :from => 'Natureza de lançamento'
        select 'Subtrair', :from => 'Operação'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Evento Contábil editado com sucesso.'

    click_link 'Evento Tal'

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2012 - Detran'
      expect(page).to have_field 'Evento', :with => 'Evento Tal'
      expect(page).to have_field 'Função', :with => 'Função alterada'
    end

    within_tab 'Contas Contábeis' do
      within '.nested-event-account:nth-child(1)' do
        expect(page).to have_field 'Conta corrente da conta contábil', :with => '30 - Disponibilidade'
        expect(page).to have_select 'Natureza de lançamento', :selected => 'Débito'
        expect(page).to have_select 'Operação', :selected => 'Subtrair'
      end

      within '.nested-event-account:nth-child(2)' do
        expect(page).to have_field 'Conta corrente da conta contábil', :with => '14 - Disponibilidade financeira'
        expect(page).to have_select 'Natureza de lançamento', :selected => 'Crédito'
        expect(page).to have_select 'Operação', :selected => 'Somar'
      end
    end
  end

  scenario 'destroy an existent event_checking_configuration' do
    EventCheckingConfiguration.make!(:detran)

    navigate 'Cadastros Gerais > Plano de Contas > Configurações de Eventos Contábeis'

    click_link 'Evento Tal'

    click_link 'Apagar'

    expect(page).to have_notice 'Configuração de Evento Contábil apagado com sucesso.'

    expect(page).to_not have_content '2012 - Detran'
    expect(page).to_not have_content 'Evento Tal'
  end
end
