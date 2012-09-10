# encoding: utf-8
require 'spec_helper'

feature "People" do
  background do
    sign_in
  end

  scenario 'create a new person as individual' do
    State.make!(:mg)
    Street.make!(:amazonas)

    navigate 'Outros > Pessoas'

    click_link 'Criar Pessoa'

    choose 'Pessoa Física'

    within_tab "Pessoa" do
      fill_in 'Nome', :with => 'Wenderson Malheiros'
      choose 'Masculino'
      fill_in 'Mãe', :with => 'Alaine Agnes'
      fill_in 'Pai', :with => "Wenderson Primeiro"
      fill_in "CPF", :with => '003.215.785-11'
      fill_in 'Data de nascimento', :with => '21/03/1973'
    end

    within_tab 'Identidade' do
      fill_in 'Número', :with => 'MG23912702'
      fill_in 'Orgão emissor', :with => 'SSP-MG'
      fill_in 'Data de emissão', :with => '03/07/2004'
      fill_modal 'Estado', :with => 'Minas Gerais'
    end

    within_tab 'Contato' do
      fill_in 'Telefone', :with => '(33) 3333-3333'
      fill_in 'Celular', :with => '(33) 3333-3334'
      fill_in 'Fax', :with => '(99) 9999-9999'
      fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    end

    within_tab 'Endereço' do
      fill_modal 'Logradouro', :with => 'Amazonas'
      fill_in "Complemento", :with => "Apartamento 12"
      fill_modal 'Bairro', :with => 'Portugal'
      fill_in "CEP", :with => "31400-223"

      click_button 'Adicionar Endereço de Correspondência'

      within_fieldset 'Endereço de Correspondência' do
        fill_modal 'Logradouro', :with => 'Amazonas'
        fill_modal 'Bairro', :with => 'Portugal'
        fill_in 'CEP', :with => '89009-187'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Pessoa criada com sucesso.'

    click_link 'Wenderson Malheiros'

    within_tab "Pessoa" do
      expect(page).to have_field 'Nome', :with => 'Wenderson Malheiros'
      expect(page).to have_checked_field 'Masculino'
      expect(page).to have_field 'Mãe', :with => 'Alaine Agnes'
      expect(page).to have_field 'Pai', :with => "Wenderson Primeiro"
      expect(page).to have_field "CPF", :with => '003.215.785-11'
      expect(page).to have_field 'Data de nascimento', :with => '21/03/1973'
    end

    within_tab 'Identidade' do
      expect(page).to have_field 'Número', :with => 'MG23912702'
      expect(page).to have_field 'Orgão emissor', :with => 'SSP-MG'
      expect(page).to have_field 'Data de emissão', :with => '03/07/2004'
      expect(page).to have_field 'Estado', :with => 'Minas Gerais'
    end

    within_tab 'Contato' do
      expect(page).to have_field 'Telefone', :with => '(33) 3333-3333'
      expect(page).to have_field 'Celular', :with => '(33) 3333-3334'
      expect(page).to have_field 'Fax', :with => '(99) 9999-9999'
      expect(page).to have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    end

    within_tab 'Endereço' do
      expect(page).to have_field 'Logradouro', :with => 'Avenida Amazonas'
      expect(page).to have_field "Complemento", :with => "Apartamento 12"
      expect(page).to have_field 'Bairro', :with => 'Portugal'
      expect(page).to have_field "CEP", :with => "31400-223"

      within_fieldset 'Endereço de Correspondência' do
        expect(page).to have_field 'Logradouro', :with => 'Avenida Amazonas'
        expect(page).to have_field 'Bairro', :with => 'Portugal'
        expect(page).to have_field 'CEP', :with => '89009-187'
      end
    end
  end

  scenario 'update an existent person as individual' do
    Person.make!(:wenderson)

    navigate 'Outros > Pessoas'

    click_link 'Wenderson'

    expect(page).not_to have_field 'Pessoa Física'
    expect(page).not_to have_field 'Pessoa Jurídica'

    within_tab "Pessoa" do
      fill_in 'Nome', :with => 'Gabriel Sobrinho'
    end

    within_tab 'Endereço' do
      fill_in "CEP", :with => "41600-223"
      fill_in 'Complemento', :with => "Apto das alfalfas"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Pessoa editada com sucesso.'

    within_records do
      click_link 'Gabriel Sobrinho'
    end

    within_tab "Pessoa" do
      expect(page).to have_field 'Nome', :with => 'Gabriel Sobrinho'
    end

    within_tab 'Endereço' do
      expect(page).to have_field "CEP", :with => "41600-223"
      expect(page).to have_field 'Complemento', :with => "Apto das alfalfas"
    end
  end

  scenario 'destroy an existent person' do
    Person.make!(:wenderson)

    navigate 'Outros > Pessoas'

    click_link 'Wenderson Malheiros'

    click_link 'Apagar'

    expect(page).to have_notice 'Pessoa apagada com sucesso.'

    expect(page).not_to have_content 'Wenderson Malheiros'
  end

  scenario "create a new person as company" do
    LegalNature.make!(:administracao_publica)
    CompanySize.make!(:micro_empresa)
    Street.make!(:bento_goncalves)
    Person.make!(:wenderson)
    Person.make!(:sobrinho)

    navigate 'Outros > Pessoas'

    click_link 'Criar Pessoa'

    choose "Pessoa Jurídica"

    within_tab "Contribuinte" do
      fill_in 'Nome', :with => 'Nohup'
      fill_in 'CNPJ', :with => '00.000.000/9983-03'
      fill_in 'Inscrição estadual', :with => '01237070'
      fill_in 'Número do registro na junta comercial', :with => '1234909034'
      fill_in 'Data do registro na junta comercial', :with => '30/06/2011'
      fill_modal "Natureza jurídica", :with => 'Administração Pública'
      fill_modal "Pessoa responsável pela empresa", :with => "Wenderson"
      fill_in 'Função do responsável', :with => 'Administrador'
      fill_modal 'Porte da empresa', :with => 'Microempresa'
      check 'Optante pelo Simples'
    end

    within_tab 'Contato' do
      fill_in 'Telefone', :with => '(11) 7070-6432'
      fill_in 'Celular', :with => '(11) 9090-3334'
      fill_in 'Fax', :with => '(99) 1111-2222'
      fill_in 'E-mail', :with => 'wenderson.malheiros@gmail.com'
    end

    within_tab 'Endereço' do
      fill_modal 'Logradouro', :with => 'Bento Gonçalves'
      fill_in 'Complemento', :with => 'Setor 7, Sala 2'
      fill_modal 'Bairro', :with => 'Portugal'
      fill_in "CEP", :with => "31600-223"

      click_button 'Adicionar Endereço de Correspondência'

      within_fieldset 'Endereço de Correspondência' do
        fill_modal 'Logradouro', :with => 'Bento Gonçalves'
        fill_in 'Complemento', :with => 'Setor 7, Sala 2'
        fill_modal 'Bairro', :with => 'Portugal'
        fill_in "CEP", :with => "31600-223"
      end
    end

    within_tab 'Sócios' do
      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      fill_in 'Percentual de cotas societárias', :with => '100,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Pessoa criada com sucesso.'

    click_link 'Nohup'

    within_tab "Contribuinte" do
      expect(page).to have_field 'Nome', :with => 'Nohup'
      expect(page).to have_field 'CNPJ', :with => '00.000.000/9983-03'
      expect(page).to have_field 'Inscrição estadual', :with => '01237070'
      expect(page).to have_field 'Número do registro na junta comercial', :with => '1234909034'
      expect(page).to have_field 'Data do registro na junta comercial', :with => '30/06/2011'
      expect(page).to have_field "Natureza jurídica", :with => 'Administração Pública'
      expect(page).to have_field "Pessoa responsável pela empresa", :with => "Wenderson Malheiros"
      expect(page).to have_field 'Função do responsável', :with => 'Administrador'
      expect(page).to have_field 'Porte da empresa', :with => 'Microempresa'
      expect(page).to have_checked_field 'Optante pelo Simples'
    end

    within_tab 'Contato' do
      expect(page).to have_field 'E-mail', :with => 'wenderson.malheiros@gmail.com'
      expect(page).to have_field 'Telefone', :with => '(11) 7070-6432'
      expect(page).to have_field 'Celular', :with => '(11) 9090-3334'
      expect(page).to have_field 'Fax', :with => '(99) 1111-2222'
    end

    within_tab 'Endereço' do
      expect(page).to have_field 'Logradouro', :with => 'Rua Bento Gonçalves'
      expect(page).to have_field 'Complemento', :with => 'Setor 7, Sala 2'
      expect(page).to have_field 'Bairro', :with => 'Portugal'
      expect(page).to have_field "CEP", :with => "31600-223"

      within_fieldset 'Endereço de Correspondência' do
        expect(page).to have_field 'Logradouro', :with => 'Rua Bento Gonçalves'
        expect(page).to have_field 'Complemento', :with => 'Setor 7, Sala 2'
        expect(page).to have_field 'Bairro', :with => 'Portugal'
        expect(page).to have_field "CEP", :with => "31600-223"
      end
    end

    within_tab 'Sócios'do
      expect(page).to have_field 'Pessoa', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Percentual de cotas societárias', :with => '100,00'
    end
  end

  scenario 'update an existent person as company' do
    Person.make!(:nohup)
    Person.make!(:sobrinho)

    navigate 'Outros > Pessoas'

    click_link 'Nohup'

    expect(page).not_to have_field 'Pessoa Física'
    expect(page).not_to have_field 'Pessoa Jurídica'

    within_tab "Contribuinte" do
      fill_in 'Nome', :with => 'MoneyLabs'
    end

    within_tab 'Endereço' do
      fill_in 'CEP', :with => '55554-333'
      fill_in 'Complemento', :with => "Apto das alfalfas, Depto. Sobrinho"
    end

    within_tab 'Sócios' do
      click_button 'Remover Sócio'

      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'
      fill_in 'Percentual de cotas societárias', :with => '100,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Pessoa editada com sucesso.'

    click_link 'MoneyLabs'

    within_tab "Contribuinte" do
      expect(page).to have_field 'Nome', :with => 'MoneyLabs'
    end

    within_tab 'Endereço' do
      expect(page).to have_field 'CEP', :with => '55554-333'
      expect(page).to have_field 'Complemento', :with => "Apto das alfalfas, Depto. Sobrinho"
    end

    within_tab 'Sócios'do
      expect(page).to have_field 'Pessoa', :with => 'Gabriel Sobrinho'
      expect(page).to have_field 'Percentual de cotas societárias', :with => '100,00'
    end
  end

  scenario 'neighborhoods must be filtered by the selected street' do
    Street.make!(:amazonas)
    Street.make!(:cristiano_machado)

    navigate 'Outros > Pessoas'

    click_link 'Criar Pessoa'

    within_tab "Endereço" do
      fill_modal 'Logradouro', :with => 'Amazonas', :field => 'Nome do logradouro'

      fill_modal 'Bairro', :with => '' do
        click_button 'Pesquisar'

        expect(page).to have_content 'Portugal'
        expect(page).not_to have_content 'Centro'
      end

      fill_modal 'Logradouro', :with => 'Cristiano Machado', :field => 'Nome do logradouro'

      fill_modal 'Bairro', :with => '' do
        click_button 'Pesquisar'

        expect(page).to have_content 'Centro'
        expect(page).not_to have_content 'Portugal'
      end
    end
  end

  scenario 'should have the uniqueness validation to partner on new form' do
    Person.make!(:sobrinho)

    navigate 'Outros > Pessoas'

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
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'should have the uniqueness validation to partner' do
    Person.make!(:nohup)

    navigate 'Outros > Pessoas'

    click_link 'Nohup'

    within_tab 'Sócios' do
      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
      fill_in 'Percentual de cotas societárias', :with => '100,00'
    end

    click_button 'Salvar'

    within_tab 'Sócios' do
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'should validate at least one partner' do
    Person.make!(:wenderson)

    navigate 'Outros > Pessoas'

    click_link 'Criar Pessoa'

    choose "Pessoa Jurídica"

    click_button 'Salvar'

    within_tab 'Sócios' do
      expect(page).to have_content 'deve haver ao menos um sócio'

      click_button 'Adicionar Sócio'

      fill_modal 'Pessoa', :with => 'Wenderson Malheiros'
      fill_in 'Percentual de cotas societárias', :with => '100,00'
    end

    click_button 'Salvar'

    within_tab 'Sócios' do
      expect(page).not_to have_content 'deve haver ao menos um sócio'
    end
  end
end
