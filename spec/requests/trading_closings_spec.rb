#encoding: utf-8
require 'spec_helper'

feature TradingClosing do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['tradings']
    sign_in
  end

  scenario 'closing an trading' do
    TradingConfiguration.make!(:pregao)
    Trading.make!(:pregao_presencial)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"

    click_link 'Encerrar pregão'

    expect(page).to have_title 'Encerramentos do Pregão Presencial'

    expect(page).to have_link 'Voltar ao Pregão Presencial'

    click_link 'Criar Encerramento do Pregão Presencial'

    expect(page).to have_disabled_field 'Pregão', :with => '1/2012'

    expect(page).to_not have_link 'Apagar'

    select 'Suspenso', :from => 'Status'

    fill_in 'Observação', :with => 'Suspenso por tempo indeterminado'

    click_button 'Salvar'

    expect(page).to have_notice 'Encerramento do Pregão Presencial criado com sucesso.'

    expect(page).to have_title 'Encerramentos do Pregão Presencial'

    within_records do
      click_link '1/2012 - Suspenso'
    end

    expect(page).to have_disabled_field 'Pregão', :with => '1/2012'
    expect(page).to have_select 'Status', :selected => 'Suspenso'
    expect(page).to have_field 'Observação', :with => 'Suspenso por tempo indeterminado'
    expect(page).to have_link 'Apagar'
  end

  scenario 'edit an existing trading closing' do
    TradingConfiguration.make!(:pregao)
    trading = Trading.make!(:pregao_presencial)
    TradingClosing.make!(:encerramento, :trading => trading)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"

    click_link 'Encerrar pregão'

    within_records do
      click_link '1/2012 - Deserto'
    end

    expect(page).to have_disabled_field 'Pregão', :with => '1/2012'
    expect(page).to have_select 'Status', :selected => 'Deserto'
    expect(page).to have_field 'Observação', :with => 'Encerramento do pregão'

    select 'Suspenso', :from => 'Status'

    fill_in 'Observação', :with => 'Suspenso por tempo indeterminado'

    click_button 'Salvar'

    expect(page).to have_notice 'Encerramento do Pregão Presencial editado com sucesso.'

    within_records do
      click_link '1/2012 - Suspenso'
    end

    expect(page).to have_disabled_field 'Pregão', :with => '1/2012'
    expect(page).to have_select 'Status', :selected => 'Suspenso'
    expect(page).to have_field 'Observação', :with => 'Suspenso por tempo indeterminado'
  end

  scenario 'destroy an existing trading closing' do
    TradingConfiguration.make!(:pregao)
    trading = Trading.make!(:pregao_presencial)
    TradingClosing.make!(:encerramento, :trading => trading)

    navigate "Processo Administrativo/Licitatório > Pregão Presencial"

    click_link "1/2012"

    click_link 'Encerrar pregão'

    within_records do
      click_link '1/2012 - Deserto'
    end

    expect(page).to have_disabled_field 'Pregão', :with => '1/2012'
    expect(page).to have_select 'Status', :selected => 'Deserto'
    expect(page).to have_field 'Observação', :with => 'Encerramento do pregão'

    click_link 'Apagar'

    expect(page).to have_notice 'Encerramento do Pregão Presencial apagado com sucesso.'

    within_records do
      expect(page).to_not have_link '1/2012 - Deserto'
    end
  end
end
