# encoding: utf-8
require 'spec_helper'

feature "MovimentTypes" do
  background do
    sign_in
  end

  scenario "create a new moviment type" do
    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Tipos de Movimentos'

    click_link 'Criar Tipo de Movimento'

    fill_in 'Nome', :with => 'Adicionar pagamento'
    select 'Adicionar', :from => 'Operação'
    select 'Dotação', :from => 'Atributo'
    select 'Manual', :from => 'Fonte'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Movimento criado com sucesso.'

    within_records do
      click_link 'Adicionar pagamento'
    end

    expect(page).to have_field 'Nome', :with => 'Adicionar pagamento'
    expect(page).to have_select 'Operação', :selected => 'Adicionar'
    expect(page).to have_select 'Atributo', :selected => 'Dotação'
    expect(page).to have_select 'Fonte', :selected => 'Manual'
  end

  scenario "edit an exiting moviment type" do
    MovimentType.make!(:adicionar_dotacao)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Tipos de Movimentos'

    within_records do
      click_link 'Adicionar dotação'
    end

    fill_in 'Nome', :with => 'Subtração recurso'
    select 'Subtrair', :from => 'Operação'
    select 'Recurso', :from => 'Atributo'
    select 'Default', :from => 'Fonte'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Movimento editado com sucesso.'

    within_records do
      click_link 'Subtração recurso'
    end

    expect(page).to have_field 'Nome', :with => 'Subtração recurso'
    expect(page).to have_select 'Operação', :selected => 'Subtrair'
    expect(page).to have_select 'Atributo', :selected => 'Recurso'
    expect(page).to have_select 'Fonte', :selected => 'Default'
  end

  scenario "destroy an exiting moviment type" do
    MovimentType.make!(:adicionar_dotacao)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Tipos de Movimentos'

    within_records do
      click_link 'Adicionar dotação'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Movimento apagado com sucesso.'

    within_records do
      expect(page).not_to have_link 'Adicionar dotação'
    end
  end
end
