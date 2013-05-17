# encoding: utf-8
require 'spec_helper'

feature "PurchaseProcessAccreditation" do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    create_roles ['licitation_processes']
    sign_in
  end

  scenario 'create, update and remove accreditance', intermittent: true do
    LicitationProcess.make!(:pregao_presencial)
    CompanySize.make!(:empresa_de_grande_porte)
    Creditor.make!(:sobrinho)
    representative = CreditorRepresentative.make!(:representante_sobrinho,
      representative_person: Person.make!(:joao_da_silva))
    Creditor.make!(:nobe,
      representatives: [representative],
      accounts: [])


    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Credenciamento'

    expect(page).to have_disabled_element "Relatório", :reason => "Inclua algum credor primeiro"

    fill_with_autocomplete 'Fornecedor', :with => 'Gabriel'

    expect(page).to have_disabled_field 'Tipo de pessoa', :with => 'Pessoa física'
    expect(page).to have_select 'Porte', :selected => ''

    select 'Empresa de grande porte', :from => 'Porte'

    click_button 'Adicionar'

    within_records do
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Não'
    end

    fill_with_autocomplete 'Fornecedor', :with => 'Gabriel'

    expect(page).to have_disabled_field 'Tipo de pessoa', :with => 'Pessoa física'
    expect(page).to have_select 'Porte', :selected => ''

    select 'Empresa de grande porte', :from => 'Porte'

    click_button 'Adicionar'

    within_records do
      expect(page).to have_css('.record', :count => 1)
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Não'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credenciamento criado com sucesso'

    click_link 'Credenciamento'

    within_records do
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Não'
    end

    fill_with_autocomplete 'Fornecedor', :with => 'Nobe'

    expect(page).to have_disabled_field 'Tipo de pessoa', :with => 'Pessoa jurídica'
    expect(page).to have_select 'Porte', :selected => 'Microempresa'

    select 'Joao da Silva', :from => 'Representante'
    select 'Legal', :from => 'Tipo'

    check 'Procurador'

    click_button 'Adicionar'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Pessoa física'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content 'Pessoa jurídica'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Joao da Silva'
        expect(page).to have_content 'Legal'
        expect(page).to have_content 'Sim'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credenciamento editado com sucesso'

    click_link 'Credenciamento'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'Pessoa física'
        expect(page).to have_content 'Empresa de grande porte'
        expect(page).to have_content 'Não'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content 'Nobe'
        expect(page).to have_content 'Pessoa jurídica'
        expect(page).to have_content 'Microempresa'
        expect(page).to have_content 'Joao da Silva'
        expect(page).to have_content 'Legal'
        expect(page).to have_content 'Sim'
      end
    end

    within_records do
      within '.record:first' do
        click_link 'Remover'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credenciamento editado com sucesso'

    click_link 'Credenciamento'

    within_records do
      expect(page).to_not have_content 'Gabriel Sobrinho'
      expect(page).to_not have_content 'Pessoa física'
      expect(page).to_not have_content 'Empresa de grande porte'
      expect(page).to_not have_content 'Não'

      expect(page).to have_content 'Nobe'
      expect(page).to have_content 'Pessoa jurídica'
      expect(page).to have_content 'Microempresa'
      expect(page).to have_content 'Joao da Silva'
      expect(page).to have_content 'Legal'
      expect(page).to have_content 'Sim'
    end

    click_link 'Voltar'

    expect(page).to have_title 'Editar Processo de Compra'

    click_link 'Credenciamento'

    within_records do
      click_link 'Editar'
    end

    expect(page).to have_field 'Fornecedor', with: 'Nobe'
    expect(page).to have_field 'Tipo de pessoa', with: 'Pessoa jurídica'
    expect(page).to have_field 'Fornecedor', with: 'Nobe'
    expect(page).to have_select 'Porte', selected: 'Microempresa'
    expect(page).to have_select 'Representante', selected: 'Joao da Silva'
    expect(page).to have_select 'Tipo', selected: 'Legal'
    expect(page).to have_checked_field 'Procurador'

    uncheck 'Procurador'
    select 'Empresa de grande porte', from: 'Porte'

    click_button 'Adicionar'

    within_records do
      expect(page).to have_content 'Nobe'
      expect(page).to have_content 'Pessoa jurídica'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Joao da Silva'
      expect(page).to have_content 'Legal'
      expect(page).to have_content 'Não'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credenciamento editado com sucesso'

    click_link 'Credenciamento'

    within_records do
      expect(page).to have_content 'Nobe'
      expect(page).to have_content 'Pessoa jurídica'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Joao da Silva'
      expect(page).to have_content 'Legal'
      expect(page).to have_content 'Não'
    end
  end

  scenario 'kind should be required only when has a representative' do
    LicitationProcess.make!(:processo_licitatorio, modality: Modality::TRADING)
    CompanySize.make!(:empresa_de_grande_porte)
    sobrinho = Creditor.make!(:sobrinho)

    CreditorRepresentative.make!(:representante_sobrinho,
      :representative_person => Person.make!(:wenderson),
      :creditor => sobrinho)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Credenciamento'

    fill_with_autocomplete 'Fornecedor', :with => 'Gabriel'

    expect(page).to have_disabled_field 'Tipo de pessoa', :with => 'Pessoa física'
    expect(page).to have_select 'Porte', :selected => ''

    select 'Empresa de grande porte', :from => 'Porte'
    select 'Wenderson Malheiros', :from => 'Representante'

    click_button 'Adicionar'

    within_records do
      expect(page).to_not have_css('.record')
    end

    select 'Comercial', :from => 'Tipo'

    click_button 'Adicionar'

    within_records do
      expect(page).to have_css('.record', :count => 1)
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content 'Comercial'
      expect(page).to have_content 'Não'

      click_link 'Remover'
    end

    fill_with_autocomplete 'Fornecedor', :with => 'Gabriel'

    expect(page).to have_disabled_field 'Tipo de pessoa', :with => 'Pessoa física'
    select 'Empresa de grande porte', :from => 'Porte'

    click_button 'Adicionar'

    within_records do
      expect(page).to have_css('.record', :count => 1)
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Não'
    end
  end

  scenario 'show report' do
    licitation_process = LicitationProcess.make!(:pregao_presencial)
    company_size = CompanySize.make!(:empresa_de_grande_porte)
    sobrinho = Creditor.make!(:sobrinho)
    nobe = Creditor.make!(:nobe)

    representative = CreditorRepresentative.make!(:representante_sobrinho,
      :representative_person => Person.make!(:joao_da_silva),
      :creditor => nobe)

    accreditation = PurchaseProcessAccreditation.create!(:licitation_process_id => licitation_process.id)
    accreditation_sobrinho = PurchaseProcessAccreditationCreditor.create!(
      :creditor_id => sobrinho.id,
      :company_size_id => company_size.id,
      :purchase_process_accreditation_id => accreditation.id)

    accreditation_nobe = PurchaseProcessAccreditationCreditor.create!(
      :creditor_id => nobe.id,
      :company_size_id => company_size.id,
      :creditor_representative_id => representative.id,
      :kind => PurchaseProcessAccreditationCreditorKind::COMMERCIAL,
      :purchase_process_accreditation_id => accreditation.id)

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Credenciamento'
    click_link 'Relatório'

    within 'table.creditor:first' do
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content '003.151.987-37'
      expect(page).to have_content 'Rua Girassol, 9874 - São Francisco'
      expect(page).to have_content 'São Francisco'
      expect(page).to have_content '33400-500'
      expect(page).to have_content 'Paraná'
      expect(page).to have_content '(33) 3333-3333'
      expect(page).to have_content 'gabriel.sobrinho@gmail.com'
      expect(page).to have_content 'Não possui representante'
    end

    within 'table.creditor:last' do
      expect(page).to have_content 'Nobe'
      expect(page).to have_content '76.238.594/0001-35'
      expect(page).to have_content 'Rua Girassol, 9874 - São Francisco'
      expect(page).to have_content 'São Francisco'
      expect(page).to have_content '33400-500'
      expect(page).to have_content 'Paraná'

      expect(page).to have_content 'Joao da Silva'
      expect(page).to have_content 'MG12345677'
      expect(page).to have_content '206.538.014-40'
      expect(page).to have_content '(33) 3333-3333'
      expect(page).to have_content 'joao.da.silva@gmail.com'
    end
  end
end
