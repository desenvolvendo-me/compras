# encoding: utf-8
require 'spec_helper'

feature "ServiceType" do
  background do
    sign_in
  end

  scenario 'create a new service' do
    click_link 'Cadastros Diversos'

    click_link 'Tipos de Serviço'

    click_link 'Criar Tipo de Serviço'

    fill_in 'Código TCE', :with => '123'
    fill_in 'Descrição', :with => 'Contratação de estagiários'
    select 'Estagiário', :from => 'Finalidade'

    click_button 'Criar Tipo de Serviço'

    page.should have_notice 'Tipo de Serviço criado com sucesso.'

    click_link 'Contratação de estagiários'

    page.should have_field 'Código TCE', :with => '123'
    page.should have_field 'Descrição', :with => 'Contratação de estagiários'
    page.should have_select 'Finalidade', :with => 'Estagiário'
  end

  scenario 'update an existent service' do
    ServiceType.make!(:trainees)

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Serviço'

    click_link 'Contratação de estagiários'

    fill_in 'Descrição', :with => 'Contratação de 10 estagiários'

    click_button 'Atualizar Tipo de Serviço'

    page.should have_notice 'Tipo de Serviço editado com sucesso.'

    click_link 'Contratação de 10 estagiários'

    page.should have_field 'Código TCE', :with => '123'
    page.should have_field 'Descrição', :with => 'Contratação de 10 estagiários'
    page.should have_select 'Finalidade', :with => 'Estagiário'
  end

  scenario 'destroy an existent service' do
    ServiceType.make!(:trainees)

    click_link 'Cadastros Diversos'

    click_link 'Tipos de Serviço'

    click_link 'Contratação de estagiários'

    click_link 'Apagar Contratação de estagiários', :confirm => true

    page.should have_notice 'Serviço apagado com sucesso.'

    page.should_not have_content '123'
    page.should_not have_content 'Contratação de estagiários'
    page.should_not have_content 'Estagiário'
  end
end
