# encoding: utf-8
require 'spec_helper'

feature "AdministrativeProcessLiberations" do
  background do
    sign_in
  end

  scenario 'release an administrative_process' do
    AdministrativeProcess.make!(:compra_aguardando)
    Employee.make!(:sobrinho)

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Administrativo > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Liberar'

    page.should have_content 'Liberação do Processo Administrativo 1/2012'

    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
    fill_in 'Data', :with => '15/06/2012'

    click_button 'Salvar'

    page.should have_notice 'Processo Administrativo liberado com sucesso'

    click_link 'Liberação'

    page.should have_disabled_field 'Responsável'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_disabled_field 'Data'
    page.should have_field 'Data',  :with => '15/06/2012'
  end

  scenario 'when edit a liberation all fields should be disabled' do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Administrativo > Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Liberação'

    page.should have_disabled_field 'Responsável'
    page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => '01/02/2012'

    page.should_not have_button 'Salvar'
    page.should_not have_button 'Apagar'
  end

  scenario 'cancel should return to edit_administrative_process' do
    AdministrativeProcess.make!(:compra_de_cadeiras)

    navigate_through 'Compras e Licitações > Processo Administrativo/Licitatório > Processo Administrativo > Processos Administrativos'

    
    within_records do
      page.find('a').click
    end

    click_link 'Liberação'

    click_link 'Cancelar'

    page.should have_content 'Editar 1/2012'
  end
end
