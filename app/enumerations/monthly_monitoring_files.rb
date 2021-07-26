class MonthlyMonitoringFiles < EnumerateIt::Base
  associate_values(
    :bidding_authorization,
    :contract,
    :direct_purchase,
    :legal_analysis_appraisal,
    :licitation_judgment,
    :licitation_ratification,
    :price_registration_accession,
    :process_responsible,
    :purchase_opening,
    :regulatory_act
  )
end
