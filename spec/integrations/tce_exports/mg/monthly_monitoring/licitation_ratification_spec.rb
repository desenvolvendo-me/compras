#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::LicitationRatificationGenerator do
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
        year: 2013,
        city_code: "51234")
    end

    let(:licitation_process) do
      LicitationProcess.make!(:pregao_presencial)
    end

    let(:creditor_proposal_arame_farpado) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation_process)
    end

    let(:creditor_proposal_arame) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame,
        licitation_process: licitation_process)
    end

    let(:licitation_process_ratification) do
      LicitationProcessRatification.make!(:processo_licitatorio_computador,
        creditor: Creditor.make!(:sobrinho_sa),
        licitation_process: licitation_process)
    end

    it "generates a CSV file with the required data" do
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      accreditation = PurchaseProcessAccreditation.make!(:general_accreditation,
        licitation_process: licitation_process)

      LicitationProcessRatificationItem.make!(:item, ratificated: true,
        licitation_process_ratification: licitation_process_ratification,
        purchase_process_creditor_proposal: creditor_proposal_arame_farpado)

      LicitationProcessRatificationItem.make!(:item, ratificated: true,
        licitation_process_ratification: licitation_process_ratification,
        purchase_process_creditor_proposal: creditor_proposal_arame)

      current_date     = Date.current.strftime('%d%m%Y')
      arame_farpado_id = creditor_proposal_arame_farpado.purchase_process_item_id
      arame_comum_id   = creditor_proposal_arame.purchase_process_item_id

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/HOMOLIC.csv', encoding: 'ISO-8859-1')

      reg_10_1 = "10;98;98029;2012;1;1;00315198737;2050;#{arame_farpado_id};02.02.00001 - Arame farpado;1,0000;4,9900"
      reg_30_1 = "30;98;98029;2012;1;#{current_date};#{current_date}"
      reg_10_2 = "10;98;98029;2012;1;1;00315198737;2050;#{arame_comum_id};02.02.00002 - Arame comum;1,0000;2,9900"
      reg_30_2 = "30;98;98029;2012;1;#{current_date};#{current_date}"

      expect(csv).to eq [reg_10_1, reg_30_1, reg_10_2, reg_30_2].join("\n")
    end
  end
end
