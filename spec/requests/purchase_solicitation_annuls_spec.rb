#encoding: utf-8
require 'spec_helper'

feature 'PurchaseSolicitationAnnul' do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'should not have a annul link when was creating a new solicitation' do
    navigate 'Processos de Compra > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    expect(page).to_not have_link 'Anular'
    expect(page).to_not have_link 'Anulação'
  end

  scenario 'should see the default values on the screen' do
    solicitation = PurchaseSolicitation.make!(:reparo)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "#{solicitation}"

    click_link 'Anular'

    expect(page).to have_content "Anular Solicitação de Compra #{solicitation}"

    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end

  scenario 'annul button should be disabled when there is a direct_purchase related' do
    purchase_solicitation = PurchaseSolicitation.make!(:reparo,
        :service_status => PurchaseSolicitationServiceStatus::LIBERATED)
    DirectPurchase.make!(:compra,
        :purchase_solicitation => purchase_solicitation)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "#{purchase_solicitation}"

    expect(page).to have_disabled_element 'Anular',
                                          :reason => 'esta solicitação já está em uso e não pode ser anulada'
  end

  scenario 'annuling a purchase solicitation' do
    solicitation = PurchaseSolicitation.make!(:reparo)

    navigate 'Processos de Compra > Solicitações de Compra'

    click_link "#{solicitation}"

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'

      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Data', :with => '10/06/2012'
    fill_in 'Justificativa', :with => 'Foo Bar'

    click_button 'Salvar'

    expect(page).to have_content 'Anulação de Recurso criada com sucesso.'

    expect(page).to have_content "Editar #{solicitation}"
    expect(page).to have_select 'Status de atendimento', :selected => 'Anulada'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Ano'
      expect(page).to have_disabled_field 'Data da solicitação'
      expect(page).to have_disabled_field 'Estrutura orçamentaria solicitante'
      expect(page).to have_disabled_field 'Responsável pela solicitação'
      expect(page).to have_disabled_field 'Justificativa da solicitação'
      expect(page).to have_disabled_field 'Local para entrega'
      expect(page).to have_disabled_field 'Tipo de solicitação'
      expect(page).to have_disabled_field 'Observações gerais'
      expect(page).to have_disabled_field 'Status de atendimento'
      expect(page).to have_disabled_field 'Liberação'
      expect(page).to have_disabled_field 'Por'
      expect(page).to have_disabled_field 'Observações do atendimento'
      expect(page).to have_disabled_field 'Justificativa para não atendimento'
    end

    within_tab 'Dotações orçamentarias' do
      expect(page).to have_disabled_field 'Valor total dos itens'

      expect(page).to have_disabled_field 'Dotação'
      expect(page).to have_disabled_field 'Natureza da despesa'

      expect(page).to have_disabled_field 'Item'
      expect(page).to have_disabled_field 'Material'
      expect(page).to have_disabled_field 'Marca/Referência'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_disabled_field 'Quantidade'
      expect(page).to have_disabled_field 'Valor unitário'
      expect(page).to have_disabled_field 'Valor total'
    end
    expect(page).to have_disabled_element 'Adicionar Dotação',
                    :reason => 'esta solicitação foi anulada e não pode ser editada'
    expect(page).to have_disabled_element 'Adicionar Item',
                    :reason => 'esta solicitação foi anulada e não pode ser editada'
    expect(page).to have_disabled_element 'Remover Item',
                    :reason => 'esta solicitação foi anulada e não pode ser editada'
    expect(page).to have_disabled_element 'Remover Dotação',
                    :reason => 'esta solicitação foi anulada e não pode ser editada'

    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'esta solicitação foi anulada e não pode ser editada'

    click_link 'Anulação'

    expect(page).to have_disabled_field 'Responsável'
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_disabled_field 'Data'
    expect(page).to have_field 'Data', :with => '10/06/2012'

    expect(page).to have_disabled_field 'Justificativa'
    expect(page).to have_field 'Justificativa', :with => 'Foo Bar'

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end
end
