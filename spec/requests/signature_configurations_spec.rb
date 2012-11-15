# encoding: utf-8
require 'spec_helper'

feature "SignatureConfigurations" do
  background do
    sign_in
  end

  scenario 'create a new signature_configuration' do
    Signature.make!(:gerente_sobrinho)

    navigate 'Geral > Parâmetros > Assinaturas > Configurações de Assinatura'

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

    expect(page).to have_notice 'Configuração de Assinatura criada com sucesso.'

    click_link 'Autorizações de Fornecimento'

    expect(page).to have_select 'Relatório', :selected => 'Autorizações de Fornecimento'
    expect(page).to have_field 'Assinatura', :with => 'Gabriel Sobrinho'
    expect(page).to have_field 'Ordem', :with => '1'
    expect(page).to have_disabled_field 'Cargo'
    expect(page).to have_field 'Cargo', :with => 'Gerente'
  end

  scenario 'should have only availables reports' do
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    navigate 'Geral > Parâmetros > Assinaturas > Configurações de Assinatura'

    click_link 'Criar Configuração de Assinatura'

    expect(page).to have_css '#signature_configuration_report option', :count => 4
    expect(page).to have_select 'Relatório', :options => ['', 'Processos Administrativos']
  end

  scenario 'should have only availables reports when edit' do
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    navigate 'Geral > Parâmetros > Assinaturas > Configurações de Assinatura'

    click_link 'Autorizações de Fornecimento'

    expect(page).to have_css '#signature_configuration_report option', :count => 5
    expect(page).to have_select 'Relatório', :options => ['', 'Processos Administrativos', 'Autorizações de Fornecimento', 'Certificados de Registro Cadastral']
  end

  scenario 'when fill signature should fill position' do
    Signature.make!(:gerente_sobrinho)

    navigate 'Geral > Parâmetros > Assinaturas > Configurações de Assinatura'

    click_link 'Criar Configuração de Assinatura'

    click_button 'Adicionar Assinatura'

    within_modal 'Assinatura' do
      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      click_button 'Pesquisar'

      click_record 'Gerente'
    end

    expect(page).to have_disabled_field 'Cargo'
    expect(page).to have_field 'Cargo', :with => 'Gerente'

    clear_modal 'Assinatura'

    expect(page).to_not have_field 'Cargo', :with => 'Gerente'
  end

  scenario 'update an existent signature_configuration' do
    Signature.make!(:supervisor_wenderson)
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    navigate 'Geral > Parâmetros > Assinaturas > Configurações de Assinatura'

    click_link 'Autorizações de Fornecimento'

    select 'Processos Administrativos', :from => 'Relatório'

    click_button 'Remover'
    click_button 'Adicionar Assinatura'

    fill_in 'Ordem', :with => '1'
    within_modal 'Assinatura' do
      fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
      click_button 'Pesquisar'

      click_record 'Supervisor'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Configuração de Assinatura editada com sucesso.'

    click_link 'Processos Administrativos'

    expect(page).to have_select 'Relatório', :selected => 'Processos Administrativos'
    expect(page).to have_field 'Assinatura', :with => 'Wenderson Malheiros'
    expect(page).to have_disabled_field 'Cargo'
    expect(page).to have_field 'Ordem', :with => '1'
  end

  scenario 'destroy an existent signature_configuration' do
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)

    navigate 'Geral > Parâmetros > Assinaturas > Configurações de Assinatura'

    click_link 'Autorizações de Fornecimento'

    click_link 'Apagar'

    expect(page).to have_notice 'Configuração de Assinatura apagada com sucesso.'

    within_records do
      expect(page).to_not have_content 'Autorizações de Fornecimento'
    end
  end

  scenario 'acces modal' do
    SignatureConfiguration.make!(:autorizacoes_de_fornecimento)
    SignatureConfiguration.make!(:processo_administrativo)

    navigate 'Geral > Parâmetros > Assinaturas > Configurações de Assinatura'

    click_link 'Filtrar Configurações de Assinatura'

    select 'Processos Administrativos', :from => 'Relatório'

    click_button 'Pesquisar'

    within_records do
      expect(page).to have_link 'Processos Administrativos'
      expect(page).to_not have_link 'Autorizações de Fornecimento'
    end
  end
end
