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
      fill_in 'Marca', :with => 'Avira'
      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor', :with => '10,00'
    end

    within '.arame-comum' do
      fill_in 'Marca', :with => 'Farpado'
      fill_in 'Quantidade', :with => '5'
      fill_in 'Valor', :with => '10,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial editado com sucesso.'

    click_link 'Realinhamento de preço'

    within '.antivirus' do
      expect(page).to have_field 'Marca', :with => 'Avira'
      expect(page).to have_field 'Quantidade', :with => '5'
      expect(page).to have_field 'Valor', :with => '10,00'
    end

    within '.arame-comum' do
      expect(page).to have_field 'Marca', :with => 'Farpado'
      expect(page).to have_field 'Quantidade', :with => '5'
      expect(page).to have_field 'Valor', :with => '10,00'
    end

    within '.antivirus' do
      fill_in 'Marca', :with => 'Avira free'
      fill_in 'Quantidade', :with => '50'
      fill_in 'Valor', :with => '10,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Proposta Comercial editado com sucesso.'

    click_link 'Realinhamento de preço'

    within '.antivirus' do
      expect(page).to have_field 'Marca', :with => 'Avira free'
      expect(page).to have_field 'Quantidade', :with => '50'
      expect(page).to have_field 'Valor', :with => '10,00'
    end

  end

  def make_dependencies!
    purchase_process = LicitationProcess.make!(:valor_maximo_ultrapassado)
    PurchaseProcessCreditorProposal.make!(:proposta_global_nohup)
    PurchaseProcessCreditorProposal.make!(:proposta_global_ibm)
  end
end
