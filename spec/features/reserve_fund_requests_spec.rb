# encoding: utf-8
require 'spec_helper'

feature "ReserveFundRequests" do
  background do
    sign_in
  end

  scenario 'create a reserve fund request' do
    pending "Integration is hard"

    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Instrumentos Contratuais > Reserva de Dotações'

    click_link "Limpar Filtro"

    expect(page).to have_content 'Reserva de Dotação dos Processos de Compras'

    within_records do
      click_link 'Editar Reserva de dotação'
    end

    # TODO: assim que acabar os testes com VCR isso vai ter que ser testado
    # expect(page).to have_field 'Valor da reserva', with: '300,00'
  end
end
