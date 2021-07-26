require 'spec_helper'

feature 'Report::PurchaseSolicitations', vcr: {cassette_name: 'report_purchase_solicitation'} do
  background do
    sign_in
  end

  scenario 'should display all purchase solicitation filtered by between date in analytical report' do
    make_dependencies!

    navigate 'Relatórios > Solicitações Emitidas'

    fill_in 'Data inicial', with: '01/01/2011'
    fill_in 'Data final', with: I18n.l(Date.current)

    select 'Analítico', from: 'Tipo de relatório'

    click_button 'Gerar Relatório de solicitação de compra emitida'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2/2012'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '4/2012'
        expect(page).to have_content '9 - Secretaria de Educação'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content '3/2012'
        expect(page).to have_content '9 - Secretaria de Educação'
        expect(page).to have_content '01.01.00002 - Office'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(5)' do
        expect(page).to have_content '3/2012'
        expect(page).to have_content '9 - Secretaria de Educação'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '99,00'
        expect(page).to have_content '19.800,00'
      end
    end
  end

  scenario 'should display all purchase solicitation filtered by between date in synthetic report' do
    make_dependencies!

    navigate 'Relatórios > Solicitações Emitidas'

    fill_in 'Data inicial', with: '01/01/2011'
    fill_in 'Data final', with: I18n.l(Date.current)

    select 'Sintético', from: 'Tipo de relatório'

    click_button 'Gerar Relatório de solicitação de compra emitida'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '6,00'
        expect(page).to have_content '1.200,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '9 - Secretaria de Educação'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '9 - Secretaria de Educação'
        expect(page).to have_content '01.01.00002 - Office'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content '9 - Secretaria de Educação'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '99,00'
        expect(page).to have_content '19.800,00'
      end
    end
  end

  scenario 'should display all purchase solicitation filtered by budget_structure in synthetic report' do
    make_dependencies!

    navigate 'Relatórios > Solicitações Emitidas'

    fill_with_autocomplete 'Solicitante', with: 'Detran'
    fill_in 'Data inicial', with: '01/01/2011'
    fill_in 'Data final', with: I18n.l(Date.current)

    select 'Sintético', from: 'Tipo de relatório'

    click_button 'Gerar Relatório de solicitação de compra emitida'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '6,00'
        expect(page).to have_content '1.200,00'
      end

      expect(page).to_not have_content '9 - Secretaria de Educação'
    end
  end

  scenario 'should display all purchase solicitation filtered by budget_structure in analytical report' do
    make_dependencies!

    navigate 'Relatórios > Solicitações Emitidas'

    fill_with_autocomplete 'Solicitante', with: 'Detran'
    fill_in 'Data inicial', with: '01/01/2011'
    fill_in 'Data final', with: I18n.l(Date.current)

    select 'Analítico', from: 'Tipo de relatório'

    click_button 'Gerar Relatório de solicitação de compra emitida'

    within_records do
      within 'tbody tr', text: '2/2012' do
        expect(page).to have_content '2/2012'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr', text: '1/2012' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      expect(page).to_not have_content '9 - Secretaria de Educação'
    end
  end

  scenario 'should display all purchase solicitation filtered by product in analytical report' do
    make_dependencies!

    navigate 'Relatórios > Solicitações Emitidas'

    fill_modal 'Produto', with: 'Antivirus', field: 'Descrição'
    fill_in 'Data inicial', with: '01/01/2011'
    fill_in 'Data final', with: I18n.l(Date.current)

    select 'Analítico', from: 'Tipo de relatório'

    click_button 'Gerar Relatório de solicitação de compra emitida'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2/2012'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '4/2012'
        expect(page).to have_content '9 - Secretaria de Educação'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      expect(page).to_not have_content 'Office'
      expect(page).to_not have_content 'Arame farpado'
    end
  end

  scenario 'should display all purchase solicitation filtered by product in synthetic report' do
    make_dependencies!

    navigate 'Relatórios > Solicitações Emitidas'

    fill_modal 'Produto', with: 'Antivirus', field: 'Descrição'
    fill_in 'Data inicial', with: '01/01/2011'
    fill_in 'Data final', with: I18n.l(Date.current)

    select 'Sintético', from: 'Tipo de relatório'

    click_button 'Gerar Relatório de solicitação de compra emitida'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '6,00'
        expect(page).to have_content '1.200,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '9 - Secretaria de Educação'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      expect(page).to_not have_content 'Office'
      expect(page).to_not have_content 'Arame farpado'
    end
  end

  scenario 'should display all purchase solicitation filtered by status in synthetic report' do
    make_dependencies!

    navigate 'Relatórios > Solicitações Emitidas'

    fill_in 'Data inicial', with: '01/01/2011'
    fill_in 'Data final', with: I18n.l(Date.current)

    select 'Liberada', from: 'Status'
    select 'Sintético', from: 'Tipo de relatório'

    click_button 'Gerar Relatório de solicitação de compra emitida'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end
    end
  end

  scenario 'should display all purchase solicitation filtered by status in analytical report' do
    make_dependencies!

    navigate 'Relatórios > Solicitações Emitidas'

    fill_in 'Data inicial', with: '01/01/2011'
    fill_in 'Data final', with: I18n.l(Date.current)

    select 'Liberada', from: 'Status'
    select 'Analítico', from: 'Tipo de relatório'

    click_button 'Gerar Relatório de solicitação de compra emitida'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1/2012'
        expect(page).to have_content '1 - Detran'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end
    end
  end

  context "when click_link Imprimir" do
    scenario 'should display all purchase solicitation filtered by between date in analytical report' do
      make_dependencies!

      navigate 'Relatórios > Solicitações Emitidas'

      fill_in 'Data inicial', with: '01/01/2011'
      fill_in 'Data final', with: I18n.l(Date.current)

      select 'Analítico', from: 'Tipo de relatório'

      click_button 'Gerar Relatório de solicitação de compra emitida'

      within_records do
        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '1/2012'
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content '2/2012'
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(3)' do
          expect(page).to have_content '4/2012'
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(4)' do
          expect(page).to have_content '3/2012'
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '01.01.00002 - Office'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(5)' do
          expect(page).to have_content '3/2012'
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '02.02.00001 - Arame farpado'
          expect(page).to have_content '99,00'
          expect(page).to have_content '19.800,00'
        end
      end

      click_link 'Imprimir'

      within_records do
        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '1/2012'
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content '2/2012'
          expect(page).to have_content '1 - Detran'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(3)' do
          expect(page).to have_content '4/2012'
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(4)' do
          expect(page).to have_content '3/2012'
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '01.01.00002 - Office'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(5)' do
          expect(page).to have_content '3/2012'
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '02.02.00001 - Arame farpado'
          expect(page).to have_content '99,00'
          expect(page).to have_content '19.800,00'
        end
      end
    end

    scenario 'should display all purchase solicitation filtered by between date in synthetic report' do
      make_dependencies!

      navigate 'Relatórios > Solicitações Emitidas'

      fill_in 'Data inicial', with: '01/01/2011'
      fill_in 'Data final', with: I18n.l(Date.current)
      select 'Pendente', from: 'Status'
      select 'Bens', from: 'Tipo'
      fill_with_autocomplete 'Solicitante', with: 'Secretaria de Educação'
      select 'Sintético', from: 'Tipo de relatório'

      click_button 'Gerar Relatório de solicitação de compra emitida'

      within_records do
        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '01.01.00002 - Office'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(3)' do
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '02.02.00001 - Arame farpado'
          expect(page).to have_content '99,00'
          expect(page).to have_content '19.800,00'
        end
      end

      click_link 'Imprimir'

      within '.filters' do
        expect(page).to have_content 'Filtros'
        expect(page).to have_content "Período: 01/01/2011 até #{I18n.l Date.current}"
        expect(page).to have_content "Solicitante: 9 - Secretaria de Educação"
        expect(page).to have_content "Status: Pendente"
        expect(page).to have_content "Tipo: Bens"
      end

      within_records do
        within 'tbody tr:nth-child(1)' do
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '01.01.00001 - Antivirus'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '01.01.00002 - Office'
          expect(page).to have_content '3,00'
          expect(page).to have_content '600,00'
        end

        within 'tbody tr:nth-child(3)' do
          expect(page).to have_content '9 - Secretaria de Educação'
          expect(page).to have_content '02.02.00001 - Arame farpado'
          expect(page).to have_content '99,00'
          expect(page).to have_content '19.800,00'
        end
      end
    end
  end

  def make_dependencies!
    PurchaseSolicitation.make!(:reparo_liberado)
    PurchaseSolicitation.make!(:reparo)
    PurchaseSolicitation.make!(:reparo_office, budget_structure_id: 2)
    PurchaseSolicitation.make!(:reparo_desenvolvimento, budget_structure_id: 2)
  end
end
