# encoding: utf-8
require 'spec_helper'

feature "StageProcesses" do
  background do
    sign_in
  end

  scenario 'create a new stage_process' do
    navigate 'Processos de Compra > Etapas do Processo'

    click_link 'Criar Etapa do Processo'

    fill_in 'Descrição', with: '1 Etapa'
    select 'Compra direta', from: 'Tipo de compra'

    click_button 'Salvar'

    expect(page).to have_notice 'Etapa do Processo criado com sucesso.'

    click_link '1 Etapa'

    expect(page).to have_field 'Descrição', :with => '1 Etapa'
    expect(page).to have_select 'Tipo de compra', selected: 'Compra direta'

    fill_in 'Descrição', with: '2 Etapa'
    select 'Compra direta', from: 'Tipo de compra'

    click_button 'Salvar'

    expect(page).to have_notice 'Etapa do Processo editado com sucesso.'

    click_link '2 Etapa'

    expect(page).to have_field 'Descrição', with: '2 Etapa'
    expect(page).to have_select 'Tipo de compra', selected: 'Compra direta'

    click_link 'Apagar'

    expect(page).to have_notice 'Etapa do Processo apagado com sucesso.'

    expect(page).to_not have_content '2 Etapa'
    expect(page).to_not have_content 'Processo licitatório'
  end
end
