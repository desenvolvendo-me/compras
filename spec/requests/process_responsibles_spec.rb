# encoding: utf-8
require 'spec_helper'

feature "ProcessResponsibles" do
  background do
    sign_in
  end

  scenario 'create a new process_responsible' do
    make_dependencies!

    navigate 'Processos de Compra > Responsáveis pelo Process'

    click_link 'Criar responsável'

    within '.emissao-do-edital' do
      fill_modal 'emissao-do-edital-employee_id', :with => '958473', :field => 'Matrícula'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    within '.emissao-do-edital' do
      expect(page).to have_field 'emissao-do-edital-employee_id', :with => 'Gabriel Sobrinho'

      fill_modal 'emissao-do-edital-employee_id', :with => '12903412', :field => 'Matrícula'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    expect(page).to have_field 'emissao-do-edital-employee_id', :with => 'Wenderson Malheiros'

  end

  def make_dependencies!
    LicitationProcess.make!(:processo_licitatorio)
    StageProcess.make!(:emissao_edital)
    Employee.make!(:sobrinho)
    Employee.make!(:wenderson)
  end
end
