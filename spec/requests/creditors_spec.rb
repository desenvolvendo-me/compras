# encoding: utf-8
require 'spec_helper'

feature "Creditors" do
  background do
    sign_in
  end

  scenario 'create a new creditor when people is special entry' do
    Person.make!(:mateus)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Mateus', :field => 'Nome'

    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Mateus Lorandi'

    page.should have_field 'Pessoa', :with => 'Mateus Lorandi'
  end

  scenario 'create a new creditor when people is a company' do
    Person.make!(:nohup)
    Cnae.make!(:varejo)
    Cnae.make!(:aluguel)
    Cnae.make!(:direito_social)
    CompanySize.make!(:micro_empresa)
    DocumentType.make!(:fiscal)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Nohup', :field => 'Nome'

    within_tab 'Principal' do
      fill_modal 'Porte da empressa', :with => 'Microempresa', :field => 'Nome'
      check 'Optante pelo simples'

      fill_modal 'CNAE principal', :with => '4712100', :field => 'Código'
    end

    within_tab 'Cnaes secundários' do
      fill_modal 'Cnaes', :with => '94308', :field => 'Código'
      fill_modal 'Cnaes', :with => '7739099', :field => 'Código'
    end

    within_tab 'Documentos' do
      click_button 'Adicionar Documento'

      fill_modal 'Tipo de documento', :with => 'Fiscal', :field => 'Descrição'
      fill_in 'Número', :with => '1234'
      fill_mask 'Data de emissão', :with => '05/04/2012'
      fill_mask 'Data de validade', :with => '05/04/2013'
      fill_in 'Órgão emissor', :with => 'SSP'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Nohup'

    page.should have_field 'Pessoa', :with => 'Nohup'

    within_tab 'Principal' do
      page.should have_field 'Porte da empressa', :with => 'Microempresa'
      page.should have_checked_field 'Optante pelo simples'
      page.should have_field 'CNAE principal', :with => 'Comércio varejista de mercadorias em geral'
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
  end

  scenario 'create a new creditor when people is individual' do
    Person.make!(:sobrinho)
    OccupationClassification.make!(:armed_forces)

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
  end

  scenario 'update a creditor when people is special entry' do
    Creditor.make!(:mateus)
    Person.make!(:sobrinho, :personable => SpecialEntry.make!(:especial))

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Mateus Lorandi'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho', :field => 'Nome'

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Gabriel Sobrinho'

    page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
  end

  scenario 'update a creditor when people is a company' do
    Creditor.make!(:nohup)
    Cnae.make!(:aluguel)
    Cnae.make!(:direito_social)
    CompanySize.make!(:empresa_de_grande_porte)
    DocumentType.make!(:oficial)
    Person.make!(:wenderson)

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

      fill_modal 'Cnaes', :with => '94308', :field => 'Código'
    end

    within_tab 'Documentos' do
      click_button 'Remover Documento'

      click_button 'Adicionar Documento'

      fill_modal 'Tipo de documento', :with => 'Oficial', :field => 'Descrição'
      fill_in 'Número', :with => '12345'
      fill_mask 'Data de emissão', :with => '05/05/2012'
      fill_mask 'Data de validade', :with => '05/05/2013'
      fill_in 'Órgão emissor', :with => 'PM'
    end

    within_tab 'Representantes' do
      page.should have_content 'Gabriel Sobrinho'
      page.should have_content '003.151.987-37'
      click_button 'Remover'

      fill_modal 'Representantes', :with => 'Wenderson Malheiros', :field => 'Nome'
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
  end

  scenario 'update a creditor when people is individual' do
    Creditor.make!(:sobrinho)
    Person.make!(:wenderson)
    OccupationClassification.make!(:engineer)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Gabriel Sobrinho'

    fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'

    within_tab 'Principal' do
      fill_modal 'CBO', :with => 'Engenheiro', :field => 'Nome'
      check 'Autônomo'
      fill_in 'PIS/PASEP', :with => '6789'
      fill_mask 'Início do contrato', :with => '05/04/2011'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Wenderson Malheiros'

    page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'

    within_tab 'Principal' do
      page.should have_field 'CBO', :with => '214 - Engenheiro'
      page.should have_unchecked_field 'Admnistração pública municipal'
      page.should have_checked_field 'Autônomo'
      page.should have_field 'PIS/PASEP', :with => '6789'
      page.should have_field 'Início do contrato', :with => '05/04/2011'
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
end
