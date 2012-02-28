# encoding: utf-8
require 'spec_helper'

feature "ServiceOrContractType" do
  background do
    sign_in
  end

  scenario 'create a new service' do
    click_link 'Solicitações'

    click_link 'Tipos de Serviço'

    click_link 'Criar Tipo de Serviço ou Contrato'

    fill_in 'Código do TCE', :with => '123'
    fill_in 'Descrição', :with => 'Contratação de estagiários'
    select 'Estagiário', :from => 'Finalidade'

    click_button 'Criar Tipo de Serviço ou Contrato'

    page.should have_notice 'Tipo de Serviço ou Contrato criado com sucesso.'

    click_link 'Contratação de estagiários'

    page.should have_field 'Código do TCE', :with => '123'
    page.should have_field 'Descrição', :with => 'Contratação de estagiários'
    page.should have_select 'Finalidade', :selected => 'Estagiário'
  end

  scenario 'validates uniqueness of description' do
    ServiceOrContractType.make!(:trainees)

    click_link 'Solicitações'

    click_link 'Tipos de Serviço'

    click_link 'Criar Tipo de Serviço ou Contrato'

    fill_in 'Descrição', :with => 'Contratação de estagiários'

    click_button 'Criar Tipo de Serviço ou Contrato'

    page.should_not have_notice 'Tipo de Serviço ou Contrato criado com sucesso.'

    page.should have_content 'já está em uso'
  end

  scenario 'update an existent service' do
    ServiceOrContractType.make!(:trainees)

    click_link 'Solicitações'

    click_link 'Tipos de Serviço'

    click_link 'Contratação de estagiários'

    fill_in 'Descrição', :with => 'Contratação de 10 estagiários'

    click_button 'Atualizar Tipo de Serviço ou Contrato'

    page.should have_notice 'Tipo de Serviço ou Contrato editado com sucesso.'

    click_link 'Contratação de 10 estagiários'

    page.should have_field 'Código do TCE', :with => '123'
    page.should have_field 'Descrição', :with => 'Contratação de 10 estagiários'
    page.should have_select 'Finalidade', :selected => 'Estagiário'
  end

  scenario 'destroy an existent service' do
    ServiceOrContractType.make!(:trainees)

    click_link 'Solicitações'

    click_link 'Tipos de Serviço'

    click_link 'Contratação de estagiários'

    click_link 'Apagar Contratação de estagiários', :confirm => true

    page.should have_notice 'Tipo de Serviço ou Contrato apagado com sucesso.'

    page.should_not have_content '123'
    page.should_not have_content 'Contratação de estagiários'
    page.should_not have_content 'Estagiário'
  end
end
