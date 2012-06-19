# encoding: utf-8
require 'spec_helper'

feature "Creditors" do
  background do
    sign_in
  end

  scenario 'create a new creditor when people is special entry' do
    Person.make!(:mateus)
    Agency.make!(:itau)
    Material.make!(:arame_farpado)
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Mateus', :field => 'Nome'

    within_tab 'Contas Bancárias' do
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Itaú', :field => 'Nome'

      within_modal 'Agência' do
        page.should have_disabled_field 'Banco'
        page.should have_field 'Banco', :with => 'Itaú'

        fill_in 'Nome', :with => 'Agência Itaú'
        click_button 'Pesquisar'

        click_record 'Agência Itaú'
      end

      select 'Ativo', :from => 'Status'
      select 'Conta corrente', :from => 'Tipo da conta'
      fill_in 'Número da conta', :with => '12345'
      fill_in 'Dígito da conta', :with => 'x'
    end

    within_tab 'Balanço' do
      click_button 'Adicionar Balanço'

      fill_in 'Exercício', :with => '2012'
      fill_in 'Ativo circulante', :with => '10,00'
      fill_in 'Realizável em longo prazo', :with => '20,00'
      fill_in 'Passivo circulante', :with => '30,00'
      fill_in 'Patrimônio líquido', :with => '40,00'
      fill_in 'Exigível em longo prazo', :with => '50,00'
      fill_in 'Liquidez geral', :with => '60,00'
      fill_in 'Liquidez corrente', :with => '70,00'
      fill_in 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Materiais' do
      fill_modal 'Materiais', :with => 'Arame farpado', :field => 'Descrição'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2012'
      fill_in 'Data da ocorrência', :with => '05/05/2012'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Mateus Lorandi'

    page.should have_field 'Pessoa', :with => 'Mateus Lorandi'

    within_tab 'Contas Bancárias' do
      page.should have_field 'Banco', :with => 'Itaú', :field => 'Nome'
      page.should have_field 'Agência', :with => 'Agência Itaú', :field => 'Nome'
      page.should have_select 'Status', :selected => 'Ativo'
      page.should have_select 'Tipo da conta', :selected => 'Conta corrente'
      page.should have_field 'Número da conta', :with => '12345'
      page.should have_field 'Dígito da conta', :with => 'x'
    end

    within_tab 'Materiais' do
      page.should have_content '02.02.00001'
      page.should have_content 'Arame farpado'
    end

    within_tab 'Balanço' do
      page.should have_field 'Exercício', :with => '2012'
      page.should have_field 'Ativo circulante', :with => '10,00'
      page.should have_field 'Realizável em longo prazo', :with => '20,00'
      page.should have_field 'Passivo circulante', :with => '30,00'
      page.should have_field 'Patrimônio líquido', :with => '40,00'
      page.should have_field 'Exigível em longo prazo', :with => '50,00'
      page.should have_field 'Liquidez geral', :with => '60,00'
      page.should have_field 'Liquidez corrente', :with => '70,00'
      page.should have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      page.should have_field 'Tipo', :with => 'Sanção administrativa'
      page.should have_field 'Suspenso até', :with => '05/04/2012'
      page.should have_field 'Data da ocorrência', :with => '05/05/2012'
    end
  end

  scenario 'viewing more data from the selected person' do
    Person.make!(:nohup)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Nohup', :field => 'Nome'

    click_link 'Mais informações'

    page.should have_content 'Nohup'
    page.should have_content 'Sócios'
    page.should have_content 'Wenderson Malheiros'
  end

  scenario 'create a new creditor when people is a company' do
    Person.make!(:nohup)
    Cnae.make!(:varejo)
    Cnae.make!(:aluguel)
    Cnae.make!(:direito_social)
    CompanySize.make!(:micro_empresa)
    DocumentType.make!(:fiscal)
    Material.make!(:arame_farpado)
    Agency.make!(:itau)
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Nohup', :field => 'Nome'

    within_tab 'Principal' do
      fill_modal 'Porte da empressa', :with => 'Microempresa', :field => 'Nome'
      check 'Optante pelo simples'

      fill_modal 'CNAE principal', :with => '4712100', :field => 'Código'
      fill_modal 'Natureza jurídica', :with => 'Administração Pública'
    end

    within_tab 'Cnaes secundários' do
      within_modal 'Cnaes' do
        fill_in 'Código', :with => '94308'
        click_button 'Pesquisar'

        click_record '94308'
      end

      within_modal 'Cnaes' do
        fill_in 'Código', :with => '7739099'

        click_button 'Pesquisar'

        page.find('.records').should have_content '7739099'

        click_record '7739099'
      end

      within_modal 'Cnaes' do
        fill_in 'Código', :with => '4712100'

        click_button 'Pesquisar'

        page.find('.records').should_not have_content '4712100'

        click_link 'Cancelar'
      end
    end

    within_tab 'Documentos' do
      click_button 'Adicionar Documento'

      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
      fill_in 'Número', :with => '1234'
      fill_in 'Data de emissão', :with => '05/04/2012'
      fill_in 'Data de validade', :with => '05/04/2013'
      fill_in 'Órgão emissor', :with => 'SSP'
    end

    within_tab 'Materiais' do
      fill_modal 'Materiais', :with => 'Arame farpado', :field => 'Descrição'
    end

    within_tab 'Contas Bancárias' do
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Itaú', :field => 'Nome'

      within_modal 'Agência' do
        page.should have_disabled_field 'Banco'
        page.should have_field 'Banco', :with => 'Itaú'

        fill_in 'Nome', :with => 'Agência Itaú'
        click_button 'Pesquisar'

        click_record 'Agência Itaú'
      end

      select 'Ativo', :from => 'Status'
      select 'Conta corrente', :from => 'Tipo da conta'
      fill_in 'Número da conta', :with => '12345'
      fill_in 'Dígito da conta', :with => 'x'
    end

    within_tab 'Balanço' do
      click_button 'Adicionar Balanço'

      fill_in 'Exercício', :with => '2012'
      fill_in 'Ativo circulante', :with => '10,00'
      fill_in 'Realizável em longo prazo', :with => '20,00'
      fill_in 'Passivo circulante', :with => '30,00'
      fill_in 'Patrimônio líquido', :with => '40,00'
      fill_in 'Exigível em longo prazo', :with => '50,00'
      fill_in 'Liquidez geral', :with => '60,00'
      fill_in 'Liquidez corrente', :with => '70,00'
      fill_in 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2012'
      fill_in 'Data da ocorrência', :with => '05/05/2012'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Nohup'

    page.should have_field 'Pessoa', :with => 'Nohup'

    within_tab 'Principal' do
      page.should have_field 'Porte da empressa', :with => 'Microempresa'
      page.should have_checked_field 'Optante pelo simples'
      page.should have_field 'CNAE principal', :with => 'Comércio varejista de mercadorias em geral'
      page.should have_field 'Natureza jurídica', :with => 'Administração Pública'
    end

    within_tab 'Cnaes secundários' do
      page.should have_content '7739099'
      page.should have_content 'Aluguel de outras máquinas'
      page.should have_content '94308'
      page.should have_content 'Atividades de associações de defesa de direitos sociais'
    end

    within_tab 'Documentos' do
      page.should have_field 'Tipo de documento', :with => 'Fiscal'
      page.should have_field 'Número', :with => '1234'
      page.should have_field 'Data de emissão', :with => '05/04/2012'
      page.should have_field 'Data de validade', :with => '05/04/2013'
      page.should have_field 'Órgão emissor', :with => 'SSP'
    end

    within_tab 'Materiais' do
      page.should have_content '02.02.00001'
      page.should have_content 'Arame farpado'
    end

    within_tab 'Contas Bancárias' do
      page.should have_field 'Banco', :with => 'Itaú', :field => 'Nome'
      page.should have_field 'Agência', :with => 'Agência Itaú', :field => 'Nome'
      page.should have_select 'Status', :selected => 'Ativo'
      page.should have_select 'Tipo da conta', :selected => 'Conta corrente'
      page.should have_field 'Número da conta', :with => '12345'
      page.should have_field 'Dígito da conta', :with => 'x'
    end

    within_tab 'Balanço' do
      page.should have_field 'Exercício', :with => '2012'
      page.should have_field 'Ativo circulante', :with => '10,00'
      page.should have_field 'Realizável em longo prazo', :with => '20,00'
      page.should have_field 'Passivo circulante', :with => '30,00'
      page.should have_field 'Patrimônio líquido', :with => '40,00'
      page.should have_field 'Exigível em longo prazo', :with => '50,00'
      page.should have_field 'Liquidez geral', :with => '60,00'
      page.should have_field 'Liquidez corrente', :with => '70,00'
      page.should have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      page.should have_field 'Tipo', :with => 'Sanção administrativa'
      page.should have_field 'Suspenso até', :with => '05/04/2012'
      page.should have_field 'Data da ocorrência', :with => '05/05/2012'
    end
  end

  scenario 'validate uniqueness of person' do
    Creditor.make!(:sobrinho)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho', :field => 'Nome'

    click_button 'Salvar'

    page.should have_content 'já está em uso'
  end

  scenario 'create a new creditor when people is individual' do
    Person.make!(:sobrinho)
    Material.make!(:arame_farpado)
    OccupationClassification.make!(:armed_forces)
    Agency.make!(:itau)
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho', :field => 'Nome'

    within_tab 'Principal' do
      fill_modal 'CBO', :with => 'MEMBROS DAS FORÇAS ARMADAS', :field => 'Nome'
      check 'Admnistração pública municipal'
      check 'Autônomo'
      fill_in 'PIS/PASEP', :with => '123456'
      fill_in 'Início do contrato', :with => '05/04/2012'
    end

    within_tab 'Materiais' do
      fill_modal 'Materiais', :with => 'Arame farpado', :field => 'Descrição'
    end

    within_tab 'Contas Bancárias' do
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Itaú', :field => 'Nome'

      within_modal 'Agência' do
        page.should have_disabled_field 'Banco'
        page.should have_field 'Banco', :with => 'Itaú'

        fill_in 'Nome', :with => 'Agência Itaú'
        click_button 'Pesquisar'

        click_record 'Agência Itaú'
      end

      select 'Ativo', :from => 'Status'
      select 'Conta corrente', :from => 'Tipo da conta'
      fill_in 'Número da conta', :with => '12345'
      fill_in 'Dígito da conta', :with => 'x'
    end

    within_tab 'Balanço' do
      click_button 'Adicionar Balanço'

      fill_in 'Exercício', :with => '2012'
      fill_in 'Ativo circulante', :with => '10,00'
      fill_in 'Realizável em longo prazo', :with => '20,00'
      fill_in 'Passivo circulante', :with => '30,00'
      fill_in 'Patrimônio líquido', :with => '40,00'
      fill_in 'Exigível em longo prazo', :with => '50,00'
      fill_in 'Liquidez geral', :with => '60,00'
      fill_in 'Liquidez corrente', :with => '70,00'
      fill_in 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2012'
      fill_in 'Data da ocorrência', :with => '05/05/2012'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Gabriel Sobrinho'

    page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'

    within_tab 'Principal' do
      page.should have_field 'CBO', :with => '01 - MEMBROS DAS FORÇAS ARMADAS'
      page.should have_checked_field 'Admnistração pública municipal'
      page.should have_checked_field 'Autônomo'
      page.should have_field 'PIS/PASEP', :with => '123456'
      page.should have_field 'Início do contrato', :with => '05/04/2012'
    end

    within_tab 'Materiais' do
      page.should have_content '02.02.00001'
      page.should have_content 'Arame farpado'
    end

    within_tab 'Contas Bancárias' do
      page.should have_field 'Banco', :with => 'Itaú', :field => 'Nome'
      page.should have_field 'Agência', :with => 'Agência Itaú', :field => 'Nome'
      page.should have_select 'Status', :selected => 'Ativo'
      page.should have_select 'Tipo da conta', :selected => 'Conta corrente'
      page.should have_field 'Número da conta', :with => '12345'
      page.should have_field 'Dígito da conta', :with => 'x'
    end

    within_tab 'Balanço' do
      page.should have_field 'Exercício', :with => '2012'
      page.should have_field 'Ativo circulante', :with => '10,00'
      page.should have_field 'Realizável em longo prazo', :with => '20,00'
      page.should have_field 'Passivo circulante', :with => '30,00'
      page.should have_field 'Patrimônio líquido', :with => '40,00'
      page.should have_field 'Exigível em longo prazo', :with => '50,00'
      page.should have_field 'Liquidez geral', :with => '60,00'
      page.should have_field 'Liquidez corrente', :with => '70,00'
      page.should have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      page.should have_field 'Tipo', :with => 'Sanção administrativa'
      page.should have_field 'Suspenso até', :with => '05/04/2012'
      page.should have_field 'Data da ocorrência', :with => '05/05/2012'
    end
  end

  scenario 'acessing a CRC for a creditor and returnig to creditor' do
    Creditor.make!(:mateus)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Mateus Lorandi'

    click_link 'CRC'

    click_link '1/2012'

    page.should have_content 'Editar Certificado de Registro Cadastral 1/2012 do Credor Mateus Lorandi'

    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Número', :with => '1'
    page.should have_field 'Especificação', :with => 'Especificação do certificado do registro cadastral'
    page.should have_field 'Data da inscrição', :with => I18n.l(Date.yesterday)
    page.should have_field 'Data da validade', :with => I18n.l(Date.current)
    page.should have_field 'Data da revogação', :with => I18n.l(Date.tomorrow)
    page.should have_field 'Capital social', :with => '12.349,99'
    page.should have_field 'Capital integral', :with => '56.789,99'
    page.should have_field 'Faturamento mensal', :with => '123.456.789,99'
    page.should have_field 'Área construída (m²)', :with => '99,99'
    page.should have_field 'Área total (m²)', :with => '123,99'
    page.should have_field 'Total de empregados', :with => '1'
    page.should have_field 'Data de registro na junta comercial', :with => I18n.l(Date.current)
    page.should have_field 'Número na junta comercial', :with => '12345678-x'

    click_link 'Cancelar'

    click_link 'Voltar ao credor'

    page.should have_content 'Editar Mateus Lorandi'
  end

  scenario 'create a CRC for a creditor' do
    Creditor.make!(:mateus)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Mateus Lorandi'

    click_link 'CRC'

    click_link 'Criar Certificado de Registro Cadastral'

    page.should have_content 'Criar Certificado de Registro Cadastral para o Credor Mateus Lorandi'

    fill_in 'Exercício', :with => '2013'
    fill_in 'Especificação', :with => 'Especificação do Certificado do Registro Cadastral'
    fill_in 'Data da inscrição', :with => I18n.l(Date.yesterday)
    fill_in 'Data da validade', :with => '05/04/2013'
    fill_in 'Data da revogação', :with => '05/04/2014'
    fill_in 'Capital social', :with => '987.654,32'
    fill_in 'Capital integral', :with => '123.456,78'
    fill_in 'Faturamento mensal', :with => '456.789,99'
    fill_in 'Área construída (m²)', :with => '99,99'
    fill_in 'Área total (m²)', :with => '123,50'
    fill_in 'Total de empregados', :with => '2'
    fill_in 'Data de registro na junta comercial', :with => '05/04/2011'
    fill_in 'Número na junta comercial', :with => '12345678'

    click_button 'Salvar'

    page.should have_notice 'Certificado de Registro Cadastral criado com sucesso.'

    click_link '1/2013'

    page.should have_content 'Editar Certificado de Registro Cadastral 1/2013 do Credor Mateus Lorandi'

    page.should have_field 'Exercício', :with => '2013'
    page.should have_field 'Número', :with => '1'
    page.should have_field 'Especificação', :with => 'Especificação do Certificado do Registro Cadastral'
    page.should have_field 'Data da inscrição', :with => I18n.l(Date.yesterday)
    page.should have_field 'Data da validade', :with => '05/04/2013'
    page.should have_field 'Data da revogação', :with => '05/04/2014'
    page.should have_field 'Capital social', :with => '987.654,32'
    page.should have_field 'Capital integral', :with => '123.456,78'
    page.should have_field 'Faturamento mensal', :with => '456.789,99'
    page.should have_field 'Área construída (m²)', :with => '99,99'
    page.should have_field 'Área total (m²)', :with => '123,50'
    page.should have_field 'Total de empregados', :with => '2'
    page.should have_field 'Data de registro na junta comercial', :with => '05/04/2011'
    page.should have_field 'Número na junta comercial', :with => '12345678'

    click_link 'Cancelar'

    click_link 'Criar Certificado de Registro Cadastral'

    page.should have_content 'Criar Certificado de Registro Cadastral para o Credor Mateus Lorandi'

    fill_in 'Exercício', :with => '2013'
    fill_in 'Especificação', :with => 'Especificação do CRC'
    fill_in 'Data da inscrição', :with => I18n.l(Date.yesterday)
    fill_in 'Data da validade', :with => '05/04/2013'
    fill_in 'Data da revogação', :with => '05/04/2014'

    click_button 'Salvar'

    page.should have_notice 'Certificado de Registro Cadastral criado com sucesso.'

    click_link '2/2013'

    page.should have_content 'Editar Certificado de Registro Cadastral 2/2013 do Credor Mateus Lorandi'

    page.should have_field 'Exercício', :with => '2013'
    page.should have_field 'Número', :with => '2'
    page.should have_field 'Especificação', :with => 'Especificação do CRC'
    page.should have_field 'Data da inscrição', :with => I18n.l(Date.yesterday)
    page.should have_field 'Data da validade', :with => '05/04/2013'
    page.should have_field 'Data da revogação', :with => '05/04/2014'
  end

  scenario 'update a creditor when people is special entry' do
    Creditor.make!(:mateus)
    Agency.make!(:santander)
    Material.make!(:arame_farpado)
    RegularizationOrAdministrativeSanctionReason.make!(:regularizacao)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Mateus Lorandi'

    within_tab 'Contas Bancárias' do
      click_button 'Remover Conta Bancária'
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Santander', :field => 'Nome'

      within_modal 'Agência' do
        page.should have_disabled_field 'Banco'
        page.should have_field 'Banco', :with => 'Santander'

        fill_in 'Nome', :with => 'Agência Santander'
        click_button 'Pesquisar'

        click_record 'Agência Santander'
      end

      select 'Ativo', :from => 'Status'
      select 'Conta corrente', :from => 'Tipo da conta'
      fill_in 'Número da conta', :with => '98765'
      fill_in 'Dígito da conta', :with => '4'
    end

    within_tab 'Materiais' do
      fill_modal 'Materiais', :with => 'Arame farpado', :field => 'Descrição'
    end

    within_tab 'Balanço' do
      click_button 'Remover Balanço'
      click_button 'Adicionar Balanço'

      fill_in 'Exercício', :with => '2012'
      fill_in 'Ativo circulante', :with => '10,00'
      fill_in 'Realizável em longo prazo', :with => '20,00'
      fill_in 'Passivo circulante', :with => '30,00'
      fill_in 'Patrimônio líquido', :with => '40,00'
      fill_in 'Exigível em longo prazo', :with => '50,00'
      fill_in 'Liquidez geral', :with => '60,00'
      fill_in 'Liquidez corrente', :with => '70,00'
      fill_in 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      page.should have_field 'Tipo', :with => 'Sanção administrativa'
      page.should have_field 'Suspenso até', :with => '05/04/2012'
      page.should have_field 'Data da ocorrência', :with => '04/01/2012'

      click_button 'Remover Sanção Administrativa / Regularização'

      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Ativação do registro cadastral', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2011'
      fill_in 'Data da ocorrência', :with => '05/05/2011'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Mateus Lorandi'

    page.should have_field 'Pessoa', :with => 'Mateus Lorandi'

    within_tab 'Contas Bancárias' do
      page.should_not have_field 'Banco', :with => 'Itaú', :field => 'Nome'
      page.should_not have_field 'Agência', :with => 'Agência Itaú', :field => 'Nome'

      page.should have_field 'Banco', :with => 'Santander', :field => 'Nome'
      page.should have_field 'Agência', :with => 'Agência Santander', :field => 'Nome'
      page.should have_select 'Status', :selected => 'Ativo'
      page.should have_select 'Tipo da conta', :selected => 'Conta corrente'
      page.should have_field 'Número da conta', :with => '98765'
      page.should have_field 'Dígito da conta', :with => '4'
    end

    within_tab 'Materiais' do
      page.should have_content '02.02.00001'
      page.should have_content 'Arame farpado'
    end

    within_tab 'Balanço' do
      page.should have_field 'Exercício', :with => '2012'
      page.should have_field 'Ativo circulante', :with => '10,00'
      page.should have_field 'Realizável em longo prazo', :with => '20,00'
      page.should have_field 'Passivo circulante', :with => '30,00'
      page.should have_field 'Patrimônio líquido', :with => '40,00'
      page.should have_field 'Exigível em longo prazo', :with => '50,00'
      page.should have_field 'Liquidez geral', :with => '60,00'
      page.should have_field 'Liquidez corrente', :with => '70,00'
      page.should have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should_not have_content 'Advertência por desistência parcial da proposta devidamente justificada'

      page.should have_field 'Motivo', :with => 'Ativação do registro cadastral'
      page.should have_field 'Tipo', :with => 'Regularização'
      page.should have_field 'Suspenso até', :with => '05/04/2011'
      page.should have_field 'Data da ocorrência', :with => '05/05/2011'
    end
  end

  scenario 'update a creditor when people is a company' do
    Creditor.make!(:nohup)
    Cnae.make!(:aluguel)
    Cnae.make!(:direito_social)
    CompanySize.make!(:empresa_de_grande_porte)
    DocumentType.make!(:oficial)
    Person.make!(:wenderson)
    Material.make!(:arame_farpado)
    Agency.make!(:santander)
    RegularizationOrAdministrativeSanctionReason.make!(:regularizacao)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Nohup'

    within_tab 'Principal' do
      fill_modal 'Porte da empressa', :with => 'Empresa de grande porte', :field => 'Nome'
      uncheck 'Optante pelo simples'

      fill_modal 'CNAE principal', :with => '7739099', :field => 'Código'
    end

    within_tab 'Cnaes secundários' do
      page.should have_content 'Aluguel de outras máquinas'

      click_button 'Remover'

      within_modal 'Cnaes' do
        fill_in 'Código', :with => '94308'
        click_button 'Pesquisar'

        page.find('.records').should have_content '94308'

        click_record '94308'
      end

      within_modal 'Cnaes' do
        fill_in 'Código', :with => '7739099'

        click_button 'Pesquisar'

        page.find('.records').should_not have_content '7739099'

        click_link 'Cancelar'
      end
    end

    within_tab 'Documentos' do
      click_button 'Remover Documento'

      click_button 'Adicionar Documento'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
      fill_in 'Número', :with => '12345'
      fill_in 'Data de emissão', :with => '05/05/2012'
      fill_in 'Data de validade', :with => '05/05/2013'
      fill_in 'Órgão emissor', :with => 'PM'
    end

    within_tab 'Representantes' do
      page.should have_content 'Gabriel Sobrinho'
      page.should have_content '003.151.987-37'
      click_button 'Remover'

      fill_modal 'Representantes', :with => 'Wenderson Malheiros', :field => 'Nome'
    end

    within_tab 'Materiais' do
      click_button 'Remover Material'

      fill_modal 'Materiais', :with => 'Arame farpado', :field => 'Descrição'
    end

    within_tab 'Contas Bancárias' do
      click_button 'Remover Conta Bancária'
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Santander', :field => 'Nome'

      within_modal 'Agência' do
        page.should have_disabled_field 'Banco'
        page.should have_field 'Banco', :with => 'Santander'

        fill_in 'Nome', :with => 'Agência Santander'
        click_button 'Pesquisar'

        click_record 'Agência Santander'
      end

      select 'Ativo', :from => 'Status'
      select 'Conta corrente', :from => 'Tipo da conta'
      fill_in 'Número da conta', :with => '98765'
      fill_in 'Dígito da conta', :with => '4'
    end

    within_tab 'Balanço' do
      click_button 'Remover Balanço'
      click_button 'Adicionar Balanço'

      fill_in 'Exercício', :with => '2012'
      fill_in 'Ativo circulante', :with => '10,00'
      fill_in 'Realizável em longo prazo', :with => '20,00'
      fill_in 'Passivo circulante', :with => '30,00'
      fill_in 'Patrimônio líquido', :with => '40,00'
      fill_in 'Exigível em longo prazo', :with => '50,00'
      fill_in 'Liquidez geral', :with => '60,00'
      fill_in 'Liquidez corrente', :with => '70,00'
      fill_in 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      page.should have_field 'Tipo', :with => 'Sanção administrativa'
      page.should have_field 'Suspenso até', :with => '05/04/2012'
      page.should have_field 'Data da ocorrência', :with => '04/01/2012'

      click_button 'Remover Sanção Administrativa / Regularização'

      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Ativação do registro cadastral', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2011'
      fill_in 'Data da ocorrência', :with => '05/05/2011'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Nohup'

    page.should have_field 'Pessoa', :with => 'Nohup'

    within_tab 'Principal' do
      page.should have_field 'Porte da empressa', :with => 'Empresa de grande porte'
      page.should have_unchecked_field 'Optante pelo simples'
      page.should have_field 'CNAE principal', :with => 'Aluguel de outras máquinas'
    end

    within_tab 'Cnaes secundários' do
      page.should have_content '94308'
      page.should have_content 'Atividades de associações de defesa de direitos sociais'
      page.should_not have_content '7739099'
      page.should_not have_content 'Aluguel de outras máquinas'
    end

    within_tab 'Documentos' do
      page.should have_field 'Tipo de documento', :with => 'Oficial'
      page.should have_field 'Número', :with => '12345'
      page.should have_field 'Data de emissão', :with => '05/05/2012'
      page.should have_field 'Data de validade', :with => '05/05/2013'
      page.should have_field 'Órgão emissor', :with => 'PM'

      page.should_not have_content 'SSP'
    end

    within_tab 'Representantes' do
      page.should_not have_content 'Gabriel Sobrinho'
      page.should_not have_content '003.151.987-37'

      page.should have_content 'Wenderson Malheiros'
      page.should have_content '003.149.513-34'
    end

    within_tab 'Materiais' do
      page.should_not have_content '01.01.00001'
      page.should_not have_content 'Antivirus'

      page.should have_content '02.02.00001'
      page.should have_content 'Arame farpado'
    end

    within_tab 'Contas Bancárias' do
      page.should_not have_field 'Banco', :with => 'Itaú', :field => 'Nome'
      page.should_not have_field 'Agência', :with => 'Agência Itaú', :field => 'Nome'

      page.should have_field 'Banco', :with => 'Santander', :field => 'Nome'
      page.should have_field 'Agência', :with => 'Agência Santander', :field => 'Nome'
      page.should have_select 'Status', :selected => 'Ativo'
      page.should have_select 'Tipo da conta', :selected => 'Conta corrente'
      page.should have_field 'Número da conta', :with => '98765'
      page.should have_field 'Dígito da conta', :with => '4'
    end

    within_tab 'Balanço' do
      page.should have_field 'Exercício', :with => '2012'
      page.should have_field 'Ativo circulante', :with => '10,00'
      page.should have_field 'Realizável em longo prazo', :with => '20,00'
      page.should have_field 'Passivo circulante', :with => '30,00'
      page.should have_field 'Patrimônio líquido', :with => '40,00'
      page.should have_field 'Exigível em longo prazo', :with => '50,00'
      page.should have_field 'Liquidez geral', :with => '60,00'
      page.should have_field 'Liquidez corrente', :with => '70,00'
      page.should have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should_not have_content 'Advertência por desistência parcial da proposta devidamente justificada'

      page.should have_field 'Motivo', :with => 'Ativação do registro cadastral'
      page.should have_field 'Tipo', :with => 'Regularização'
      page.should have_field 'Suspenso até', :with => '05/04/2011'
      page.should have_field 'Data da ocorrência', :with => '05/05/2011'
    end
  end

  scenario 'update a creditor when people is individual' do
    Creditor.make!(:sobrinho)
    OccupationClassification.make!(:engineer)
    Material.make!(:arame_farpado)
    Material.make!(:arame_comum)
    Agency.make!(:santander)
    RegularizationOrAdministrativeSanctionReason.make!(:regularizacao)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Gabriel Sobrinho'

    within_tab 'Principal' do
      fill_modal 'CBO', :with => 'Engenheiro', :field => 'Nome'
      check 'Autônomo'
      fill_in 'PIS/PASEP', :with => '6789'
      fill_in 'Início do contrato', :with => '05/04/2011'
    end

    within_tab 'Materiais' do
      fill_modal 'Materiais', :with => 'Arame farpado', :field => 'Descrição'
      fill_modal 'Materiais', :with => 'Arame comum', :field => 'Descrição'
    end

    within_tab 'Contas Bancárias' do
      click_button 'Remover Conta Bancária'
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Santander', :field => 'Nome'

      within_modal 'Agência' do
        page.should have_disabled_field 'Banco'
        page.should have_field 'Banco', :with => 'Santander'

        fill_in 'Nome', :with => 'Agência Santander'
        click_button 'Pesquisar'

        click_record 'Agência Santander'
      end

      select 'Ativo', :from => 'Status'
      select 'Conta corrente', :from => 'Tipo da conta'
      fill_in 'Número da conta', :with => '98765'
      fill_in 'Dígito da conta', :with => '4'
    end

    within_tab 'Balanço' do
      click_button 'Remover Balanço'
      click_button 'Adicionar Balanço'

      fill_in 'Exercício', :with => '2012'
      fill_in 'Ativo circulante', :with => '10,00'
      fill_in 'Realizável em longo prazo', :with => '20,00'
      fill_in 'Passivo circulante', :with => '30,00'
      fill_in 'Patrimônio líquido', :with => '40,00'
      fill_in 'Exigível em longo prazo', :with => '50,00'
      fill_in 'Liquidez geral', :with => '60,00'
      fill_in 'Liquidez corrente', :with => '70,00'
      fill_in 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      page.should have_field 'Tipo', :with => 'Sanção administrativa'
      page.should have_field 'Suspenso até', :with => '05/04/2012'
      page.should have_field 'Data da ocorrência', :with => '04/01/2012'

      click_button 'Remover Sanção Administrativa / Regularização'

      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Ativação do registro cadastral', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2011'
      fill_in 'Data da ocorrência', :with => '05/05/2011'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Gabriel Sobrinho'

    page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'

    within_tab 'Principal' do
      page.should have_field 'CBO', :with => '214 - Engenheiro'
      page.should have_unchecked_field 'Admnistração pública municipal'
      page.should have_checked_field 'Autônomo'
      page.should have_field 'PIS/PASEP', :with => '6789'
      page.should have_field 'Início do contrato', :with => '05/04/2011'
    end

    within_tab 'Materiais' do
      page.should have_content '02.02.00001'
      page.should have_content 'Arame farpado'
      page.should have_content '02.02.00002'
      page.should have_content 'Arame comum'
    end

    within_tab 'Contas Bancárias' do
      page.should_not have_field 'Banco', :with => 'Itaú', :field => 'Nome'
      page.should_not have_field 'Agência', :with => 'Agência Itaú', :field => 'Nome'

      page.should have_field 'Banco', :with => 'Santander', :field => 'Nome'
      page.should have_field 'Agência', :with => 'Agência Santander', :field => 'Nome'
      page.should have_select 'Status', :selected => 'Ativo'
      page.should have_select 'Tipo da conta', :selected => 'Conta corrente'
      page.should have_field 'Número da conta', :with => '98765'
      page.should have_field 'Dígito da conta', :with => '4'
    end

    within_tab 'Balanço' do
      page.should have_field 'Exercício', :with => '2012'
      page.should have_field 'Ativo circulante', :with => '10,00'
      page.should have_field 'Realizável em longo prazo', :with => '20,00'
      page.should have_field 'Passivo circulante', :with => '30,00'
      page.should have_field 'Patrimônio líquido', :with => '40,00'
      page.should have_field 'Exigível em longo prazo', :with => '50,00'
      page.should have_field 'Liquidez geral', :with => '60,00'
      page.should have_field 'Liquidez corrente', :with => '70,00'
      page.should have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      page.should_not have_content 'Advertência por desistência parcial da proposta devidamente justificada'

      page.should have_field 'Motivo', :with => 'Ativação do registro cadastral'
      page.should have_field 'Tipo', :with => 'Regularização'
      page.should have_field 'Suspenso até', :with => '05/04/2011'
      page.should have_field 'Data da ocorrência', :with => '05/05/2011'
    end
  end

  scenario 'validating javascript to regularization or administrative sanction reason modal' do
    Creditor.make!(:nohup)
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Nohup'

    within_tab 'Sanções Administrativas / Regularizações' do
      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada', :field => 'Descrição'

      page.should have_field 'Tipo', :with => 'Sanção administrativa'
      page.should have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'

      fill_in 'Motivo', :with => ''

      page.should have_field 'Tipo', :with => ''
    end
  end

  scenario 'shoud not update a person on creditor' do
    Creditor.make!(:mateus)
    Person.make!(:sobrinho)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Mateus Lorandi'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

    click_button 'Salvar'

    page.should have_content 'Mateus Lorandi'
    page.should_not have_content 'Gabriel Sobrinho'
  end

  scenario 'show only the tabs that are common to all personable of people when has not a people.' do
    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    within "#creditor-tabs" do
       page.should_not have_link "Principal"
       page.should_not have_link "Cnaes secundários"
       page.should_not have_link "Documentos"
       page.should have_link "Materiais"
       page.should_not have_link "Representantes"
       page.should have_link "Contas Bancárias"
       page.should have_link "Balanço"
       page.should have_link "Sanções Administrativas / Regularizações"
    end
  end

  scenario 'should only show only tabs for special people' do
    Person.make!(:mateus)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Mateus Lorandi', :field => 'Nome'

    within "#creditor-tabs" do
       page.should_not have_link "Principal"
       page.should_not have_link "Cnaes secundários"
       page.should_not have_link "Documentos"
       page.should have_link "Materiais"
       page.should_not have_link "Representantes"
       page.should have_link "Contas Bancárias"
       page.should have_link "Balanço"
       page.should have_link "Sanções Administrativas / Regularizações"
    end
  end

  scenario 'should only show only tabs for individual people' do
    Person.make!(:sobrinho)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho', :field => 'Nome'

    within "#creditor-tabs" do
       page.should have_link "Principal"
       page.should_not have_link "Cnaes secundários"
       page.should_not have_link "Documentos"
       page.should have_link "Materiais"
       page.should_not have_link "Representantes"
       page.should have_link "Contas Bancárias"
       page.should have_link "Balanço"
       page.should have_link "Sanções Administrativas / Regularizações"
    end
  end

  scenario 'should only show only tabs for company people' do
    Person.make!(:nohup)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Nohup', :field => 'Nome'

    within "#creditor-tabs" do
       page.should have_link "Principal"
       page.should have_link "Cnaes secundários"
       page.should have_link "Documentos"
       page.should have_link "Materiais"
       page.should have_link "Representantes"
       page.should have_link "Contas Bancárias"
       page.should have_link "Balanço"
       page.should have_link "Sanções Administrativas / Regularizações"
    end
  end

  scenario 'destroy an existent creditor' do
    Creditor.make!(:nohup)
    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Nohup'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Credor apagado com sucesso.'

    page.should_not have_content 'Nohup'
    page.should_not have_content 'Microempresa'
  end

  scenario 'destroy a CRC for a creditor' do
    Creditor.make!(:mateus)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Mateus Lorandi'

    click_link 'CRC'

    click_link '1/2012'

    page.should have_content 'Editar Certificado de Registro Cadastral 1/2012 do Credor Mateus Lorandi'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Certificado de Registro Cadastral apagado com sucesso.'

    page.should_not have_link '2012'
    page.should_not have_content '2012'
  end
end
