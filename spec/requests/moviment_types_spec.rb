# encoding: utf-8
require 'spec_helper'

feature "MovimentTypes" do
  background do
    sign_in
  end

  scenario "create a new moviment type" do
    navigate_through 'Outros > Tipos de Movimentos'

    click_link 'Criar Tipo de Movimento'

    fill_in 'Nome', :with => 'Adicionar pagamento'
    select 'Soma', :from => 'Operação'
    select 'Dotação', :from => 'Atributo'
    select 'Manual', :from => 'Fonte'

    click_button 'Salvar'

    page.should have_notice 'Tipo de Movimento criado com sucesso.'

    within_records do
      click_link 'Adicionar pagamento'
    end

    page.should have_field 'Nome', :with => 'Adicionar pagamento'
    page.should have_select 'Operação', :selected => 'Soma'
    page.should have_select 'Atributo', :selected => 'Dotação'
    page.should have_select 'Fonte', :selected => 'Manual'
  end

  scenario "edit an exiting moviment type" do
    MovimentType.make!(:adicionar_dotacao)

    navigate_through 'Outros > Tipos de Movimentos'

    within_records do
      click_link 'Adicionar dotação'
    end

    fill_in 'Nome', :with => 'Subtrair recurso'
    select 'Subtração', :from => 'Operação'
    select 'Recurso', :from => 'Atributo'
    select 'Default', :from => 'Fonte'

    click_button 'Salvar'

    page.should have_notice 'Tipo de Movimento editado com sucesso.'

    within_records do
      click_link 'Subtrair recurso'
    end

    page.should have_field 'Nome', :with => 'Subtrair recurso'
    page.should have_select 'Operação', :selected => 'Subtração'
    page.should have_select 'Atributo', :selected => 'Recurso'
    page.should have_select 'Fonte', :selected => 'Default'
  end

  scenario "destroy an exiting moviment type" do
    MovimentType.make!(:adicionar_dotacao)

    navigate_through 'Outros > Tipos de Movimentos'

    within_records do
      click_link 'Adicionar dotação'
    end

    click_link 'Apagar'

    page.should have_notice 'Tipo de Movimento apagado com sucesso.'

    within_records do
      page.should_not have_link 'Adicionar dotação'
    end
  end
end
