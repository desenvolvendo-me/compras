require 'spec_helper'

feature "LicitationProcessPublications", vcr: { cassette_name: :licitation_process_publications } do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    create_roles ['licitation_processes']
    sign_in
  end

  scenario 'index should have link to back to licitation_process and create a new publication' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Publicações'

    expect(page).to have_link 'Voltar ao processo de compra'
    expect(page).to have_link 'Criar Publicação'
    expect(page).to have_content "Publicações do Processo de Compra #{licitation_process}"
  end

  scenario 'create, update and destroy a publication' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Publicações'

    click_link 'Criar Publicação'

    expect(page).to have_content "Criar Publicação para o Processo de Compra #{licitation_process}"

    fill_in "Nome do veículo de comunicação", :with => 'Jornal'
    fill_in "Data da publicação", :with => '20/04/2012'
    select "Edital", :from => "Publicação do(a)"
    select "Internet", :from => "Tipo de circulação do veículo de comunicação"

    click_button 'Salvar'

    expect(page).to have_notice 'Publicação criada com sucesso'

    within_records do
      click_link 'Jornal'
    end

    expect(page).to have_content "Editar Publicação Jornal do Processo de Compra #{licitation_process}"

    expect(page).to have_field 'Nome do veículo de comunicação', :with => 'Jornal'
    expect(page).to have_field 'Data da publicação', :with => '20/04/2012'
    expect(page).to have_select 'Publicação do(a)', :selected => 'Edital'

    fill_in "Nome do veículo de comunicação", :with => 'Portal do servidor'
    fill_in "Data da publicação", :with => '22/04/2012'
    select "Cancelamento", :from => "Publicação do(a)"
    select "Diário oficial do estado", :from => "Tipo de circulação do veículo de comunicação"

    click_button 'Salvar'

    expect(page).to have_notice 'Publicação editada com sucesso'

    within_records do
      click_link 'Portal do servidor'
    end

    expect(page).to have_field 'Nome do veículo de comunicação', :with => 'Portal do servidor'
    expect(page).to have_field 'Data da publicação', :with => '22/04/2012'
    expect(page).to have_select 'Publicação do(a)', :selected => 'Cancelamento'

    click_link 'Apagar'

    expect(page).to have_notice 'Publicação apagada com sucesso'

    expect(page).to_not have_link 'Portal do servidor'
  end

  scenario 'show columns at the index' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    click_link 'Publicações'

    within_records do
       expect(page).to have_content 'Publicação'
       expect(page).to have_content '20/04/2012'
       expect(page).to have_content "Edital"
       expect(page).to have_content 'Internet'
     end
  end

  scenario 'should javascript when licitation_process is direct_purchase publication_of is default confirmation' do
    LicitationProcess.make!(:compra_direta,
      type_of_purchase: PurchaseProcessTypeOfPurchase::DIRECT_PURCHASE,
      justification: 'Justificativa',
      type_of_removal: TypeOfRemoval::REMOVAL_JUSTIFIED,
      items: [PurchaseProcessItem.make!(:item, creditor: Creditor.make!(:sobrinho))] )


    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '2/2013'
    end

    click_link 'Publicações'

    click_link 'Criar Publicação'

    expect(page).to have_select 'Publicação do(a)', selected: 'Ratificação'

    fill_in 'Nome do veículo de comunicação', with:'veículo'
    fill_in 'Data da publicação', with: I18n.l(Date.current)
    select 'Internet', from: 'Tipo de circulação do veículo de comunicação'

    click_button 'Salvar'
    click_link 'veículo'

    expect(page).to have_field 'Nome do veículo de comunicação', with: 'veículo'
    expect(page).to have_field 'Data da publicação', with: I18n.l(Date.current)
    expect(page).to have_select 'Publicação do(a)', selected: 'Ratificação'
    expect(page).to have_select 'Tipo de circulação do veículo de comunicação', selected: 'Internet'
  end

  scenario 'does not have edital when direct_purchase' do
    licitation_process = LicitationProcess.make!(:compra_direta, publications: [])

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '2/2013'
    end

    click_link 'Publicações'

    click_link 'Criar Publicação'

    expect(page).to have_content "Criar Publicação para o Processo de Compra #{licitation_process}"

    expect(page).to have_select 'Publicação do(a)', options: ['', 'Cancelamento', 'Homologação', 'Outros', 'Prorrogação',
                                                              'Ratificação', 'Retificação do edital', 'Vencedores']
  end

  scenario "it should suggest licitation_process's dates when create a publication with kind edital" do
    LicitationProcess.make!(:processo_licitatorio,
      publications: [],
      proposal_envelope_opening_date: nil)

    navigate 'Licitações > Processos de Compras'

    

    within_records do
      click_link '1/2012'
    end

    within_tab 'Prazos' do
      expect(page).to have_disabled_element 'Abertura das propostas', reason: 'deve ter uma publicação de edital'
      expect(page).to have_disabled_element 'Abertura da habilitação', reason: 'deve ter uma publicação de edital'
      expect(page).to have_disabled_element 'Data do credenciamento', reason: 'deve ter uma publicação de edital'
      expect(page).to have_disabled_element 'Data da fase de lances', reason: 'deve ter uma publicação de edital'
    end

    click_link 'Publicações'
    click_link 'Criar Publicação'

    fill_in "Nome do veículo de comunicação", :with => 'Jornal'
    fill_in "Data da publicação", :with => '01/06/2013'
    select "Edital", :from => "Publicação do(a)"
    select "Internet", :from => "Tipo de circulação do veículo de comunicação"

    click_button 'Salvar'

    expect(page).to have_notice 'Publicação criada com sucesso'

    click_link 'Voltar ao processo de compra'

    within_tab 'Prazos' do
      expect(page).to have_field 'Abertura das propostas',  with: '16/07/2013'
      expect(page).to have_field 'Abertura da habilitação', with: '16/07/2013'
      expect(page).to have_field 'Data do credenciamento',  with: '16/07/2013'
      expect(page).to have_field 'Data da fase de lances',  with: '16/07/2013'
    end

    click_link 'Voltar'

    

    within_records do
      click_link '1/2012'
    end

    within_tab 'Prazos' do
      expect(page).to have_field 'Abertura das propostas',  with: '16/07/2013'
      expect(page).to have_field 'Abertura da habilitação', with: '16/07/2013'
      expect(page).to have_field 'Data do credenciamento',  with: '16/07/2013'
      expect(page).to have_field 'Data da fase de lances',  with: '16/07/2013'
    end
  end
end
