# encoding: utf-8
require 'spec_helper'

feature "LicitationProcessImpugnments" do
  background do
    sign_in
  end

  scenario 'create a new licitation_process_impugnment' do
    LicitationProcess.make!(:processo_licitatorio)
    Person.make!(:sobrinho)

    navigate 'Processo Administrativo/Licitatório > Processo Licitatório > Impugnações dos Processos Licitatórios'

    click_link 'Criar Impugnação do Processo Licitatório'

    expect(page).to have_select 'Situação', :selected => 'Pendente'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 2.days)
    select 'Pregão', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'

    expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    expect(page).to have_field 'Hora da entrega', :with => '14:00'
    expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Hora da abertura', :with => '14:00'

    click_button 'Salvar'

    expect(page).to have_notice 'Impugnação do Processo Licitatório criado com sucesso.'
    click_link LicitationProcessImpugnment.last.to_s

    expect(page).to have_field 'Processo licitatório', :with => '1/2012'
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
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

    navigate 'Processo Administrativo/Licitatório > Processo Licitatório > Impugnações dos Processos Licitatórios'

    click_link licitation_process_impugnment.to_s

    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 1.year + 2.days)
    select 'Pregão', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'

    expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    expect(page).to have_field 'Hora da entrega', :with => '14:00'
    expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Hora da abertura', :with => '14:00'

    click_button 'Salvar'

    expect(page).to have_notice 'Impugnação do Processo Licitatório editado com sucesso.'

    click_link licitation_process_impugnment.to_s

    expect(page).to have_field 'Processo licitatório', :with => '1/2012'
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
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras_deferida)

    navigate 'Processo Administrativo/Licitatório > Processo Licitatório > Impugnações dos Processos Licitatórios'

    click_link licitation_process_impugnment.to_s

    expect(page).to have_disabled_field 'Processo licitatório'
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

    expect(page).to_not have_button 'Atualizar Impugnação do Processo Licitatório'
  end

  scenario 'destroy an existent licitation_process_impugnment' do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

    navigate 'Processo Administrativo/Licitatório > Processo Licitatório > Impugnações dos Processos Licitatórios'

    click_link licitation_process_impugnment.to_s

    expect(page).to_not have_link "Apagar"
  end

  scenario 'envelope dates should be filled when licitation process selected' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processo Administrativo/Licitatório > Processo Licitatório > Impugnações dos Processos Licitatórios'

    click_link 'Criar Impugnação do Processo Licitatório'

    fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

    expect(page).to have_field 'Data da entrega dos envelopes', :with => I18n.l(Date.current)
    expect(page).to have_field 'Hora da entrega', :with => '14:00'
    expect(page).to have_field 'Data da abertura dos envelopes', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Hora da abertura', :with => '14:00'
  end

  scenario 'envelope dates should be empty when clear licitaion process' do
    licitation_process_impugnment = LicitationProcessImpugnment.make!(:proibido_cadeiras)

    navigate 'Processo Administrativo/Licitatório > Processo Licitatório > Impugnações dos Processos Licitatórios'

    click_link licitation_process_impugnment.to_s

    clear_modal 'Processo licitatório'

    expect(page).to have_field 'Data da entrega dos envelopes', :with => ''
    expect(page).to have_field 'Hora da entrega', :with => ''
    expect(page).to have_field 'Data da abertura dos envelopes', :with => ''
    expect(page).to have_field 'Hora da abertura', :with => ''
  end
end
