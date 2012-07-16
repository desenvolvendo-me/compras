# encoding: utf-8
require 'spec_helper'

feature "PledgeCancellations" do
  background do
    sign_in
  end

  scenario 'create a new pledge_cancellation' do
    pledge = Pledge.make!(:empenho_com_dois_vencimentos)

    navigate_through 'Contabilidade > Execução > Empenho > Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => pledge.id.to_s, :field => 'Id'

    fill_in 'Valor a ser anulado', :with => '150,00'
    fill_in 'Data *', :with => I18n.l(Date.current + 1.day)
    select 'Normal', :from => 'Natureza da ocorrência'
    fill_in 'Motivo', :with => 'Motivo para o anulamento'

    click_button 'Salvar'

    page.should have_notice 'Anulação de Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

    page.find('#pledge_value').should have_content 'R$ 200,00'
    page.find('#pledge_liquidations_sum').should have_content 'R$ 0,00'
    page.find('#pledge_cancellations_sum').should have_content 'R$ 150,00'
    page.find('#pledge_balance').should have_content 'R$ 50,00'

    page.should have_field 'Valor a ser anulado', :with => '150,00'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_select 'Natureza da ocorrência', :selected => 'Normal'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'when fill/clear pledge should fill/clear delegateds fields' do
    pledge = Pledge.make!(:empenho)

    navigate_through 'Contabilidade > Execução > Empenho > Anulações de Empenho'

    click_link 'Criar Anulação de Empenho'

    fill_modal 'Empenho', :with => pledge.id.to_s, :field => 'Id'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)

    page.find('#pledge_value').should have_content 'R$ 9,99'
    page.find('#pledge_liquidations_sum').should have_content 'R$ 0,00'
    page.find('#pledge_cancellations_sum').should have_content 'R$ 0,00'
    page.find('#pledge_balance').should have_content 'R$ 9,99'

    clear_modal 'Empenho'

    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => ''
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    pledge = Pledge.make!(:empenho)
    PledgeCancellation.make!(:empenho_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Anulações de Empenho'

    within_records do
      page.find('a').click
    end

    should_not have_button 'Criar Anulação de Empenho'

    page.should have_disabled_field 'Empenho'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor a ser anulado'
    page.should have_field 'Valor a ser anulado', :with => '1,00'
    page.should have_disabled_field 'Data *'
    page.should have_field 'Data *', :with => I18n.l(Date.current + 1.day)
    page.should have_disabled_field 'Natureza da ocorrência'
    page.should have_select 'Natureza da ocorrência', :selected => 'Normal'
    page.should have_disabled_field 'Motivo'
    page.should have_field 'Motivo', :with => 'Motivo para o anulamento'
  end

  scenario 'should not have a button to destroy an existent pledge' do
    PledgeCancellation.make!(:empenho_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Anulações de Empenho'

    within_records do
      page.find('a').click
    end

    page.should_not have_link "Apagar"
  end
end
