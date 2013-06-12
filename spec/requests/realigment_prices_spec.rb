# encoding: utf-8
require 'spec_helper'

feature "RealigmentPrices" do
  background do
    sign_in
  end

  scenario 'create a new realigment_price' do
    make_dependencies!

    navigate 'Processos de Compra > Processos de Compras'

    click_link 'Limpar Filtro'
    click_link '1/2012'

    click_link 'Realinhamento de preço'

    click_link 'Realinhamento de preço'

    expect(page).to have_disabled_field "Valor total da proposta"
    expect(page).to have_field "Valor total da proposta", with: "100,00"

    within '.antivirus' do
      expect(page).to have_disabled_field 'Quantidade', with: '2'

      fill_in 'Marca', with: 'Avira'
      fill_in 'Valor', with: '25,00'
    end

    within '.arame-comum' do
      expect(page).to have_disabled_field 'Quantidade', with: '1'

      fill_in 'Marca', with: 'Farpado'
      fill_in 'Valor', with: '50,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial editado com sucesso.'

    click_link 'Realinhamento de preço'

    within '.antivirus' do
      expect(page).to have_disabled_field 'Quantidade', with: '2'
      expect(page).to have_field 'Marca', with: 'Avira'
      expect(page).to have_field 'Valor', with: '25,00'
    end

    within '.arame-comum' do
      expect(page).to have_disabled_field 'Quantidade', with: '1'

      expect(page).to have_field 'Marca', with: 'Farpado'
      expect(page).to have_field 'Valor', with: '50,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial editado com sucesso.'
  end

  def make_dependencies!
    creditor_nohup = Creditor.make!(:nohup)
    creditor_ibm = Creditor.make!(:ibm)
    purchase_process = LicitationProcess.make!(:valor_maximo_ultrapassado,
      publications: [LicitationProcessPublication.make!(:publicacao)],
      bidders: [Bidder.make!(:licitante_com_proposta_3, creditor: creditor_nohup,
                              licitation_process: purchase_process, enabled: true),
                Bidder.make!(:licitante_com_proposta_7, creditor: creditor_ibm,
                              licitation_process: purchase_process, enabled: true)])
    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup, creditor: creditor_nohup,
      disqualified: false, licitation_process: purchase_process, ranking: 1)
    PurchaseProcessCreditorProposal.make!(:proposta_global_ibm, creditor: creditor_ibm,
      disqualified: true, licitation_process: purchase_process, ranking: 1)

  end
end
