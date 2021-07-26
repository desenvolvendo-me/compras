require 'spec_helper'

feature "ReserveFundRequests" do
  background do
    sign_in
  end

  scenario 'create a reserve fund request' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Contratos > Reserva de Dotações'

    pending 'Teste incompleto'

    expect(page).to have_title 'Reserva de Dotação dos Processos de Compras'
    expect(page).to have_link 'Filtrar Reserva de Dotação'

    


    within_records do
      click_link 'Criar Reserva de Dotação'
    end

    # TODO: assim que acabar os testes com VCR isso vai ter que ser testado
    # expect(page).to have_field 'Valor da reserva', with: '300,00'
  end
end
