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

    select "Janeiro", from: "Mês da prestação de contas"

    expect(page).to have_checked_field 'Marcar todos'

    expect(page).to have_field "Ano da prestação de contas", with: "#{Date.current.year}"
    expect(page).to have_field "Código de controle externo da remessa", disabled: true
    expect(page).to have_content "Arquivos a serem gerados"
    expect(page).to have_content "ABERLIC - Abertura da Licitação"
    expect(page).to have_content "CONTRATOS - Contratos"
    expect(page).to have_content "DISPENSA - Dispensa ou Inexigibilidade"
    expect(page).to have_content "HABLIC - Habilitação da Licitação"
    expect(page).to have_content "HOMOLIC - Homologação da Licitação"
    expect(page).to have_content "JULGLIC - Julgamento da Licitação"
    expect(page).to have_content "PARELIC - Parecer da Licitação"
    expect(page).to have_content "REGADESAO - Adesão a Registro de Preços"
    expect(page).to have_content "REGLIC - Decreto Municipal Regulamentador do Pregão / Registro de Preços"
    expect(page).to have_content "RESPLIC - Responsáveis pela Licitação"

    uncheck 'Marcar todos'

    expect(page).to_not have_checked_field "ABERLIC - Abertura da Licitação"
    expect(page).to_not have_checked_field "CONTRATOS - Contratos"
    expect(page).to_not have_checked_field "DISPENSA - Dispensa ou Inexigibilidade"
    expect(page).to_not have_checked_field "HABLIC - Habilitação da Licitação"
    expect(page).to_not have_checked_field "HOMOLIC - Homologação da Licitação"
    expect(page).to_not have_checked_field "JULGLIC - Julgamento da Licitação"
    expect(page).to_not have_checked_field "PARELIC - Parecer da Licitação"
    expect(page).to_not have_checked_field "REGADESAO - Adesão a Registro de Preços"
    expect(page).to_not have_checked_field "REGLIC - Decreto Municipal Regulamentador do Pregão / Registro de Preços"
    expect(page).to_not have_checked_field "RESPLIC - Responsáveis pela Licitação"

    check 'Marcar todos'

    expect(page).to have_checked_field "ABERLIC - Abertura da Licitação"
    expect(page).to have_checked_field "CONTRATOS - Contratos"
    expect(page).to have_checked_field "DISPENSA - Dispensa ou Inexigibilidade"
    expect(page).to have_checked_field "HABLIC - Habilitação da Licitação"
    expect(page).to have_checked_field "HOMOLIC - Homologação da Licitação"
    expect(page).to have_checked_field "JULGLIC - Julgamento da Licitação"
    expect(page).to have_checked_field "PARELIC - Parecer da Licitação"
    expect(page).to have_checked_field "REGADESAO - Adesão a Registro de Preços"
    expect(page).to have_checked_field "REGLIC - Decreto Municipal Regulamentador do Pregão / Registro de Preços"
    expect(page).to have_checked_field "RESPLIC - Responsáveis pela Licitação"

    fill_in "Ano da prestação de contas", with: "2013"

    click_button "Gerar arquivo"

    expect(page).to_not have_field "Marcar todos", visible: true

    expect(page).to have_field "ABERLIC - Abertura da Licitação", checked: true, disabled: true
    expect(page).to have_field "CONTRATOS - Contratos", checked: true, disabled: true
    expect(page).to have_field "DISPENSA - Dispensa ou Inexigibilidade", checked: true, disabled: true
    expect(page).to have_field "HABLIC - Habilitação da Licitação", checked: true, disabled: true
    expect(page).to have_field "HOMOLIC - Homologação da Licitação", checked: true, disabled: true
    expect(page).to have_field "JULGLIC - Julgamento da Licitação", checked: true, disabled: true
    expect(page).to have_field "PARELIC - Parecer da Licitação", checked: true, disabled: true
    expect(page).to have_field "REGADESAO - Adesão a Registro de Preços", checked: true, disabled: true
    expect(page).to have_field "REGLIC - Decreto Municipal Regulamentador do Pregão / Registro de Preços", checked: true, disabled: true
    expect(page).to have_field "RESPLIC - Responsáveis pela Licitação", checked: true, disabled: true

    expect(page).to have_notice "Arquivo encaminhado para geração"
    expect(page).to have_content "Acompanhamento Mensal"
    expect(page).to have_select 'Mês da prestação de contas', selected: "Janeiro", disabled: true
    expect(page).to have_field "Ano da prestação de contas", with: "2013", disabled: true
    expect(page).to have_field "Código de controle externo da remessa", with: "20130000000000000001", disabled: true
    expect(page).to have_field "Situação", with: "Em processamento", disabled: true
    expect(page).not_to have_button "Gerar arquivo"

    click_link "Cancelar"

    expect(page).to have_notice "Geração do arquivo cancelada"
    expect(page).to have_field "Situação", with: "Cancelado", disabled: true
    expect(page).not_to have_link "Cancelar"
  end
end
