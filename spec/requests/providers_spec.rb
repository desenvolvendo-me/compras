# encoding: utf-8
require 'spec_helper'

feature "Providers" do
  background do
    sign_in
  end

  scenario 'create a new provider' do
    Person.make!(:wenderson)
    Person.make!(:sobrinho)
    EconomicRegistration.make!(:nohup)
    Agency.make!(:itau)
    LegalNature.make!(:administracao_publica)
    Cnae.make!(:aluguel)
    MaterialsGroup.make!(:alimenticios)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    within_tab 'Principal'do
      fill_modal 'Cadastro econômico', :with => '00001', :field => 'Inscrição'
      fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
      fill_in 'Data do cadastramento', :with => '15/02/2012'
      fill_modal 'Banco', :with => 'Itaú'
      fill_modal 'Agência', :with => 'Agência Itaú'
      fill_in 'C/C', :with => '123456'
      fill_in 'Número', :with => '456789'
      fill_in 'Data da inscrição', :with => '26/02/2012'
      fill_in 'Data de validade', :with => '27/02/2012'
      fill_in 'Data da renovação', :with => '28/02/2012'
      fill_modal 'Natureza jurídica', :with => 'Administração Pública'
      fill_modal 'CNAE', :with => 'Aluguel de outras máquinas', :field => 'Descrição'
    end

    within_tab 'Grupos/Classes/Materiais fornecidos' do
      fill_modal 'Grupo de materiais', :with => 'Generos alimenticios', :field => 'Descrição'
    end

    click_button 'Criar Fornecedor'

    page.should have_notice 'Fornecedor criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal'do
      page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'
      page.should have_field 'Cadastro econômico', :with => '00001'
      page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'
      page.should have_field 'Data do cadastramento', :with => '15/02/2012'
      page.should have_field 'Banco', :with => 'Itaú'
      page.should have_field 'Agência', :with => 'Agência Itaú'
      page.should have_field 'C/C', :with => '123456'
      page.should have_field 'Número', :with => '456789'
      page.should have_field 'Data da inscrição', :with => '26/02/2012'
      page.should have_field 'Data de validade', :with => '27/02/2012'
      page.should have_field 'Data da renovação', :with => '28/02/2012'
      page.should have_field 'Natureza jurídica', :with => 'Administração Pública'
      page.should have_field 'CNAE', :with => 'Aluguel de outras máquinas'
    end

    within_tab 'Grupos/Classes/Materiais fornecidos' do
      page.should have_content 'Generos alimenticios'
    end
  end

  scenario 'update an existent provider' do
    Provider.make!(:wenderson_sa)
    Person.make!(:sobrinho)
    Property.make!(:propriedade_2)
    Agency.make!(:santander)
    LegalNature.make!(:executivo_federal)
    Cnae.make!(:varejo)
    EconomicRegistration.make!(:nobe)
    MaterialsGroup.make!(:limpeza)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal'do
      fill_modal 'Cadastro econômico', :with => '00002', :field => 'Inscrição'
      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      fill_in 'Data do cadastramento', :with => '15/02/2013'
      fill_modal 'Banco', :with => 'Santander'
      fill_modal 'Agência', :with => 'Agência Santander'
      fill_in 'C/C', :with => '456789'
      fill_in 'Número', :with => '147258'
      fill_in 'Data da inscrição', :with => '26/02/2013'
      fill_in 'Data de validade', :with => '27/02/2013'
      fill_in 'Data da renovação', :with => '28/02/2013'
      fill_modal 'Natureza jurídica', :with => 'Orgão Público do Poder Executivo Federal'
      fill_modal 'CNAE', :with => 'Comércio varejista de mercadorias em geral', :field => 'Descrição'
    end

    within_tab 'Grupos/Classes/Materiais fornecidos' do
      fill_modal 'Grupo de materiais', :with => 'Limpeza', :field => 'Descrição'
    end

    click_button 'Atualizar Fornecedor'

    page.should have_notice 'Fornecedor editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal'do
      page.should have_field 'Cadastro econômico', :with => '00002'
      page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
      page.should have_field 'Data do cadastramento', :with => '15/02/2013'
      page.should have_field 'Banco', :with => 'Santander'
      page.should have_field 'Agência', :with => 'Agência Santander'
      page.should have_field 'C/C', :with => '456789'
      page.should have_field 'Número', :with => '147258'
      page.should have_field 'Data da inscrição', :with => '26/02/2013'
      page.should have_field 'Data de validade', :with => '27/02/2013'
      page.should have_field 'Data da renovação', :with => '28/02/2013'
      page.should have_field 'Natureza jurídica', :with => 'Orgão Público do Poder Executivo Federal'
      page.should have_field 'CNAE', :with => 'Comércio varejista de mercadorias em geral'
    end

    within_tab 'Grupos/Classes/Materiais fornecidos' do
      page.should have_content 'Limpeza'
    end
  end

  scenario 'create a new provider with Company person and partners' do
    Person.make!(:sobrinho)
    EconomicRegistration.make!(:nohup_office)
    Agency.make!(:itau)
    LegalNature.make!(:administracao_publica)
    Cnae.make!(:aluguel)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    within_tab 'Principal'do
      fill_modal 'Cadastro econômico', :with => '00001', :field => 'Inscrição'
      fill_modal 'Pessoa', :with => 'Nohup'
      fill_in 'Data do cadastramento', :with => '15/02/2012'
      fill_modal 'Banco', :with => 'Itaú'
      fill_modal 'Agência', :with => 'Agência Itaú'
      fill_in 'C/C', :with => '123456'
      fill_in 'Número', :with => '456789'
      fill_in 'Data da inscrição', :with => '26/02/2012'
      fill_in 'Data de validade', :with => '27/02/2012'
      fill_in 'Data da renovação', :with => '28/02/2012'
      fill_modal 'Natureza jurídica', :with => 'Administração Pública'
      fill_modal 'CNAE', :with => 'Aluguel de outras máquinas', :field => 'Descrição'
    end

    within_tab 'Sócios/Responsáveis pela empresa' do
      click_button 'Adicionar'

      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      select 'Membro do quadro societário', :from => 'Função'
      fill_in 'Data', :with => '25/02/2012'
    end

    click_button 'Criar Fornecedor'

    page.should have_notice 'Fornecedor criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal'do
      page.should have_field 'Cadastro econômico', :with => '00001'
      page.should have_field 'Pessoa', :with => 'Nohup'
      page.should have_field 'Data do cadastramento', :with => '15/02/2012'
      page.should have_field 'Banco', :with => 'Itaú'
      page.should have_field 'Agência', :with => 'Agência Itaú'
      page.should have_field 'C/C', :with => '123456'
      page.should have_field 'Número', :with => '456789'
      page.should have_field 'Data da inscrição', :with => '26/02/2012'
      page.should have_field 'Data de validade', :with => '27/02/2012'
      page.should have_field 'Data da renovação', :with => '28/02/2012'
      page.should have_field 'Natureza jurídica', :with => 'Administração Pública'
      page.should have_field 'CNAE', :with => 'Aluguel de outras máquinas'
    end

    within_tab 'Sócios/Responsáveis pela empresa' do
      page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
      page.should have_select 'Função', :selected => 'Membro do quadro societário'
      page.should have_field 'Data', :with => '25/02/2012'
    end
  end

  scenario 'destroy an existent provider' do
    Provider.make!(:wenderson_sa)
    Person.make!(:sobrinho)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    within_records do
      page.find('a').click
    end

    click_link "Apagar", :confirm => true

    page.should have_notice 'Fornecedor apagado com sucesso.'

    page.should_not have_content 'Wenderson Malheiros'
  end

  scenario 'show modal info of person - Individual' do
    Person.make!(:wenderson)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Pessoa', :with => 'Wenderson Malheiros'

    click_link 'provider_person_info_link'

    within '#record' do
      page.should have_content 'Wenderson Malheiros'
      page.should have_content '(33) 3333-3333'
      page.should have_content '(33) 3333-3334'
      page.should have_content '(99) 9999-9999'
      page.should have_content '003.149.513-34'
      page.should have_content 'wenderson.malheiros@gmail.com'
      page.should have_content 'Girassol, 9874 - São Francisco'
      page.should have_content '003.149.513-34'
      page.should have_content 'Masculino'
      page.should have_content 'Alaine Agnes'
      page.should have_content '21/03/1973'
      page.should have_content 'MG23912702'
    end
  end

  scenario 'show modal info of person - Company' do
    Person.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Pessoa', :with => 'Nohup'

    click_link 'provider_person_info_link'

    within '#record' do
      page.should have_content 'Nohup'
      page.should have_content '(11) 7070-9999'
      page.should have_content '(11) 7070-8888'
      page.should have_content '(33) 7070-7777'
      page.should have_content 'wenderson@gmail.com'
      page.should have_content 'Girassol, 9874 - São Francisco'
      page.should have_content '00.000.000/9999-62'
      page.should have_content 'SP'
      page.should have_content '099901'
      page.should have_content '29/06/2011'
      page.should have_content 'Administrador'
      page.should have_content 'Não'
      page.should have_content 'Administração Pública'
      page.should have_content 'Wenderson Malheiros'
      page.should have_content 'Microempresa'
    end
  end

  scenario 'should fill person as economic registration person when select' do
    EconomicRegistration.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Cadastro econômico', :with => '00001', :field => 'Inscrição'

    page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'
  end

  scenario 'should clear economic_registration when change person' do
    EconomicRegistration.make!(:nohup)
    Person.make!(:sobrinho)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Cadastro econômico', :with => '00001', :field => 'Inscrição'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

    page.should have_field 'Cadastro econômico', :with => ''
  end

  scenario 'should not clear economic_registration when person is equal' do
    EconomicRegistration.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Cadastro econômico', :with => '00001', :field => 'Inscrição'

    fill_modal 'Pessoa', :with => 'Wenderson Malheiros'

    page.should have_field 'Cadastro econômico', :with => '00001'
  end

  scenario 'ensure the error when duplicated partners is de only error' do
    Person.make!(:nohup)
    Person.make!(:sobrinho)
    EconomicRegistration.make!(:nohup_office)
    Agency.make!(:itau)
    LegalNature.make!(:administracao_publica)
    Cnae.make!(:aluguel)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    within_tab 'Principal'do
      fill_modal 'Cadastro econômico', :with => '00001', :field => 'Inscrição'
      fill_modal 'Pessoa', :with => 'Nohup'
      fill_in 'Data do cadastramento', :with => '15/02/2012'
      fill_modal 'Banco', :with => 'Itaú'
      fill_modal 'Agência', :with => 'Agência Itaú'
      fill_in 'C/C', :with => '123456'
      fill_in 'Número', :with => '456789'
      fill_in 'Data da inscrição', :with => '26/02/2012'
      fill_in 'Data de validade', :with => '27/02/2012'
      fill_in 'Data da renovação', :with => '28/02/2012'
      fill_modal 'Natureza jurídica', :with => 'Administração Pública'
      fill_modal 'CNAE', :with => 'Aluguel de outras máquinas', :field => 'Descrição'
    end

    within_tab 'Sócios/Responsáveis pela empresa' do
      click_button 'Adicionar'

      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      select 'Membro do quadro societário', :from => 'Função'
      fill_in 'Data', :with => '25/02/2012'

      click_button 'Adicionar'

      within '.provider-partner:last' do
        fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
        select 'Membro do quadro societário', :from => 'Função'
        fill_in 'Data', :with => '25/02/2012'
      end
    end

    click_button 'Criar Fornecedor'

    within_tab 'Sócios/Responsáveis pela empresa' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'toggle partners inclusion depending on type of person selected (individual/company)' do
    Person.make!(:wenderson)
    Person.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    within_tab 'Principal'do
      fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
    end

    within_tab 'Sócios/Responsáveis pela empresa' do
      page.should have_content 'Foi selecionada uma pessoa física na aba "Principal". Não é necessário cadastrar sócios.'
    end

    within_tab 'Principal'do
      fill_modal 'Pessoa', :with => 'Nohup'
    end

    within_tab 'Sócios/Responsáveis pela empresa' do
      page.should_not have_content 'Foi selecionada uma pessoa física na aba "Principal". Não é necessário cadastrar sócios.'
    end
  end

  scenario 'remove materials group from an existent provider' do
    Provider.make!(:wenderson_sa)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    within_records do
      page.find('a').click
    end

    within_tab 'Grupos/Classes/Materiais fornecidos' do
      page.should have_content 'Generos alimenticios'
      click_button 'Remover grupo'
    end

    click_button 'Atualizar Fornecedor'

    page.should have_notice 'Fornecedor editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Grupos/Classes/Materiais fornecidos' do
      page.should_not have_content 'Generos alimenticios'
    end
  end
end
