# encoding: utf-8
require 'spec_helper'

feature "Precatories" do
  background do
    sign_in
  end

  scenario 'create a new precatory' do
    Creditor.make!(:wenderson_sa)
    PrecatoryType.make!(:tipo_de_precatorio_ativo)

    navigate 'Contabilidade > Comum > Precatório > Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Principal' do
      fill_in 'Número do precatório', :with => '123456'
      within_modal 'Beneficiário' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end
      fill_in 'Número da ação', :with => '001.111.2222/2012'
      fill_in 'Data do precatório', :with => '10/05/2012'
      fill_in 'Data da decisão judicial', :with => '05/01/2012'
      fill_in 'Data da apresentação', :with => '10/01/2012'
      fill_modal 'Tipo', :field => 'Descrição', :with => 'Precatórios Alimentares'
      fill_in 'Histórico', :with => 'Histórico'
    end

    within_tab 'Vencimentos' do
      fill_in 'Valor', :with => '20.000.000,00'

      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        fill_in 'Data do vencimento', :with => '15/05/2012'
        fill_in 'Valor', :with => '10.000.000,00'
        select 'Pago', :from => 'Situação'
        fill_in 'Data do pagamento', :with => '15/05/2012'
        fill_in 'Valor pago', :with => '10.000.000,00'
        fill_in 'Observação', :with => 'pagamento efetuado'

        expect(page).to have_content 'Parcela 1'
      end

      click_button 'Adicionar Parcela'

      within '.parcel:last' do
        fill_in 'Data do vencimento', :with => '15/06/2012'
        fill_in 'Valor', :with => '10.000.000,00'
        select 'A vencer', :from => 'Situação'
        fill_in 'Valor pago', :with => '0,00'

        expect(page).to have_content 'Parcela 2'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Precatório criado com sucesso.'

    within_records do
      click_link '123456'
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Número do precatório', :with => '123456'
      expect(page).to have_field 'Beneficiário', :with => 'Wenderson Malheiros'
      expect(page).to have_field 'Número da ação', :with => '001.111.2222/2012'
      expect(page).to have_field 'Data do precatório', :with => '10/05/2012'
      expect(page).to have_field 'Data da decisão judicial', :with => '05/01/2012'
      expect(page).to have_field 'Data da apresentação', :with => '10/01/2012'
      expect(page).to have_field 'Tipo', :with => 'Precatórios Alimentares'
      expect(page).to have_field 'Histórico', :with => 'Histórico'
    end

    within_tab 'Vencimentos' do
      expect(page).to have_field 'Valor', :with => '20.000.000,00'
      expect(page).to have_field 'Valor parcelado', :with => '20.000.000,00'

      within '.parcel:first' do
        expect(page).to have_field 'Data do vencimento', :with => '15/05/2012'
        expect(page).to have_field 'Valor', :with => '10.000.000,00'
        expect(page).to have_select 'Situação', :selected => 'Pago'
        expect(page).to have_field 'Data do pagamento', :with => '15/05/2012'
        expect(page).to have_field 'Valor pago', :with => '10.000.000,00'
        expect(page).to have_field 'Observação', :with => 'pagamento efetuado'
      end

      within '.parcel:last' do
        expect(page).to have_field 'Data do vencimento', :with => '15/06/2012'
        expect(page).to have_field 'Valor', :with => '10.000.000,00'
        expect(page).to have_select 'Situação', :selected => 'A vencer'
        expect(page).to have_field 'Data do pagamento', :with => ''
        expect(page).to have_field 'Valor pago', :with => '0,00'
        expect(page).to have_field 'Observação', :with => ''
      end
    end
  end

  scenario 'it should update order' do
    navigate 'Contabilidade > Comum > Precatório > Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Vencimentos' do
      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        expect(page).to have_content 'Parcela 1'
      end

      click_button 'Adicionar Parcela'

      within '.parcel:last' do
        expect(page).to have_content 'Parcela 2'
      end

      click_button 'Remover Parcela'
      click_button 'Adicionar Parcela'

      within '.parcel:last' do
        expect(page).to have_content 'Parcela 2'
      end
    end
  end

  scenario 'update an existent precatory' do
    Precatory.make!(:precatorio)
    Creditor.make!(:sobrinho_sa)
    PrecatoryType.make!(:ordinario_demais_casos)

    navigate 'Contabilidade > Comum > Precatório > Precatórios'

    within_records do
      click_link '1234/2012'
    end

    within_tab 'Principal' do
      fill_in 'Número do precatório', :with => '123455'
      within_modal 'Beneficiário' do
        fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
        click_button 'Pesquisar'
        click_record 'Gabriel Sobrinho'
      end
      fill_in 'Número da ação', :with => '002.111.2222/2012'
      fill_in 'Data do precatório', :with => '09/05/2012'
      fill_in 'Data da decisão judicial', :with => '06/01/2012'
      fill_in 'Data da apresentação', :with => '11/01/2012'
      fill_modal 'Tipo', :field => 'Descrição', :with => 'Ordinário - Demais Casos'
      fill_in 'Histórico', :with => 'Histórico atualizado'
    end

    within_tab 'Vencimentos' do
      fill_in 'Valor', :with => '5.000.000,00'

      within '.parcel:first' do
        fill_in 'Valor', :with => '2.500.000,00'
        fill_in 'Valor pago', :with => '2.500.000,00'
      end

      within '.parcel:last' do
        fill_in 'Valor', :with => '2.500.000,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Precatório editado com sucesso.'

    within_records do
      click_link '123455'
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Número do precatório', :with => '123455'
      expect(page).to have_field 'Beneficiário', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Número da ação', :with => '002.111.2222/2012'
      expect(page).to have_field 'Data do precatório', :with => '09/05/2012'
      expect(page).to have_field 'Data da decisão judicial', :with => '06/01/2012'
      expect(page).to have_field 'Data da apresentação', :with => '11/01/2012'
      expect(page).to have_field 'Tipo', :with => 'Ordinário - Demais Casos'
      expect(page).to have_field 'Histórico', :with => 'Histórico atualizado'
    end

    within_tab 'Vencimentos' do
      expect(page).to have_field 'Valor', :with => '5.000.000,00'
      expect(page).to have_field 'Valor parcelado', :with => '5.000.000,00'

      within '.parcel:first' do
        expect(page).to have_field 'Data do vencimento', :with => '12/05/2012'
        expect(page).to have_field 'Valor', :with => '2.500.000,00'
        expect(page).to have_select 'Situação', :selected => 'Pago'
        expect(page).to have_field 'Data do pagamento', :with => '12/05/2012'
        expect(page).to have_field 'Valor pago', :with => '2.500.000,00'
        expect(page).to have_field 'Observação', :with => 'pagamento efetuado'
      end

      within '.parcel:last' do
        expect(page).to have_field 'Data do vencimento', :with => '20/05/2012'
        expect(page).to have_field 'Valor', :with => '2.500.000,00'
        expect(page).to have_select 'Situação', :selected => 'A vencer'
        expect(page).to have_field 'Data do pagamento', :with => ''
        expect(page).to have_field 'Valor pago', :with => '0,00'
        expect(page).to have_field 'Observação', :with => ''
      end
    end
  end

  scenario 'BugFix: should filter precatories' do
    Precatory.make!(:precatorio)

    navigate 'Contabilidade > Comum > Precatório > Precatórios'

    click_link 'Filtrar Precatórios'

    fill_in 'Número do precatório', :with => '1234/2012'

    expect(page).to have_content '1234/2012'
  end

  scenario 'should return empty erro when try create a empty parcel' do
    navigate 'Contabilidade > Comum > Precatório > Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Vencimentos' do
      click_button 'Adicionar Parcela'
      click_button 'Adicionar Parcela'
    end

    click_button 'Salvar'

    expect(page).to have_content 'não pode ficar em branco'
  end

  scenario 'destroy an existent precatory' do
    Precatory.make!(:precatorio)

    navigate 'Contabilidade > Comum > Precatório > Precatórios'

    within_records do
      click_link '1234/2012'
    end

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Precatório apagado com sucesso.'

    expect(page).not_to have_link '1234/2012'

  end

  scenario "when writing a value parcel should update automatic parceled_value" do
    navigate 'Contabilidade > Comum > Precatório > Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Vencimentos' do
      fill_in 'Valor', :with => '20.000.000,00'

      expect(page).to have_field 'Valor parcelado', :with => '0,00'

      click_button 'Adicionar Parcela'

      within '.parcel:first' do
        fill_in 'Valor', :with => '10.000.000,00'
      end

      expect(page).to have_field 'Valor parcelado', :with => '10.000.000,00'

      click_button 'Adicionar Parcela'

      within '.parcel:last' do
        fill_in 'Valor', :with => '5.000.000,00'
      end

      expect(page).to have_field 'Valor parcelado', :with => '15.000.000,00'
    end
  end

  scenario "when remove a parcel the parceled_value should be recalculated" do
    navigate 'Contabilidade > Comum > Precatório > Precatórios'

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

      expect(page).to have_field 'Valor parcelado', :with => '5.000.000,00'

      within '.parcel:first' do
        click_button 'Remover Parcela'
      end

      expect(page).to have_field 'Valor parcelado', :with => '0,00'
    end
  end

  scenario "type modal should show only precatory_types with status active" do
    PrecatoryType.make!(:tipo_de_precatorio_ativo)
    PrecatoryType.make!(:tipo_de_precatorio_inativo)
    PrecatoryType.make!(:ordinario_demais_casos)

    navigate 'Contabilidade > Comum > Precatório > Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Principal' do
      within_modal 'Tipo' do
        click_button 'Pesquisar'

        expect(page).to have_css("table.records tbody tr", :count => 2)
        expect(page).to have_content 'Precatórios Alimentares'
        expect(page).to have_content 'Ordinário - Demais Casos'
        expect(page).not_to have_content 'De pequeno valor'
      end
    end
  end
end
