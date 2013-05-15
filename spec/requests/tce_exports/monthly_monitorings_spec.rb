#encoding: utf-8
require 'spec_helper'
require 'sidekiq/testing'

feature "Monthly Monitoring TCE File" do
  let(:current_user) { User.make!(:sobrinho) }

  background do
    Sidekiq::Queue.any_instance.stub(find_job: double.as_null_object)
    create_roles [:tce_export_monthly_monitorings]
    sign_in
  end

  scenario "generating the monthly monitoring file" do
    Prefecture.make!(:belo_horizonte, address: Address.make!(:general))

    navigate "Prestação de Contas > SICOM - Acompanhamento Mensal"

    click_link "Gerar Acompanhamento Mensal"

    select "Janeiro", on: "Mês da prestação de contas"

    expect(page).to have_field "Ano da prestação de contas", with: "#{Date.current.year}"
    expect(page).to have_disabled_field "Código de controle externo da remessa"
    expect(page).to have_content "Arquivos a serem gerados"
    expect(page).to have_content "REGLIC - Decreto Municipal Regulamentador do Pregão / Registro de Preços"
    expect(page).to have_content "RESPLIC - Responsáveis pela Licitação"
    expect(page).to have_content "REGADESAO - Adesão a Registro de Preços"
    expect(page).to have_content "PARELIC - Parecer da Licitação"

    fill_in "Ano da prestação de contas", with: "2013"

    click_button "Gerar arquivo"

    expect(page).to have_notice "Arquivo encaminhado para geração"
    expect(page).to have_content "Acompanhamento Mensal"
    expect(page).to have_disabled_field "Mês da prestação de contas"
    expect(page).to have_select 'Mês da prestação de contas', selected: "Janeiro"
    expect(page).to have_disabled_field "Ano da prestação de contas", with: "2013"
    expect(page).to have_field "Código de controle externo da remessa", with: "20130000000000000001"
    expect(page).to have_disabled_field "Situação"
    expect(page).to have_field "Situação", with: "Em processamento"
    expect(page).not_to have_button "Gerar arquivo"

    click_button "Cancelar"

    expect(page).to have_notice "Geração do arquivo cancelada"
    expect(page).to have_field "Situação", with: "Cancelado"
    expect(page).not_to have_button "Cancelar"
  end
end
