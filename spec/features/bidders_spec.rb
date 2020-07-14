require 'spec_helper'

feature "Bidders", vcr: { cassette_name: :bidders } do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['licitation_processes',
                  'people',
                  'creditors',
                  'purchase_process_items']
    sign_in
 end

  scenario 'accessing the bidders and return to licitation process edit page' do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    expect(page).to have_link 'Wenderson Malheiros'

    click_link 'Voltar ao processo de compra'

    expect(page).to have_title "Editar Processo de Compra"
  end

  scenario 'creating, updating, destroy a new bidder' do
    LicitationProcess.make!(:processo_licitatorio_computador,
      :modality => Modality::INVITATION,
      :judgment_form => JudgmentForm.make!(:global_com_menor_preco),
      :proposal_envelope_opening_date => Date.tomorrow)
    Creditor.make!(:sobrinho_sa)
    Person.make!(:wenderson)
    Person.make!(:joao_da_silva)
    DocumentType.make!(:oficial)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    within_records do
      expect(page).to have_link 'Wenderson Malheiros'
    end

    click_link 'Criar Habilitação'

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1', disabled: true
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013', disabled: true

    fill_with_autocomplete 'Fornecedor', :with => 'Gabriel Sobrinho'

    check 'Convidado'
    fill_in 'Protocolo', :with => '123456'
    fill_in 'Data do protocolo', :with => I18n.l(Date.current)
    fill_in 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    check 'Renúncia a recurso'
    check 'Registro de presença em ata'
    check 'Habilitado'

    within_tab 'Documentos' do
      # testing that document type from licitation process are automaticaly included in bidder
      expect(page).to have_field 'Documento', :with => 'Fiscal', disabled: true

      fill_in 'Número/certidão', :with => '222222'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      fill_in 'Validade', :with => I18n.l(Date.tomorrow + 5.days)

      click_button 'Adicionar Documento'

      within '#bidder_documents' do
        fill_modal 'Documento', :with => 'Oficial', :field => 'Descrição'

        fill_in 'Número/certidão', :with => '1234'
        fill_in 'Data de emissão', :with => I18n.l(Date.yesterday)
        fill_in 'Validade', :with => I18n.l(Date.tomorrow + 15.days)
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Habilitação criado com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1', disabled: true
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013', disabled: true
    expect(page).to have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Protocolo', :with => '123456'
    expect(page).to have_field 'Data do protocolo', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)
    expect(page).to have_checked_field 'Renúncia a recurso'
    expect(page).to have_checked_field 'Registro de presença em ata'
    expect(page).to have_checked_field 'Habilitado'
    expect(page).to have_field 'Data da habilitação', :with => I18n.l(Date.current)

    within_tab 'Documentos' do
      expect(page).to have_field 'Documento', :with => 'Fiscal', disabled: true
      expect(page).to have_field 'Número/certidão', :with => '222222'
      expect(page).to have_field 'Data de emissão', :with => I18n.l(Date.current)
      expect(page).to have_field 'Validade', :with => I18n.l(Date.tomorrow + 5.days)

      within '#bidder_documents' do
        expect(page).to have_field 'Documento', :with => 'Oficial'
        expect(page).to have_field 'Número/certidão', :with => '1234'
        expect(page).to have_field 'Data de emissão', :with => I18n.l(Date.yesterday)
        expect(page).to have_field 'Validade', :with => I18n.l(Date.tomorrow + 15.days)
      end
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1', disabled: true
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013', disabled: true

    fill_with_autocomplete 'Fornecedor', :with => 'Gabriel Sobrinho'

    check 'Convidado'
    fill_in 'Protocolo', :with => '111111'
    fill_in 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    fill_in 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)
    uncheck 'Renúncia a recurso'
    uncheck 'Registro de presença em ata'
    uncheck 'Habilitado'

    within_tab 'Documentos' do
      fill_in 'Número/certidão', :with => '333333'
      fill_in 'Data de emissão', :with => I18n.l(Date.yesterday)
      fill_in 'Validade', :with => I18n.l(Date.tomorrow + 6.days)

      within '#bidder_documents' do
        click_button 'Remover'
      end
    end

    click_button 'Salvar'

    expect(page).to have_content 'Habilitação editado com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1', disabled: true
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013', disabled: true

    expect(page).to have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Protocolo', :with => '111111'
    expect(page).to have_field 'Data do protocolo', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow + 1.day)
    expect(page).to_not have_checked_field 'Renúncia a recurso'
    expect(page).to_not have_checked_field 'Registro de presença em ata'
    expect(page).to_not have_checked_field 'Habilitado'
    expect(page).to have_field 'Data da habilitação', ''

    within_tab 'Documentos' do
      expect(page).to have_field 'Documento', :with => 'Fiscal', disabled: true
      expect(page).to have_field 'Número/certidão', :with => '333333'
      expect(page).to have_field 'Data de emissão', :with => I18n.l(Date.yesterday)
      expect(page).to have_field 'Validade', :with => I18n.l(Date.tomorrow + 6.days)

      within '#bidder_documents' do
        expect(page).to_not have_field 'Documento', :with => 'Oficial'
        expect(page).to_not have_field 'Número/certidão', :with => '1234'
        expect(page).to_not have_field 'Data de emissão', :with => I18n.l(Date.yesterday)
        expect(page).to_not have_field 'Validade', :with => I18n.l(Date.tomorrow + 15.days)
      end
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Habilitação apagado com sucesso.'

    within_records do
      expect(page).to have_link 'Wenderson Malheiro'
      expect(page).to_not have_link 'Gabriel Sobrinho'
    end
  end

  scenario 'when is not invited should disable and clear date, protocol fields' do
    LicitationProcess.make!(:processo_licitatorio_computador,
      :modality => Modality::INVITATION,
      :judgment_form => JudgmentForm.make!(:global_com_menor_preco))

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Protocolo', :with => '123456'
    expect(page).to have_field 'Data do protocolo', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data do recebimento', :with => I18n.l(Date.tomorrow)

    expect(page).to_not have_field 'Protocolo', disabled: true
    expect(page).to_not have_field 'Data do protocolo', disabled: true
    expect(page).to_not have_field 'Data do recebimento', disabled: true

    uncheck 'Convidado'

    expect(page).to_not have_checked_field 'Convidado'
    expect(page).to have_field 'Protocolo', :with => '', disabled: true
    expect(page).to have_field 'Data do protocolo', :with => '', disabled: true
    expect(page).to have_field 'Data do recebimento', :with => '', disabled: true

    click_button 'Salvar'

    expect(page).to have_content 'Habilitação editado com sucesso.'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to_not have_checked_field 'Convidado'
    expect(page).to have_field 'Protocolo', :with => '', disabled: true
    expect(page).to have_field 'Data do protocolo', :with => '', disabled: true
    expect(page).to have_field 'Data do recebimento', :with => '', disabled: true
  end

  scenario 'showing some items without lot on proposals' do
    LicitationProcess.make!(:processo_licitatorio_canetas_sem_lote)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Processo de compra', :with => '2/2013 - Convite 1', disabled: true
    expect(page).to have_field 'Data do processo de compra', :with => '20/03/2013', disabled: true
    expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    expect(page).to have_field 'Protocolo', :with => '123456'

    click_button 'Salvar'

    expect(page).to have_content 'Habilitação editado com sucesso.'

    within_records do
      click_link 'Wenderson Malheiros'
    end
  end

  scenario 'create bidder link does show when envelope opening date is today' do
    LicitationProcess.make!(:processo_licitatorio_computador)
    Creditor.make!(:sobrinho_sa)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    click_link 'Criar Habilitação'

    expect(page).to have_button 'Salvar'
  end

  scenario "index should have title Habilitaçãos do Processo de Compra 1/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    expect(page).to have_content "Habilitações do Processo de Compra 2/2013"
  end

  scenario "edit should have title Editar Habilitação do Processo de Compra 2/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_content "Editar Habilitação (Wenderson Malheiros) do Processo de Compra 2/2013"
  end

  scenario "new should have title Nova Habilitação do Processo de Compra 2/2013" do
    LicitationProcess.make!(:processo_licitatorio_computador)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    click_link 'Criar Habilitação'

    expect(page).to have_content "Criar Habilitação no Processo de Compra 2/2013"
  end

 scenario 'should have field technical_score when licitation kind is technical_and_price' do
    LicitationProcess.make!(:apuracao_melhor_tecnica_e_preco)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Habilitação'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Pontuação técnica'
  end

  scenario 'should have field technical_score when licitation kind is best_technique' do
    LicitationProcess.make!(:apuracao_global, :judgment_form => JudgmentForm.make!(:por_item_com_melhor_tecnica))

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Habilitação'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_field 'Pontuação técnica'
  end

  scenario 'should not have field technical_score when licitation kind is not(best_technique, technical_and_price)' do
    LicitationProcess.make!(:processo_licitatorio_fornecedores, :proposal_envelope_opening_date => I18n.l(Date.current))

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Habilitação'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to_not have_field 'Pontuação técnica'
  end

  scenario 'Bidders cant be changed when the licitation process has a ratification' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
    Creditor.make!(:sobrinho_sa)
    Person.make!(:wenderson)
    LicitationProcessRatification.make!(:processo_licitatorio_computador,
      :licitation_process => licitation_process)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    click_link 'Habilitação'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    expect(page).to have_disabled_element 'Apagar',
                    :reason => 'não pode ser alterado pois o processo de compra possui homologação'
    expect(page).to have_disabled_element 'Salvar',
                    :reason => 'não pode ser alterado pois o processo de compra possui homologação'

    expect(page).to have_field 'Processo de compra', disabled: true
    expect(page).to have_field 'Data do processo de compra', disabled: true
    expect(page).to have_field 'Fornecedor', disabled: true

    within_tab 'Documentos' do
      expect(page).to have_field 'Documento', disabled: true
      expect(page).to have_field 'Número/certidão', disabled: true
      expect(page).to have_field 'Data de emissão', disabled: true
      expect(page).to have_field 'Validade', disabled: true
    end
  end

  scenario "enable the licitation_process when enable a bidder" do
    LicitationProcess.make!(:processo_licitatorio_computador,
      status: PurchaseProcessStatus::WAITING_FOR_OPEN)

    navigate 'Licitações > Processos de Compras'

    within_records do
      click_link '2/2013'
    end

    expect(page).to have_select 'Status', selected: 'Aguardando Abertura', disabled: true

    click_link 'Habilitação'

    within_records do
      click_link 'Wenderson Malheiros'
    end

    check 'Habilitado'

    click_button 'Salvar'

    click_link 'Voltar ao processo de compra'

    expect(page).to have_select 'Status', selected: 'Em andamento', disabled: true
  end
end
