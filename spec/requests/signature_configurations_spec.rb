# encoding: utf-8
require 'spec_helper'

feature "SignatureConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new signature_configuration' do
    Signature.make!(:gerente_sobrinho)

    click_link 'Administração'

    click_link 'Relatórios'

    click_link 'Configurações de Assinatura'

    click_link 'Criar Configuração de Assinatura'

    select 'Autorizações de Fornecimento', :from => 'Relatório'

    click_button 'Adicionar Assinatura'

    fill_in 'Ordem', :with => '1'
    within_modal 'Assinatura' do
      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      click_button 'Pesquisar'

      click_record 'Gerente'
    end

    click_button 'Salvar'

    page.should have_notice 'Configuração de Assinatura criado com sucesso.'

    click_link 'Autorizações de Fornecimento'

    page.should have_select 'Relatório', :selected => 'Autorizações de Fornecimento'
    page.should have_field 'Assinatura', :with => 'Gabriel Sobrinho'
    page.should have_field 'Ordem', :with => '1'
    page.should have_disabled_field 'Cargo'
    page.should have_field 'Cargo', :with => 'Gerente'
  end

  scenario 'should have only availables reports' do
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    click_link 'Administração'

    click_link 'Relatórios'

    click_link 'Configurações de Assinatura'

    click_link 'Criar Configuração de Assinatura'

    page.should have_css '#signature_configuration_report option', :count => 2
    page.should have_select 'Relatório', :options => ['', 'Processos Administrativos']
  end

  scenario 'should have only availables reports when edit' do
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    click_link 'Administração'

    click_link 'Relatórios'

    click_link 'Configurações de Assinatura'

    click_link 'Autorizações de Fornecimento'

    page.should have_css '#signature_configuration_report option', :count => 3
    page.should have_select 'Relatório', :options => ['', 'Processos Administrativos', 'Autorizações de Fornecimento']
  end

  scenario 'when fill signature should fill position' do
    Signature.make!(:gerente_sobrinho)

    click_link 'Administração'

    click_link 'Relatórios'

    click_link 'Configurações de Assinatura'

    click_link 'Criar Configuração de Assinatura'

    click_button 'Adicionar Assinatura'

    within_modal 'Assinatura' do
      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      click_button 'Pesquisar'

      click_record 'Gerente'
    end

    page.should have_disabled_field 'Cargo'
    page.should have_field 'Cargo', :with => 'Gerente'

    clear_modal 'Assinatura'

    page.should_not have_field 'Cargo', :with => 'Gerente'
  end

  scenario 'update an existent signature_configuration' do
    Signature.make!(:supervisor_wenderson)
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    click_link 'Administração'

    click_link 'Relatórios'

    click_link 'Configurações de Assinatura'

    click_link 'Autorizações de Fornecimento'

    select 'Processos Administrativos', :from => 'Relatório'

    click_button 'Remover Assinatura'
    click_button 'Adicionar Assinatura'

    fill_in 'Ordem', :with => '1'
    within_modal 'Assinatura' do
      fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
      click_button 'Pesquisar'

      click_record 'Supervisor'
    end

    click_button 'Salvar'

    page.should have_notice 'Configuração de Assinatura editado com sucesso.'

    click_link 'Processos Administrativos'

    page.should have_select 'Relatório', :selected => 'Processos Administrativos'
    page.should have_field 'Assinatura', :with => 'Wenderson Malheiros'
    page.should have_disabled_field 'Cargo'
    page.should have_field 'Ordem', :with => '1'
  end

  scenario 'destroy an existent signature_configuration' do
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    click_link 'Administração'

    click_link 'Relatórios'

    click_link 'Configurações de Assinatura'

    click_link 'Autorizações de Fornecimento'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Configuração de Assinatura apagado com sucesso.'

    within_records do
      page.should_not have_content 'Autorizações de Fornecimento'
    end
  end
end
