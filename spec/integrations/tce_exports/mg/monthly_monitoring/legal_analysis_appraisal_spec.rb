#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::LegalAnalysisAppraisalGenerator do
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
        year: 2013)
    end

    let :processo_licitatorio do
      LicitationProcess.make!(:processo_licitatorio,
        execution_unit_responsible: "ABCDE")
    end

    let :pregao do 
      LicitationProcess.make!(:pregao_presencial)
    end

    let(:sobrinho) { Employee.make!(:sobrinho) }
    let(:wenderson) { Employee.make!(:wenderson) }
    let(:emissao_edital) { StageProcess.make!(:emissao_edital) }

    it "generates a CSV file with the required data" do
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      LegalAnalysisAppraisal.create!(
        licitation_process_id: processo_licitatorio.id,
        responsible_id: sobrinho.id,
        appraisal_expedition_date: Date.new(2013, 5, 13),
        appraisal_type: AppraisalType::TECHNICAL,
        reference: AppraisalReference::DRAFT
      )

      LegalAnalysisAppraisal.create!(
        licitation_process_id: pregao.id,
        responsible_id: wenderson.id,
        appraisal_expedition_date: Date.new(2013, 5, 11),
        appraisal_type: AppraisalType::LEGAL,
        reference: AppraisalReference::PUBLIC_SESSION
      )

      city = sobrinho.city
      city.tce_mg_code = 1
      city.save!

      city = wenderson.city
      city.tce_mg_code = 1
      city.save!

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/PARELIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "98;ABCDE;2012;1;13052013;1;00315198737;Gabriel Sobrinho;Girassol;São Francisco;1;PR;33400500;3333333333;gabriel.sobrinho@gmail.com\n" +
                        "98; ;2012;1;11052013;3;00314951334;Wenderson Malheiros;Girassol;São Francisco;1;PR;33400500;3333333333;wenderson.malheiros@gmail.com"
    end
  end
end

