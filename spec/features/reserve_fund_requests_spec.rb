# encoding: utf-8
require 'spec_helper'

feature "ReserveFundRequests" do
  background do
    sign_in
  end

  scenario 'create a reserve fund request' do
    pending "Integration is hard"

    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Processos de Compra > Reserva de Dotações'

    click_link "Limpar Filtro"

    expect(page).to have_content 'Reserva de Dotação dos Processos de Compras'

    within_records do
      click_link 'Editar Reserva de dotação'
    end
  end
end
