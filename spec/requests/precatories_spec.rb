# encoding: utf-8
require 'spec_helper'

feature "Precatories" do
  background do
    sign_in
  end

  scenario 'create a new precatory' do
    Provider.make!(:wenderson_sa)
    PrecatoryType.make!(:tipo_de_precatorio_ativo)

    click_link 'Contabilidade'

    click_link 'Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Principal' do
      fill_in 'Número do precatório', :with => '123456'
      fill_modal 'Beneficiário', :field => 'CRC', :with => '456789'
      fill_in 'Número da ação', :with => '001.111.2222/2012'
      fill_mask 'Data do precatório', :with => '10/05/2012'
      fill_mask 'Data da decisão judicial', :with => '05/01/2012'
      fill_mask 'Data da apresentação', :with => '10/01/2012'
      fill_modal 'Tipo', :field => 'Descrição', :with => 'Precatórios Alimentares'
      fill_in 'Histórico', :with => 'Histórico'
    end

    within_tab 'Vencimentos' do
      fill_in 'Valor', :with => '20.000.000,00'

      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        fill_mask 'Data do vencimento', :with => '15/05/2012'
        fill_in 'Valor', :with => '10.000.000,00'
        select 'Pago', :from => 'Situação'
        fill_mask 'Data do pagamento', :with => '15/05/2012'
        fill_in 'Valor pago', :with => '10.000.000,00'
        fill_in 'Observação', :with => 'pagamento efetuado'
      end

      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        fill_mask 'Data do vencimento', :with => '15/06/2012'
        fill_in 'Valor', :with => '10.000.000,00'
        select 'A vencer', :from => 'Situação'
        fill_in 'Valor pago', :with => '0,00'
      end
    end

    click_button 'Salvar'

    page.should have_notice 'Precatório criado com sucesso.'

    within_records do
      click_link '123456'
    end

    within_tab 'Principal' do
      page.should have_field 'Número do precatório', :with => '123456'
      page.should have_field 'Beneficiário', :with => 'Wenderson Malheiros'
      page.should have_field 'Número da ação', :with => '001.111.2222/2012'
      page.should have_field 'Data do precatório', :with => '10/05/2012'
      page.should have_field 'Data da decisão judicial', :with => '05/01/2012'
      page.should have_field 'Data da apresentação', :with => '10/01/2012'
      page.should have_field 'Tipo', :with => 'Precatórios Alimentares'
      page.should have_field 'Histórico', :with => 'Histórico'
    end

    within_tab 'Vencimentos' do
      page.should have_field 'Valor', :with => '20.000.000,00'
      page.should have_field 'Valor parcelado', :with => '20.000.000,00'

      within '.parcel:first' do
        page.should have_field 'Data do vencimento', :with => '15/05/2012'
        page.should have_field 'Valor', :with => '10.000.000,00'
        page.should have_select 'Situação', :selected => 'Pago'
        page.should have_field 'Data do pagamento', :with => '15/05/2012'
        page.should have_field 'Valor pago', :with => '10.000.000,00'
        page.should have_field 'Observação', :with => 'pagamento efetuado'
      end

      within '.parcel:last' do
        page.should have_field 'Data do vencimento', :with => '15/06/2012'
        page.should have_field 'Valor', :with => '10.000.000,00'
        page.should have_select 'Situação', :selected => 'A vencer'
        page.should have_field 'Data do pagamento', :with => ''
        page.should have_field 'Valor pago', :with => '0,00'
        page.should have_field 'Observação', :with => ''
      end
    end
  end

  scenario 'update an existent precatory' do
    Precatory.make!(:precatorio)
    Provider.make!(:sobrinho_sa)
    PrecatoryType.make!(:ordinario_demais_casos)

    click_link 'Contabilidade'

    click_link 'Precatórios'

    within_records do
      click_link '1234/2012'
    end

    within_tab 'Principal' do
      fill_in 'Número do precatório', :with => '123455'
      fill_modal 'Beneficiário', :field => 'CRC', :with => '123456'
      fill_in 'Número da ação', :with => '002.111.2222/2012'
      fill_mask 'Data do precatório', :with => '09/05/2012'
      fill_mask 'Data da decisão judicial', :with => '06/01/2012'
      fill_mask 'Data da apresentação', :with => '11/01/2012'
      fill_modal 'Tipo', :field => 'Descrição', :with => 'Ordinário - Demais Casos'
      fill_in 'Histórico', :with => 'Histórico atualizado'
    end

    within_tab 'Vencimentos' do
      fill_in 'Valor', :with => '5.000.000,00'

      within '.parcel:last' do
        fill_in 'Valor', :with => '2.500.000,00'
        fill_in 'Valor pago', :with => '2.500.000,00'
      end

      within '.parcel:first' do
        fill_in 'Valor', :with => '2.500.000,00'
      end
    end

    click_button 'Salvar'

    page.should have_notice 'Precatório editado com sucesso.'

    within_records do
      click_link '123455'
    end

    within_tab 'Principal' do
      page.should have_field 'Número do precatório', :with => '123455'
      page.should have_field 'Beneficiário', :with => 'Gabriel Sobrinho'
      page.should have_field 'Número da ação', :with => '002.111.2222/2012'
      page.should have_field 'Data do precatório', :with => '09/05/2012'
      page.should have_field 'Data da decisão judicial', :with => '06/01/2012'
      page.should have_field 'Data da apresentação', :with => '11/01/2012'
      page.should have_field 'Tipo', :with => 'Ordinário - Demais Casos'
      page.should have_field 'Histórico', :with => 'Histórico atualizado'
    end

    within_tab 'Vencimentos' do
      page.should have_field 'Valor', :with => '5.000.000,00'
      page.should have_field 'Valor parcelado', :with => '5.000.000,00'

      within '.parcel:last' do
        page.should have_field 'Data do vencimento', :with => '12/05/2012'
        page.should have_field 'Valor', :with => '2.500.000,00'
        page.should have_select 'Situação', :selected => 'Pago'
        page.should have_field 'Data do pagamento', :with => '12/05/2012'
        page.should have_field 'Valor pago', :with => '2.500.000,00'
        page.should have_field 'Observação', :with => 'pagamento efetuado'
      end

      within '.parcel:first' do
        page.should have_field 'Data do vencimento', :with => '20/05/2012'
        page.should have_field 'Valor', :with => '2.500.000,00'
        page.should have_select 'Situação', :selected => 'A vencer'
        page.should have_field 'Data do pagamento', :with => ''
        page.should have_field 'Valor pago', :with => '0,00'
        page.should have_field 'Observação', :with => ''
      end
    end
  end

  scenario 'destroy an existent precatory' do
    Precatory.make!(:precatorio)

    click_link 'Contabilidade'

    click_link 'Precatórios'

    within_records do
      click_link '1234/2012'
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Precatório apagado com sucesso.'

    page.should_not have_link '1234/2012'

  end

  scenario "when writing a value parcel should update automatic parceled_value" do
    click_link 'Contabilidade'

    click_link 'Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Vencimentos' do
      fill_in 'Valor', :with => '20.000.000,00'

      page.should have_field 'Valor parcelado', :with => '0,00'

      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        fill_in 'Valor', :with => '10.000.000,00'
      end

      page.should have_field 'Valor parcelado', :with => '10.000.000,00'

      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        fill_in 'Valor', :with => '5.000.000,00'
      end

      page.should have_field 'Valor parcelado', :with => '15.000.000,00'
    end
  end

  scenario "when remove a parcel the parceled_value should be recalculated" do
    click_link 'Contabilidade'

    click_link 'Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Vencimentos' do
      fill_in 'Valor', :with => '20.000.000,00'

      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        fill_in 'Valor', :with => '10.000.000,00'
      end

      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        fill_in 'Valor', :with => '5.000.000,00'
      end

      within '.parcel:last' do
        click_button 'Remover Parcela'
      end

      page.should have_field 'Valor parcelado', :with => '5.000.000,00'

      within '.parcel:first' do
        click_button 'Remover Parcela'
      end

      page.should have_field 'Valor parcelado', :with => '0,00'
    end
  end

  scenario "type modal should show only precatory_types with status active" do
    PrecatoryType.make!(:tipo_de_precatorio_ativo)
    PrecatoryType.make!(:tipo_de_precatorio_inativo)
    PrecatoryType.make!(:ordinario_demais_casos)

    click_link 'Contabilidade'

    click_link 'Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Principal' do
      within_modal 'Tipo' do
        click_button 'Pesquisar'

        page.should have_css("table.records tbody tr", :count => 2)
        page.should have_content 'Precatórios Alimentares'
        page.should have_content 'Ordinário - Demais Casos'
        page.should_not have_content 'De pequeno valor'
      end
    end
  end
end
