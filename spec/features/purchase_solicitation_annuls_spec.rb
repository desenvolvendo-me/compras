require 'spec_helper'

feature 'PurchaseSolicitationAnnul', vcr: { cassette_name: :purchase_solicitation_annuls } do
  let :current_user do
    User.make!(:sobrinho_as_admin_and_employee)
  end

  background do
    sign_in
  end

  scenario 'should not have a annul link when was creating a new solicitation' do
    navigate 'Licitações > Solicitações de Compra'

    click_link 'Criar Solicitação de Compra'

    expect(page).to_not have_link 'Anular'
    expect(page).to_not have_link 'Anulação'
  end

  scenario 'should see the default values on the screen' do
    solicitation = PurchaseSolicitation.make!(:reparo)

    navigate 'Licitações > Solicitações de Compra'

    

    click_link "#{solicitation.decorator.code_and_year}"

    click_link 'Anular'

    expect(page).to have_content "Anular Solicitação de Compra #{solicitation}"

    expect(page).to have_field 'Data', :with => I18n.l(Date.current)
    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'

    expect(page).to have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end

  scenario 'annul button should be disabled when there is a direct_purchase related' do
    purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)
    LicitationProcess.make!(:processo_licitatorio, purchase_solicitations: [purchase_solicitation])

    navigate 'Licitações > Solicitações de Compra'

    

    click_link "#{purchase_solicitation.decorator.code_and_year}"

    expect(page).to have_disabled_element 'Anular',
                                          :reason => 'está sendo utilizada no processo de compra, não pode ser anulada.'
  end

  scenario 'annuling a purchase solicitation' do
    solicitation = PurchaseSolicitation.make!(:reparo)

    navigate 'Licitações > Solicitações de Compra'

    

    click_link "#{solicitation.decorator.code_and_year}"

    click_link 'Anular'

    within_modal 'Responsável' do
      click_button 'Pesquisar'

      click_record 'Gabriel Sobrinho'
    end

    fill_in 'Data', :with => '10/06/2012'
    fill_in 'Justificativa', :with => 'Foo Bar'

    click_button 'Salvar'

    expect(page).to have_notice 'Anulação de Recurso criada com sucesso.'

    expect(page).to have_title "Editar Solicitação de Compra"
    expect(page).to have_select 'Status de atendimento', :selected => 'Anulada', disabled: true

    within_tab 'Principal' do
      expect(page).to have_field 'Ano', disabled: true
      expect(page).to have_field 'Data da solicitação', disabled: true
      expect(page).to have_field 'Solicitante', disabled: true
      expect(page).to have_field 'Responsável pela solicitação', disabled: true
      expect(page).to have_field 'Justificativa da solicitação', disabled: true
      expect(page).to have_field 'Local para entrega', disabled: true
      expect(page).to have_field 'Tipo de solicitação', disabled: true
      expect(page).to have_field 'Observações gerais', disabled: true
      expect(page).to have_field 'Status de atendimento', disabled: true
      expect(page).to have_field 'Liberação', disabled: true
      expect(page).to have_field 'Por', disabled: true
      expect(page).to have_field 'Observações do atendimento', disabled: true
      expect(page).to have_field 'Justificativa para não atendimento', disabled: true
    end

    within_tab 'Itens' do
      expect(page).to have_field 'Valor total dos itens', disabled: true
    end

    within_tab 'Itens' do
      expect(page).to have_disabled_element 'Adicionar',
                      :reason => 'esta solicitação foi anulada e não pode ser editada'

      within_records do
        expect(page).to have_disabled_element 'Remover',
                        :reason => 'esta solicitação foi anulada e não pode ser editada'
      end
    end

    within_tab 'Dotações orçamentárias' do
      expect(page).to have_field 'Dotação', disabled: true

      within_records do
        expect(page).to have_disabled_element 'Remover',
                    :reason => 'esta solicitação foi anulada e não pode ser editada'
      end
    end

    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'esta solicitação já está em uso ou anulada e não pode ser editada'

    click_link 'Anulação'

    expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho', disabled: true

    expect(page).to have_field 'Data', :with => '10/06/2012', disabled: true

    expect(page).to have_field 'Justificativa', :with => 'Foo Bar', disabled: true

    expect(page).to_not have_button 'Salvar'
    expect(page).to_not have_link 'Apagar'
  end
end
