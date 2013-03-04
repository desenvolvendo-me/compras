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

    click_link "Limpar Filtro"

    click_link "1/2012"

    within_tab 'Trâmites' do
      click_link 'Encerrar pregão'
    end

    click_link 'Voltar'

    expect(page).to have_title 'Editar Pregão Presencial'

    expect(page).to be_on_tab 'Trâmites'

    click_link 'Encerrar pregão'

    expect(page).to have_title 'Criar Encerramento do Pregão Presencial'

    expect(page).to have_disabled_field 'Pregão', :with => '1/2012'

    expect(page).to_not have_link 'Apagar'

    select 'Suspenso', :from => 'Status'

    fill_in 'Observação', :with => 'Suspenso por tempo indeterminado'

    click_button 'Salvar'

    expect(page).to have_notice 'Encerramento do Pregão Presencial criado com sucesso.'

    expect(page).to have_title 'Editar Pregão Presencial'

    expect(page).to be_on_tab 'Trâmites'

    within_records do
      expect(page).to have_content "#{I18n.l Date.current}"
      expect(page).to have_content 'Suspenso'
      expect(page).to have_content 'Suspenso por tempo indeterminado'
    end
  end
end
