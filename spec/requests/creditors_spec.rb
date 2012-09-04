# encoding: utf-8
require 'spec_helper'

feature "Creditors" do
  background do
    sign_in
  end

  scenario 'creditor filter by person or special entry' do
    Creditor.make!(:nohup)
    Creditor.make!(:special)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Filtrar Credores'
    fill_in 'Nome', :with => 'Nohup'
    click_button 'Pesquisar'

    expect(page).to have_link 'Nohup'
    expect(page).to_not have_link 'Tal'

    click_link 'Filtrar Credores'
    fill_in 'Nome', :with => 'Tal'
    click_button 'Pesquisar'

    expect(page).to have_link 'Tal'
    expect(page).to_not have_link 'Nohup'
  end

  scenario 'creditor filter by CNPJ or CPF' do
    Creditor.make!(:nohup)
    Creditor.make!(:sobrinho)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Filtrar Credores'
    fill_in 'CPF', :with => '003.151.987-37'
    click_button 'Pesquisar'

    expect(page).to_not have_link 'Nohup'
    expect(page).to have_link 'Gabriel Sobrinho'

    click_link 'Filtrar Credores'
    fill_in 'CNPJ', :with => '00.000.000/9999-62'
    click_button 'Pesquisar'

    expect(page).to have_link 'Nohup'
    expect(page).to_not have_link 'Gabriel Sobrinho'
  end

  scenario 'switch type of creditor between special entry and person' do
    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    expect(page).to have_field 'Inscrição especial', :with => ''

    choose 'Pessoa física ou jurídica'

    expect(page).to have_field 'creditor_creditable', :with => ''

    choose 'Inscrição especial'

    expect(page).to have_field 'Inscrição especial', :with => ''
  end

  scenario 'create a new creditor when people is special entry' do
    SpecialEntry.make!(:example)
    Agency.make!(:itau)
    Material.make!(:arame_farpado)
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    fill_modal 'creditor_creditable', :with => 'Tal'

    within_tab 'Contas Bancárias' do
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Itaú'

      within_modal 'Agência' do
        expect(page).to have_disabled_field 'Banco'
        expect(page).to have_field 'Banco', :with => 'Itaú'

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

    expect(page).to have_notice 'Credor criado com sucesso.'

    click_link 'Tal'

    expect(page).to have_field 'Inscrição especial', :with => 'Tal'
    expect(page).not_to have_field 'Porte da empresa'

    within_tab 'Contas Bancárias' do
      expect(page).to have_field 'Banco', :with => 'Itaú'
      expect(page).to have_field 'Agência', :with => 'Agência Itaú'
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_select 'Tipo da conta', :selected => 'Conta corrente'
      expect(page).to have_field 'Número da conta', :with => '12345'
      expect(page).to have_field 'Dígito da conta', :with => 'x'
    end

    within_tab 'Materiais' do
      expect(page).to have_content '02.02.00001'
      expect(page).to have_content 'Arame farpado'
    end

    within_tab 'Balanço' do
      expect(page).to have_field 'Exercício', :with => '2012'
      expect(page).to have_field 'Ativo circulante', :with => '10,00'
      expect(page).to have_field 'Realizável em longo prazo', :with => '20,00'
      expect(page).to have_field 'Passivo circulante', :with => '30,00'
      expect(page).to have_field 'Patrimônio líquido', :with => '40,00'
      expect(page).to have_field 'Exigível em longo prazo', :with => '50,00'
      expect(page).to have_field 'Liquidez geral', :with => '60,00'
      expect(page).to have_field 'Liquidez corrente', :with => '70,00'
      expect(page).to have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      expect(page).to have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      expect(page).to have_field 'Tipo', :with => 'Sanção administrativa'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2012'
      expect(page).to have_field 'Data da ocorrência', :with => '05/05/2012'
    end
  end

  scenario 'viewing more data from the selected person' do
    Person.make!(:nohup)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    choose 'Pessoa física ou jurídica'

    fill_modal 'creditor_creditable', :with => 'Nohup'

    click_link 'Mais informações'

    expect(page).to have_content 'Nohup'
    expect(page).to have_content 'Sócios'
    expect(page).to have_content 'Wenderson Malheiros'
  end

  scenario 'create a new creditor when people is a company' do
    Person.make!(:ibrama)
    Cnae.make!(:varejo)
    Cnae.make!(:aluguel)
    Cnae.make!(:direito_social)
    CompanySize.make!(:micro_empresa)
    DocumentType.make!(:fiscal)
    Material.make!(:arame_farpado)
    Agency.make!(:itau)
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    choose 'Pessoa física ou jurídica'

    fill_modal 'creditor_creditable', :with => 'Ibrama'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Porte da empresa'
      expect(page).to have_field 'Porte da empresa', :with => 'Microempresa'
      expect(page).to have_disabled_field 'Optante pelo simples'
      expect(page).to have_checked_field 'Optante pelo simples'
      expect(page).to have_disabled_field 'Natureza jurídica'
      expect(page).to have_field 'Natureza jurídica', :with => 'Administração Pública'
      expect(page).to have_disabled_field 'Número do registro na junta comercial'
      expect(page).to have_field 'Número do registro na junta comercial', :with => '099901'
      expect(page).to have_disabled_field 'Data do registro na junta comercial'
      expect(page).to have_field 'Data do registro na junta comercial', :with => '29/06/2011'
    end

    within_tab 'CNAEs' do
      fill_modal 'CNAE principal', :with => '4712100', :field => 'Código'

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

      fill_modal 'Banco', :with => 'Itaú'

      within_modal 'Agência' do
        expect(page).to have_disabled_field 'Banco'
        expect(page).to have_field 'Banco', :with => 'Itaú'

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

    expect(page).to have_notice 'Credor criado com sucesso.'

    click_link 'Ibrama'

    expect(page).to have_field 'creditor_creditable', :with => 'Ibrama'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Porte da empresa'
      expect(page).to have_field 'Porte da empresa', :with => 'Microempresa'
      expect(page).to have_disabled_field 'Optante pelo simples'
      expect(page).to have_checked_field 'Optante pelo simples'
      expect(page).to have_disabled_field 'Natureza jurídica'
      expect(page).to have_field 'Natureza jurídica', :with => 'Administração Pública'
      expect(page).to have_disabled_field 'Número do registro na junta comercial'
      expect(page).to have_field 'Número do registro na junta comercial', :with => '099901'
      expect(page).to have_disabled_field 'Data do registro na junta comercial'
      expect(page).to have_field 'Data do registro na junta comercial', :with => '29/06/2011'
      expect(page).not_to have_field 'PIS/PASEP'
    end

    within_tab 'CNAEs' do
      expect(page).to have_field 'CNAE principal', :with => 'Comércio varejista de mercadorias em geral'
      expect(page).to have_content '7739099'
      expect(page).to have_content 'Aluguel de outras máquinas'
      expect(page).to have_content '94308'
      expect(page).to have_content 'Atividades de associações de defesa de direitos sociais'
    end

    within_tab 'Documentos' do
      expect(page).to have_field 'Tipo de documento', :with => 'Fiscal'
      expect(page).to have_field 'Número', :with => '1234'
      expect(page).to have_field 'Data de emissão', :with => '05/04/2012'
      expect(page).to have_field 'Data de validade', :with => '05/04/2013'
      expect(page).to have_field 'Órgão emissor', :with => 'SSP'
    end

    within_tab 'Materiais' do
      expect(page).to have_content '02.02.00001'
      expect(page).to have_content 'Arame farpado'
    end

    within_tab 'Contas Bancárias' do
      expect(page).to have_field 'Banco', :with => 'Itaú'
      expect(page).to have_field 'Agência', :with => 'Agência Itaú'
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_select 'Tipo da conta', :selected => 'Conta corrente'
      expect(page).to have_field 'Número da conta', :with => '12345'
      expect(page).to have_field 'Dígito da conta', :with => 'x'
    end

    within_tab 'Balanço' do
      expect(page).to have_field 'Exercício', :with => '2012'
      expect(page).to have_field 'Ativo circulante', :with => '10,00'
      expect(page).to have_field 'Realizável em longo prazo', :with => '20,00'
      expect(page).to have_field 'Passivo circulante', :with => '30,00'
      expect(page).to have_field 'Patrimônio líquido', :with => '40,00'
      expect(page).to have_field 'Exigível em longo prazo', :with => '50,00'
      expect(page).to have_field 'Liquidez geral', :with => '60,00'
      expect(page).to have_field 'Liquidez corrente', :with => '70,00'
      expect(page).to have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      expect(page).to have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      expect(page).to have_field 'Tipo', :with => 'Sanção administrativa'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2012'
      expect(page).to have_field 'Data da ocorrência', :with => '05/05/2012'
    end
  end

  scenario 'validate uniqueness of person' do
    Creditor.make!(:sobrinho)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    choose 'Pessoa física ou jurídica'

    fill_modal 'creditor_creditable', :with => 'Gabriel Sobrinho'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end

  scenario 'validate uniqueness of special_entry' do
    Creditor.make!(:special)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    fill_modal 'creditor_creditable', :with => 'Tal'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end

  scenario 'create a new creditor when people is individual' do
    Person.make!(:sobrinho)
    Material.make!(:arame_farpado)
    OccupationClassification.make!(:armed_forces)
    Agency.make!(:itau)
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    choose 'Pessoa física ou jurídica'

    fill_modal 'creditor_creditable', :with => 'Gabriel Sobrinho'

    within_tab 'Principal' do
      fill_modal 'CBO', :with => 'MEMBROS DAS FORÇAS ARMADAS'
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

      fill_modal 'Banco', :with => 'Itaú'

      within_modal 'Agência' do
        expect(page).to have_disabled_field 'Banco'
        expect(page).to have_field 'Banco', :with => 'Itaú'

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

    expect(page).to have_notice 'Credor criado com sucesso.'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'creditor_creditable', :with => 'Gabriel Sobrinho'

    within_tab 'Principal' do
      expect(page).to have_field 'CBO', :with => '01 - MEMBROS DAS FORÇAS ARMADAS'
      expect(page).to have_checked_field 'Admnistração pública municipal'
      expect(page).to have_checked_field 'Autônomo'
      expect(page).to have_field 'PIS/PASEP', :with => '123456'
      expect(page).to have_field 'Início do contrato', :with => '05/04/2012'
      expect(page).not_to have_field 'Porte da empresa'
    end

    within_tab 'Materiais' do
      expect(page).to have_content '02.02.00001'
      expect(page).to have_content 'Arame farpado'
    end

    within_tab 'Contas Bancárias' do
      expect(page).to have_field 'Banco', :with => 'Itaú'
      expect(page).to have_field 'Agência', :with => 'Agência Itaú'
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_select 'Tipo da conta', :selected => 'Conta corrente'
      expect(page).to have_field 'Número da conta', :with => '12345'
      expect(page).to have_field 'Dígito da conta', :with => 'x'
    end

    within_tab 'Balanço' do
      expect(page).to have_field 'Exercício', :with => '2012'
      expect(page).to have_field 'Ativo circulante', :with => '10,00'
      expect(page).to have_field 'Realizável em longo prazo', :with => '20,00'
      expect(page).to have_field 'Passivo circulante', :with => '30,00'
      expect(page).to have_field 'Patrimônio líquido', :with => '40,00'
      expect(page).to have_field 'Exigível em longo prazo', :with => '50,00'
      expect(page).to have_field 'Liquidez geral', :with => '60,00'
      expect(page).to have_field 'Liquidez corrente', :with => '70,00'
      expect(page).to have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      expect(page).to have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      expect(page).to have_field 'Tipo', :with => 'Sanção administrativa'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2012'
      expect(page).to have_field 'Data da ocorrência', :with => '05/05/2012'
    end
  end

  scenario 'acessing a CRC for a creditor and returnig to creditor' do
    Creditor.make!(:nohup)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    click_link 'CRC'

    click_link '1/2012'

    expect(page).to have_content 'Editar Certificado de Registro Cadastral 1/2012 do Credor Nohup'

    expect(page).to have_field 'Exercício', :with => '2012'
    expect(page).to have_field 'Número', :with => '1'
    expect(page).to have_field 'Especificação', :with => 'Especificação do certificado do registro cadastral'
    expect(page).to have_field 'Data da inscrição', :with => I18n.l(Date.yesterday)
    expect(page).to have_field 'Data da validade', :with => I18n.l(Date.current)
    expect(page).to have_field 'Data da revogação', :with => I18n.l(Date.tomorrow)
    expect(page).to have_field 'Capital social', :with => '12.349,99'
    expect(page).to have_field 'Capital integral', :with => '56.789,99'
    expect(page).to have_field 'Faturamento mensal', :with => '123.456.789,99'
    expect(page).to have_field 'Área construída (m²)', :with => '99,99'
    expect(page).to have_field 'Área total (m²)', :with => '123,99'
    expect(page).to have_field 'Total de empregados', :with => '1'
    expect(page).to have_field 'Data de registro na junta comercial', :with => I18n.l(Date.current)
    expect(page).to have_field 'Número na junta comercial', :with => '12345678-x'

    expect(page).to have_link 'Imprimir certificado de registro cadastral'

    click_link 'Cancelar'

    click_link 'Voltar ao credor'

    expect(page).to have_content 'Editar Nohup'
  end

  scenario 'create a CRC for a creditor' do
    Creditor.make!(:nohup)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    click_link 'CRC'

    click_link 'Criar Certificado de Registro Cadastral'

    expect(page).to have_content 'Criar Certificado de Registro Cadastral para o Credor Nohup'

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

    expect(page).not_to have_link 'Imprimir certificado de registro cadastral'

    click_button 'Salvar'

    expect(page).to have_notice 'Certificado de Registro Cadastral criado com sucesso.'

    click_link '1/2013'

    expect(page).to have_content 'Editar Certificado de Registro Cadastral 1/2013 do Credor Nohup'

    expect(page).to have_field 'Exercício', :with => '2013'
    expect(page).to have_field 'Número', :with => '1'
    expect(page).to have_field 'Especificação', :with => 'Especificação do Certificado do Registro Cadastral'
    expect(page).to have_field 'Data da inscrição', :with => I18n.l(Date.yesterday)
    expect(page).to have_field 'Data da validade', :with => '05/04/2013'
    expect(page).to have_field 'Data da revogação', :with => '05/04/2014'
    expect(page).to have_field 'Capital social', :with => '987.654,32'
    expect(page).to have_field 'Capital integral', :with => '123.456,78'
    expect(page).to have_field 'Faturamento mensal', :with => '456.789,99'
    expect(page).to have_field 'Área construída (m²)', :with => '99,99'
    expect(page).to have_field 'Área total (m²)', :with => '123,50'
    expect(page).to have_field 'Total de empregados', :with => '2'
    expect(page).to have_field 'Data de registro na junta comercial', :with => '05/04/2011'
    expect(page).to have_field 'Número na junta comercial', :with => '12345678'

    expect(page).to have_link 'Imprimir certificado de registro cadastral'

    click_link 'Cancelar'

    click_link 'Criar Certificado de Registro Cadastral'

    expect(page).to have_content 'Criar Certificado de Registro Cadastral para o Credor Nohup'

    fill_in 'Exercício', :with => '2013'
    fill_in 'Especificação', :with => 'Especificação do CRC'
    fill_in 'Data da inscrição', :with => I18n.l(Date.yesterday)
    fill_in 'Data da validade', :with => '05/04/2013'
    fill_in 'Data da revogação', :with => '05/04/2014'

    click_button 'Salvar'

    expect(page).to have_notice 'Certificado de Registro Cadastral criado com sucesso.'

    click_link '2/2013'

    expect(page).to have_content 'Editar Certificado de Registro Cadastral 2/2013 do Credor Nohup'

    expect(page).to have_field 'Exercício', :with => '2013'
    expect(page).to have_field 'Número', :with => '2'
    expect(page).to have_field 'Especificação', :with => 'Especificação do CRC'
    expect(page).to have_field 'Data da inscrição', :with => I18n.l(Date.yesterday)
    expect(page).to have_field 'Data da validade', :with => '05/04/2013'
    expect(page).to have_field 'Data da revogação', :with => '05/04/2014'
  end

  scenario 'update a CRC for a creditor' do
    Creditor.make!(:nohup)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    click_link 'CRC'

    click_link '1/2012'

    expect(page).to have_content 'Editar Certificado de Registro Cadastral 1/2012 do Credor Nohup'

    fill_in 'Exercício', :with => '2013'
    expect(page).to have_field 'Número', :with => '1'
    fill_in 'Especificação', :with => 'Especificação do Certificado do Registro Cadastral da Nohup'
    fill_in 'Data da inscrição', :with => I18n.l(Date.yesterday)
    fill_in 'Data da validade', :with => '05/04/2014'
    fill_in 'Data da revogação', :with => '05/04/2015'
    fill_in 'Capital social', :with => '987.654,31'
    fill_in 'Capital integral', :with => '123.456,79'
    fill_in 'Faturamento mensal', :with => '456.789,00'
    fill_in 'Área construída (m²)', :with => '88,88'
    fill_in 'Área total (m²)', :with => '99,99'
    fill_in 'Total de empregados', :with => '99'
    fill_in 'Data de registro na junta comercial', :with => '05/05/2011'
    fill_in 'Número na junta comercial', :with => '123456789'

    expect(page).to have_link 'Imprimir certificado de registro cadastral'

    click_button 'Salvar'

    expect(page).to have_notice 'Certificado de Registro Cadastral editado com sucesso.'

    click_link '1/2013'

    expect(page).to have_content 'Editar Certificado de Registro Cadastral 1/2013 do Credor Nohup'

    expect(page).to have_field 'Exercício', :with => '2013'
    expect(page).to have_field 'Número', :with => '1'
    expect(page).to have_field 'Especificação', :with => 'Especificação do Certificado do Registro Cadastral da Nohup'
    expect(page).to have_field 'Data da inscrição', :with => I18n.l(Date.yesterday)
    expect(page).to have_field 'Data da validade', :with => '05/04/2014'
    expect(page).to have_field 'Data da revogação', :with => '05/04/2015'
    expect(page).to have_field 'Capital social', :with => '987.654,31'
    expect(page).to have_field 'Capital integral', :with => '123.456,79'
    expect(page).to have_field 'Faturamento mensal', :with => '456.789,00'
    expect(page).to have_field 'Área construída (m²)', :with => '88,88'
    expect(page).to have_field 'Área total (m²)', :with => '99,99'
    expect(page).to have_field 'Total de empregados', :with => '99'
    expect(page).to have_field 'Data de registro na junta comercial', :with => '05/05/2011'
    expect(page).to have_field 'Número na junta comercial', :with => '123456789'
  end

  scenario 'should not show CRC when creditor is' do
    Creditor.make!(:nohup)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    expect(page).to have_link 'CRC'
  end

  scenario 'should not show CRC when creditor is company' do
    Creditor.make!(:sobrinho)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Gabriel Sobrinho'

    expect(page).not_to have_link 'CRC'
  end

  scenario 'update a creditor when people is special entry' do
    Creditor.make!(:mateus)
    Agency.make!(:santander)
    Material.make!(:arame_farpado)
    RegularizationOrAdministrativeSanctionReason.make!(:regularizacao)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Mateus Lorandi'

    within_tab 'Contas Bancárias' do
      click_button 'Remover Conta Bancária'
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Santander'

      within_modal 'Agência' do
        expect(page).to have_disabled_field 'Banco'
        expect(page).to have_field 'Banco', :with => 'Santander'

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
      expect(page).to have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      expect(page).to have_field 'Tipo', :with => 'Sanção administrativa'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2012'
      expect(page).to have_field 'Data da ocorrência', :with => '04/01/2012'

      click_button 'Remover Sanção Administrativa / Regularização'

      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Ativação do registro cadastral', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2011'
      fill_in 'Data da ocorrência', :with => '05/05/2011'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credor editado com sucesso.'

    click_link 'Mateus Lorandi'

    expect(page).to have_field 'creditor_creditable', :with => 'Mateus Lorandi'

    within_tab 'Contas Bancárias' do
      expect(page).not_to have_field 'Banco', :with => 'Itaú'
      expect(page).not_to have_field 'Agência', :with => 'Agência Itaú'

      expect(page).to have_field 'Banco', :with => 'Santander'
      expect(page).to have_field 'Agência', :with => 'Agência Santander'
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_select 'Tipo da conta', :selected => 'Conta corrente'
      expect(page).to have_field 'Número da conta', :with => '98765'
      expect(page).to have_field 'Dígito da conta', :with => '4'
    end

    within_tab 'Materiais' do
      expect(page).to have_content '02.02.00001'
      expect(page).to have_content 'Arame farpado'
    end

    within_tab 'Balanço' do
      expect(page).to have_field 'Exercício', :with => '2012'
      expect(page).to have_field 'Ativo circulante', :with => '10,00'
      expect(page).to have_field 'Realizável em longo prazo', :with => '20,00'
      expect(page).to have_field 'Passivo circulante', :with => '30,00'
      expect(page).to have_field 'Patrimônio líquido', :with => '40,00'
      expect(page).to have_field 'Exigível em longo prazo', :with => '50,00'
      expect(page).to have_field 'Liquidez geral', :with => '60,00'
      expect(page).to have_field 'Liquidez corrente', :with => '70,00'
      expect(page).to have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      expect(page).not_to have_content 'Advertência por desistência parcial da proposta devidamente justificada'

      expect(page).to have_field 'Motivo', :with => 'Ativação do registro cadastral'
      expect(page).to have_field 'Tipo', :with => 'Regularização'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2011'
      expect(page).to have_field 'Data da ocorrência', :with => '05/05/2011'
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

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Porte da empresa'
      expect(page).to have_field 'Porte da empresa', :with => 'Microempresa'
      expect(page).to have_disabled_field 'Optante pelo simples'
      expect(page).not_to have_checked_field 'Optante pelo simples'
      expect(page).to have_disabled_field 'Natureza jurídica'
      expect(page).to have_field 'Natureza jurídica', :with => 'Administração Pública'
      expect(page).to have_disabled_field 'Número do registro na junta comercial'
      expect(page).to have_field 'Número do registro na junta comercial', :with => '099901'
      expect(page).to have_disabled_field 'Data do registro na junta comercial'
      expect(page).to have_field 'Data do registro na junta comercial', :with => '29/06/2011'
    end

    within_tab 'CNAEs' do
      fill_modal 'CNAE principal', :with => '7739099', :field => 'Código'

      expect(page).to have_content 'Aluguel de outras máquinas'

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
      expect(page).to have_content 'Gabriel Sobrinho'
      expect(page).to have_content '003.151.987-37'
      click_button 'Remover'

      fill_modal 'Representantes', :with => 'Wenderson Malheiros'
    end

    within_tab 'Materiais' do
      click_button 'Remover Material'

      fill_modal 'Materiais', :with => 'Arame farpado', :field => 'Descrição'
    end

    within_tab 'Contas Bancárias' do
      click_button 'Remover Conta Bancária'
      click_button 'Adicionar Conta Bancária'

      fill_modal 'Banco', :with => 'Santander'

      within_modal 'Agência' do
        expect(page).to have_disabled_field 'Banco'
        expect(page).to have_field 'Banco', :with => 'Santander'

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
      expect(page).to have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      expect(page).to have_field 'Tipo', :with => 'Sanção administrativa'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2012'
      expect(page).to have_field 'Data da ocorrência', :with => '04/01/2012'

      click_button 'Remover Sanção Administrativa / Regularização'

      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Ativação do registro cadastral', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2011'
      fill_in 'Data da ocorrência', :with => '05/05/2011'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credor editado com sucesso.'

    click_link 'Nohup'

    expect(page).to have_field 'creditor_creditable', :with => 'Nohup'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Porte da empresa'
      expect(page).to have_field 'Porte da empresa', :with => 'Microempresa'
      expect(page).to have_disabled_field 'Optante pelo simples'
      expect(page).not_to have_checked_field 'Optante pelo simples'
      expect(page).to have_disabled_field 'Natureza jurídica'
      expect(page).to have_field 'Natureza jurídica', :with => 'Administração Pública'
      expect(page).to have_disabled_field 'Número do registro na junta comercial'
      expect(page).to have_field 'Número do registro na junta comercial', :with => '099901'
      expect(page).to have_disabled_field 'Data do registro na junta comercial'
      expect(page).to have_field 'Data do registro na junta comercial', :with => '29/06/2011'
    end

    within_tab 'CNAEs' do
      expect(page).to have_field 'CNAE principal', :with => 'Aluguel de outras máquinas'
      expect(page).to have_content '94308'
      expect(page).to have_content 'Atividades de associações de defesa de direitos sociais'
      expect(page).not_to have_content '7739099'
      expect(page).not_to have_content 'Aluguel de outras máquinas'
    end

    within_tab 'Documentos' do
      expect(page).to have_field 'Tipo de documento', :with => 'Oficial'
      expect(page).to have_field 'Número', :with => '12345'
      expect(page).to have_field 'Data de emissão', :with => '05/05/2012'
      expect(page).to have_field 'Data de validade', :with => '05/05/2013'
      expect(page).to have_field 'Órgão emissor', :with => 'PM'

      expect(page).not_to have_content 'SSP'
    end

    within_tab 'Representantes' do
      expect(page).not_to have_content 'Gabriel Sobrinho'
      expect(page).not_to have_content '003.151.987-37'

      expect(page).to have_content 'Wenderson Malheiros'
      expect(page).to have_content '003.149.513-34'
    end

    within_tab 'Materiais' do
      expect(page).not_to have_content '01.01.00001'
      expect(page).not_to have_content 'Antivirus'

      expect(page).to have_content '02.02.00001'
      expect(page).to have_content 'Arame farpado'
    end

    within_tab 'Contas Bancárias' do
      expect(page).not_to have_field 'Banco', :with => 'Itaú'
      expect(page).not_to have_field 'Agência', :with => 'Agência Itaú'

      expect(page).to have_field 'Banco', :with => 'Santander'
      expect(page).to have_field 'Agência', :with => 'Agência Santander'
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_select 'Tipo da conta', :selected => 'Conta corrente'
      expect(page).to have_field 'Número da conta', :with => '98765'
      expect(page).to have_field 'Dígito da conta', :with => '4'
    end

    within_tab 'Balanço' do
      expect(page).to have_field 'Exercício', :with => '2012'
      expect(page).to have_field 'Ativo circulante', :with => '10,00'
      expect(page).to have_field 'Realizável em longo prazo', :with => '20,00'
      expect(page).to have_field 'Passivo circulante', :with => '30,00'
      expect(page).to have_field 'Patrimônio líquido', :with => '40,00'
      expect(page).to have_field 'Exigível em longo prazo', :with => '50,00'
      expect(page).to have_field 'Liquidez geral', :with => '60,00'
      expect(page).to have_field 'Liquidez corrente', :with => '70,00'
      expect(page).to have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      expect(page).not_to have_content 'Advertência por desistência parcial da proposta devidamente justificada'

      expect(page).to have_field 'Motivo', :with => 'Ativação do registro cadastral'
      expect(page).to have_field 'Tipo', :with => 'Regularização'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2011'
      expect(page).to have_field 'Data da ocorrência', :with => '05/05/2011'
    end
  end

  scenario 'update a creditor when people is individual' do
    Creditor.make!(:sobrinho)
    OccupationClassification.make!(:engineer)
    Material.make!(:arame_farpado)
    Material.make!(:arame_comum)
    Agency.make!(:santander)
    RegularizationOrAdministrativeSanctionReason.make!(:regularizacao)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Gabriel Sobrinho'

    within_tab 'Principal' do
      fill_modal 'CBO', :with => 'Engenheiro'
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

      fill_modal 'Banco', :with => 'Santander'

      within_modal 'Agência' do
        expect(page).to have_disabled_field 'Banco'
        expect(page).to have_field 'Banco', :with => 'Santander'

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
      expect(page).to have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'
      expect(page).to have_field 'Tipo', :with => 'Sanção administrativa'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2012'
      expect(page).to have_field 'Data da ocorrência', :with => '04/01/2012'

      click_button 'Remover Sanção Administrativa / Regularização'

      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Ativação do registro cadastral', :field => 'Descrição'
      fill_in 'Suspenso até', :with => '05/04/2011'
      fill_in 'Data da ocorrência', :with => '05/05/2011'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Credor editado com sucesso.'

    click_link 'Gabriel Sobrinho'

    expect(page).to have_field 'creditor_creditable', :with => 'Gabriel Sobrinho'

    within_tab 'Principal' do
      expect(page).to have_field 'CBO', :with => '214 - Engenheiro'
      expect(page).to have_unchecked_field 'Admnistração pública municipal'
      expect(page).to have_checked_field 'Autônomo'
      expect(page).to have_field 'PIS/PASEP', :with => '6789'
      expect(page).to have_field 'Início do contrato', :with => '05/04/2011'
    end

    within_tab 'Materiais' do
      expect(page).to have_content '02.02.00001'
      expect(page).to have_content 'Arame farpado'
      expect(page).to have_content '02.02.00002'
      expect(page).to have_content 'Arame comum'
    end

    within_tab 'Contas Bancárias' do
      expect(page).not_to have_field 'Banco', :with => 'Itaú'
      expect(page).not_to have_field 'Agência', :with => 'Agência Itaú'

      expect(page).to have_field 'Banco', :with => 'Santander'
      expect(page).to have_field 'Agência', :with => 'Agência Santander'
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_select 'Tipo da conta', :selected => 'Conta corrente'
      expect(page).to have_field 'Número da conta', :with => '98765'
      expect(page).to have_field 'Dígito da conta', :with => '4'
    end

    within_tab 'Balanço' do
      expect(page).to have_field 'Exercício', :with => '2012'
      expect(page).to have_field 'Ativo circulante', :with => '10,00'
      expect(page).to have_field 'Realizável em longo prazo', :with => '20,00'
      expect(page).to have_field 'Passivo circulante', :with => '30,00'
      expect(page).to have_field 'Patrimônio líquido', :with => '40,00'
      expect(page).to have_field 'Exigível em longo prazo', :with => '50,00'
      expect(page).to have_field 'Liquidez geral', :with => '60,00'
      expect(page).to have_field 'Liquidez corrente', :with => '70,00'
      expect(page).to have_field 'Capital circulante líquido', :with => '80,00'
    end

    within_tab 'Sanções Administrativas / Regularizações' do
      expect(page).not_to have_content 'Advertência por desistência parcial da proposta devidamente justificada'

      expect(page).to have_field 'Motivo', :with => 'Ativação do registro cadastral'
      expect(page).to have_field 'Tipo', :with => 'Regularização'
      expect(page).to have_field 'Suspenso até', :with => '05/04/2011'
      expect(page).to have_field 'Data da ocorrência', :with => '05/05/2011'
    end
  end

  scenario 'validating javascript to regularization or administrative sanction reason modal' do
    Creditor.make!(:nohup)
    RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    within_tab 'Sanções Administrativas / Regularizações' do
      click_button 'Adicionar Sanção Administrativa / Regularização'

      fill_modal 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada', :field => 'Descrição'

      expect(page).to have_field 'Tipo', :with => 'Sanção administrativa'
      expect(page).to have_field 'Motivo', :with => 'Advertência por desistência parcial da proposta devidamente justificada'

      fill_in 'Motivo', :with => ''

      expect(page).to have_field 'Tipo', :with => ''
    end
  end

  scenario 'shoud not update a person on creditor' do
    Creditor.make!(:mateus)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Mateus Lorandi'

    expect(page).to have_disabled_field 'creditor_creditable'

    click_button 'Salvar'

    expect(page).to have_content 'Mateus Lorandi'
  end

  scenario 'show only the tabs that are common to all personable of people when has not a people.' do
    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    within "#creditor-tabs" do
       expect(page).not_to have_link "Principal"
       expect(page).not_to have_link "CNAEs"
       expect(page).not_to have_link "Documentos"
       expect(page).to have_link "Materiais"
       expect(page).not_to have_link "Representantes"
       expect(page).to have_link "Contas Bancárias"
       expect(page).to have_link "Balanço"
       expect(page).to have_link "Sanções Administrativas / Regularizações"
    end
  end

  scenario 'should only show only tabs for individual people' do
    Person.make!(:sobrinho)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    choose 'Pessoa física ou jurídica'

    fill_modal 'creditor_creditable', :with => 'Gabriel Sobrinho'

    within "#creditor-tabs" do
       expect(page).to have_link "Principal"
       expect(page).not_to have_link "CNAEs"
       expect(page).not_to have_link "Documentos"
       expect(page).to have_link "Materiais"
       expect(page).not_to have_link "Representantes"
       expect(page).to have_link "Contas Bancárias"
       expect(page).to have_link "Balanço"
       expect(page).to have_link "Sanções Administrativas / Regularizações"
    end
  end

  scenario 'should only show only tabs for company people' do
    Person.make!(:nohup)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Criar Credor'

    choose 'Pessoa física ou jurídica'

    fill_modal 'creditor_creditable', :with => 'Nohup'

    within "#creditor-tabs" do
       expect(page).to have_link "Principal"
       expect(page).to have_link "CNAEs"
       expect(page).to have_link "Documentos"
       expect(page).to have_link "Materiais"
       expect(page).to have_link "Representantes"
       expect(page).to have_link "Contas Bancárias"
       expect(page).to have_link "Balanço"
       expect(page).to have_link "Sanções Administrativas / Regularizações"
    end
  end

  scenario 'destroy an existent creditor' do
    Creditor.make!(:nohup)
    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Credor apagado com sucesso.'

    expect(page).not_to have_content 'Nohup'
    expect(page).not_to have_content 'Microempresa'
  end

  scenario 'destroy a CRC for a creditor' do
    Creditor.make!(:nohup)

    navigate 'Compras e Licitações > Cadastros Gerais > Credores'

    click_link 'Nohup'

    click_link 'CRC'

    click_link '1/2012'

    expect(page).to have_content 'Editar Certificado de Registro Cadastral 1/2012 do Credor Nohup'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Certificado de Registro Cadastral apagado com sucesso.'

    expect(page).not_to have_link '2012'
    expect(page).not_to have_content '2012'
  end
end
