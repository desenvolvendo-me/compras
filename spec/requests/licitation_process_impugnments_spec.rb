# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessImpugnments" do
  background do
    sign_in
  end

  scenario 'create a new licitation_process_impugnment' do
    LicitationProcess.make!(:processo_licitatorio)
    Person.make!(:sobrinho)

    navigate 'Processos de Compra > Impugnações dos Processos Licitatórios'

    click_link 'Criar Impugnação do Processo de Compra'

    expect(page).to have_select 'Situação', :selected => 'Pendente'

    fill_modal 'Processo de compra', :with => '2012', :field => 'Ano'
    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 2.days)
    select 'Pregão', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'

    expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    expect(page).to have_field 'Hora da entrega', :with => '14:00'
    expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Hora da abertura', :with => '14:00'

    click_button 'Salvar'

    expect(page).to have_notice 'Impugnação do Processo de Compra criada com sucesso.'

    within_records do
      click_link "1/2012 - Convite 1 - #{I18n.l(Date.current + 2.days)}"
    end

    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Convite 1'
    expect(page).to have_field 'Data da impugnação', :with => I18n.l(Date.current + 2.days)
    expect(page).to have_select 'Referente ao', :selected => 'Pregão'
    expect(page).to have_field 'Autor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'
    expect(page).to have_select 'Situação', :selected => 'Pendente'
    expect(page).to have_disabled_field 'Data do julgamento'
    expect(page).to have_field 'Data do julgamento', :with => ''
    expect(page).to have_disabled_field 'Observação'
    expect(page).to have_field 'Observação', :with => ''
    expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    expect(page).to have_field 'Hora da entrega', :with => '14:00'
    expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Hora da abertura', :with => '14:00'
  end

  scenario 'update an existent licitation_process_impugnment' do
    LicitationProcessImpugnment.make!(:proibido_cadeiras)

    navigate 'Processos de Compra > Impugnações dos Processos Licitatórios'

    within_records do
      click_link "1/2012 - Convite 1 - 01/04/2012"
    end

    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 1.year + 2.days)
    select 'Pregão', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'

    expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    expect(page).to have_field 'Hora da entrega', :with => '14:00'
    expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Hora da abertura', :with => '14:00'

    click_button 'Salvar'

    expect(page).to have_notice 'Impugnação do Processo de Compra editada com sucesso.'

    within_records do
      click_link "1/2012 - Convite 1 - #{I18n.l(Date.current + 1.year + 2.days)}"
    end

    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Convite 1'
    expect(page).to have_field 'Data da impugnação', :with => I18n.l(Date.current + 1.year + 2.days)
    expect(page).to have_select 'Referente ao', :selected => 'Pregão'
    expect(page).to have_field 'Autor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'
    expect(page).to have_disabled_field 'Data do julgamento'
    expect(page).to have_field 'Data do julgamento', :with => ''
    expect(page).to have_disabled_field 'Observação'
    expect(page).to have_field 'Observação', :with => ''
    expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    expect(page).to have_field 'Hora da entrega', :with => '14:00'
    expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Hora da abertura', :with => '14:00'
  end

  scenario 'should have fields disabled when situation is not pending' do
    LicitationProcessImpugnment.make!(:proibido_cadeiras_deferida)

    navigate 'Processos de Compra > Impugnações dos Processos Licitatórios'

    within_records do
      click_link '1/2012 - Convite 1 - 01/04/2012'
    end

    expect(page).to have_disabled_field 'Processo de compra'
    expect(page).to have_disabled_field 'Data da impugnação'
    expect(page).to have_disabled_field 'Referente ao'
    expect(page).to have_disabled_field 'Autor'
    expect(page).to have_disabled_field 'Motivo fundamentado da impugnação'
    expect(page).to have_disabled_field 'Data do julgamento'
    expect(page).to have_disabled_field 'Observação'
    expect(page).to have_disabled_field 'Data da entrega dos envelopes'
    expect(page).to have_disabled_field 'Hora da entrega'
    expect(page).to have_disabled_field 'Data da abertura dos envelopes'
    expect(page).to have_disabled_field 'Hora da abertura'

    expect(page).to have_disabled_element 'Salvar', :reason => 'permitido alterar somente em situação pendente'
  end

  scenario 'should not be able to destroy an existent licitation_process_impugnment' do
    LicitationProcessImpugnment.make!(:proibido_cadeiras)

    navigate 'Processos de Compra > Impugnações dos Processos Licitatórios'

    within_records do
      click_link '1/2012 - Convite 1 - 01/04/2012'
    end

    expect(page).to_not have_link "Apagar"
  end

  scenario 'envelope dates should be filled when licitation process selected' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processos de Compra > Impugnações dos Processos Licitatórios'

    click_link 'Criar Impugnação do Processo de Compra'

    fill_modal 'Processo de compra', :with => '2012', :field => 'Ano'

    expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    expect(page).to have_field 'Hora da entrega', :with => '14:00'
    expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Hora da abertura', :with => '14:00'
  end

  scenario 'envelope dates should be empty when clear licitaion process' do
    LicitationProcessImpugnment.make!(:proibido_cadeiras)

    navigate 'Processos de Compra > Impugnações dos Processos Licitatórios'

    within_records do
      click_link '1/2012 - Convite 1 - 01/04/2012'
    end

    clear_modal 'Processo de compra'

    expect(page).to have_field 'Data da entrega dos envelopes', :with => ''
    expect(page).to have_field 'Hora da entrega', :with => ''
    expect(page).to have_field 'Data da abertura dos envelopes', :with => ''
    expect(page).to have_field 'Hora da abertura', :with => ''
  end
end
