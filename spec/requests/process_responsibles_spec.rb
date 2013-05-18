# encoding: utf-8
require 'spec_helper'

feature "ProcessResponsibles" do
  background do
    sign_in
  end

  scenario 'create a new process_responsible' do
    make_dependencies!

    navigate 'Processos de Compra > Responsáveis pelo Processo'

    click_link 'Criar responsável'

    within 'div.nested-process_responsibles:first' do
      fill_modal 'Funcionário', :with => '958473', :field => 'Matrícula'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    within 'div.nested-process_responsibles:first' do
      expect(page).to have_field 'Funcionário', :with => 'Gabriel Sobrinho'

      fill_modal 'Funcionário', :with => '12903412', :field => 'Matrícula'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    expect(page).to have_field 'Funcionário', :with => 'Wenderson Malheiros'

    click_link 'Adicionar Responsável pelo Processo'

    within 'div.nested-process_responsibles:first' do
      fill_modal 'Etapas do Processo', :with => 'Emissão do edital', :field => 'Descrição'
      fill_modal 'Funcionário', :with => '958473', :field => 'Matrícula'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    within 'div.nested-process_responsibles:last' do
      expect(page).to have_field 'Etapas do Processo', :with => 'Emissão do edital'
      expect(page).to have_field 'Funcionário', :with => 'Gabriel Sobrinho'

      click_button 'Remover'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    within 'div.nested-process_responsibles:last' do
      expect(page).to have_field 'Etapas do Processo', :with => 'Emissão do edital'
      expect(page).to have_field 'Funcionário', :with => 'Wenderson Malheiros'
    end
  end

  def make_dependencies!
    LicitationProcess.make!(:processo_licitatorio)
    StageProcess.make!(:emissao_edital)
    Employee.make!(:sobrinho)
    Employee.make!(:wenderson)
  end
end
