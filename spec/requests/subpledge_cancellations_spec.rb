# encoding: utf-8
require 'spec_helper'

feature "SubpledgeCancellations" do
  background do
    sign_in
  end

  scenario 'create a new subpledge_cancellation' do
    Entity.make!(:detran)
    pledge = Pledge.make!(:empenho)
    subpledge = Subpledge.make!(:empenho_2012)
    subpledge_expiration = SubpledgeExpiration.make!(:vencimento)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    click_link 'Criar Anulação de Subempenho'
    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Exercício', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_modal 'Subempenho', :with => '1', :field => 'Número do processo'
    fill_modal 'Parcela', :with => '1', :field => 'Número'
    fill_in 'Valor *', :with => '1,00'
    fill_in 'Data *', :with => I18n.l(Date.current)
    fill_in 'Motivo', :with => 'Falta de documentação'

    click_button 'Salvar'

    page.should have_notice 'Anulação de Subempenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Fornecedor'
    page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_field 'Subempenho', :with => subpledge.to_s
    page.should have_disabled_field 'Saldo do subempenho'
    page.should have_field 'Saldo do subempenho', :with => '0,00'
    page.should have_field 'Parcela', :with => subpledge_expiration.to_s
    page.should have_disabled_field 'Saldo da parcela'
    page.should have_field 'Saldo da parcela', :with => '0,00'
    page.should have_field 'Valor *', :with => '1,00'
    page.should have_field 'Data *', :with => I18n.l(Date.current)
    page.should have_field 'Motivo', :with => 'Falta de documentação'
  end

  scenario 'when fill/clear pledge should fill/clear related fields' do
    pledge = Pledge.make!(:empenho)
    subpledge = Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    click_link 'Criar Anulação de Subempenho'

    page.should have_disabled_field 'Fornecedor'
    page.should have_disabled_field 'Data de emissão'
    page.should have_disabled_field 'Valor do empenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_modal 'Subempenho', :with => '1', :field => 'Número do processo'

    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_field 'Valor do empenho', :with => '9,99'

    clear_modal 'Empenho'

    page.should have_field 'Empenho', :with => ''
    page.should have_field 'Fornecedor', :with => ''
    page.should have_field 'Data de emissão', :with => ''
    page.should have_field 'Valor do empenho', :with => ''
    page.should have_field 'Subempenho', :with => ''
  end

  scenario 'when select pledge first should filter subpledge by pledge' do
    pledge = Pledge.make!(:empenho)
    Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    click_link 'Criar Anulação de Subempenho'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'

    fill_modal 'Subempenho', :with => '1', :field => 'Número do processo' do
      page.should have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => "#{pledge.id}"
    end

    clear_modal 'Empenho'

    fill_modal 'Subempenho', :with => '1', :field => 'Número do processo' do
      page.should_not have_disabled_field 'filter_pledge'
      page.should have_field 'filter_pledge', :with => ''
    end
  end

  scenario 'should filter only pledge with subpledge' do
    Pledge.make!(:empenho_saldo_maior_mil)
    Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    click_link 'Criar Anulação de Subempenho'

    within_modal 'Empenho' do
      click_button 'Pesquisar'

      page.should have_content '2012'
      page.should_not have_content '2011'
    end
  end

  scenario 'when fill subpledge should fill related fields' do
    pledge = Pledge.make!(:empenho)
    subpledge = Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    click_link 'Criar Anulação de Subempenho'

    page.should have_disabled_field 'Fornecedor'
    page.should have_disabled_field 'Data de emissão'
    page.should have_disabled_field 'Valor do empenho'

    fill_modal 'Subempenho', :with => '1', :field => 'Número do processo'

    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_field 'Subempenho', :with => subpledge.to_s
    page.should have_field 'Saldo do subempenho', :with => '1,00'
    page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_field 'Valor do empenho', :with => '9,99'
  end

  scenario 'when fill subpledge should enable subpledge_expiration' do
    Pledge.make!(:empenho)
    subpledge = Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    click_link 'Criar Anulação de Subempenho'

    page.should have_disabled_field 'Parcela'

    fill_modal 'Subempenho', :with => '1', :field => 'Número do processo'

    page.should_not have_disabled_field 'Parcela'

    fill_modal 'Parcela', :with => '1', :field => 'Número' do
      page.should have_disabled_field 'filter_subpledge'
      page.should have_field 'filter_subpledge', :with => subpledge.to_s
    end

    clear_modal 'Subempenho'

    page.should have_disabled_field 'Parcela'
  end

  scenario 'when fill subpledge_expiration fill related fields' do
    Pledge.make!(:empenho)
    subpledge = Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    click_link 'Criar Anulação de Subempenho'

    fill_modal 'Subempenho', :with => '1', :field => 'Número do processo'
    fill_modal 'Parcela', :with => '1', :field => 'Número'

    page.should have_disabled_field 'Saldo da parcela'
    page.should have_field 'Saldo da parcela', :with => '1,00'
    page.should have_field 'Valor *', :with => '1,00'
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    pledge = Pledge.make!(:empenho)
    subpledge = Subpledge.make!(:empenho_2012)
    pledge_expiration = PledgeParcel.make!(:vencimento)
    subpledge_cancellation = SubpledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    click_link subpledge_cancellation.to_s

    should_not have_button 'Salvar'

    page.should have_disabled_field 'Entidade'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_disabled_field 'Exercício'
    page.should have_field 'Exercício', :with => '2012'
    page.should have_disabled_field 'Empenho'
    page.should have_field 'Empenho', :with => pledge.to_s
    page.should have_disabled_field 'Fornecedor'
    page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_disabled_field 'Subempenho'
    page.should have_field 'Subempenho', :with => subpledge.to_s
    page.should have_disabled_field 'Saldo do subempenho'
    page.should have_field 'Saldo do subempenho', :with => '0,00'
    page.should have_disabled_field 'Parcela'
    page.should have_field 'Parcela', :with => pledge_expiration.to_s
    page.should have_disabled_field 'Saldo da parcela'
    page.should have_field 'Saldo da parcela', :with => '0,00'
    page.should have_disabled_field 'Valor'
    page.should have_field 'Valor *', :with => '1,00'
    page.should have_disabled_field 'Data'
    page.should have_field 'Data *', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Motivo'
    page.should have_field 'Motivo', :with => 'Falta de documentação'
  end

  scenario 'should not have a button to destroy an existent subpledge cancellation' do
    subpledge_cancellation = SubpledgeCancellation.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Anulações de Subempenho'

    within_records do
      page.find('a').click
    end

    page.should_not have_link 'Apagar'
  end
end
