require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::LegalAnalysisAppraisalGenerator, vcr: { cassette_name: 'integration/legal_analysis_appraisal' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    UnicoAPI::Consumer.set_customer customer
  end

  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/PARELIC.csv')
    end

    after do
      FileUtils.rm_f('tmp/PARELIC.csv')
    end

    let :prefecture do
      Prefecture.make!(:belo_horizonte,
        address: Address.make!(:general))
    end

    let :monthly_monitoring do
      FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        month: 5,
        year: 2013)
    end

    let :licitation_process do
      LicitationProcess.make!(:processo_licitatorio_computador)
    end

    let :direct_purchase do
      LicitationProcess.make!(:compra_direta, process: 1)
    end

    let(:sobrinho) { Employee.make!(:sobrinho) }
    let(:wenderson) { Employee.make!(:wenderson) }
    let(:emissao_edital) { StageProcess.make!(:emissao_edital) }


    it "generates a CSV file with the required data" do
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation_process,
        ratification_date: Date.new(2013, 5, 13),
        adjudication_date: Date.new(2013, 5, 13)
      )

      LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: direct_purchase,
        ratification_date: Date.new(2013, 5, 13),
        adjudication_date: Date.new(2013, 5, 13)
      )

      LegalAnalysisAppraisal.create!(
        licitation_process_id: licitation_process.id,
        responsible_id: sobrinho.id,
        appraisal_expedition_date: Date.new(2013, 5, 13),
        appraisal_type: AppraisalType::TECHNICAL,
        reference: AppraisalReference::DRAFT
      )

      LegalAnalysisAppraisal.create!(
        licitation_process_id: direct_purchase.id,
        responsible_id: sobrinho.id,
        appraisal_expedition_date: Date.new(2013, 5, 13),
        appraisal_type: AppraisalType::TECHNICAL,
        reference: AppraisalReference::DRAFT
      )

      city = sobrinho.city
      city.tce_mg_code = 1
      city.save!

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/PARELIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "98;;2013;2;13052013;1;00315198737;Gabriel Sobrinho;Girassol;São Francisco;1;PR;33400500;3333333333;gabriel.sobrinho@gmail.com"
    end
  end
end
