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

    click_button 'Criar Pessoa'

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

    click_button 'Atualizar Pessoa'

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

    click_link 'Apagar Wenderson Malheiros', :confirm => true

    page.should have_notice 'Pessoa apagada com sucesso.'

    page.should_not have_content 'Wenderson Malheiros'
  end
end
