require 'spec_helper'

feature "LicitationProcessImpugnments" do
  background do
    sign_in
  end

  scenario 'create and update a licitation_process_impugnment' do
    LicitationProcess.make!(:processo_licitatorio)
    Person.make!(:sobrinho)

    navigate 'Licitações > Impugnações dos Processos de Compras'

    click_link 'Criar Impugnação do Processo de Compra'

    expect(page).to have_select 'Situação', :selected => 'Pendente', disabled: true

    fill_modal 'Processo de compra', :with => '2012', :field => 'Ano'
    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 2.days)
    select 'Pregão', :from => 'Referente ao'
    fill_modal 'Autor', :with => 'Gabriel Sobrinho'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'

    expect(page).to have_field 'Data do recebimento dos envelopes', :with => I18n.l(Date.current), disabled: true
    expect(page).to have_field 'Hora do recebimento', :with => '14:00', disabled: true
    expect(page).to have_field 'Abertura das propostas', :with => I18n.l(Date.tomorrow), disabled: true
    expect(page).to have_field 'Hora da abertura', :with => '14:00', disabled: true

    click_button 'Salvar'

    expect(page).to have_notice 'Impugnação do Processo de Compra criada com sucesso.'

    within_records do
      click_link "1/2012 - Concorrência 1 - #{I18n.l(Date.current + 2.days)}"
    end

    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Concorrência 1'
    expect(page).to have_field 'Data da impugnação', :with => I18n.l(Date.current + 2.days)
    expect(page).to have_select 'Referente ao', :selected => 'Pregão'
    expect(page).to have_field 'Autor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras.'
    expect(page).to have_select 'Situação', :selected => 'Pendente', disabled: true
    expect(page).to have_field 'Data do julgamento', :with => '', disabled: true
    expect(page).to have_field 'Observação', :with => '', disabled: true
    expect(page).to have_field 'Data do recebimento dos envelopes', :with => I18n.l(Date.current), disabled: true
    expect(page).to have_field 'Hora do recebimento', :with => '14:00', disabled: true
    expect(page).to have_field 'Abertura das propostas', :with => I18n.l(Date.tomorrow), disabled: true
    expect(page).to have_field 'Hora da abertura', :with => '14:00', disabled: true

    fill_in 'Data da impugnação', :with => I18n.l(Date.current + 1.year + 2.days)
    select 'Edital', :from => 'Referente ao'
    fill_in 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras e mesas.'

    click_button 'Salvar'

    expect(page).to have_notice 'Impugnação do Processo de Compra editada com sucesso.'

    within_records do
      click_link "1/2012 - Concorrência 1 - #{I18n.l(Date.current + 1.year + 2.days)}"
    end

    expect(page).to have_field 'Processo de compra', :with => '1/2012 - Concorrência 1'
    expect(page).to have_field 'Data da impugnação', :with => I18n.l(Date.current + 1.year + 2.days)
    expect(page).to have_select 'Referente ao', :selected => 'Edital'
    expect(page).to have_field 'Autor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Motivo fundamentado da impugnação', :with => 'Não há a necessidade de comprar cadeiras e mesas.'
    expect(page).to have_field 'Data do julgamento', :with => '', disabled: true
    expect(page).to have_field 'Observação', :with => '', disabled: true
    expect(page).to have_field 'Data do recebimento dos envelopes', :with => I18n.l(Date.current), disabled: true
    expect(page).to have_field 'Hora do recebimento', :with => '14:00', disabled: true
    expect(page).to have_field 'Abertura das propostas', :with => I18n.l(Date.tomorrow), disabled: true
    expect(page).to have_field 'Hora da abertura', :with => '14:00', disabled: true
  end

  scenario 'should have fields disabled when situation is not pending' do
    LicitationProcessImpugnment.make!(:proibido_cadeiras_deferida)

    navigate 'Licitações > Impugnações dos Processos de Compras'

    within_records do
      click_link '1/2012 - Concorrência 1 - 01/04/2012'
    end

    expect(page).to have_field 'Processo de compra', disabled: true
    expect(page).to have_field 'Data da impugnação', disabled: true
    expect(page).to have_field 'Referente ao', disabled: true
    expect(page).to have_field 'Autor', disabled: true
    expect(page).to have_field 'Motivo fundamentado da impugnação', disabled: true
    expect(page).to have_field 'Data do julgamento', disabled: true
    expect(page).to have_field 'Observação', disabled: true
    expect(page).to have_field 'Data do recebimento dos envelopes', disabled: true
    expect(page).to have_field 'Hora do recebimento', disabled: true
    expect(page).to have_field 'Abertura das propostas', disabled: true
    expect(page).to have_field 'Hora da abertura', disabled: true

    expect(page).to have_disabled_element 'Salvar', :reason => 'permitido alterar somente em situação pendente'
  end

  scenario 'should not be able to destroy an existent licitation_process_impugnment' do
    LicitationProcessImpugnment.make!(:proibido_cadeiras)

    navigate 'Licitações > Impugnações dos Processos de Compras'

    within_records do
      click_link '1/2012 - Concorrência 1 - 01/04/2012'
    end

    expect(page).to_not have_link "Apagar"
  end

  scenario 'envelope dates should be filled when licitation process selected' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Impugnações dos Processos de Compras'

    click_link 'Criar Impugnação do Processo de Compra'

    fill_modal 'Processo de compra', :with => '2012', :field => 'Ano'

    expect(page).to have_field 'Data do recebimento dos envelopes', :with => I18n.l(Date.current), disabled: true
    expect(page).to have_field 'Hora do recebimento', :with => '14:00', disabled: true
    expect(page).to have_field 'Abertura das propostas', :with => I18n.l(Date.tomorrow), disabled: true
    expect(page).to have_field 'Hora da abertura', :with => '14:00', disabled: true
  end

  scenario 'envelope dates should be empty when clear licitaion process' do
    LicitationProcessImpugnment.make!(:proibido_cadeiras)

    navigate 'Licitações > Impugnações dos Processos de Compras'

    within_records do
      click_link '1/2012 - Concorrência 1 - 01/04/2012'
    end

    clear_modal 'Processo de compra'

    expect(page).to have_field 'Data do recebimento dos envelopes', :with => '', disabled: true
    expect(page).to have_field 'Hora do recebimento', :with => '', disabled: true
    expect(page).to have_field 'Abertura das propostas', :with => '', disabled: true
    expect(page).to have_field 'Hora da abertura', :with => '', disabled: true
  end
end
