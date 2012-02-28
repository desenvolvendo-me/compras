# encoding: utf-8
require 'spec_helper'

feature "ReserveAllocationTypes" do
  background do
    sign_in
  end

  scenario 'create a new reserve_allocation_type' do
    click_link 'Contabilidade'

    click_link 'Tipos de Reserva de Dotação'

    click_link 'Criar Tipo de Reserva de Dotação'

    fill_in 'Descrição', :with => 'Reserva para Educação'
    select 'Ativo', :from => 'Status'

    click_button 'Criar Tipo de Reserva de Dotação'

    page.should have_notice 'Tipo de Reserva de Dotação criado com sucesso.'

    click_link 'Reserva para Educação'

    page.should have_field 'Descrição', :with => 'Reserva para Educação'
    page.should have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent reserve_allocation_type' do
    ReserveAllocationType.make!(:comum)

    click_link 'Contabilidade'

    click_link 'Tipos de Reserva de Dotação'

    click_link 'Comum'

    fill_in 'Descrição', :with => 'Descrição do Tipo'
    select 'Inativo', :from => 'Status'

    click_button 'Atualizar Tipo de Reserva de Dotação'

    page.should have_notice 'Tipo de Reserva de Dotação editado com sucesso.'

    click_link 'Descrição do Tipo'

    page.should have_field 'Descrição', :with => 'Descrição do Tipo'
    page.should have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent reserve_allocation_type' do
    ReserveAllocationType.make!(:comum)

    click_link 'Contabilidade'

    click_link 'Tipos de Reserva de Dotação'

    click_link 'Comum'

    click_link 'Apagar Comum', :confirm => true

    page.should have_notice 'Tipo de Reserva de Dotação apagado com sucesso.'

    page.should_not have_field 'Descrição', :with => 'Reserva para Educação'
    page.should_not have_select 'Status', :selected => 'Ativo'
  end

  scenario 'validate uniqueness of description' do
    ReserveAllocationType.make!(:comum)

    click_link 'Contabilidade'

    click_link 'Tipos de Reserva de Dotação'

    click_link 'Criar Tipo de Reserva de Dotação'

    fill_in 'Descrição', :with => 'Comum'

    click_button 'Criar Tipo de Reserva de Dotação'

    page.should have_content 'já está em uso'
  end
end
