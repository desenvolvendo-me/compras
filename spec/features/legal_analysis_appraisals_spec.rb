require 'spec_helper'

feature "LegalAnalysisAppraisals", vcr: { cassette_name: :legal_analysis_appraisals }  do
  background do
    sign_in
  end

  scenario 'create a new legal_analysis_appraisal, update and destroy an existing' do
    LicitationProcess.make!(:processo_licitatorio)
    Employee.make!(:sobrinho)
    Employee.make!(:wenderson)

    navigate 'Licitações > Processos de Compra'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Laudo de Análise Jurídica'

    click_link 'Criar Laudo de Análise Jurídica'

    choose 'Laudo jurídico'
    select 'Edital', :from => 'Referência'
    fill_in 'Data de expedição do laudo', :with => '27/03/2013'
    fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'

    expect(page).to have_field 'Número', :with => 'MG16236013'
    expect(page).to have_select 'Orgão expedidor', :selected => 'SSP'

    click_button 'Salvar'

    expect(page).to have_notice 'Laudo de Análise Jurídica criado com sucesso.'

    click_link '1/2012'

    expect(page).to have_checked_field 'Laudo jurídico'
    expect(page).to have_select 'Referência', :selected => 'Edital'
    expect(page).to have_field 'Data de expedição do laudo', :with => '27/03/2013'
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    choose 'Laudo técnico'
    select 'Outros', :from => 'Referência'
    fill_in 'Data de expedição do laudo', :with => '30/03/2013'
    fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
    fill_in 'Número', :with => '9223356'
    select 'Conselho Regional de Medicina Veterinária', :from => 'Orgão expedidor'

    click_button 'Salvar'

    expect(page).to have_notice 'Laudo de Análise Jurídica editado com sucesso.'

    click_link '1/2012'

    expect(page).to have_checked_field 'Laudo técnico'
    expect(page).to have_select 'Referência', :selected => 'Outros'
    expect(page).to have_field 'Data de expedição do laudo', :with => '30/03/2013'
    expect(page).to have_field 'Responsável', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Número', :with => '9223356'
    expect(page).to have_select 'Orgão expedidor', :selected => 'Conselho Regional de Medicina Veterinária'

    click_link 'Apagar'

    expect(page).to have_notice 'Laudo de Análise Jurídica apagado com sucesso.'

    expect(page).to_not have_content '1/2012'
  end
end
