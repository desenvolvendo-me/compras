# encoding: utf-8
require 'spec_helper'

feature "Providers" do
  background do
    sign_in
  end

  scenario 'create a new provider' do
    Person.make!(:wenderson)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    click_link 'Criar Fornecedor'

    fill_modal 'Pessoa', :with => 'Wenderson Malheiros'

    click_button 'Criar Fornecedor'

    page.should have_notice 'Fornecedor criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'
  end

  scenario 'update an existent provider' do
    Provider.make!(:wenderson_sa)
    Person.make!(:sobrinho)

    click_link 'Contabilidade'

    click_link 'Fornecedores'

    within_records do
      page.find('a').click
    end

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho'

    click_button 'Atualizar Fornecedor'

    page.should have_notice 'Fornecedor editado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
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
end
