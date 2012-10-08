# encoding: utf-8
require 'spec_helper'

feature "AdministrativeProcessLiberations" do
  background do
    sign_in
  end

  scenario 'release an administrative_process' do
    AdministrativeProcess.make!(:compra_aguardando)
    Employee.make!(:sobrinho)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Liberar'

    expect(page).to have_content 'Liberar Processo Administrativo 1/2012'

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '15/06/2012'

    click_button 'Salvar'

    expect(page).to have_notice 'Processo Administrativo liberado com sucesso'

    click_link 'Liberação'

    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data',  :with => '15/06/2012'
  end

  scenario 'when edit a liberation all fields should be disabled' do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Liberação'

    expect(page).to have_content 'Liberação do Processo Administrativo 1/2012'

    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data', :with => '01/02/2012'

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_button 'Apagar'
  end

  scenario 'cancel should return to edit_administrative_process' do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate 'Compras e Licitações > Processo Administrativo/Licitatório > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Liberação'

    click_link 'Voltar'

    expect(page).to have_content 'Editar 1/2012'
  end
end
