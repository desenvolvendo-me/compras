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
        month: 5,
        year: 2013)
    end

    let :licitation_process do
      LicitationProcess.make!(:processo_licitatorio_computador)
    end

    let(:sobrinho) { Employee.make!(:sobrinho) }
    let(:wenderson) { Employee.make!(:wenderson) }
    let(:emissao_edital) { StageProcess.make!(:emissao_edital) }

    let :budget_structure_parent do
      BudgetStructure.new(
        id: 2,
        code: '1',
        tce_code: '051',
        description: 'Secretaria de Educação',
        acronym: 'SEMUEDU',
        performance_field: 'Desenvolvimento Educacional')
    end

    let :budget_structure do
      BudgetStructure.new(
        id: 1,
        parent_id: 2,
        code: '29',
        tce_code: '051',
        description: 'Secretaria de Desenvolvimento',
        acronym: 'SEMUEDU',
        performance_field: 'Desenvolvimento Educacional')
      end

    it "generates a CSV file with the required data" do
      BudgetStructure.should_receive(:find).at_least(1).times.with(2, params: {}).and_return(budget_structure_parent)
      BudgetStructure.should_receive(:find).at_least(1).times.with(1, params: {}).and_return(budget_structure)

      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation_process,
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

      city = sobrinho.city
      city.tce_mg_code = 1
      city.save!

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/PARELIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "98;98029;2013;2;13052013;1;00315198737;Gabriel Sobrinho;Girassol;São Francisco;1;PR;33400500;3333333333;gabriel.sobrinho@gmail.com"
    end
  end
end
