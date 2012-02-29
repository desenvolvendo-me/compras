# encoding: utf-8
require 'spec_helper'

feature "Providers" do
  background do
    sign_in
  end

  scenario 'create a new provider' do
    Person.make!(:wenderson)
    Property.make!(:propriedade_1)
    Agency.make!(:itau)
    LegalNature.make!(:administracao_publica)
    Cnae.make!(:aluguel)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Cadastro econômico', :with => '123', :field => 'Inscrição imobiliária'
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

    click_button 'Criar Fornecedor'

    page.should have_notice 'Fornecedor criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'
    page.should have_field 'Cadastro econômico', :with => '123'
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

  scenario 'update an existent provider' do
    Provider.make!(:wenderson_sa)
    Person.make!(:sobrinho)
    Property.make!(:propriedade_2)
    Agency.make!(:santander)
    LegalNature.make!(:executivo_federal)
    Cnae.make!(:varejo)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    within_records do
      page.find('a').click
    end

    fill_modal 'Cadastro econômico', :with => '456', :field => 'Inscrição imobiliária'
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

    click_button 'Atualizar Fornecedor'

    page.should have_notice 'Fornecedor editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Cadastro econômico', :with => '456'
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

  scenario 'destroy an existent provider' do
    Provider.make!(:wenderson_sa)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Fornecedor apagado com sucesso.'

    page.should_not have_content 'Wenderson Malheiros'
  end

  scenario 'show modal info of person' do
    Person.make!(:wenderson)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Pessoa', :with => 'Wenderson Malheiros'

    click_link 'provider_person_info_link'

    within '#record' do
      page.should have_content 'Wenderson Malheiros'
      page.should have_content '003.149.513-34'
      page.should have_content '(33) 3333-3333'
      page.should have_content '(33) 3333-3334'
      page.should have_content '(99) 9999-9999'
      page.should have_content 'wenderson.malheiros@gmail.com'
    end
  end

  scenario 'should fill person as property owner when select property' do
    Property.make!(:propriedade_1)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Cadastro econômico', :with => '123', :field => 'Inscrição imobiliária'

    page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'
  end
end
