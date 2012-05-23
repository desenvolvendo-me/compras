# encoding: utf-8
require 'spec_helper'

feature "People" do
  background do
    sign_in
  end

  scenario 'create a new person as individual' do
    State.make!(:mg)
    Street.make!(:amazonas)

    click_link 'Cadastros Diversos'

    click_link 'Pessoas'

    click_link 'Criar Pessoa'

    choose 'Pessoa Física'

    within_tab "Pessoa" do
      fill_in 'Nome', :with => 'Wenderson Malheiros'
      choose 'Masculino'
      fill_in 'Mãe', :with => 'Alaine Agnes'
      fill_in 'Pai', :with => "Wenderson Primeiro"
      fill_mask "CPF", :with => '003.215.785-11'
      fill_mask 'Data de nascimento', :with => '21/03/1973'
    end

    within_tab 'Identidade' do
      fill_in 'Número', :with => 'MG23912702'
      fill_in 'Orgão emissor', :with => 'SSP-MG'
      fill_mask 'Data de emissão', :with => '03/07/2004'
      fill_modal 'Estado', :with => 'Minas Gerais'
    end

    within_tab 'Contato' do
      fill_mask 'Telefone', :with => '(33) 3333-3333'
      fill_mask 'Celular', :with => '(33) 3333-3334'
      fill_mask 'Fax', :with => '(99) 9999-9999'
      fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    end

    within_tab 'Endereço' do
      fill_modal 'Logradouro', :with => 'Amazonas'
      fill_in "Complemento", :with => "Apartamento 12"
      fill_modal 'Bairro', :with => 'Portugal'
      fill_mask "CEP", :with => "31400-223"

      click_button 'Adicionar Endereço de Correspondência'

      within_fieldset 'Endereço de Correspondência' do
        fill_modal 'Logradouro', :with => 'Amazonas'
        fill_modal 'Bairro', :with => 'Portugal'
        fill_mask 'CEP', :with => '89009-187'
      end
    end

    click_button 'Salvar'

    page.should have_notice 'Pessoa criada com sucesso.'

    click_link 'Wenderson Malheiros'

    within_tab "Pessoa" do
      page.should have_field 'Nome', :with => 'Wenderson Malheiros'
      page.should have_checked_field 'Masculino'
      page.should have_field 'Mãe', :with => 'Alaine Agnes'
      page.should have_field 'Pai', :with => "Wenderson Primeiro"
      page.should have_field "CPF", :with => '003.215.785-11'
      page.should have_field 'Data de nascimento', :with => '21/03/1973'
    end

    within_tab 'Identidade' do
      page.should have_field 'Número', :with => 'MG23912702'
      page.should have_field 'Orgão emissor', :with => 'SSP-MG'
      page.should have_field 'Data de emissão', :with => '03/07/2004'
      page.should have_field 'Estado', :with => 'Minas Gerais'
    end

    within_tab 'Contato' do
      page.should have_field 'Telefone', :with => '(33) 3333-3333'
      page.should have_field 'Celular', :with => '(33) 3333-3334'
      page.should have_field 'Fax', :with => '(99) 9999-9999'
      page.should have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    end

    within_tab 'Endereço' do
      page.should have_field 'Logradouro', :with => 'Amazonas'
      page.should have_field "Complemento", :with => "Apartamento 12"
      page.should have_field 'Bairro', :with => 'Portugal'
      page.should have_field "CEP", :with => "31400-223"

      within_fieldset 'Endereço de Correspondência' do
        page.should have_field 'Logradouro', :with => 'Amazonas'
        page.should have_field 'Bairro', :with => 'Portugal'
        page.should have_field 'CEP', :with => '89009-187'
      end
    end
  end

  scenario 'update an existent person as individual' do
    Person.make!(:wenderson)

    click_link 'Cadastros Diversos'

    click_link 'Pessoa'

    click_link 'Wenderson'

    page.should_not have_field 'Pessoa Física'
    page.should_not have_field 'Pessoa Jurídica'

    within_tab "Pessoa" do
      fill_in 'Nome', :with => 'Gabriel Sobrinho'
    end

    within_tab 'Endereço' do
      fill_mask "CEP", :with => "41600-223"
      fill_in 'Complemento', :with => "Apto das alfalfas"
    end

    click_button 'Salvar'

    page.should have_notice 'Pessoa editada com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    within_tab "Pessoa" do
      page.should have_field 'Nome', :with => 'Gabriel Sobrinho'
    end

    within_tab 'Endereço' do
      page.should have_field "CEP", :with => "41600-223"
      page.should have_field 'Complemento', :with => "Apto das alfalfas"
    end
  end

  scenario 'destroy an existent person' do
    Person.make!(:wenderson)

    click_link 'Cadastros Diversos'

    click_link 'Pessoa'

    click_link 'Wenderson Malheiros'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Pessoa apagada com sucesso.'

    page.should_not have_content 'Wenderson Malheiros'
  end

  scenario "create a new person as company" do
    LegalNature.make!(:administracao_publica)
    CompanySize.make!(:micro_empresa)
    Street.make!(:bento_goncalves)
    Person.make!(:wenderson)
    Person.make!(:sobrinho)

    click_link 'Cadastros Diversos'

    click_link 'Pessoas'

    click_link 'Criar Pessoa'

    choose "Pessoa Jurídica"

    within_tab "Contribuinte" do
      fill_in 'Nome', :with => 'Nohup'
      fill_mask 'CNPJ', :with => '00.000.000/9983-03'
      fill_in 'Inscrição estadual', :with => '01237070'
      fill_in 'Número do registro na junta comercial', :with => '1234909034'
      fill_mask 'Data do registro na junta comercial', :with => '30/06/2011'
      fill_modal "Natureza jurídica", :with => 'Administração Pública'
      fill_modal "Pessoa responsável pela empresa", :with => "Wenderson"
      fill_in 'Função do responsável', :with => 'Administrador'
      fill_modal 'Porte da empresa', :with => 'Microempresa'
      check 'Optante pelo Simples'
    end

    within_tab 'Contato' do
      fill_mask 'Telefone', :with => '(11) 7070-6432'
      fill_mask 'Celular', :with => '(11) 9090-3334'
      fill_mask 'Fax', :with => '(99) 1111-2222'
      fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    end

    within_tab 'Endereço' do
      fill_modal 'Logradouro', :with => 'Bento Gonçalves'
      fill_in 'Complemento', :with => 'Setor 7, Sala 2'
      fill_modal 'Bairro', :with => 'Portugal'
      fill_mask "CEP", :with => "31600-223"

      click_button 'Adicionar Endereço de Correspondência'

      within_fieldset 'Endereço de Correspondência' do
        fill_modal 'Logradouro', :with => 'Bento Gonçalves'
        fill_in 'Complemento', :with => 'Setor 7, Sala 2'
        fill_modal 'Bairro', :with => 'Portugal'
        fill_mask "CEP", :with => "31600-223"
      end
    end

    within_tab 'Sócios' do
      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      fill_in 'Percentual de cotas societárias', :with => '100,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Pessoa criada com sucesso.'

    click_link 'Nohup'

    within_tab "Contribuinte" do
      page.should have_field 'Nome', :with => 'Nohup'
      page.should have_field 'CNPJ', :with => '00.000.000/9983-03'
      page.should have_field 'Inscrição estadual', :with => '01237070'
      page.should have_field 'Número do registro na junta comercial', :with => '1234909034'
      page.should have_field 'Data do registro na junta comercial', :with => '30/06/2011'
      page.should have_field "Natureza jurídica", :with => 'Administração Pública'
      page.should have_field "Pessoa responsável pela empresa", :with => "Wenderson Malheiros"
      page.should have_field 'Função do responsável', :with => 'Administrador'
      page.should have_field 'Porte da empresa', :with => 'Microempresa'
      page.should have_checked_field 'Optante pelo Simples'
    end

    within_tab 'Contato' do
      page.should have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
      page.should have_field 'Telefone', :with => '(11) 7070-6432'
      page.should have_field 'Celular', :with => '(11) 9090-3334'
      page.should have_field 'Fax', :with => '(99) 1111-2222'
    end

    within_tab 'Endereço' do
      page.should have_field 'Logradouro', :with => 'Bento Gonçalves'
      page.should have_field 'Complemento', :with => 'Setor 7, Sala 2'
      page.should have_field 'Bairro', :with => 'Portugal'
      page.should have_field "CEP", :with => "31600-223"

      within_fieldset 'Endereço de Correspondência' do
        page.should have_field 'Logradouro', :with => 'Bento Gonçalves'
        page.should have_field 'Complemento', :with => 'Setor 7, Sala 2'
        page.should have_field 'Bairro', :with => 'Portugal'
        page.should have_field "CEP", :with => "31600-223"
      end
    end

    within_tab 'Sócios'do
      page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
      page.should have_field 'Percentual de cotas societárias', :with => '100,00'
    end
  end

  scenario 'update an existent person as company' do
    Person.make!(:nohup)
    Person.make!(:sobrinho)

    click_link 'Cadastros Diversos'

    click_link 'Pessoas'

    click_link 'Nohup'

    page.should_not have_field 'Pessoa Física'
    page.should_not have_field 'Pessoa Jurídica'

    within_tab "Contribuinte" do
      fill_in 'Nome', :with => 'MoneyLabs'
    end

    within_tab 'Endereço' do
      fill_mask 'CEP', :with => '55554-333'
      fill_in 'Complemento', :with => "Apto das alfalfas, Depto. Sobrinho"
    end

    within_tab 'Sócios' do
      click_button 'Remover Sócio'

      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      fill_in 'Percentual de cotas societárias', :with => '100,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Pessoa editada com sucesso.'

    click_link 'MoneyLabs'

    within_tab "Contribuinte" do
      page.should have_field 'Nome', :with => 'MoneyLabs'
    end

    within_tab 'Endereço' do
      page.should have_field 'CEP', :with => '55554-333'
      page.should have_field 'Complemento', :with => "Apto das alfalfas, Depto. Sobrinho"
    end

    within_tab 'Sócios'do
      page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
      page.should have_field 'Percentual de cotas societárias', :with => '100,00'
    end
  end

  scenario 'neighborhoods must be filtered by the selected street' do
    Street.make!(:amazonas)
    Street.make!(:cristiano_machado)

    click_link 'Cadastros Diversos'

    click_link 'Pessoas'

    click_link 'Criar Pessoa'

    within_tab "Endereço" do
      fill_modal 'Logradouro', :with => 'Amazonas', :field => 'Nome do logradouro'

      fill_modal 'Bairro', :with => '' do
        click_button 'Pesquisar'

        page.should have_content 'Portugal'
        page.should_not have_content 'Centro'
      end

      fill_modal 'Logradouro', :with => 'Cristiano Machado', :field => 'Nome do logradouro'

      fill_modal 'Bairro', :with => '' do
        click_button 'Pesquisar'

        page.should have_content 'Centro'
        page.should_not have_content 'Portugal'
      end
    end
  end

  scenario 'create a new person as special_entry' do
    State.make!(:mg)
    Street.make!(:amazonas)

    click_link 'Cadastros Diversos'

    click_link 'Pessoas'

    click_link 'Criar Pessoa'

    choose 'Inscrição Especial'

    within_tab "Inscrição especial" do
      fill_in 'Nome', :with => 'Wenderson Malheiros'
    end

    within_tab 'Contato' do
      fill_mask 'Telefone', :with => '(33) 3333-3333'
      fill_mask 'Celular', :with => '(33) 3333-3334'
      fill_mask 'Fax', :with => '(99) 9999-9999'
      fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    end

    within_tab 'Endereço' do
      fill_modal 'Logradouro', :with => 'Amazonas'
      fill_in "Complemento", :with => "Apartamento 12"
      fill_modal 'Bairro', :with => 'Portugal'
      fill_mask "CEP", :with => "31400-223"

      click_button 'Adicionar Endereço de Correspondência'

      within_fieldset 'Endereço de Correspondência' do
        fill_modal 'Logradouro', :with => 'Amazonas'
        fill_modal 'Bairro', :with => 'Portugal'
        fill_mask 'CEP', :with => '89009-187'
      end
    end

    click_button 'Salvar'

    page.should have_notice 'Pessoa criada com sucesso.'

    click_link 'Wenderson Malheiros'

    within_tab "Inscrição especial" do
      page.should have_field 'Nome', :with => 'Wenderson Malheiros'
    end

    within_tab 'Contato' do
      page.should have_field 'Telefone', :with => '(33) 3333-3333'
      page.should have_field 'Celular', :with => '(33) 3333-3334'
      page.should have_field 'Fax', :with => '(99) 9999-9999'
      page.should have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    end

    within_tab 'Endereço' do
      page.should have_field 'Logradouro', :with => 'Amazonas'
      page.should have_field "Complemento", :with => "Apartamento 12"
      page.should have_field 'Bairro', :with => 'Portugal'
      page.should have_field "CEP", :with => "31400-223"

      within_fieldset 'Endereço de Correspondência' do
        page.should have_field 'Logradouro', :with => 'Amazonas'
        page.should have_field 'Bairro', :with => 'Portugal'
        page.should have_field 'CEP', :with => '89009-187'
      end
    end
  end

  scenario 'update an existent person as special_entry' do
    Person.make!(:mateus)

    click_link 'Cadastros Diversos'

    click_link 'Pessoa'

    click_link 'Mateus Lorandi'

    page.should_not have_field 'Pessoa Física'
    page.should_not have_field 'Pessoa Jurídica'
    page.should_not have_field 'Inscrição Especial'

    within_tab "Inscrição especial" do
      fill_in 'Nome', :with => 'Gabriel Sobrinho'
    end

    within_tab 'Endereço' do
      fill_mask "CEP", :with => "41600-223"
      fill_in 'Complemento', :with => "Apto das alfalfas"
    end

    click_button 'Salvar'

    page.should have_notice 'Pessoa editada com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    within_tab "Inscrição especial" do
      page.should have_field 'Nome', :with => 'Gabriel Sobrinho'
    end

    within_tab 'Endereço' do
      page.should have_field "CEP", :with => "41600-223"
      page.should have_field 'Complemento', :with => "Apto das alfalfas"
    end
  end

  scenario 'destroy an existent special_entry' do
    Person.make!(:mateus)

    click_link 'Cadastros Diversos'

    click_link 'Pessoa'

    click_link 'Mateus Lorandi'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Pessoa apagada com sucesso.'

    page.should_not have_content 'Mateus Lorandi'
  end

  scenario 'should have the uniqueness validation to partner on new form' do
    Person.make!(:sobrinho)

    click_link 'Cadastros Diversos'

    click_link 'Pessoa'

    click_link 'Criar Pessoa'

    choose "Pessoa Jurídica"

    within_tab 'Sócios' do
      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      fill_in 'Percentual de cotas societárias', :with => '20,00'

      click_button 'Adicionar Sócio'

      within 'div.partner:first' do
        fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
        fill_in 'Percentual de cotas societárias', :with => '80,00'
      end
    end

    click_button 'Salvar'

    within_tab 'Sócios' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'should have the uniqueness validation to partner' do
    Person.make!(:nohup)

    click_link 'Cadastros'

    click_link 'Pessoa'

    click_link 'Nohup'

    within_tab 'Sócios' do
      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
      fill_in 'Percentual de cotas societárias', :with => '100,00'
    end

    click_button 'Salvar'

    within_tab 'Sócios' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'should validate at least one partner' do
    Person.make!(:wenderson)

    click_link 'Cadastros'

    click_link 'Pessoa'

    click_link 'Criar Pessoa'

    choose "Pessoa Jurídica"

    click_button 'Salvar'

    within_tab 'Sócios' do
      page.should have_content 'deve haver ao menos um sócio.'

      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
      fill_in 'Percentual de cotas societárias', :with => '100,00'
    end

    click_button 'Salvar'

    within_tab 'Sócios' do
      page.should_not have_content 'deve haver ao menos um sócio.'
    end
  end
end
