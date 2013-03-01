#encoding: utf-8
require 'spec_helper'

feature 'PurchaseSolicitationAnnul' do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'should not have a annul link when was creating a new purchase_solicitation_item_group' do
    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Criar Agrupamento de Item de Solicitação de Compra'

    expect(page).to_not have_link 'Anular'
    expect(page).to_not have_link 'Anulação'
  end

  scenario 'should see the default values on the screen' do
    PurchaseSolicitationItemGroup.make!(:reparo_2013)

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link "Agrupamento de reparo 2013"

    click_link 'Anular'

    expect(page).to have_content "Anular Agrupamento de Item de Solicitação de Compra Agrupamento de reparo 2013"

    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end

  scenario 'annul an existent purchase_solicitation_item_group' do
    item_group = PurchaseSolicitationItemGroup.make!(:reparo_2013)

    item = PurchaseSolicitationBudgetAllocationItem.last
    item.purchase_solicitation_item_group = item_group
    item.save

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link '1/2013'

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item:first' do
          expect(page).to have_select 'Status', :selected => 'Agrupado'
          expect(page).to have_field 'Agrupamento', :with => 'Agrupamento de reparo 2013'
        end
      end
    end

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Agrupamento de reparo 2013'

    click_link 'Anular'

    fill_modal 'Responsável', :field => 'Matrícula', :with => '958473'

    fill_in 'Data', :with => '21/08/2012'
    fill_in 'Justificativa', :with => 'Foo Bar'

    click_button 'Salvar'

    expect(page).to have_content 'Anulação de Recurso criada com sucesso.'

    expect(page).to have_disabled_element 'Salvar', :reason => 'este agrupamento foi anulado e não pode ser editado'
    expect(page).to_not have_link 'Anular'

    expect(page).to have_select 'Situação', :selected => 'Anulado'

    click_link 'Anulação'

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Data', :with => '21/08/2012'
    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Justificativa', :with => 'Foo Bar'
    expect(page).to have_disabled_field 'Justificativa'

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
    expect(page).to have_link 'Voltar'

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link '1/2013'

    within_tab 'Dotações orçamentárias' do
      within '.purchase-solicitation-budget-allocation:first' do
        within '.item:first' do
          expect(page).to have_select 'Status', :selected => 'Pendente'
          expect(page).to have_field 'Agrupamento', :with => ''
        end
      end
    end
  end

  scenario 'disable annul button if not annullable' do
    PurchaseSolicitationItemGroup.make!(
      :antivirus,
      :licitation_process => LicitationProcess.make!(:processo_licitatorio)
    )

    navigate 'Processos de Compra > Agrupamentos de Itens de Solicitações de Compra'

    click_link 'Agrupamento de antivirus'

    expect(page).to have_disabled_element 'Anular', :reason => 'este agrupamento já está em uso e não pode ser anulado'
  end
end
