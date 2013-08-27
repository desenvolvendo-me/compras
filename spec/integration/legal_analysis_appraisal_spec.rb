require 'spec_helper'

describe LegalAnalysisAppraisal do
  it 'should return all legal analysis appraisal by licitation' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio)
    direct_purchase = LicitationProcess.make!(:compra_direta)
    sobrinho = Employee.make!(:sobrinho)

    legal_analysis_appraisal = LegalAnalysisAppraisal.create!(
        licitation_process_id: licitation_process.id,
        responsible_id: sobrinho.id,
        appraisal_expedition_date: Date.new(2013, 5, 13),
        appraisal_type: AppraisalType::TECHNICAL,
        reference: AppraisalReference::DRAFT
      )

    legal_analysis_appraisal_two = LegalAnalysisAppraisal.create!(
        licitation_process_id: direct_purchase.id,
        responsible_id: sobrinho.id,
        appraisal_expedition_date: Date.new(2013, 5, 13),
        appraisal_type: AppraisalType::TECHNICAL,
        reference: AppraisalReference::DRAFT
      )

    expect(LegalAnalysisAppraisal.type_of_purchase_licitation).to include(legal_analysis_appraisal)
    expect(LegalAnalysisAppraisal.type_of_purchase_licitation).to_not include(legal_analysis_appraisal_two)
  end
end
