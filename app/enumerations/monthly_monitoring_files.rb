class MonthlyMonitoringFiles < EnumerateIt::Base
  associate_values :regulatory_act, :process_responsible, :price_registration_accession,
    :legal_analysis_appraisal, :licitation_judgment, :licitation_ratification
end
