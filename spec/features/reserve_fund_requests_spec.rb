# encoding: utf-8
require 'spec_helper'

feature "ReserveFundRequests" do
  background do
    sign_in
  end

  scenario 'create a reserve fund request' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Instrumentos Contratuais > Reserva de Dotações'

    expect(page).to have_title 'Reserva de Dotação dos Processos de Compras'
    expect(page).to have_link 'Filtrar Reserva de Dotação'
    expect(page).to have_link 'Criar Reserva de Dotação'

    click_link "Limpar Filtro"

    within_records do
      click_link 'Editar Reserva de Dotação'
    end

    # TODO: assim que acabar os testes com VCR isso vai ter que ser testado
    # expect(page).to have_field 'Valor da reserva', with: '300,00'
    pending 'Teste incompleto'
  end
end
