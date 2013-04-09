# encoding: utf-8
require 'spec_helper'

feature "PurchaseProcessAccreditation" do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    create_roles ['licitation_processes']
    sign_in
  end

  scenario 'create, update and remove accreditance' do
    LicitationProcess.make!(:processo_licitatorio)
    CompanySize.make!(:empresa_de_grande_porte)
    sobrinho = Creditor.make!(:sobrinho)
    nobe = Creditor.make!(:nobe)

    CreditorRepresentative.make!(:representante_sobrinho,
      :representative_person => Person.make!(:wenderson),
      :creditor => sobrinho)

    CreditorRepresentative.make!(:representante_sobrinho,
      :representative_person => Person.make!(:joao_da_silva),
      :creditor => nobe)

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
    select 'Comercial', :from => 'Tipo'

    click_button 'Adicionar'

    within_records do
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content 'Comercial'
      expect(page).to have_content 'Não'
    end

    fill_with_autocomplete 'Fornecedor', :with => 'Gabriel'

    expect(page).to have_disabled_field 'Tipo de pessoa', :with => 'Pessoa física'
    expect(page).to have_select 'Porte', :selected => ''

    select 'Empresa de grande porte', :from => 'Porte'
    select 'Wenderson Malheiros', :from => 'Representante'
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
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credenciamento criado com sucesso'

    click_link 'Credenciamento'

    within_records do
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content 'Comercial'
      expect(page).to have_content 'Não'
    end

    fill_with_autocomplete 'Fornecedor', :with => 'Nobe'

    expect(page).to have_disabled_field 'Tipo de pessoa', :with => 'Pessoa jurídica'
    expect(page).to have_select 'Porte', :selected => 'Microempresa'

    select 'Joao da Silva', :from => 'Representante'
    select 'Legal', :from => 'Tipo'

    check 'Possui procuração?'

    click_button 'Adicionar'

    within_records do
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content 'Comercial'
      expect(page).to have_content 'Não'

      expect(page).to have_content 'Nobe'
      expect(page).to have_content 'Pessoa jurídica'
      expect(page).to have_content 'Microempresa'
      expect(page).to have_content 'Joao da Silva'
      expect(page).to have_content 'Legal'
      expect(page).to have_content 'Sim'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credenciamento editado com sucesso'

    click_link 'Credenciamento'

    within_records do
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content 'Pessoa física'
      expect(page).to have_content 'Empresa de grande porte'
      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content 'Comercial'
      expect(page).to have_content 'Não'

      expect(page).to have_content 'Nobe'
      expect(page).to have_content 'Pessoa jurídica'
      expect(page).to have_content 'Microempresa'
      expect(page).to have_content 'Joao da Silva'
      expect(page).to have_content 'Legal'
      expect(page).to have_content 'Sim'
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
      expect(page).to_not have_content 'Comercial'
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
  end

  scenario 'kind should be required only when has a representative' do
    LicitationProcess.make!(:processo_licitatorio)
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
end
