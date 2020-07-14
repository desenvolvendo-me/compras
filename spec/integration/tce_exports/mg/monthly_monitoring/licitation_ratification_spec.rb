require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::LicitationRatificationGenerator, vcr: { cassette_name: 'integration/licitation_ratification' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    UnicoAPI::Consumer.set_customer customer
  end

  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/HOMOLIC.csv')
    end

    after do
      FileUtils.rm_f('tmp/HOMOLIC.csv')
    end

    let :prefecture do
      Prefecture.make!(:belo_horizonte,
        address: Address.make!(:general))
    end

    let(:monthly_monitoring) do
      FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        year: Date.today.year,
        month: Date.today.month,
        city_code: "51234")
    end

    let(:licitation_process) do
      LicitationProcess.make!(:pregao_presencial)
    end

    let(:direct_purchase) do
      LicitationProcess.make!(:compra_direta)
    end

    let(:creditor_proposal_arame_farpado) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation_process)
    end

    let(:creditor_proposal_arame_farpado_direct_purchase) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: direct_purchase)
    end

    let(:creditor_proposal_arame) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation_process)
    end

    let(:creditor_sobrinho) do
      Creditor.make!(:sobrinho_sa)
    end

    let(:licitation_process_ratification) do
      LicitationProcessRatification.make(:processo_licitatorio_computador,
        creditor: creditor_sobrinho,
        licitation_process: licitation_process,
        licitation_process_ratification_items: [],
        ratification_date: Date.current)
    end

    let(:ratification_direct_purchase) do
      LicitationProcessRatification.make(:processo_licitatorio_computador,
        creditor: creditor_sobrinho,
        licitation_process: direct_purchase,
        licitation_process_ratification_items: [],
        ratification_date: Date.current)
    end

    it "generates a CSV file with the required data" do
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation_process)

      accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
        licitation_process: licitation_process)

      ratification_item = LicitationProcessRatificationItem.make!(:item, ratificated: true,
        licitation_process_ratification: licitation_process_ratification,
        purchase_process_creditor_proposal: creditor_proposal_arame_farpado)

        licitation_process_ratification.licitation_process_ratification_items << ratification_item
        licitation_process_ratification.save!

      LicitationProcessRatificationItem.make!(:item, ratificated: true,
        licitation_process_ratification: licitation_process_ratification,
        purchase_process_creditor_proposal: creditor_proposal_arame)

      LicitationProcessRatificationItem.make!(:item, ratificated: true,
        licitation_process_ratification: ratification_direct_purchase,
        purchase_process_creditor_proposal: creditor_proposal_arame_farpado_direct_purchase)

      current_date     = Date.current.strftime('%d%m%Y')
      arame_farpado = creditor_proposal_arame_farpado.item
      arame_comum   = creditor_proposal_arame.item

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/HOMOLIC.csv', encoding: 'ISO-8859-1')

      reg_10_1 = "10;98;;2012;1;1;00315198737;2050;#{arame_farpado.item_number};Arame farpado;1,0000;4,9900"
      reg_30_1 = "30;98;;2012;1;#{current_date};#{current_date}"
      reg_10_2 = "10;98;;2012;1;1;00315198737;2050;#{arame_comum.item_number};Arame comum;1,0000;2,9900"
      reg_30_2 = "30;98;;2012;1;#{current_date};#{current_date}"

      expect(csv).to eq [reg_10_1, reg_30_1, reg_10_2, reg_30_2].join("\n")
    end
  end
end
