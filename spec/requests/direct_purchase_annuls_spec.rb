# encoding: utf-8
require 'spec_helper'

feature 'DirectPurchaseAnnuls' do
  background do
    sign_in
  end

  pending 'Esses testes serão removidos em breve' do
    scenario 'annul link should not be visible on create a direct purchase' do
      navigate 'Processos de Compra > Compra Direta'

      click_link 'Gerar Compra Direta'

      expect(page).to_not have_link 'Anular'
    end

    scenario 'annul link should be visible on update direct purchase' do
      DirectPurchase.make!(:compra)

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      expect(page).to have_link 'Anular'
    end

    scenario 'should not be possible to save or generate supply_authorizarion when annulled' do
      ResourceAnnul.make!(
        :anulacao_generica,
        :annullable => DirectPurchase.make!(:compra)
      )

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      expect(page).to_not have_link 'Anular'
      expect(page).to have_disabled_element 'Salvar', :reason => 'não é permitido para compra anulada'
      expect(page).to have_disabled_element 'Gerar autorização de fornecimento', :reason => 'não é permitido para compra anulada'
    end

    scenario 'should not be possible to send supply_authorizarion by email when annulled' do
      supply_authorization = SupplyAuthorization.make!(:nohup)

      ResourceAnnul.make!(
        :anulacao_generica,
        :annullable => supply_authorization.direct_purchase
      )

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      expect(page).to_not have_link 'Anular'
      expect(page).to have_disabled_element 'Salvar', :reason => 'não é permitido para compra anulada'
      expect(page).to have_disabled_element 'Enviar autorização de fornecimento por e-mail', :reason => 'não é permitido para compra anulada'
    end

    scenario 'annul an existent direct_purchase' do
      DirectPurchase.make!(:compra)

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      click_link 'Anular'

      expect(page).to have_content "Anular Compra Direta 1/2012"

      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Data', :with => '01/10/2012'
      fill_in 'Justificativa', :with => 'Anulação da compra direta'

      click_button 'Salvar'

      expect(page).to have_notice 'Compra direta 1/2012 anulada com sucesso'

      click_link 'Anulação'

      expect(page).to have_content "Anulação da Compra Direta 1/2012"

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Data', :with => '01/10/2012'
      expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'
    end

    scenario 'annul an existent direct_purchase with purchase_solicitation' do
      DirectPurchase.make!(:compra)
      PurchaseSolicitation.make!(:reparo_liberado)

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      fill_modal 'Solicitação de compra', :with => '2012', :field => 'Ano'

      click_button 'Salvar'

      expect(page).to have_notice 'Compra Direta 1/2012 editada com sucesso.'

      navigate 'Processos de Compra > Solicitações de Compra'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      within_tab 'Principal' do
        expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
      end

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      click_link 'Anular'

      expect(page).to have_content "Anular Compra Direta 1/2012"

      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Data', :with => '01/10/2012'
      fill_in 'Justificativa', :with => 'Anulação da compra direta'

      click_button 'Salvar'

      expect(page).to have_notice 'Compra direta 1/2012 anulada com sucesso'

      click_link 'Anulação'

      expect(page).to have_content "Anulação da Compra Direta 1/2012"

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Data', :with => '01/10/2012'
      expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'

      navigate 'Processos de Compra > Solicitações de Compra'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      within_tab 'Principal' do
        expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
      end

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      expect(page).to have_field 'Solicitação de compra', :with => ''
    end

    scenario 'annul an existent direct_purchase with purchase_solicitation and supply_authorization' do
      Prefecture.make!(:belo_horizonte)
      SupplyAuthorization.make!(
        :nohup,
        :direct_purchase => DirectPurchase.make!(
          :compra,
          :purchase_solicitation => PurchaseSolicitation.make!(:reparo_liberado)
        )
      )

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      click_link 'Anular'

      expect(page).to have_content "Anular Compra Direta 1/2012"

      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Data', :with => '01/10/2012'
      fill_in 'Justificativa', :with => 'Anulação da compra direta'

      click_button 'Salvar'

      expect(page).to have_notice 'Compra direta 1/2012 anulada com sucesso'

      click_link 'Anulação'

      expect(page).to have_content "Anulação da Compra Direta 1/2012"

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Data', :with => '01/10/2012'
      expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'

      navigate 'Processos de Compra > Solicitações de Compra'

      click_link "Limpar Filtro"

      within_records do
        page.find('a').click
      end

      within_tab 'Principal' do
        expect(page).to have_select 'Status de atendimento', :selected => 'Liberada'
      end
    end

    scenario 'when annul a direct purchase the licitation object balance should be rolled back' do
      direct_purchase = DirectPurchase.make!(:compra)
      DirectPurchase.make!(:compra_nao_autorizada)
      DirectPurchase.make!(:compra_2011)

      navigate 'Processos de Compra > Auxiliar > Objetos de Licitação'

      click_link "Limpar Filtro"

      click_link 'Ponte'

      within_tab 'Total acumulado' do
        within_fieldset 'Total acumulado de compras e serviços' do
          expect(page).to have_field 'Dispensa de licitação', :with => '1.200,00'
        end

        within_fieldset 'Total acumulado de obras e engenharia' do
          expect(page).to have_field 'Dispensa de licitação', :with => '600,00'
        end
      end

      navigate 'Processos de Compra > Compra Direta'

      click_link "Limpar Filtro"

      within_records do
        click_link "#{direct_purchase}"
      end

      click_link 'Anular'

      expect(page).to have_content "Anular Compra Direta 1/2012"

      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_in 'Data', :with => '01/10/2012'
      fill_in 'Justificativa', :with => 'Anulação da compra direta'

      click_button 'Salvar'

      expect(page).to have_notice 'Compra direta 1/2012 anulada com sucesso'

      click_link 'Anulação'

      expect(page).to have_content "Anulação da Compra Direta 1/2012"

      expect(page).to have_field 'Responsável', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Data', :with => '01/10/2012'
      expect(page).to have_field 'Justificativa', :with => 'Anulação da compra direta'

      navigate 'Processos de Compra > Auxiliar > Objetos de Licitação'

      click_link "Limpar Filtro"

      click_link 'Ponte'

      within_tab 'Total acumulado' do
        within_fieldset 'Total acumulado de compras e serviços' do
          expect(page).to have_field 'Dispensa de licitação', :with => '600,00'
        end

        within_fieldset 'Total acumulado de obras e engenharia' do
          expect(page).to have_field 'Dispensa de licitação', :with => '600,00'
        end
      end
    end
  end
end
