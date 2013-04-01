class LegalAnalysisAppraisalDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :process_and_year, :appraisal_type, :reference, :appraisal_expedition_date
end
