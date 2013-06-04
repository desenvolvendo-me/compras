# encoding: utf-8
require 'spec_helper'

feature "PurchaseProcessTradings" do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    create_roles ['judgment_forms',
                  'payment_methods',
                  'indexers',
                  'document_types',
                  'materials',
                  'publications',
                  'purchase_solicitations']

    Prefecture.make!(:belo_horizonte)

    sign_in
  end

  scenario 'create a trading by item' do
    purchase_process = LicitationProcess.make!(:pregao_presencial,
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: purchase_process,
      purchase_process_accreditation_creditors: [])

    sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
      company_size: CompanySize.make!(:micro_empresa),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    ibm = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      creditor: Creditor.make!(:ibm),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    nobe = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      creditor: Creditor.make!(:nobe),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: false)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_disabled_element 'Lances', reason: 'todas as propostas devem ser preenchidas'

    click_link 'Propostas'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'IBM'
        fill_in 'Preço unitário', with: '100,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'IBM'
        fill_in 'Preço unitário', with: '130,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Gabriel Sobrinho'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '110,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '120,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'Nobe'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '120,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '110,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content 'IBM'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '130,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '100,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    click_link 'Voltar ao processo de compra'

    click_link 'Lances'

    expect(page).to have_title 'Lances do Processo 1/2012 - Pregão 1'

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_checked_field 'item_chooser'

        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '-'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end

      within 'tbody tr:last' do
        expect(page).to_not have_checked_field 'item_chooser'

        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '-'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'IBM'
      end
    end

    expect(page).to have_content 'Fornecedores Habilitados Para Lances Por Item'

    within 'table#accreditation_creditors' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '3'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '130,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '110,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '1'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content '4'
        expect(page).to have_content 'Nobe'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '120,00'
        expect(page).to have_content 'Não'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "IBM"
    expect(page).to have_button 'Gravar lance'
    expect(page).to have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    within 'table#historic' do
      expect(page).to_not have_css('tbody tr')
    end

    fill_in 'Valor', with: '100,00'

    click_button 'Gravar lance'

    expect(page).to have_content 'Valor deve ser menor que 100,00'

    click_button 'Ok'

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "IBM"
    expect(page).to have_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to_not have_css('tbody tr')
    end

    fill_in 'Valor', with: '99,00'

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 1)

      within 'tbody tr:first' do
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '99,00'
        expect(page).to have_content '0,00'
      end
    end

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '99,00'
        expect(page).to have_content 'IBM'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Gabriel Sobrinho"
    expect(page).to have_button 'Desfazer'
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: "98,00"

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 2)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '98,00'
        expect(page).to have_content '0,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '99,00'
        expect(page).to have_content '1,02'
      end
    end

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '98,00'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Wenderson Malheiros"
    expect(page).to have_button 'Desfazer'
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: '0,00'

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 3)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '3'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '98,00'
        expect(page).to have_content '0,00'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '99,00'
        expect(page).to have_content '1,02'
      end
    end

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '98,00'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "2"
    expect(page).to have_disabled_field 'Fornecedor', with: "IBM"
    expect(page).to have_button 'Desfazer'
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: '97,00'

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 4)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2'
        expect(page).to have_content '4'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '97,00'
        expect(page).to have_content '0,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '1'
        expect(page).to have_content '3'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '98,00'
        expect(page).to have_content '1,03'
      end

      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '99,00'
        expect(page).to have_content '2,06'
      end
    end

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '97,00'
        expect(page).to have_content 'IBM'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "2"
    expect(page).to have_disabled_field 'Fornecedor', with: "Gabriel Sobrinho"
    expect(page).to have_button 'Desfazer'
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: '0,00'

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 5)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '2'
        expect(page).to have_content '5'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2'
        expect(page).to have_content '4'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '97,00'
        expect(page).to have_content '0,00'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '1'
        expect(page).to have_content '3'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end

      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '98,00'
        expect(page).to have_content '1,03'
      end

      within 'tbody tr:nth-child(5)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '99,00'
        expect(page).to have_content '2,06'
      end
    end

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '97,00'
        expect(page).to have_content 'IBM'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: ""
    expect(page).to have_disabled_field 'Fornecedor', with: ""
    expect(page).to have_disabled_field 'Valor', with: "0,00"
    expect(page).to have_button 'Desfazer'
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'
    expect(page).to have_disabled_element 'Gravar lance', reason: 'todos os lances já foram efetuados'

    expect(page).to_not have_button 'Valor'

    # Próximo item
    within 'table#items' do
      within 'tbody tr:last' do
        choose 'item_chooser'
      end
    end

    within 'table#accreditation_creditors' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content '130,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '120,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '3'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(4)' do
        expect(page).to have_content '4'
        expect(page).to have_content 'Nobe'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '110,00'
        expect(page).to have_content 'Não'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Wenderson Malheiros"
    expect(page).to have_button 'Desfazer'
    expect(page).to have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: '0,00'

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 1)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end
    end

    within 'table#items' do
      within 'tbody tr:last' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '-'
        expect(page).to have_content '-'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'IBM'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Gabriel Sobrinho"
    expect(page).to have_button 'Desfazer'
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: "90,00"

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 2)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '90,00'
        expect(page).to have_content '0,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '1'
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end
    end

    within 'table#items' do
      within 'tbody tr:last' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '90,00'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'IBM'
      end
    end

    click_button 'Desfazer'

    within 'table#historic' do
      expect(page).to_not have_css('tbody tr', count: 1)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end
    end

    within 'table#items' do
      within 'tbody tr:last' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '-'
        expect(page).to have_content '-'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'IBM'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Gabriel Sobrinho"
    expect(page).to have_button 'Desfazer'
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: "90,00"

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 2)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '90,00'
        expect(page).to have_content '0,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '1'
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end
    end

    within 'table#items' do
      within 'tbody tr:last' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '90,00'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'IBM'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "IBM"
    expect(page).to have_button 'Desfazer'
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: '0,00'

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 3)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'IBM'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '90,00'
        expect(page).to have_content '0,00'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '1'
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Declinou'
        expect(page).to have_content '0,00'
        expect(page).to have_content '-'
      end
    end

    within 'table#items' do
      within 'tbody tr:last' do
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '90,00'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'IBM'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: ""
    expect(page).to have_disabled_field 'Fornecedor', with: ""
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'
    expect(page).to have_disabled_element 'Gravar lance', reason: 'todos os lances já foram efetuados'
  end

  scenario 'creditors with disqualified proposal should not be part of trading' do
    purchase_process = LicitationProcess.make!(:pregao_presencial,
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: purchase_process,
      purchase_process_accreditation_creditors: [])

    sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
      company_size: CompanySize.make!(:micro_empresa),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    ibm = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      creditor: Creditor.make!(:ibm),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_disabled_element 'Lances', reason: 'todas as propostas devem ser preenchidas'

    click_link 'Propostas'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'IBM'
        fill_in 'Preço unitário', with: '100,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'IBM'
        fill_in 'Preço unitário', with: '130,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Gabriel Sobrinho'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '110,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '120,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'IBM'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '130,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '100,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'IBM'

        click_link 'Desclassificar propostas'
      end
    end

    fill_in 'Motivo', with: 'Desclassificado'
    choose 'Toda proposta'

    click_button 'Salvar'

    expect(page).to have_notice 'Desclassificação de Proposta de Credor criada com sucesso.'

    click_link 'Voltar ao processo de compra'

    click_link 'Lances'

    expect(page).to have_title 'Lances do Processo 1/2012 - Pregão 1'

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_checked_field 'item_chooser'

        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '-'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end

      within 'tbody tr:last' do
        expect(page).to_not have_checked_field 'item_chooser'

        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '-'
        expect(page).to have_content '120,00'
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end

    expect(page).to have_content 'Fornecedores Habilitados Para Lances Por Item'

    within 'table#accreditation_creditors' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '110,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Sim'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Gabriel Sobrinho"
    expect(page).to have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'

    fill_in 'Valor', with: '0,00'

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 1)
    end

    expect(page).to have_disabled_field 'Etapa', with: ""
    expect(page).to have_disabled_field 'Fornecedor', with: ""
    expect(page).to_not have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'
    expect(page).to have_disabled_element 'Gravar lance', reason: 'todos os lances já foram efetuados'
  end

  scenario 'with reduction by value' do
    purchase_process = LicitationProcess.make!(:pregao_presencial,
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: purchase_process,
      purchase_process_accreditation_creditors: [])

    sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
      company_size: CompanySize.make!(:micro_empresa),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    ibm = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      creditor: Creditor.make!(:ibm),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_disabled_element 'Lances', reason: 'todas as propostas devem ser preenchidas'

    click_link 'Propostas'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'IBM'
        fill_in 'Preço unitário', with: '100,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'IBM'
        fill_in 'Preço unitário', with: '130,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Gabriel Sobrinho'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '110,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '120,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'IBM'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '130,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '100,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'IBM'

        click_link 'Desclassificar propostas'
      end
    end

    fill_in 'Motivo', with: 'Desclassificado'
    choose 'Toda proposta'

    click_button 'Salvar'

    expect(page).to have_notice 'Desclassificação de Proposta de Credor criada com sucesso.'

    click_link 'Voltar ao processo de compra'

    click_link 'Lances'

    expect(page).to have_title 'Lances do Processo 1/2012 - Pregão 1'

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_checked_field 'item_chooser'

        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '-'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end

      within 'tbody tr:last' do
        expect(page).to_not have_checked_field 'item_chooser'

        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '-'
        expect(page).to have_content '120,00'
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end

    expect(page).to have_content 'Fornecedores Habilitados Para Lances Por Item'

    within 'table#accreditation_creditors' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '110,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Sim'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Gabriel Sobrinho"
    expect(page).to have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'
    expect(page).to have_field 'Valor', with: "99,99"

    fill_in 'Decréscimo em valor', with: '10,00'

    click_button 'Gravar decréscimo'

    expect(page).to have_field 'Valor', with: "90,00"

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 1)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '90,00'
        expect(page).to have_content '-'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Wenderson Malheiros"
    expect(page).to have_field 'Valor', with: "80,00"
  end

  scenario 'with reduction by percentage' do
    purchase_process = LicitationProcess.make!(:pregao_presencial,
      items: [PurchaseProcessItem.make!(:item_arame_farpado),
        PurchaseProcessItem.make!(:item_arame)])

    accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
      licitation_process: purchase_process,
      purchase_process_accreditation_creditors: [])

    sobrinho = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    wenderson = PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor,
      company_size: CompanySize.make!(:micro_empresa),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)
    ibm = PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor,
      creditor: Creditor.make!(:ibm),
      purchase_process_accreditation: accreditation,
      has_power_of_attorney: true)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    expect(page).to have_disabled_element 'Lances', reason: 'todas as propostas devem ser preenchidas'

    click_link 'Propostas'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Wenderson Malheiros'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'IBM'
        fill_in 'Preço unitário', with: '100,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'IBM'
        fill_in 'Preço unitário', with: '130,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Gabriel Sobrinho'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '110,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '120,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'IBM'

        click_link 'Cadastrar propostas'
      end
    end

    within '#purchase_process_creditor_proposals' do
      within 'div.add-margin-bottom:nth-of-type(1)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '130,00'
      end

      within 'div.add-margin-bottom:nth-of-type(2)' do
        fill_in 'Marca', with: 'Fio'
        fill_in 'Preço unitário', with: '100,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial criada com sucesso'

    within_records do
      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content 'IBM'

        click_link 'Desclassificar propostas'
      end
    end

    fill_in 'Motivo', with: 'Desclassificado'
    choose 'Toda proposta'

    click_button 'Salvar'

    expect(page).to have_notice 'Desclassificação de Proposta de Credor criada com sucesso.'

    click_link 'Voltar ao processo de compra'

    click_link 'Lances'

    expect(page).to have_title 'Lances do Processo 1/2012 - Pregão 1'

    within 'table#items' do
      within 'tbody tr:first' do
        expect(page).to have_checked_field 'item_chooser'

        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '-'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Wenderson Malheiros'
      end

      within 'tbody tr:last' do
        expect(page).to_not have_checked_field 'item_chooser'

        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00002 - Arame comum'
        expect(page).to have_content '-'
        expect(page).to have_content '120,00'
        expect(page).to have_content 'Gabriel Sobrinho'
      end
    end

    expect(page).to have_content 'Fornecedores Habilitados Para Lances Por Item'

    within 'table#accreditation_creditors' do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content '110,00'
        expect(page).to have_content 'Sim'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2'
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content '100,00'
        expect(page).to have_content 'Sim'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Gabriel Sobrinho"
    expect(page).to have_disabled_element 'Desfazer', reason: 'não há lance para ser desfeito'
    expect(page).to have_field 'Valor', with: "99,99"

    fill_in 'Decréscimo em percentual', with: '5,00'

    click_button 'Gravar decréscimo'

    expect(page).to have_field 'Valor', with: "95,00"

    click_button 'Gravar lance'

    within 'table#historic' do
      expect(page).to have_css('tbody tr', count: 1)

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1'
        expect(page).to have_content '1'
        expect(page).to have_content '2050'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Com proposta'
        expect(page).to have_content '95,00'
        expect(page).to have_content '-'
      end
    end

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Wenderson Malheiros"
    expect(page).to have_field 'Valor', with: "90,25"

    # Próximo item
    within 'table#items' do
      within 'tbody tr:last' do
        choose 'item_chooser'
      end
    end

    expect(page).to have_field 'Decréscimo em valor', with: '0,00'
    expect(page).to have_field 'Decréscimo em percentual', with: '0,00'

    expect(page).to have_field 'Valor', with: "119,99"

    # Item anterior
    within 'table#items' do
      within 'tbody tr:first' do
        choose 'item_chooser'
      end
    end

    expect(page).to have_field 'Decréscimo em valor', with: '0,00'
    expect(page).to have_field 'Decréscimo em percentual', with: '5,00'

    expect(page).to have_disabled_field 'Etapa', with: "1"
    expect(page).to have_disabled_field 'Fornecedor', with: "Wenderson Malheiros"
    expect(page).to have_field 'Valor', with: "90,25"
  end
end
