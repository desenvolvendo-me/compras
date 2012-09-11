# encoding: utf-8
require 'spec_helper'

feature "ReserveAllocationTypes" do
  background do
    sign_in
  end

  scenario 'create a new reserve_allocation_type' do
    navigate 'Contabilidade > Execução > Reserva de Dotação > Tipos de Reserva de Dotação'

    click_link 'Criar Tipo de Reserva de Dotação'

    fill_in 'Descrição', :with => 'Reserva para Educação'
    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Reserva de Dotação criado com sucesso.'

    click_link 'Reserva para Educação'

    expect(page).to have_field 'Descrição', :with => 'Reserva para Educação'
    expect(page).to have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent reserve_allocation_type' do
    ReserveAllocationType.make!(:comum)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Tipos de Reserva de Dotação'

    click_link 'Tipo Comum'

    fill_in 'Descrição', :with => 'Descrição do Tipo'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo de Reserva de Dotação editado com sucesso.'

    click_link 'Descrição do Tipo'

    expect(page).to have_field 'Descrição', :with => 'Descrição do Tipo'
    expect(page).to have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent reserve_allocation_type' do
    ReserveAllocationType.make!(:comum)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Tipos de Reserva de Dotação'

    click_link 'Tipo Comum'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo de Reserva de Dotação apagado com sucesso.'

    expect(page).to_not have_field 'Descrição', :with => 'Reserva para Educação'
    expect(page).to_not have_select 'Status', :selected => 'Ativo'
  end

  scenario 'validate uniqueness of description' do
    ReserveAllocationType.make!(:comum)

    navigate 'Contabilidade > Execução > Reserva de Dotação > Tipos de Reserva de Dotação'

    click_link 'Criar Tipo de Reserva de Dotação'

    fill_in 'Descrição', :with => 'Tipo Comum'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end
end
