# encoding: utf-8
require 'spec_helper'

feature 'PurchaseProcessCreditorProposals' do
  let(:current_user) { User.make!(:sobrinho_as_admin_and_employee) }

  background do
    Prefecture.make!(:belo_horizonte)
    sign_in
  end

  scenario 'create and update creditor proposals' do
    LicitationProcess.make!(:pregao_presencial,
      bidders: [Bidder.make!(:licitante_sobrinho), Bidder.make!(:licitante)])

    navigate 'Processos de Compra > Processos de Compras'

    click_link "Limpar Filtro"

    within_records do
      click_link '1/2012'
    end

    click_link 'Propostas'

    expect(page).to have_content 'Proposta Comercial Processo 1/2012 - Pregão 1'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Cadastrar Propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar Propostas'
      end

      within 'tbody tr:first' do
        click_link 'Cadastrar Propostas'
      end
    end

    expect(page).to have_content 'Criar Proposta Comercial'
    expect(page).to have_content 'Fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'

    expect(page).to have_disabled_field 'Valor total da proposta', with: '0,00'
    expect(page).to have_disabled_field 'Lote', with: '2050'
    expect(page).to have_disabled_field 'Item', with: '1'
    expect(page).to have_disabled_field 'Material', with: '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Unidade', with: 'UN'
    expect(page).to have_disabled_field 'Quantidade', with: '2'
    expect(page).to have_disabled_field 'Preço total', with: '0,00'

    fill_in 'Preço unitário', with: '50,20'

    expect(page).to have_disabled_field 'Valor total da proposta', with: '100,40'
    expect(page).to have_disabled_field 'Preço total', with: '100,40'

    click_button 'Salvar'

    expect(page).to have_field 'Marca', with: ''
    expect(page).to have_content 'não pode ficar em branco'

    fill_in 'Marca', with: 'Tabajara'
    fill_in 'Prazo de entrega', with: '10/05/2013'

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial criada com sucesso'

    within_records do
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Propostas'

      within 'tbody tr:first' do
        expect(page).to have_content 'Gabriel Sobrinho'
        expect(page).to have_content 'gabriel.sobrinho@gmail.com'
        expect(page).to have_content 'Editar Propostas'
      end

      within 'tbody tr:last' do
        expect(page).to have_content 'Wenderson Malheiros'
        expect(page).to have_content 'wenderson.malheiros@gmail.com'
        expect(page).to have_content 'Cadastrar Propostas'
      end

      within 'tbody tr:first' do
        click_link 'Editar Propostas'
      end
    end

    expect(page).to have_content 'Editar Proposta Comercial'
    expect(page).to have_content 'Fornecedor Gabriel Sobrinho - Processo 1/2012 - Pregão 1'


    expect(page).to have_disabled_field 'Valor total da proposta', with: '100,40'
    expect(page).to have_disabled_field 'Lote', with: '2050'
    expect(page).to have_disabled_field 'Item', with: '1'
    expect(page).to have_disabled_field 'Material', with: '01.01.00001 - Antivirus'
    expect(page).to have_disabled_field 'Unidade', with: 'UN'
    expect(page).to have_disabled_field 'Quantidade', with: '2'
    expect(page).to have_disabled_field 'Preço total', with: '100,40'
    expect(page).to have_disabled_field 'Valor total da proposta', with: '100,40'

    expect(page).to have_field 'Marca', with: 'Tabajara'
    expect(page).to have_field 'Prazo de entrega', with: '10/05/2013'
    expect(page).to have_field 'Preço unitário', with: '50,20'

    fill_in 'Marca', with: 'Acme'

    click_button 'Salvar'

    expect(page).to have_content 'Proposta Comercial editada com sucesso'
  end
end
