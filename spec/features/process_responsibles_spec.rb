require 'spec_helper'

feature "ProcessResponsibles" do
  background do
    sign_in
  end

  scenario 'create a new process_responsible' do
    make_dependencies!

    navigate 'Licitações > Responsáveis pelo Processo'

    click_link 'Criar responsável'

    within 'div.nested-process_responsibles:nth-child(1)' do
      expect(page).to have_field 'Etapas do Processo', with: 'Emissão do edital', disabled: true
      expect(page).to_not have_button 'Remover'

      fill_modal 'Funcionário', :with => '958473', :field => 'Matrícula'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    within 'div.nested-process_responsibles:nth-child(1)' do
      expect(page).to have_field 'Funcionário', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Etapas do Processo', with: 'Emissão do edital', disabled: true
      expect(page).to_not have_button 'Remover'

      fill_modal 'Funcionário', :with => '12903412', :field => 'Matrícula'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    expect(page).to have_field 'Funcionário', :with => 'Wenderson Malheiros'

    click_link 'Adicionar Responsável pelo Processo'

    within 'div.nested-process_responsibles:nth-child(1)' do
      fill_modal 'Etapas do Processo', :with => 'Emissão do edital', :field => 'Descrição'
      fill_modal 'Funcionário', :with => '958473', :field => 'Matrícula'
    end

    within 'div.nested-process_responsibles:nth-last-child(1)' do
      expect(page).to have_field 'Etapas do Processo', with: 'Emissão do edital', disabled: true
      expect(page).to_not have_button 'Remover'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    within 'div.nested-process_responsibles:nth-child(1)' do
      expect(page).to have_field 'Etapas do Processo', with: 'Emissão do edital', disabled: true
      expect(page).to_not have_button 'Remover'
    end

    within 'div.nested-process_responsibles:nth-last-child(1)' do
      expect(page).to have_field 'Etapas do Processo', :with => 'Emissão do edital'
      expect(page).to have_field 'Funcionário', :with => 'Gabriel Sobrinho'

      click_button 'Remover'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Processo de Compra editado com sucesso.'

    click_link 'Editar responsável'

    within 'div.nested-process_responsibles:nth-last-child(1)' do
      expect(page).to have_field 'Etapas do Processo', :with => 'Emissão do edital', disabled: true
      expect(page).to have_field 'Funcionário', :with => 'Wenderson Malheiros'
      expect(page).to_not have_button 'Remover'
    end
  end

  def make_dependencies!
    LicitationProcess.make!(:processo_licitatorio)
    StageProcess.make!(:emissao_edital)
    Employee.make!(:sobrinho)
    Employee.make!(:wenderson)
  end
end
