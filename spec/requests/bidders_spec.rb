# encoding: utf-8
require 'spec_helper'

feature "Bidders" do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['licitation_processes',
                  'people',
                  'creditors',
                  'licitation_process_lots',
                  'administrative_process_budget_allocation_items']
    sign_in
  end

  scenario 'accessing the bidders and return to licitation process edit page' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    expect(page).to have_link 'Wenderson Malheiros'

    click_link 'Voltar ao processo de compra'

    expect(page).to have_title "Editar Processo de Compra"
  end

  scenario 'creating, updating, destroy a new bidder' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    Creditor.make!(:sobrinho_sa)
    Person.make!(:wenderson)
    Person.make!(:joao_da_silva)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013'
    expect(page).to have_checked_field 'Apresentará nova proposta em caso de empate'

    fill_modal 'Fornecedor', :with => 'Gabriel Sobrinho'

    fill_in 'Pontuação técnica', :with => '10,00'
    check 'Convidado'
    fill_in 'Protocolo', :with => '123456'
    fill_in 'Data do protocolo', :with => I18n.l(Date.current)
    fill_in 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    within_tab 'Representantes credenciados' do
      fill_modal 'Representantes', :with => 'Wenderson Malheiros'
      fill_modal 'Representantes', :with => 'Joao da Silva'
    end

    within_tab 'Documentos' do
      # testing that document type from licitation process are automaticaly included in bidder
      expect(page).to have_disabled_field 'Documento'
      expect(page).to have_field 'Documento', :with => 'Fiscal'

      fill_in 'Número/certidão', :with => '222222'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      fill_in 'Validade', :with => I18n.l(Date.tomorrow + 5.days)
    end

    within_tab 'Propostas' do
      expect(page).to have_content 'Item 1'
      expect(page).to have_disabled_field 'Preço total dos itens'
      expect(page).to have_disabled_field 'Material'
      expect(page).to have_disabled_field 'Situação'
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_disabled_field 'Quantidade'
      expect(page).to have_disabled_field 'Preço total'
      expect(page).to have_select 'Situação', :selected => 'Indefinido'

      fill_in 'Marca', :with => 'Apple'
      fill_in 'Preço unitário', :with => '11,22'

      expect(page).to have_field 'Preço total', :with => '22,44'
      expect(page).to have_field 'Preço total dos itens', :with => '22,44'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Licitante criado com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013'
    expect(page).to have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Pontuação técnica', :with => '10,00'
    expect(page).to have_field 'Protocolo', :with => '123456'
    expect(page).to have_field 'Data do protocolo', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)
    expect(page).to have_checked_field 'Apresentará nova proposta em caso de empate'

    within_tab 'Representantes credenciados' do
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content '003.149.513-34'
      expect(page).to have_content 'Joao da Silva'
      expect(page).to have_content '206.538.014-40'
    end

    within_tab 'Documentos' do
      expect(page).to have_field 'Documento', :with => 'Fiscal'
      expect(page).to have_field 'Número/certidão', :with => '222222'
      expect(page).to have_field 'Data de emissão', :with => I18n.l(Date.current)
      expect(page).to have_field 'Validade', :with => I18n.l(Date.tomorrow + 5.days)
    end

    within_tab 'Propostas' do
      expect(page).to have_content 'Item 1'
      expect(page).to have_disabled_field 'Preço total dos itens'
      expect(page).to have_disabled_field 'Material'
      expect(page).to have_disabled_field 'Situação'
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_disabled_field 'Quantidade'
      expect(page).to have_disabled_field 'Preço total'

      expect(page).to have_field 'Preço total dos itens', :with => '22,44'
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_select 'Situação', :selected => 'Indefinido'
      expect(page).to have_field 'Classificação', :with => ''
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '2'
      expect(page).to have_field 'Preço unitário', :with => '11,22'
      expect(page).to have_field 'Preço total', :with => '22,44'
      expect(page).to have_field 'Marca', :with => 'Apple'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013'

    fill_modal 'Fornecedor', :with => 'Gabriel Sobrinho'

    fill_in 'Pontuação técnica', :with => '10,00'
    uncheck 'Apresentará nova proposta em caso de empate'
    check 'Convidado'
    fill_in 'Protocolo', :with => '111111'
    fill_in 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    fill_in 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)

    within_tab 'Representantes credenciados' do
      click_button 'Remover Pessoa'

      fill_modal 'Representantes', :with => 'Wenderson Malheiros'
    end

    within_tab 'Documentos' do
      fill_in 'Número/certidão', :with => '333333'
      fill_in 'Data de emissão', :with => I18n.l(Date.yesterday)
      fill_in 'Validade', :with => I18n.l(Date.tomorrow + 6.days)
    end

    within_tab 'Propostas' do
      expect(page).to have_content 'Item 1'
      expect(page).to have_disabled_field 'Preço total dos itens'
      expect(page).to have_disabled_field 'Material'
      expect(page).to have_disabled_field 'Situação'
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_disabled_field 'Quantidade'
      expect(page).to have_disabled_field 'Preço total'

      fill_in 'Marca', :with => 'LG'
      fill_in 'Preço unitário', :with => '10,01'

      expect(page).to have_field 'Preço unitário', :with => '10,01'
      expect(page).to have_field 'Preço total', :with => '20,02'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Licitante editado com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013'

    expect(page).to_not have_checked_field 'Apresentará nova proposta em caso de empate'
    expect(page).to have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Pontuação técnica', :with => '10,00'
    expect(page).to have_field 'Protocolo', :with => '111111'
    expect(page).to have_field 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)

    within_tab 'Representantes credenciados' do
      expect(page).to_not have_content 'Gabriel Sobrinho'
      expect(page).to_not have_content '003.151.987-37'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content '003.149.513-34'
    end

    within_tab 'Documentos' do
      expect(page).to have_field 'Documento', :with => 'Fiscal'
      expect(page).to have_field 'Número/certidão', :with => '333333'
      expect(page).to have_field 'Data de emissão', :with => I18n.l(Date.yesterday)
      expect(page).to have_field 'Validade', :with => I18n.l(Date.tomorrow + 6.days)
    end

    within_tab 'Propostas' do
      expect(page).to have_content 'Item 1'
      expect(page).to have_disabled_field 'Preço total dos itens'
      expect(page).to have_disabled_field 'Material'
      expect(page).to have_disabled_field 'Situação'
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_disabled_field 'Quantidade'
      expect(page).to have_disabled_field 'Preço total'

      expect(page).to have_field 'Preço total dos itens', :with => '20,02'
      expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
      expect(page).to have_select 'Situação', :selected => 'Indefinido'
      expect(page).to have_field 'Classificação', :with => ''
      expect(page).to have_field 'Unidade', :with => 'UN'
      expect(page).to have_field 'Quantidade', :with => '2'
      expect(page).to have_field 'Preço unitário', :with => '10,01'
      expect(page).to have_field 'Preço total', :with => '20,02'
      expect(page).to have_field 'Marca', :with => 'LG'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Licitante apagado com sucesso.'

    within_records do
      expect(page).to have_link 'Wenderson Malheiro'
      expect(page).to_not have_link 'Gabriel Sobrinho'
    end
  end

  scenario 'when is not invited should disable and clear date, protocol fields' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Protocolo', :with => '123456'
    expect(page).to have_field 'Data do protocolo', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    expect(page).to_not have_disabled_field 'Protocolo'
    expect(page).to_not have_disabled_field 'Data do protocolo'
    expect(page).to_not have_disabled_field 'Data do recebimento'

    uncheck 'Convidado'

    expect(page).to have_disabled_field 'Protocolo'
    expect(page).to have_disabled_field 'Data do protocolo'
    expect(page).to have_disabled_field 'Data do recebimento'

    expect(page).to_not have_checked_field 'Convidado'
    expect(page).to have_field 'Protocolo', :with => ''
    expect(page).to have_field 'Data do protocolo', :with => ''
    expect(page).to have_field 'Data do recebimento', :with => ''

    click_button 'Salvar'

    expect(page).to have_content 'Licitante editado com sucesso.'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to_not have_checked_field 'Convidado'
    expect(page).to have_field 'Protocolo', :with => ''
    expect(page).to have_field 'Data do protocolo', :with => ''
    expect(page).to have_field 'Data do recebimento', :with => ''

    expect(page).to have_disabled_field 'Protocolo'
    expect(page).to have_disabled_field 'Data do protocolo'
    expect(page).to have_disabled_field 'Data do recebimento'
  end

  scenario 'showing some items without lot on proposals' do
    LicitationProcess.make!(:processo_licitatorio_canetas_sem_lote)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013'
    expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Protocolo', :with => '123456'

    within_tab 'Propostas' do
      within '.proposal' do
        expect(page).to have_content 'Item 1'
        expect(page).to have_disabled_field 'Material'
        expect(page).to have_disabled_field 'Situação'
        expect(page).to have_disabled_field 'Classificação'
        expect(page).to have_disabled_field 'Unidade'
        expect(page).to have_disabled_field 'Quantidade'
        expect(page).to have_disabled_field 'Preço total'

        expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
        expect(page).to have_field 'Unidade', :with => 'UN'
        expect(page).to have_field 'Quantidade', :with => '2'

        fill_in 'Marca', :with => 'mcafee'
        fill_in 'Preço unitário', :with => '99,99'

        expect(page).to have_field 'Preço total', :with => '199,98'
      end

      within 'div.proposal:last' do
        expect(page).to have_content 'Item 2'
        expect(page).to have_disabled_field 'Material'
        expect(page).to have_disabled_field 'Situação'
        expect(page).to have_disabled_field 'Classificação'
        expect(page).to have_disabled_field 'Unidade'
        expect(page).to have_disabled_field 'Quantidade'
        expect(page).to have_disabled_field 'Preço total'

        expect(page).to have_field 'Material', :with => '02.02.00002 - Arame comum'
        expect(page).to have_field 'Unidade', :with => 'UN'
        expect(page).to have_field 'Quantidade', :with => '1'

        fill_in 'Marca', :with => 'Arame Forte'
        fill_in 'Preço unitário', :with => '9,99'

        expect(page).to have_field 'Preço total', :with => '9,99'
      end

      expect(page).to have_field 'Preço total dos itens', :with => '209,97'
    end

    click_button 'Salvar'

    expect(page).to have_content 'Licitante editado com sucesso.'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    within_tab 'Propostas' do
      within '.proposal' do
        expect(page).to have_content 'Item 1'
        expect(page).to have_disabled_field 'Material'
        expect(page).to have_disabled_field 'Situação'
        expect(page).to have_disabled_field 'Classificação'
        expect(page).to have_disabled_field 'Unidade'
        expect(page).to have_disabled_field 'Quantidade'
        expect(page).to have_disabled_field 'Preço total'

        expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
        expect(page).to have_select 'Situação', :selected => 'Indefinido'
        expect(page).to have_field 'Classificação', :with => ''
        expect(page).to have_field 'Unidade', :with => 'UN'
        expect(page).to have_field 'Quantidade', :with => '2'
        expect(page).to have_field 'Preço unitário', :with => '99,99'
        expect(page).to have_field 'Preço total', :with => '199,98'
        expect(page).to have_field 'Marca', :with => 'mcafee'
      end

      within '.proposal:last' do
        expect(page).to have_content 'Item 2'
        expect(page).to have_disabled_field 'Material'
        expect(page).to have_disabled_field 'Situação'
        expect(page).to have_disabled_field 'Classificação'
        expect(page).to have_disabled_field 'Unidade'
        expect(page).to have_disabled_field 'Quantidade'
        expect(page).to have_disabled_field 'Preço total'

        expect(page).to have_field 'Material', :with => '02.02.00002 - Arame comum'
        expect(page).to have_select 'Situação', :selected => 'Indefinido'
        expect(page).to have_field 'Classificação', :with => ''
        expect(page).to have_field 'Unidade', :with => 'UN'
        expect(page).to have_field 'Quantidade', :with => '1'
        expect(page).to have_field 'Preço unitário', :with => '9,99'
        expect(page).to have_field 'Preço total', :with => '9,99'
        expect(page).to have_field 'Marca', :with => 'Arame Forte'
      end

      expect(page).to have_disabled_field 'Preço total dos itens'
      expect(page).to have_field 'Preço total dos itens', :with => '209,97'
    end
  end

  scenario 'creating some lots and showing one tab for lot on proposals' do
    LicitationProcess.make!(:processo_licitatorio_canetas_sem_lote)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'Lote 1'
    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    expect(page).to have_notice 'Lote de itens criado com sucesso.'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_field 'Observações', :with => 'Lote 1'
    expect(page).to have_content '01.01.00001 - Antivirus'
    expect(page).to have_content '2'
    expect(page).to have_content '10,00'

    click_link 'Voltar'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'Lote 2'
    fill_modal 'Itens', :with => '02.02.00002 - Arame comum', :field => 'Material'

    click_button 'Salvar'

    expect(page).to have_notice 'Lote de itens criado com sucesso.'

    within_records do
      click_link 'Lote 2'
    end

    expect(page).to have_field 'Observações', :with => 'Lote 2'
    expect(page).to have_content '02.02.00002 - Arame comum'
    expect(page).to have_content '1'
    expect(page).to have_content '10,00'

    click_link 'Voltar'

    within_records do
      expect(page).to have_content 'Lote 1'
      expect(page).to have_content 'Lote 2'
    end

    click_link 'Voltar ao processo de compra'

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013'
    expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Protocolo', :with => '123456'

    within_tab 'Propostas' do
      expect(page).to have_content 'Lote 1'
      expect(page).to have_content 'Lote 2'

      within_tab 'Lote 1' do
        expect(page).to have_content 'Item 1'
        expect(page).to have_disabled_field 'Preço total dos itens'
        expect(page).to have_disabled_field 'Material'
        expect(page).to have_disabled_field 'Situação'
        expect(page).to have_disabled_field 'Classificação'
        expect(page).to have_disabled_field 'Unidade'
        expect(page).to have_disabled_field 'Quantidade'
        expect(page).to have_disabled_field 'Preço total'

        expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
        expect(page).to have_field 'Unidade', :with => 'UN'
        expect(page).to have_field 'Quantidade', :with => '2'

        fill_in 'Marca', :with => 'mcafee'
        fill_in 'Preço unitário', :with => '99,99'

        expect(page).to have_field 'Preço total', :with => '199,98'
        expect(page).to have_field 'Preço total dos itens', :with => '199,98'
      end

      within_tab 'Lote 2' do
        expect(page).to have_content 'Item 1'
        expect(page).to have_disabled_field 'Preço total dos itens'
        expect(page).to have_disabled_field 'Material'
        expect(page).to have_disabled_field 'Situação'
        expect(page).to have_disabled_field 'Classificação'
        expect(page).to have_disabled_field 'Unidade'
        expect(page).to have_disabled_field 'Quantidade'
        expect(page).to have_disabled_field 'Preço total'

        expect(page).to have_field 'Material', :with => '02.02.00002 - Arame comum'
        expect(page).to have_field 'Unidade', :with => 'UN'
        expect(page).to have_field 'Quantidade', :with => '1'

        fill_in 'Marca', :with => 'Arame Forte'
        fill_in 'Preço unitário', :with => '9,99'

        expect(page).to have_field 'Preço total', :with => '9,99'
        expect(page).to have_field 'Preço total dos itens', :with => '9,99'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Licitante editado com sucesso.'

    click_link 'Wenderson Malheiros'

    within_tab 'Propostas' do
      within_tab 'Lote 1' do
        expect(page).to have_content 'Item 1'
        expect(page).to have_disabled_field 'Preço total dos itens'
        expect(page).to have_disabled_field 'Material'
        expect(page).to have_disabled_field 'Situação'
        expect(page).to have_disabled_field 'Classificação'
        expect(page).to have_disabled_field 'Unidade'
        expect(page).to have_disabled_field 'Quantidade'
        expect(page).to have_disabled_field 'Preço total'

        expect(page).to have_field 'Preço total dos itens', :with => '199,98'
        expect(page).to have_field 'Material', :with => '01.01.00001 - Antivirus'
        expect(page).to have_select 'Situação', :selected => 'Indefinido'
        expect(page).to have_field 'Classificação', :with => ''
        expect(page).to have_field 'Unidade', :with => 'UN'
        expect(page).to have_field 'Quantidade', :with => '2'
        expect(page).to have_field 'Preço unitário', :with => '99,99'
        expect(page).to have_field 'Preço total', :with => '199,98'
        expect(page).to have_field 'Marca', :with => 'mcafee'
      end

      within_tab 'Lote 2' do
        expect(page).to have_content 'Item 1'
        expect(page).to have_disabled_field 'Preço total dos itens'
        expect(page).to have_disabled_field 'Material'
        expect(page).to have_disabled_field 'Situação'
        expect(page).to have_disabled_field 'Classificação'
        expect(page).to have_disabled_field 'Unidade'
        expect(page).to have_disabled_field 'Quantidade'
        expect(page).to have_disabled_field 'Preço total'

        expect(page).to have_field 'Preço total dos itens', :with => '9,99'
        expect(page).to have_field 'Material', :with => '02.02.00002 - Arame comum'
        expect(page).to have_select 'Situação', :selected => 'Indefinido'
        expect(page).to have_field 'Classificação', :with => ''
        expect(page).to have_field 'Unidade', :with => 'UN'
        expect(page).to have_field 'Quantidade', :with => '1'
        expect(page).to have_field 'Preço unitário', :with => '9,99'
        expect(page).to have_field 'Preço total', :with => '9,99'
        expect(page).to have_field 'Marca', :with => 'Arame Forte'
      end
    end
  end

  scenario 'should show message that can not update proposals when any item does not have lot and licitation process has lot' do
    LicitationProcess.make!(:processo_licitatorio_canetas_sem_lote)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Lotes de itens'

    click_link 'Criar Lote de itens'

    fill_in 'Observações', :with => 'Lote 1'
    fill_modal 'Itens', :with => '01.01.00001 - Antivirus', :field => 'Material'

    click_button 'Salvar'

    expect(page).to have_notice 'Lote de itens criado com sucesso.'

    within_records do
      click_link 'Lote 1'
    end

    expect(page).to have_field 'Observações', :with => 'Lote 1'
    expect(page).to have_content '01.01.00001 - Antivirus'
    expect(page).to have_content '2'
    expect(page).to have_content '10,00'

    click_link 'Voltar'

    expect(page).to have_content 'Lote 1'

    click_link 'Voltar ao processo de compra'

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1'
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013'
    expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Protocolo', :with => '123456'

    within_tab 'Propostas' do
      expect(page).to have_content 'Para adicionar propostas, todos os itens devem pertencer a algum Lote ou nenhum lote deve existir.'
    end
  end

  scenario 'create bidder link does show when envelope opening date is today' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    Creditor.make!(:sobrinho_sa)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    expect(page).to have_button 'Salvar'
  end

  scenario 'create bidder link does not show when envelope opening date is not today' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    visit bidders_path(:licitation_process_id => licitation_process.id)

    expect(page).to_not have_link 'Criar Licitante'
  end

  scenario "index should have title Licitantes do Processo de Compra 1/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    expect(page).to have_content "Licitantes do Processo de Compra 2/2013"
  end

  scenario "edit should have title Editar Licitante do Processo de Compra 2/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_content "Editar Licitante (Wenderson Malheiros) do Processo de Compra 2/2013"
  end

  scenario "new should have title Novo Licitante do Processo de Compra 2/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    click_link 'Criar Licitante'

    expect(page).to have_content "Criar Licitante no Processo de Compra 2/2013"
  end

 scenario 'should have field technical_score when licitation kind is technical_and_price' do
    LicitationProcess.make!(:apuracao_melhor_tecnica_e_preco)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Pontuação técnica'
  end

  scenario 'should have field technical_score when licitation kind is best_technique' do
    LicitationProcess.make!(:apuracao_global, :judgment_form => JudgmentForm.make!(:por_item_com_melhor_tecnica))

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Pontuação técnica'
  end

  scenario 'should not have field technical_score when licitation kind is not(best_technique, technical_and_price)' do
    LicitationProcess.make!(:processo_licitatorio_fornecedores, :proposal_envelope_opening_date => I18n.l(Date.current))

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to_not have_field 'Pontuação técnica'
  end

  scenario "Save and destroy buttons should be disabled if licitation process envelope opening date is not today" do
    licitation_process = LicitationProcess.make!(:apuracao_global)
    licitation_process.update_attribute :proposal_envelope_opening_date, Date.tomorrow

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_disabled_element 'Apagar',
                    :reason => 'alterações permitidas somente no dia da abertura dos envelopes'
    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'alterações permitidas somente no dia da abertura dos envelopes'
  end

  scenario "Save and destroy buttons should be shown if licitation process envelope opening date is today" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_button 'Salvar'
    expect(page).to have_link 'Apagar'
  end

  scenario 'Bidders cant be changed when the licitation process has a ratification' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    Creditor.make!(:sobrinho_sa)
    Person.make!(:wenderson)
    LicitationProcessRatification.make!(:processo_licitatorio_computador,
      :licitation_process => licitation_process)

    navigate 'Processos de Compra > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_disabled_element 'Apagar',
                    :reason => 'não pode ser alterado pois o processo de compra possui homologação'
    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'não pode ser alterado pois o processo de compra possui homologação'

    expect(page).to have_disabled_field 'Processo de compra'
    expect(page).to have_disabled_field 'Data do processo de compra'
    expect(page).to have_disabled_field 'Fornecedor'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_disabled_field 'Apresentará nova proposta em caso de empate'

    within_tab 'Representantes credenciados' do
      expect(page).to have_disabled_field 'Representantes'
    end

    within_tab 'Documentos' do
      expect(page).to have_disabled_field 'Documento'
      expect(page).to have_disabled_field 'Número/certidão'
      expect(page).to have_disabled_field 'Data de emissão'
      expect(page).to have_disabled_field 'Validade'
    end

    within_tab 'Propostas' do
      expect(page).to have_disabled_field 'Preço total dos itens'
      expect(page).to have_disabled_field 'Material'
      expect(page).to have_disabled_field 'Marca'
      expect(page).to have_disabled_field 'Situação'
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_disabled_field 'Quantidade'
      expect(page).to have_disabled_field 'Preço unitário'
      expect(page).to have_disabled_field 'Preço total'
    end
  end

  scenario 'when licitation process has a trading bidder proposals should be disabled' do
    Trading.make!(:pregao_presencial)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link  '1/2012'
    end

    click_link 'Licitantes'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    within_tab 'Propostas' do
      expect(page).to have_disabled_field 'Preço total dos itens'
      expect(page).to have_disabled_field 'Material'
      expect(page).to have_disabled_field 'Marca'
      expect(page).to have_disabled_field 'Situação'
      expect(page).to have_disabled_field 'Classificação'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_disabled_field 'Quantidade'
      expect(page).to have_disabled_field 'Preço unitário'
      expect(page).to have_disabled_field 'Preço total'
    end
  end
end
